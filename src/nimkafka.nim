
{.link: "/nix/store/zwbf01pncrclfvlgrkwgmfwyhbb0zcnf-rdkafka-1.8.2/lib/librdkafka++.so"}

const
  librdkafka* = "librdkafka++.so"
  irr = "<librdkafka/rdkafkacpp.h>"

# header: irr,

# RdKafka::version,
proc rd_kafka_version_cpp*(): int {.
                                    header: irr,
                                    importcpp: "RdKafka::version()",
                                    # dynlib: librdkafka.
                                    } ## Returns the librdkafka version as string.



echo rd_kafka_version_cpp()
