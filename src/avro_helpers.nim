import ../libs/nim_avro/nimavro
import std/os
import std/sequtils
import std/options


# let nullOrLong* =  """
# {
#   "namespace": "example.avro",
#   "type": "record",
#   "name": "Example",
#   "fields": [
#     {
#       "name": "values",
#       "type":
#       {
#         "type": "array",
#         "items": ["long", "null"]
#       }
#     }
#   ]
# }
# """

var foo: AvroValueT
discard foo.iface.decref == nil

proc printAvroValue*(avroValue:ptr AvroValueT) =
  var avroValueToJsonStr: cstring
  if avroValueToJson(avroValue, 1, avroValueToJsonStr.addr) == 0:
    echo avroValueToJsonStr
  else:
    echo "Error while printing Avro Value"
    echo avroValueToJson(avroValue, 1, avroValueToJsonStr.addr)
    echo avroStrerror()

proc initAvroArrayLongSchema*(): AvroSchemaT =
  var
    longSchema = avro_schema_long()
    avroArraySchema: AvroSchemaT = avroSchemaArray(longSchema)
  avroArraySchema

# proc initAvroArrayOptionLongSchema*(): AvroSchemaT =
#   var
#     nullOrLongSchema: AvroSchemaT = avroSchemaUnion()
#   echo avroSchemaFromJsonLength(nullOrLong.cstring, nullOrLong.len, nullOrLongSchema.addr)
#     # avroArraySchema: AvroSchemaT = avroSchemaArray(longSchema)

#   nullOrLongSchema


proc initAvroArrayLongValue*(): AvroValueT =
  var
    avroArr: AvroValueT
    avroArraySchema: AvroSchemaT = initAvroArrayLongSchema()
    arrayClass = avroGenericClassFromSchema(avroArraySchema)
  if not (avroGenericValueNew(arrayClass, avroArr.addr) == 0):
    echo "Error while creating Avro Array"
  avroArr

proc fillAvroArray*(src: seq[Option[uint64]], dest: ptr AvroValueT) =
  var
    index: int
    newLongAvroValue: AvroValueT
    longClass = avroGenericClassFromSchema(avro_schema_long())
    res = avroGenericValueNew(longClass, newLongAvroValue.addr)

  for el in src:
    if el.isNone:
      discard avroValueAppend(dest, newLongAvroValue.addr, index.addr)
      discard avroValueSetLong(newLongAvroValue.addr,  -1.int64)
    else:
      discard avroValueAppend(dest, newLongAvroValue.addr, index.addr)
      discard avroValueSetLong(newLongAvroValue.addr,  el.get.int64)

proc fillAvroArray*(src: seq[uint64], dest: ptr AvroValueT) =
  var
    index: int
    newLongAvroValue: AvroValueT
    longClass = avroGenericClassFromSchema(avro_schema_long())

    resL = avroGenericValueNew(longClass, newLongAvroValue.addr)

  for el in src:
    discard avroValueAppend(dest, newLongAvroValue.addr, index.addr)
    discard avroValueSetLong(newLongAvroValue.addr, el.int64)

proc fillAvroValueFromObject*(obj: object, avroV: ptr AvroValueT) =
  var
    avroArr: AvroValueT
  for name, value in obj.fieldPairs:
    if avroValueGetByName(avroV, name, avroArr.addr, 0 ) == 0:
      fillAvroArray(value, avroArr.addr)