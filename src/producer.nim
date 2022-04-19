import ./nimkafka
import ./nimkafka_c
import cppstl

echo rd_kafka_version_cpp()

var a: PConf
echo ConfType.CONF_GLOBAL
var b = create(ConfType.CONF_GLOBAL)
echo b.typeof
echo b[].typeof


let
  name = "bootstrap.servers".initCppString
  broker = "localhost:9092".initCppString
var str = initCppString()

let res = set(b, name, broker, str)
echo res
echo $str

# # Create conf with c 
# var kafkaConf: PRDKConf
# kafkaConf = rd_kafka_conf_new()
# # var topicConf: PRDKTopicConf
# var errstr: cstring = ""
# var res_c: RDKConfRes
# res_c = rd_kafka_conf_set(kafkaConf, cast[cstring]("bootstrap.servers"), cast[cstring]("localhost:9092"), errstr, 256)
# echo res_c

# Try to use dump
let dumpRes = b.dump
echo $dumpRes[]