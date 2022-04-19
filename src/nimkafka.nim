
{.link: "/nix/store/zwbf01pncrclfvlgrkwgmfwyhbb0zcnf-rdkafka-1.8.2/lib/librdkafka++.so"}

import cppstl

const
  librdkafka* = "librdkafka++.so"
  irr = "<librdkafka/rdkafkacpp.h>"

type
  List*[T]                              {.importcpp: "std::list", header: "<list>".} = object
  ListIter*[T]                          {.importcpp: "std::list<'0>::iterator", header: "<list>".} = object

proc initList*[T](): List[T]            {.importcpp: "std::list<'*0>()", constructor, header: "<list>".}
proc size*(l: List): csize_t            {.importcpp: "size", header: "<list>".}
proc begin*[T](l: List[T]): ListIter[T] {.importcpp: "begin", header: "<list>".}
proc `[]`*[T](it: ListIter[T]): T       {.importcpp: "*#", header: "<list>".}


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
  PConf* = ptr Conf
  ConfType* = enum
    CONF_GLOBAL, CONF_TOPIC

  ConfResult* = enum
    CONF_UNKNOWN = - 2,
    CONF_INVALID = - 1,
    CONF_OK = 0

proc create* (confType: ConfType):ptr Conf
  {.header: irr, importcpp: "RdKafka::Conf::create(@)".}


proc set* (this: PConf, name, value: CppString, errstr: var CppString ): ConfResult
  {.header: irr, importcpp: "#.set(@)".}

proc dump*(this: PConf): ref List[CppString]
 {.header: irr, importcpp: "#.dump()".}
