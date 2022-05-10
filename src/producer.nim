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
                                  nil, 200,
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
  sconf: ptr SerdesConfT
  serdes: ptr SerdesT
  err: SerdesErrT
  schemaName: cstring
  schemaDef: cstring
  errstr: cstring
  errstrSize: int = 500
  serBuff: pointer
  serBuff2: pointer

  serBuffSize: int = 5000

sconf = serdesConfNew(nil, 0, nil)
echo serdesConfSet(sconf, "schema.registry.url".cstring, "http://localhost:8081".cstring,
                   errstr, errstrSize)


echo "I am srconf " , repr(sconf)

serdes = serdesNew(sconf, errstr, errstr.len)

echo "I am serdes " , repr(serdes)


var
  personSchema = initPersonSchema()
  person = addPerson(personSchema, "Emil".string, "Ivannichkov".string,
            "088655555".string, 22)
  person2 = addPerson(personSchema, "mil".string, "Ivannichkov".string,
            "088655555".string, 22)


var jsonStr: cstring
var buff: AvroWrappedBufferT
echo avroValueToJson(person.addr, 0, jsonStr.addr)

# echo avroValueGetSchema(person.addr)

var schema1: SerdesSchemaT

let schema11 = serdesSchemaAdd(serdes, "Persons".cstring, -1,
                             PERSON_SCHEMA.cstring, PERSON_SCHEMA.len,
                             errstr, errstr.len)

# let schema11 = serdesSchemaGet(serdes, "Person".cstring, -1,
#                              errstr, errstr.len)
echo errstr

var errstr1: cstring = ""
var errstr2: cstring = ""


var id_value: AvroValueT
echo avroGenericStringNew(id_value.addr, "HII")


echo "I am schema " , repr(schema11)

echo schema11.serdesSchemaName
echo schema11.serdesSchemaDefinition

# echo repr(person.unsafeAddr)
# echo repr(serBuff.unsafeAddr)
# echo repr(serBuffSize.unsafeAddr)
# echo repr(errstr1.unsafeAddr)
echo serdesSchemaSerializeAvro(schema11,
                               person.addr,
                               serBuff.addr,
                               serBuffSize.addr,
                               errstr1,
                               errstr1.len)

let produceRes2 = producer.produce(topic,
                                  -1,
                                  2,
                                  serBuff, 34,
                                  nil, 0,
                                  0,
                                  nil,
                                  nil)

echo serdesSchemaSerializeAvro(schema11,
                               person2.addr,
                               serBuff2.addr,
                               serBuffSize.addr,
                               errstr2,
                               errstr2.len)

let produceRes3 = producer.produce(topic,
                                  -1,
                                  2,
                                  serBuff2, 34,
                                  nil, 0,
                                  0,
                                  nil,
                                  nil)
echo serBuffSize



let flushRes2 = producer.flush(500)
echo flushRes2

echo produceRes2