import ./nimkafka
import ./nimkafka_c
import cppstl


var a: ptr Conf
var conf = create(ConfType.CONF_GLOBAL)

let
  name = "bootstrap.servers".initCppString
  broker = "localhost:9092".initCppString
var str = initCppString()

let res = set(conf, name, broker, str)
echo $res
echo str.cStr

# Try to use dump
let dumpRes = conf.dump
echo dumpRes[].begin[]
echo dumpRes[].size

proc printConf(confDump: List[CppString]) =
  var it = confDump.begin()
  for i in 0 ..< confDump.size() div 2:
    echo it[] , "= ".initCppString , it.next()[]
    it = it.next()
    it = it.next()

dumpRes[].printConf
let topic = "purchases".initCppString
var message:cstring = "MESSAGE"
let producer = create(conf, str)
echo str.cStr
let produceRes = producer.produce(topic,
                                  -1,
                                  cast[cint](2),
                                  message, 100,
                                  nil, 0,
                                  0,
                                  nil,
                                  nil)
echo produceRes