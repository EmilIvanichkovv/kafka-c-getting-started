const
  rdkafkadll* = "librdkafka.so"

proc rd_kafka_version_c*(): cstring {.cdecl, importc: "rd_kafka_version_str",
                                      dynlib: rdkafkadll.}

echo rd_kafka_version_c()