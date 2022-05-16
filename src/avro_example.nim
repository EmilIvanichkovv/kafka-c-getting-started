import ../libs/nim_avro/nimavro
import std/os
import
  ./validator_rewards_monitor_avro_helpers,
  ./avro_helpers

let PERSON_SCHEMA* =
  """
  {"type":"record",
      "name":"Person",
      "fields":[
         {"name": "ID", "type": "long"},
         {"name": "First", "type": "string"},
         {"name": "Last", "type": "string"},
         {"name": "Phone", "type": "string"},
         {"name": "Age", "type": "int"}]}
  """
let VRM_SCHEMA* =
  """
{
  "type" : "record",
  "name" : "VRM",
  "namespace" : "com.test.avro",
  "fields" : [ {
    "name" : "source_vote_results",
    "type" : {
      "type" : "array",
      "items" : "long"
    }
  }, {
    "name" : "inclusion_delays",
    "type" : {
      "type" : "array",
      "items" : "long"
    }
  } ]
}
  """
# let NULL_OR_LONG* =  """
# {
#   "type": "record",
#   "name": "nullOrLong",
#   "fields" : [
#     { "name": "value", "type": "long" , "default": null }
#   ]
# }
# """
var idCounter:int64
var err: string


# var testSchemaJ: AvroSchemaT = avro_schema_long()





var
  testObj: AvroObjT
  testSchema = testObj.addr

proc initPersonSchema*(): AvroSchema_t =
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

proc addPerson*(schema: AvroSchemaT,
               first, last, phone: cstring,
               age: int
               ):AvroValueT =
  var res: int

  var
    personClass = avroGenericClassFromSchema(schema)
    person: AvroValueT
    id_value: AvroValueT
    first_value: AvroValueT
    last_value: AvroValueT
    age_value: AvroValueT
    phone_value: AvroValueT
    count: int

  res = avroGenericValueNew(personClass, person.addr)
  # res = avroGenericLongNew(age_value.addr, 0)
  # Set ID
  if person.iface.getByName(person.iface, person.self, "ID".cstring,
                            id_value.addr, count.addr) == 0:
    res = id_value.iface.setLong(id_value.iface, id_value.self, idCounter)
    idCounter = idCounter + 1

  # Set First Name
  if person.iface.getByName(person.iface, person.self, "First".cstring,
                            first_value.addr, count.addr) == 0:
    res = first_value.iface.setString(first_value.iface, first_value.self, first)

  # Set Last Name
  if person.iface.getByName(person.iface, person.self, "Last".cstring,
                            last_value.addr, count.addr) == 0:
    res = last_value.addr.iface.setString(last_value.iface, last_value.self, last)

  # Set Phone
  if person.iface.getByName(person.iface, person.self, "Phone".cstring,
                            phone_value.addr, count.addr) == 0:
    res = phone_value.iface.setString(phone_value.iface, phone_value.self, phone)

  # Set Age
  if person.iface.getByName(person.iface, person.self, "Age".cstring,
                            age_value.addr, count.addr) == 0:
    res = age_value.iface.setInt(age_value.iface, age_value.self, age.int32)

  person

proc addPersonToDB*(schema: AvroSchemaT,
               db: PAvroFileWriterT,
               first, last, phone: cstring,
               age: int
               ) =
  var res: int

  var
    personClass = avroGenericClassFromSchema(schema)
    person: AvroValueT
    id_value: AvroValueT
    first_value: AvroValueT
    last_value: AvroValueT
    age_value: AvroValueT
    phone_value: AvroValueT
    count: int

  person = addPerson(schema, first, last, phone, age)
  res = avroFileWriterAppendValue(db, person.addr)



var personSchema = initPersonSchema();
var
  db: PAvroFileWriterT
  dbname = "test.db"
  self: pointer
  count = 1
  first_value: AvroValueT

removeFile(dbname)


let createWriter = avroFileWriterCreate(dbname.cstring, personSchema, db.addr)
err = avroStrerror()
# let toJson = avroSchemaToJson(personSchema, db)
for i in 0..2:
  addPersonToDB(personSchema, db, "Emil".cstring, "Ivanichkov".cstring,
            "088655555".cstring, 22)
  addPersonToDB(personSchema, db, "Viktor".cstring, "Ivanov".cstring,
            "123456789".cstring, 22)
  addPersonToDB(personSchema, db, "Ivan".cstring, "Blajec".cstring,
            "0000000000".cstring, 22)
  addPersonToDB(personSchema, db, "Travel".cstring, "Isacc".cstring,
            "0".cstring, 22)

err = avroStrerror()
