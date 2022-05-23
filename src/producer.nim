import

  # ../libs/nim_kafka/nimkafka,
  ../libs/nim_kafka/nimkafka_c,
  ../libs/nim_avro/nimavro,
  ../libs/nim_serdes/nimserdes,

  ./avro_example


#  Init Kafka Producer
# broker
let
  name = "bootstrap.servers".cstring
  broker = "localhost:9092".cstring
var errstr: cstring= ""
var errstr3: cstring= ""


let conf = rd_kafka_conf_new()
let confRes = conf.rdKafkaConfSet(name, broker, errstr, 512)
let confRes2 = conf.rdKafkaConfSet("message.max.bytes", "1000000000", errstr, 512);
let confRes3 = conf.rdKafkaConfSet("compression.type", "snappy", errstr, 512);


let producer = rd_kafka_new(RdKafkaTypeT.RD_KAFKA_PRODUCER, conf, errstr, 512)

# topic
let
  topicConf = rd_kafka_topic_conf_new()
  resTopicSet = topicConf.rdKafkaTopicConfSet("compression.codec".cstring, "snappy".cstring, errstr, 512)
  resTopicSet2 = topicConf.rdKafkaTopicConfSet("compression.type".cstring, "snappy".cstring, errstr, 512)
  resTopicSet3 = topicConf.rdKafkaTopicConfSet("compression.level".cstring, "12".cstring, errstr, 512)

echo repr(topicConf)
let
  # resTopicSet = topicConf.rdKafkaTopicConfSet("message.copy.max.bytes".cstring, "1000000000".cstring,
  #                                              errstr3, 512)
  topicName:cstring = "purchases"
  topic = rd_kafka_topic_new(producer, topicName, topicConf)
  part:int32 = 0

# Set Avro
var
  sconf: ptr SerdesConfT
  serdes: ptr SerdesT
  schema: ptr SerdesSchemaT
  schemaName: cstring = "Person"
  schemaDef: cstring
  errstrSize: int = 512
  serBuff: pointer

  serBuffSize: int = 5000

sconf = serdesConfNew(nil, 0, nil)
discard serdesConfSet(sconf, "schema.registry.url".cstring, "http://localhost:8081".cstring,
                   errstr, errstrSize)

serdes = serdesNew(sconf, errstr, errstr.len)
schema = serdesSchemaGet(serdes, schemaName, -1,
                              errstr, errstr.len)
if schema.isNil:
  schema = serdesSchemaAdd(serdes, schemaName, -1,
                           PERSON_SCHEMA.cstring, PERSON_SCHEMA.len,
                           errstr, errstr.len)
# serdesSchemaDestroy(schema1)

var
  personSchema = initPersonSchema()
  person = addPerson(personSchema, "Emil".string, "Ivannichkov".string,
            "088655555".string, 22)
  person2 = addPerson(personSchema, "Evgeni".string, "Dankov".string,
            "000000000".string, 22)

echo schema.serdesSchemaName
echo schema.serdesSchemaDefinition

echo serdesSchemaSerializeAvro(schema,
                               person.addr,
                               serBuff.addr,
                               serBuffSize.addr,
                               errstr,
                               errstr.len)

let produceRes2 = rd_kafka_produce(topic,
                                   part,
                                   cast[cint](RD_KAFKA_MSG_F_COPY),
                                   serBuff,
                                   serBuffSize,
                                   nil,0,nil)

echo serdesSchemaSerializeAvro(schema,
                               person2.addr,
                               serBuff.addr,
                               serBuffSize.addr,
                               errstr,
                               errstr.len)

let produceRes3 = rd_kafka_produce(topic,
                                   part,
                                   cast[cint](RD_KAFKA_MSG_F_COPY),
                                   serBuff,
                                   serBuffSize,
                                   nil,0,nil)

discard rd_kafka_flush(producer, 10*1000)

var
  lowOffset: int64
  highOffset: int64
echo rdKafkaQueryWatermarkOffsets(producer, topicName, part, lowOffset.addr, highOffset.addr, 1)
echo lowOffset
echo highOffset
