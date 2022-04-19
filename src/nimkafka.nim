
{.link: "/nix/store/zwbf01pncrclfvlgrkwgmfwyhbb0zcnf-rdkafka-1.8.2/lib/librdkafka++.so"}

import cppstl

const
  librdkafka* = "librdkafka++.so"
  irr = "<librdkafka/rdkafkacpp.h>"

# VERSION

proc rd_kafka_version_cpp*(): int {.
                                    dynlib: librdkafka,
                                    header: irr,
                                    importcpp: "RdKafka::version()"
                                    .}

# CONF Utils:

type
  Conf* {.header: irr,
         importcpp: "RdKafka::Conf".} = object

  ConfType* {.header: irr,
             importcpp: "RdKafka::Conf::ConfType".} = enum
    CONF_GLOBAL, CONF_TOPIC

  ConfResult* {.header: irr,
               importcpp: "RdKafka::Conf::ConfResult".} = enum
    CONF_UNKNOWN, CONF_INVALID, CONF_OK

proc create* (confType: ConfType):ref Conf
  {.header: irr, importcpp: "RdKafka::Conf::create(@)".}


proc set* (this: Conf, name, value: CppString, errstr: var CppString ): ConfResult
  {.header: irr, importcpp: "#.set(@)".}
