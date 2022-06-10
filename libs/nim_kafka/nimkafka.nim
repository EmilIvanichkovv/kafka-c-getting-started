const
  rdkafkadll* = "librdkafka.so"

proc rdKafkaVersion*(): int {.cdecl, importc: "rd_kafka_version", dynlib: rdkafkadll.}
proc rdKafkaVersionStr*(): cstring {.cdecl, importc: "rd_kafka_version_str",
                                  dynlib: rdkafkadll.}

const
    # Producer API consts
  RD_KAFKA_MSG_F_FREE* = 0x00000001
  RD_KAFKA_MSG_F_COPY* = 0x00000002

type
  RdKafkaTypeT* {.size: sizeof(int).} = enum
    RD_KAFKA_PRODUCER, RD_KAFKA_CONSUMER

  RdKafkaT* = object
  RdKafkaTopicT* = object
  RdKafkaConfT* = object
  RdKafkaTopicConfT* = object
  RdKafkaQueueT* = object

  RdKafkaConfResT* {.size: sizeof(int).} = enum
    ##Configuration result type
    RD_KAFKA_CONF_UNKNOWN = - 2, ##Unknown configuration name.
    RD_KAFKA_CONF_INVALID = - 1, ##Invalid configuration value.
    RD_KAFKA_CONF_OK = 0

  RdKafkaRespErrT* {.size: sizeof(int).} = enum
    ## Internal errors to rdkafka:
    RD_KAFKA_RESP_ERR_BEGIN = - 200, # begin internal error codes
    RD_KAFKA_RESP_ERR_BAD_MSG = - 199, # Received message is incorrect
    RD_KAFKA_RESP_ERR_BAD_COMPRESSION = - 198, # Bad/unknown compression
    RD_KAFKA_RESP_ERR_DESTROY = - 197, # Broker is going away
    RD_KAFKA_RESP_ERR_FAIL = - 196, # Generic failure
    RD_KAFKA_RESP_ERR_TRANSPORT = - 195, # Broker transport error
    RD_KAFKA_RESP_ERR_CRIT_SYS_RESOURCE = - 194, # Critical system resource
                                              #             failure
    RD_KAFKA_RESP_ERR_RESOLVE = - 193, # Failed to resolve broker
    RD_KAFKA_RESP_ERR_MSG_TIMED_OUT = - 192, # Produced message timed out
    RD_KAFKA_RESP_ERR_PARTITION_EOF = - 191, # Reached the end of the
                                          #         topic+partition queue on
                                          #         the broker.
                                          #         Not really an error.
    RD_KAFKA_RESP_ERR_UNKNOWN_PARTITION = - 190, # Permanent:
                                              #             Partition does not
                                              #             exist in cluster.
    RD_KAFKA_RESP_ERR_FS = - 189, # File or filesystem error
    RD_KAFKA_RESP_ERR_UNKNOWN_TOPIC = - 188, # Permanent:
                                          #         Topic does not exist
                                          #         in cluster.
    RD_KAFKA_RESP_ERR_ALL_BROKERS_DOWN = - 187, # All broker connections
                                             #            are down.
    RD_KAFKA_RESP_ERR_INVALID_ARG = - 186, # Invalid argument, or
                                        #        invalid configuration
    RD_KAFKA_RESP_ERR_TIMED_OUT = - 185, # Operation timed out
    RD_KAFKA_RESP_ERR_QUEUE_FULL = - 184, # Queue is full
    RD_KAFKA_RESP_ERR_ISR_INSUFF = - 183, # ISR count < required.acks
    RD_KAFKA_RESP_ERR_NODE_UPDATE = - 182, # Broker node update
    RD_KAFKA_RESP_ERR_END = - 100, # end internal error codes
                                # Standard Kafka errors:
    RD_KAFKA_RESP_ERR_UNKNOWN = - 1,
    RD_KAFKA_RESP_ERR_NO_ERROR = 0,
    RD_KAFKA_RESP_ERR_OFFSET_OUT_OF_RANGE = 1,
    RD_KAFKA_RESP_ERR_INVALID_MSG = 2,
    RD_KAFKA_RESP_ERR_UNKNOWN_TOPIC_OR_PART = 3,
    RD_KAFKA_RESP_ERR_INVALID_MSG_SIZE = 4,
    RD_KAFKA_RESP_ERR_LEADER_NOT_AVAILABLE = 5,
    RD_KAFKA_RESP_ERR_NOT_LEADER_FOR_PARTITION = 6,
    RD_KAFKA_RESP_ERR_REQUEST_TIMED_OUT = 7,
    RD_KAFKA_RESP_ERR_BROKER_NOT_AVAILABLE = 8,
    RD_KAFKA_RESP_ERR_REPLICA_NOT_AVAILABLE = 9,
    RD_KAFKA_RESP_ERR_MSG_SIZE_TOO_LARGE = 10,
    RD_KAFKA_RESP_ERR_STALE_CTRL_EPOCH = 11,
    RD_KAFKA_RESP_ERR_OFFSET_METADATA_TOO_LARGE = 12,
    RD_KAFKA_RESP_ERR_OFFSETS_LOAD_IN_PROGRESS = 14,
    RD_KAFKA_RESP_ERR_CONSUMER_COORDINATOR_NOT_AVAILABLE = 15,
    RD_KAFKA_RESP_ERR_NOT_COORDINATOR_FOR_CONSUMER = 16

