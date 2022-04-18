
{.link: "/nix/store/zwbf01pncrclfvlgrkwgmfwyhbb0zcnf-rdkafka-1.8.2/lib/librdkafka++.so"}
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
  Conf {.header: irr,
         importcpp: "RdKafka::Conf".} = object

  ConfType {.header: irr,
            importcpp: "RdKafka::Conf::ConfType".} = enum
    CONF_GLOBAL, CONF_TOPIC

  ConfResult{.header: irr,
              importcpp: "RdKafka::Conf::ConfResult".} = enum
    CONF_UNKNOWN, CONF_INVALID, CONF_OK

proc create(confType: ConfType):ref Conf
  {.header: irr, importcpp: "RdKafka::Conf::create(@)".}


proc set(this: Conf, name, value, errstr: cstring): ConfResult
 {.header: irr, importcpp: "#.RdKafka::Conf::set(@)".}



echo rd_kafka_version_cpp()

var a: ptr Conf
echo ConfType.CONF_GLOBAL
var b = create(ConfType.CONF_GLOBAL)
echo b.typeof
echo b[].typeof
const
  broker: cstring = "localhost:9092"
  topic: cstring = "purchase"

var err:ref cstring
let res = set(a[], broker, topic, err[])
# echo res