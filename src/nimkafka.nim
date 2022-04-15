
const
  librdkafka* = "librdkafka++.so"
  irr = "<librdkafka/rdkafkacpp.h>"

# header: irr,

# RdKafka::version,
proc rd_kafka_version_cpp*(): int {.cdecl,
                                    importcpp: "RdKafka::version()",
                                    dynlib: librdkafka.} ## Returns the librdkafka version as string.



echo rd_kafka_version_cpp()
