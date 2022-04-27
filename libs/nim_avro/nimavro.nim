const
  avrodll* =  "libavro.so"
  hrr = "avro/value.h"

# Basics
type
  avroType_t* = enum
    AVRO_STRING
    AVRO_BYTES
    AVRO_INT32
    AVRO_INT64
    AVRO_FLOAT
    AVRO_DOUBLE
    AVRO_BOOLEAN
    AVRO_NULL
    AVRO_RECORD
    AVRO_ENUM
    AVRO_FIXED
    AVRO_MAP
    AVRO_ARRAY
    AVRO_UNION
    AVRO_LINK

  classType_t* = enum
    AVRO_SCHEMA
    AVRO_DATUM

  AvroObj_t* = object
    avroType: avroType_t
    classType: classType_t
    refcount: int

  AvroSchema_t* = ptr AvroObj_t
  PAvroSchema_t* = ptr AvroSchema_t

# Errors
proc avro_strerror*(): string
  {.cdecl, importc: "avro_strerror", dynlib: avrodll.}

# IO
type
  AvroFileReader_t* = object
  PAvroFileReader_t* = ref AvroFileReader_t
  AvroFileWriter_t* = object
  PAvroFileWriter_t* = ref AvroFileWriter_t

proc avro_file_writer_create*(path: cstring,
                              schema: AvroSchema_t,
                              writer: PAvroFileWriter_t): int
  {.cdecl, importc: "avro_file_writer_create", dynlib: avrodll.}

proc avro_file_writer_create_with_codec*(path: cstring,
                                         schema: AvroSchema_t,
                                         writer: PAvroFileWriter_t,
                                         codec: cstring,
                                         blockSize: int ): int
  {.cdecl, importc: "avro_file_writer_create_with_codec", dynlib: avrodll.}

# Value
type
  AvroValueIFace_t* = object
    {.importc: "struct avro_value_iface" header: hrr.}

  PAvroValueIFace_t* = ref AvroValueIFace_t

  AvroValue_t* = object
    iface*: PAvroValueIFace_t
    self*: pointer
  PAvroValue_t* =ref AvroValue_t

proc avro_value_get_by_name*(valuea: PAvroValueIFace_t,
                             value: PAvroValueIFace_t,
                             self: pointer,
                             name: cstring,
                             child: PAvroValue_t,
                             index: int): int
  {.cdecl,header:hrr, importcpp: "#.get_by_name(@)".}

# template avro_value_get_by_name(value: PAvroValue_t,
#                                 name: cstring,
#                                 child: PAvroValue_t,
#                                 index: int =
#   {.emit: "avro_value_get_by_name(",value, name, child, index, ")".}


# Generic
proc avro_generic_class_from_schema*(schema: AvroSchema_t): PAvroValueIFace_t
  {.cdecl, importc: "avro_generic_class_from_schema", dynlib: avrodll.}

proc avro_generic_value_new*(iface: PAvroValueIFace_t, dest: PAvroValue_t): int
  {.cdecl, importc: "avro_generic_value_new", dynlib: avrodll.}

# Schemas
proc avro_schema_string*(): AvroSchema_t
  {.cdecl, importc: "avro_schema_string", dynlib: avrodll.}

proc avro_schema_bytes*(): AvroSchema_t
  {.cdecl, importc: "avro_schema_bytes", dynlib: avrodll.}

proc avro_schema_int*(): AvroSchema_t
  {.cdecl, importc: "avro_schema_int", dynlib: avrodll.}

proc avro_schema_long*(): AvroSchema_t
  {.cdecl, importc: "avro_schema_long", dynlib: avrodll.}

proc avro_schema_float*(): AvroSchema_t
  {.cdecl, importc: "avro_schema_float", dynlib: avrodll.}

proc avro_schema_double*(): AvroSchema_t
  {.cdecl, importc: "avro_schema_double", dynlib: avrodll.}

proc avro_schema_boolean*(): AvroSchema_t
  {.cdecl, importc: "avro_schema_boolean", dynlib: avrodll.}

proc avro_schema_null*(): AvroSchema_t
  {.cdecl, importc: "avro_schema_null", dynlib: avrodll.}

proc avro_schema_record*(name: cstring, space: cstring): AvroSchema_t
  {.cdecl, importc: "avro_schema_record", dynlib: avrodll.}

proc avro_schema_record_field_get*(record: AvroSchema_t, fieldName: cstring): AvroSchema_t
  {.cdecl, importc: "avro_schema_record_field_get", dynlib: avrodll.}

proc avro_schema_record_field_name*(schema: AvroSchema_t, index: int): cstring
  {.cdecl, importc: "avro_schema_record_field_name", dynlib: avrodll.}

proc avro_schema_record_field_get_index*(schema: AvroSchema_t, fieldName: cstring): int
  {.cdecl, importc: "avro_schema_record_field_get_index", dynlib: avrodll.}

proc avro_schema_record_field_get_by_index*(schema: AvroSchema_t, index: int): AvroSchema_t
  {.cdecl, importc: "avro_schema_record_field_get_by_index", dynlib: avrodll.}

proc avro_schema_record_field_append*(record: AvroSchema_t,
                                     fieldName: cstring,
                                     fieldType: AvroSchema_t): int
  {.cdecl, importc: "avro_schema_record_field_append", dynlib: avrodll.}

proc avro_schema_from_json_length*(jsonSchema: cstring ,size: int, avroSchema: PAvroSchema_t): int
  {.cdecl, importc: "avro_schema_from_json_length", dynlib: avrodll.}

proc avro_schema_record_size*(schema: AvroSchema_t):int
  {.cdecl, importc: "avro_schema_record_size", dynlib: avrodll.}
