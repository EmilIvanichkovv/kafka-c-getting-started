#include <glib.h>
#include <librdkafka/rdkafka.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>


/* Typical include path is <libserdes/serdes.h> */
#include <libserdes/serdes-avro.h>


#include "common.c"

static volatile sig_atomic_t run = 1;

/**
 * @brief Signal termination of program
 */
static void stop(int sig) {
    run = 0;
}

// static int run = 1;
static int exit_eof = 0;
static int verbosity = 2;

static void parse_msg (rd_kafka_message_t *rkmessage, serdes_t *serdes) {
        avro_value_t avro;
        serdes_err_t err;
        serdes_schema_t *schema;
        char errstr[512];
        char *as_json;

        /* Automatic deserialization using message framing */
        err = serdes_deserialize_avro(serdes, &avro, &schema,
                                      rkmessage->payload, rkmessage->len,
                                      errstr, sizeof(errstr));
        if (err) {
                fprintf(stderr, "%% serdes_deserialize_avro failed: %s\n",
                        errstr);
                return;
        }

        if (verbosity > 1)
                fprintf(stderr,
                        "%% Successful Avro deserialization using "
                        "schema %s id %d\n",
                        serdes_schema_name(schema), serdes_schema_id(schema));

        /* Convert to JSON and print */
        if (avro_value_to_json(&avro, 1, &as_json))
                fprintf(stderr, "%% avro_to_json failed: %s\n",
                        avro_strerror());
        else {
                printf("%s\n", as_json);
                free(as_json);
        }

        avro_value_decref(&avro);
}

int main (int argc, char **argv) {
    rd_kafka_t *consumer;
    rd_kafka_conf_t *conf;
    rd_kafka_resp_err_t err;

    int partition = 0;
    char mode = 0;
    rd_kafka_conf_t *rk_conf;
    rd_kafka_topic_conf_t *rkt_conf;
    serdes_conf_t *sconf;
    serdes_t *serdes;
    // serdes_err_t err;
    char errstr2[512];
    int opt;
    int schema_id = -1;
    const char *schema_name = NULL;
    const char *schema_def = NULL;

    sconf = serdes_conf_new(NULL, 0,
                            /* Default URL */
                            "schema.registry.url", "http://localhost:8081",
                            NULL);
    serdes = serdes_new(sconf, errstr2, sizeof(errstr2));

    char errstr[512];

    // Parse the command line.
    if (argc != 2) {
        g_error("Usage: %s <config.ini>", argv[0]);
        return 1;
    }

    // Parse the configuration.
    // See https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md
    const char *config_file = argv[1];

    g_autoptr(GError) error = NULL;
    g_autoptr(GKeyFile) key_file = g_key_file_new();
    if (!g_key_file_load_from_file (key_file, config_file, G_KEY_FILE_NONE, &error)) {
        g_error ("Error loading config file: %s", error->message);
        return 1;
    }

    // Load the relevant configuration sections.
    conf = rd_kafka_conf_new();
    load_config_group(conf, key_file, "default");
    load_config_group(conf, key_file, "consumer");

    // Create the Consumer instance.
    consumer = rd_kafka_new(RD_KAFKA_CONSUMER, conf, errstr, sizeof(errstr));
    if (!consumer) {
        g_error("Failed to create new consumer: %s", errstr);
        return 1;
    }
    rd_kafka_poll_set_consumer(consumer);

    // Configuration object is now owned, and freed, by the rd_kafka_t instance.
    conf = NULL;

    // Convert the list of topics to a format suitable for librdkafka.
    const char *topic = "purchases";
    rd_kafka_topic_partition_list_t *subscription = rd_kafka_topic_partition_list_new(1);
    rd_kafka_topic_partition_list_add(subscription, topic, RD_KAFKA_PARTITION_UA);

    // Subscribe to the list of topics.
    err = rd_kafka_subscribe(consumer, subscription);
    if (err) {
        g_error("Failed to subscribe to %d topics: %s", subscription->cnt, rd_kafka_err2str(err));
        rd_kafka_topic_partition_list_destroy(subscription);
        rd_kafka_destroy(consumer);
        return 1;
    }

    rd_kafka_topic_partition_list_destroy(subscription);

    // Install a signal handler for clean shutdown.
    signal(SIGINT, stop);

    // Start polling for messages.
    while (run) {
        rd_kafka_message_t *consumer_message;

        consumer_message = rd_kafka_consumer_poll(consumer, 500);
        if (!consumer_message) {
            g_message("Waiting...");
            continue;
        }

        if (consumer_message->err) {
            if (consumer_message->err == RD_KAFKA_RESP_ERR__PARTITION_EOF) {
                /* We can ignore this error - it just means we've read
                 * everything and are waiting for more data.
                 */
            } else {
                g_message("Consumer error: %s", rd_kafka_message_errstr(consumer_message));
                return 1;
            }
        } else {
            parse_msg(consumer_message, serdes);
            g_message("Consumed event from topic %s: key = %.*s value = %s",
                      rd_kafka_topic_name(consumer_message->rkt),
                      (int)consumer_message->key_len,
                      (char *)consumer_message->key,
                      (char *)consumer_message->payload
                      );
        }

        // Free the message when we're done.
        rd_kafka_message_destroy(consumer_message);
    }

    // Close the consumer: commit final offsets and leave the group.
    g_message( "Closing consumer");
    rd_kafka_consumer_close(consumer);

    // Destroy the consumer.
    rd_kafka_destroy(consumer);

    return 0;
}