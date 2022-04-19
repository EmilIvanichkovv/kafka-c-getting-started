const
  rdkafkadll* = "librdkafka.so"

type
  RDKConf* = object
  PRDKConf* = ptr RDKConf
  RDKConfRes* {.size: sizeof(cint).} = enum
    ##Configuration result type
    RD_KAFKA_CONF_UNKNOWN = - 2, ##Unknown configuration name. 
    RD_KAFKA_CONF_INVALID = - 1, ##Invalid configuration value. 
    RD_KAFKA_CONF_OK = 0

proc rd_kafka_version_c*(): cstring {.cdecl, importc: "rd_kafka_version_str",
                                      dynlib: rdkafkadll.}


proc rd_kafka_conf_set*(conf: PRDKConf; name: cstring; value: cstring;
                       errstr: cstring; errstr_size: csize): RDKConfRes {.
    cdecl, importc: "rd_kafka_conf_set", dynlib: rdkafkadll.} 

proc rd_kafka_conf_new*(): PRDKConf {.cdecl, importc: "rd_kafka_conf_new",
    dynlib: rdkafkadll.} 