import ../libs/nim_avro/nimavro
import ../libs/nim_serdes/nimserdes


import std/os
import std/sequtils

var foo: AvroValueT
discard foo.iface.decref == nil

proc printAvroValue*(avroValue:ptr AvroValueT) =
  var avroValueToJsonStr: cstring
  if avroValueToJson(avroValue, 0, avroValueToJsonStr.addr) == 0:
    echo avroValueToJsonStr
  else:
    echo "Error while printing Avro Value"

proc initAvroArrayLongSchema*(): AvroSchemaT =
  var
    longSchema = avro_schema_long()
    avroArraySchema: AvroSchemaT = avroSchemaArray(longSchema)
  avroArraySchema

proc initAvroArrayLongValue*(): AvroValueT =
  var
    avroArr: AvroValueT
    avroArraySchema: AvroSchemaT = initAvroArrayLongSchema()
    arrayClass = avroGenericClassFromSchema(avroArraySchema)
  if not (avroGenericValueNew(arrayClass, avroArr.addr) == 0):
    echo "Error while creating Avro Array"
  avroArr

proc fillAvroArray*(src: seq[int64], dest: ptr AvroValueT) =
  var
    index: int
    newAvroValue: AvroValueT
    elementClass = avroGenericClassFromSchema(avro_schema_long())
    res = avroGenericValueNew(elementClass, newAvroValue.addr)

  for el in src:
    discard avroValueAppend(dest, newAvroValue.addr, index.addr)
    discard avroValueSetLong(newAvroValue.addr, el)

proc fillAvroValueFromObject*(obj: object, avroV: ptr AvroValueT) =
  var
    avroArr: AvroValueT
  for name, value in obj.fieldPairs:
    if avroValueGetByName(avroV, name, avroArr.addr, 0 ) == 0:
      fillAvroArray(value, avroArr.addr)

proc createAvroValueKey*(schemaKey: ptr SerdesSchemaT): AvroValueT =
  var
    keyAvroValue: AvroValueT
    keyClass = avroGenericClassFromSchema(avroSchemaLong())
    keyRes = avroGenericValueNew(keyClass, keyAvroValue.addr)

  discard avroValueSetLong(keyAvroValue.addr, 5.int64)
  keyAvroValue