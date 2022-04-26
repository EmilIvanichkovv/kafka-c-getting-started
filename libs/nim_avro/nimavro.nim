const
  avrodll* =  "libavro.so"

type
  AvroSchema_t* = object
  PAvroSchema_t = ptr AvroSchema_t

const PERSON_SCHEMA =
  """
  {\"type\":\"record\",\
      \"name\":\"Person\",\
      \"fields\":[\
         {\"name\": \"ID\", \"type\": \"long\"},\
         {\"name\": \"First\", \"type\": \"string\"},\
         {\"name\": \"Last\", \"type\": \"string\"},\
         {\"name\": \"Phone\", \"type\": \"string\"},\
         {\"name\": \"Age\", \"type\": \"int\"}]}
  """
var testSchema: PAvroSchema_t

# Errors
proc avroSterror(): string
  {.cdecl, importc: "avro_strerror", dynlib: avrodll.}

proc avroSchemaFromJson*(jsonSchema: cstring ,size: int, avroSchema: PAvroSchema_t): int
  {.cdecl, importc: "avro_schema_from_json_length", dynlib: avrodll.}

proc avroSchemaRecordSize*(schema: AvroSchema_t):int
  {.cdecl, importc: "avro_schema_record_size", dynlib: avrodll.}



let a = avroSchemaFromJson(PERSON_SCHEMA.cstring, PERSON_SCHEMA.len, testSchema)
echo a
let x = avroSterror()
echo x
let b = avroSchemaRecordSize(testSchema[])
echo b
