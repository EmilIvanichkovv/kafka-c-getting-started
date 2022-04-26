import ../libs/nim_kafka/nimkafka
import ../libs/nim_kafka/nimkafka_c
import cppstl


var a: ptr Conf
var conf = create(ConfType.CONF_GLOBAL)

let
  name = "bootstrap.servers".initCppString
  broker = "localhost:9092".initCppString
var str = initCppString()

type
  testObj = object
    name: string
    age: int

var jon = testObj(name: "Jon", age: 21)
echo jon
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

var producerErr = initCppString()
let producer = create(conf, producerErr)

echo producerErr.cStr
let produceRes = producer.produce(topic,
                                  -1,
                                  2,
                                  message, 200,
                                  nil, 0,
                                  0,
                                  nil,
                                  nil)
let flushRes = producer.flush(500)
echo flushRes

echo produceRes

echo rd_kafka_version_cpp()