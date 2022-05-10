const
  serdesdll* =  "libserdes.so"
  hrr = "libserdes/serdes.h"

import ../nim_avro/nimavro

type
  SerdesT* = object
  PSerdesT* = ref SerdesT

  SerdesSchemaT* = object
  PSerdesSchemaT* = ref SerdesSchemaT

  SerdesConfT* = object
  PSerdesConfT* = ref SerdesConfT

  SerdesErrT* = enum
      SERDES_ERR_OK,
      SERDES_ERR_CONF_UNKNOWN,
      SERDES_ERR_CONF_INVALID,
      SERDES_ERR_FRAMING_INVALID,
      SERDES_ERR_SCHEMA_LOAD,
      SERDES_ERR_PAYLOAD_INVALID,
      SERDES_ERR_SCHEMA_MISMATCH,
      SERDES_ERR_SCHEMA_REQUIRED,
      SERDES_ERR_SERIALIZER,
      SERDES_ERR_BUFFER_SIZE

proc serdesSchemaSerializeAvro*(schema: ptr SerdesSchemaT,
                               avro: ptr AvroValueT,
                               payload: pointer,
                               sizep: ptr int,
                               errstr: cstring,
                               errstrSize: int): SerdesErrT
  {.cdecl, importc: "serdes_schema_serialize_avro", dynlib: serdesdll.}

proc serdesConfNew*(errstr: cstring; errstrSize: int): ptr SerdesConfT {.varargs,
    cdecl, importc: "serdes_conf_new", dynlib: serdesdll.}

# proc serdesConfSet*(sconf: PSerdesConfT, name: cstring, val: cstring,
#                     errstr: cstring, errstrSize: int)
#   {.cdecl, importc: "serdes_conf_set", dynlib: serdesdll.}

proc serdesConfSet*(sconf: ptr SerdesConfT; name: cstring; val: cstring;
                   errstr: cstring; errstrSize: int): SerdesErrT {.cdecl,
    importc: "serdes_conf_set", dynlib: serdesdll.}

proc serdesSchemaGet*(sd: ptr SerdesT; name: cstring; id: int; errstr: cstring;
                     errstrSize: int): ptr SerdesSchemaT {.cdecl,
    importc: "serdes_schema_get", dynlib: serdesdll.}

proc serdesSchemaAdd*(sd: ptr SerdesT; name: cstring; id: int; definition: pointer;
                     definitionLen: int; errstr: cstring; errstrSize: int): ptr SerdesSchemaT {.
    cdecl, importc: "serdes_schema_add", dynlib: serdesdll.}

proc serdesSchemaId*(schema: ptr SerdesSchemaT): int
  {.cdecl, importc: "serdes_schema_id", dynlib: serdesdll.}

proc serdesSchemaName*(schema: ptr SerdesSchemaT): cstring {.cdecl,
    importc: "serdes_schema_name", dynlib: serdesdll.}

proc serdesSchemaDefinition*(schema: ptr SerdesSchemaT): cstring {.cdecl,
    importc: "serdes_schema_definition", dynlib: serdesdll.}

proc serdesNew*(conf: ptr SerdesConfT; errstr: cstring; errstrSize: int): ptr SerdesT {.
    cdecl, importc: "serdes_new", dynlib: serdesdll.}

