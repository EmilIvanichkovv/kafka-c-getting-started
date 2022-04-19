import ./nimkafka
import cppstl

echo rd_kafka_version_cpp()

var a: ptr Conf
echo ConfType.CONF_GLOBAL
var b = create(ConfType.CONF_GLOBAL)
echo b.typeof
echo b[].typeof


let
  name = "bootstrap.servers".initCppString
  broker = "localhost:9092".initCppString
var str = initCppString()

let res = set(b[], name, broker, str)
echo res
echo $str

