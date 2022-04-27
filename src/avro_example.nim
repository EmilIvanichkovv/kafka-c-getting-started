import ../libs/nim_avro/nimavro

let PERSON_SCHEMA =
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
var idCounter:int32

var err: string
# let jsonSchema = avro_schema_from_json_length(PERSON_SCHEMA.cstring, PERSON_SCHEMA.len, testSchema)
# echo jsonSchema
err = avro_strerror()
echo err


proc initPersonSchema(): AvroSchema_t =
    var res: int
    let
      id = avro_schema_long()
      firstName = avro_schema_string()
      lastName = avro_schema_string()
      phoneNumber = avro_schema_string()
      age = avro_schema_int()

    let personSchema = avro_schema_record("Person", "5")
    res = avro_schema_record_field_append(personSchema, "ID", id)
    res = avro_schema_record_field_append(personSchema, "First", firstName)
    res = avro_schema_record_field_append(personSchema, "Last", lastName)
    res = avro_schema_record_field_append(personSchema, "Phone", phoneNumber)
    res = avro_schema_record_field_append(personSchema, "Age", age)
    personSchema

proc addPerson(schema: AvroSchema_t,
              #  db: AvroFileWriter_t,
              #  first, last, phone: cstring,
              #  age: int
               ) =
  var res: int

  let
    personClass = avro_generic_class_from_schema(schema)
  var
    person: PAvroValue_t
    id_value: PAvroValue_t
    first_value: PAvroValue_t
    last_value: PAvroValue_t
    age_value: PAvroValue_t
    phone_value: PAvroValue_t

  res = avro_generic_value_new(personClass, person)
  echo person.iface.avro_value_get_by_name(person.iface, person.self, "First", first_value, 0)


let personSchema = initPersonSchema();

var
  db: PAvroFileWriter_t
  dbname = "test.db".cstring

let createWriter = avro_file_writer_create(dbname, personSchema, db)
addPerson(personSchema)