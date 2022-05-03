import

  ../libs/nim_kafka/nimkafka,
  ../libs/nim_kafka/nimkafka_c,
  ../libs/nim_avro/nimavro,
  ../libs/nim_serdes/nimserdes,

  ./avro_example

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

type
  TestObj = object
    name: string
    age: int

let test = TestObj(name: "Emil", age: 22)

echo producerErr.cStr
let produceRes = producer.produce(topic,
                                  -1,
                                  2,
                                  test.unsafeAddr, 200,
                                  nil, 0,
                                  0,
                                  nil,
                                  nil)
let flushRes = producer.flush(500)
echo flushRes

echo produceRes

echo rd_kafka_version_cpp()

# Avro --------------------------------------------------------------
echo "FROM NOW ON WE EXPERIMENT WITH AVRO"
echo ""

var
  sconf: PSerdesConfT
  serdes: PSerdesT
  err: SerdesErrT
  schemaName: cstring
  schemaDef: cstring
  errstr: cstring
  errstrSize: int = 80
  serBuff: pointer = addr(errstrSize)
  serBuffSize: int

sconf = serdesConfNew("".cstring, 0,
                      "schema.registry.url".cstring, "http://localhost:9092".cstring,
                      "".cstring);

serdes = serdesNew(sconf, errstr, errstr.len)

echo repr(serdes.addr)

let schema = serdesSchemaGet(serdes, "Person".cstring, -1,
                            #  "", -1,
                             errstr, errstr.len)
echo errstr.len
# echo schema.serdesSchemaName

var
  personSchema = initPersonSchema()
  person = addPerson(personSchema, "Emil".cstring, "Ivanichkov".cstring,
            "088655555".cstring, 22)

var schema1: SerdesSchemaT

let schema11 = serdesSchemaAdd(serdes, "Person".cstring, -1,
                             "", -1,
                             errstr, errstr.len)
# schema1 = schema11[]
echo repr(schema11)

echo schema1.addr.serdesSchemaName
# echo schema1.addr.serdesSchemaId


# let schema112 = serdesSchemaAdd(serdes, "Person".cstring, -1,
#                              "", -1,
#                              errstr, errstr.len)

# echo schema1.addr.serdesSchemaName
# echo schema1.addr.serdesSchemaId

var errstr1: cstring = ""

var id_value: AvroValueT
echo avroGenericStringNew(id_value.addr, "HII")


echo repr(schema1.unsafeAddr)
# echo repr(person.unsafeAddr)
# echo repr(serBuff.unsafeAddr)
# echo repr(serBuffSize.unsafeAddr)
# echo repr(errstr1.unsafeAddr)

# echo id_value.addr.isNil
echo serdesSchemaSerializeAvro(schema1.addr,
                               id_value.addr,
                               serBuff.addr,
                               serBuffSize.addr,
                               errstr1,
                               errstr1.len)