proc rdKafkaLastError*(): RdKafkaRespErrT {.cdecl, importc: "rd_kafka_last_error",
    dynlib: rdkafkadll.}

#  Main configuration property interface
proc rdKafkaConfNew*(): ptr RdKafkaConfT {.cdecl, importc: "rd_kafka_conf_new",
                                       dynlib: rdkafkadll.}
proc rdKafkaConfDestroy*(conf: ptr RdKafkaConfT) {.cdecl,
  importc: "rd_kafka_conf_destroy", dynlib: rdkafkadll.}
proc rdKafkaConfDup*(conf: ptr RdKafkaConfT): ptr RdKafkaConfT {.cdecl,
  importc: "rd_kafka_conf_dup", dynlib: rdkafkadll.}
proc rdKafkaConfSet*(conf: ptr RdKafkaConfT, name: cstring, value: cstring,
                    errstr: cstring, errstrSize: int): RdKafkaConfResT {.cdecl,
  importc: "rd_kafka_conf_set", dynlib: rdkafkadll.}


# Kafka Object Handle
proc rdKafkaNew*(`type`: RdKafkaTypeT,
                  conf: ptr RdKafkaConfT,
                  errstr: cstring,
                  errstrSize: int): ptr RdKafkaT {.cdecl, importc: "rd_kafka_new",
  dynlib: rdkafkadll.}

proc rdKafkaTopicNew*(rk: ptr RdKafkaT,
                      topic: cstring, conf: ptr RdKafkaTopicConfT): ptr RdKafkaTopicT {.
  cdecl, importc: "rd_kafka_topic_new", dynlib: rdkafkadll.}
proc rdKafkaTopicDestroy*(rkt: ptr RdKafkaTopicT) {.cdecl,
  importc: "rd_kafka_topic_destroy", dynlib: rdkafkadll.}
proc rdKafkaTopicName*(rkt: ptr RdKafkaTopicT): cstring {.cdecl,
  importc: "rd_kafka_topic_name", dynlib: rdkafkadll.}
proc rdKafkaTopicOpaque*(rkt: ptr RdKafkaTopicT): pointer {.cdecl,
  importc: "rd_kafka_topic_opaque", dynlib: rdkafkadll.}

# Misc API
proc rdKafkaFlush*(rk: ptr RdKafkaT, timeoutMs: int): RdKafkaRespErrT {.cdecl,
  importc: "rd_kafka_flush", dynlib: rdkafkadll.}
proc rdKafkaPurge*(rk: ptr RdKafkaT, purgeFlags: int): RdKafkaRespErrT {.cdecl,
  importc: "rd_kafka_purge", dynlib: rdkafkadll.}
proc rdKafkaBrokersAdd*(rk: ptr RdKafkaT, brokerlist: cstring): int {.cdecl,
  importc: "rd_kafka_brokers_add", dynlib: rdkafkadll.}


#  Topic configuration property interface
proc rdKafkaTopicConfNew*(): ptr RdKafkaTopicConfT {.cdecl,
  importc: "rd_kafka_topic_conf_new", dynlib: rdkafkadll.}
proc rdKafkaTopicConfDup*(conf: ptr RdKafkaTopicConfT): ptr RdKafkaTopicConfT {.cdecl,
  importc: "rd_kafka_topic_conf_dup", dynlib: rdkafkadll.}
proc rdKafkaDefaultTopicConfDup*(rk: ptr RdKafkaT): ptr RdKafkaTopicConfT {.cdecl,
  importc: "rd_kafka_default_topic_conf_dup", dynlib: rdkafkadll.}
proc rdKafkaTopicConfDestroy*(topicConf: ptr RdKafkaTopicConfT) {.cdecl,
  importc: "rd_kafka_topic_conf_destroy", dynlib: rdkafkadll.}
proc rdKafkaTopicConfSet*(conf: ptr RdKafkaTopicConfT,
                          name: cstring,
                          value: cstring,
                          errstr: cstring,
                          errstrSize: int): RdKafkaConfResT {.
  cdecl, importc: "rd_kafka_topic_conf_set", dynlib: rdkafkadll.}

# Producer API
proc rdKafkaProduce*(rkt: ptr RdKafkaTopicT,
                     partition: int32,
                     msgflags: int,
                     payload: pointer,
                     len: uint64,
                     key: pointer,
                     keylen: uint64,
                     msgOpaque: pointer): int {.cdecl, importc: "rd_kafka_produce",
  dynlib: rdkafkadll.}

# Offset management
proc rdKafkaQueryWatermarkOffsets*(rk: ptr RdKafkaT; topic: cstring;
                                  partition: int32; lowOffset: ptr int64;
                                  highOffset: ptr int64; timeoutMs: cint): RdKafkaRespErrT {.
    cdecl, importc: "rd_kafka_query_watermark_offsets", dynlib: rdkafkadll.}

proc rdKafkaGetWatermarkOffsets*(rk: ptr RdKafkaT; topic: cstring; partition: int32;
                                lowOffset: ptr int64; highOffset: ptr int64): RdKafkaRespErrT {.
    cdecl, importc: "rd_kafka_get_watermark_offsets", dynlib: rdkafkadll.}
