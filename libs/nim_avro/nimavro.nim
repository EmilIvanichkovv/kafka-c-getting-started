const
  avrodll* =  "libavro.so"
  hrr = "avro/value.h"

# Basics
type
  AvroTypeT* = enum
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

  AvroClassT* = enum
    AVRO_SCHEMA
    AVRO_DATUM

  AvroObjT* = object
    avroType*: AvroTypeT
    classType*: AvroClassT
    refcount*: int

  AvroSchemaT* = ptr AvroObjT
  PAvroSchemaT* = ptr AvroSchemaT
# Data

type
  AvroWrappedBufferT* = object
  AvroWrappedBuffer* {.bycopy.} = object
    buf*: pointer
    size*: int
    userData*: pointer
    free*: proc (self: ptr AvroWrappedBufferT) {.cdecl.}
    copy*: proc (dest: ptr AvroWrappedBufferT; src: ptr AvroWrappedBufferT;
               offset: int; length: int): cint {.cdecl.}
    slice*: proc (self: ptr AvroWrappedBufferT; offset: int; length: int): cint {.
        cdecl.}
# Errors
proc avroStrerror*(): string
  {.cdecl, importc: "avro_strerror", dynlib: avrodll.}

# IO
type
  AvroFileReaderT* = object
  PAvroFileReaderT* = ref AvroFileReaderT
  AvroFileWriterT* = object
  PAvroFileWriterT* = ref AvroFileWriterT

proc avro_file_writer_create*(path: cstring,
                              schema: AvroSchemaT,
                              writer: ptr AvroFileWriterT): int
  {.cdecl, importc: "avro_file_writer_create", dynlib: avrodll.}

proc avro_file_writer_create_with_codec*(path: cstring,
                                         schema: AvroSchemaT,
                                         writer: ptr AvroFileWriterT,
                                         codec: cstring,
                                         blockSize: int ): int
  {.cdecl, importc: "avro_file_writer_create_with_codec", dynlib: avrodll.}

# Value

type
  AvroValueT* {.bycopy.} = object
    iface*: ptr AvroValueIfaceT
    self*: pointer


  AvroValueIfaceT* {.bycopy.} = object
    increfIface*: proc (iface: ptr AvroValueIfaceT): ptr AvroValueIfaceT {.cdecl.}
    decrefIface*: proc (iface: ptr AvroValueIfaceT) {.cdecl.}
    incref*: proc (value: ptr AvroValueT) {.cdecl.}
    decref*: proc (value: ptr AvroValueT) {.cdecl.}
    reset*: proc (iface: ptr AvroValueIfaceT; self: pointer): cint {.cdecl.}
    getType*: proc (iface: ptr AvroValueIfaceT; self: pointer): AvroTypeT {.cdecl.}
    getSchema*: proc (iface: ptr AvroValueIfaceT; self: pointer): AvroSchemaT {.cdecl.}
    getBoolean*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr cint): cint {.
        cdecl.}
    getBytes*: proc (iface: ptr AvroValueIfaceT; self: pointer; buf: ptr pointer;
                   size: ptr int): cint {.cdecl.}
    grabBytes*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                    dest: ptr AvroWrappedBufferT): cint {.cdecl.}
    getDouble*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr cdouble): cint {.
        cdecl.}
    getFloat*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr cfloat): cint {.
        cdecl.}
    getInt*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr int32): cint {.
        cdecl.}
    getLong*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr int64): cint {.
        cdecl.}
    getNull*: proc (iface: ptr AvroValueIfaceT; self: pointer): cint {.cdecl.}
    getString*: proc (iface: ptr AvroValueIfaceT; self: pointer; str: cstringArray;
                    size: ptr int): cint {.cdecl.}
    grabString*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                     dest: ptr AvroWrappedBufferT): cint {.cdecl.}
    getEnum*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr cint): cint {.
        cdecl.}
    getFixed*: proc (iface: ptr AvroValueIfaceT; self: pointer; buf: ptr pointer;
                   size: ptr int): cint {.cdecl.}
    grabFixed*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                    dest: ptr AvroWrappedBufferT): cint {.cdecl.}
    setBoolean*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: cint): cint {.cdecl.}
    setBytes*: proc (iface: ptr AvroValueIfaceT; self: pointer; buf: pointer;
                   size: int): cint {.cdecl.}
    giveBytes*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                    buf: ptr AvroWrappedBufferT): cint {.cdecl.}
    setDouble*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: cdouble): cint {.
        cdecl.}
    setFloat*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: cfloat): cint {.cdecl.}
    setInt*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: int32): cint {.cdecl.}
    setLong*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: int64): cint {.cdecl.}
    setNull*: proc (iface: ptr AvroValueIfaceT; self: pointer): cint {.cdecl.}
    setString*: proc (iface: ptr AvroValueIfaceT; self: pointer; str: cstring): cint {.
        cdecl.}
    setStringLen*: proc (iface: ptr AvroValueIfaceT; self: pointer; str: cstring;
                       size: int): cint {.cdecl.}
    giveStringLen*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                        buf: ptr AvroWrappedBufferT): cint {.cdecl.}
    setEnum*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: cint): cint {.cdecl.}
    setFixed*: proc (iface: ptr AvroValueIfaceT; self: pointer; buf: pointer;
                   size: int): cint {.cdecl.}
    giveFixed*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                    buf: ptr AvroWrappedBufferT): cint {.cdecl.}
    getSize*: proc (iface: ptr AvroValueIfaceT; self: pointer; size: ptr int): cint {.
        cdecl.}
    getByIndex*: proc (iface: ptr AvroValueIfaceT; self: pointer; index: int;
                     child: ptr AvroValueT; name: cstringArray): cint {.cdecl.}
    getByName*: proc (iface: ptr AvroValueIfaceT; self: pointer; name: cstring;
                    child: ptr AvroValueT; index: ptr int): cint {.cdecl.}
    getDiscriminant*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr cint): cint {.
        cdecl.}
    getCurrentBranch*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                           branch: ptr AvroValueT): cint {.cdecl.}
    append*: proc (iface: ptr AvroValueIfaceT; self: pointer; childOut: ptr AvroValueT;
                 newIndex: ptr int): cint {.cdecl.}
    add*: proc (iface: ptr AvroValueIfaceT; self: pointer; key: cstring;
              child: ptr AvroValueT; index: ptr int; isNew: ptr cint): cint {.cdecl.}
    setBranch*: proc (iface: ptr AvroValueIfaceT; self: pointer; discriminant: cint;
                    branch: ptr AvroValueT): cint {.cdecl.}

# Generic
proc avro_generic_class_from_schema*(schema: AvroSchemaT): ptr AvroValueIfaceT
  {.cdecl, importc: "avro_generic_class_from_schema", dynlib: avrodll.}

proc avro_generic_value_new*(iface: ptr AvroValueIfaceT, dest: ptr AvroValueT): int
  {.cdecl, importc: "avro_generic_value_new", dynlib: avrodll.}

# Schemas
proc avroSchemaString*(): AvroSchemaT{.
  cdecl, importc: "avro_schema_string", dynlib: avrodll.}

proc avroSchemaBytes*(): AvroSchemaT{.
  cdecl, importc: "avro_schema_bytes", dynlib: avrodll.}

proc avroSchemaInt*(): AvroSchemaT{.
  cdecl, importc: "avro_schema_int", dynlib: avrodll.}

proc avroSchemaLong*(): AvroSchemaT{.
  cdecl, importc: "avro_schema_long", dynlib: avrodll.}

proc avroSchemaFloat*(): AvroSchemaT{.
  cdecl, importc: "avro_schema_float", dynlib: avrodll.}

proc avroSchemaDouble*(): AvroSchemaT{.
  cdecl, importc: "avro_schema_double", dynlib: avrodll.}

proc avroSchemaBoolean*(): AvroSchemaT{.
  cdecl, importc: "avro_schema_boolean", dynlib: avrodll.}

proc avroSchemaNull*(): AvroSchemaT{.
  cdecl, importc: "avro_schema_null", dynlib: avrodll.}

proc avroSchemaRecord*(name: cstring; space: cstring): AvroSchemaT{.
  cdecl, importc: "avro_schema_record", dynlib: avrodll.}

proc avroSchemaRecordFieldGet*(record: AvroSchemaT; fieldName: cstring): AvroSchemaT {.
  cdecl, importc: "avro_schema_record_field_get", dynlib: avrodll.}

proc avroSchemaRecordFieldName*(schema: AvroSchemaT; index: cint): cstring {.cdecl,
  importc: "avro_schema_record_field_name", dynlib: avrodll.}

proc avroSchemaRecordFieldGetIndex*(schema: AvroSchemaT; fieldName: cstring): cint {.
  cdecl, importc: "avro_schema_record_field_get_index", dynlib: avrodll.}

proc avroSchemaRecordFieldGetByIndex*(record: AvroSchemaT; index: cint): AvroSchemaT {.
  cdecl, importc: "avro_schema_record_field_get_by_index", dynlib: avrodll.}

proc avroSchemaRecordFieldAppend*(record: AvroSchemaT;
                                  fieldName: cstring;
                                  `type`: AvroSchemaT): cint {.
  cdecl, importc: "avro_schema_record_field_append", dynlib: avrodll.}

proc avroSchemaRecordSize*(record: AvroSchemaT): int {.cdecl,
    importc: "avro_schema_record_size", dynlib: avrodll.}

proc avroSchemaFromJsonLength*(jsontext: cstring; length: int;
                              schema: ptr AvroSchemaT): cint {.cdecl,
    importc: "avro_schema_from_json_length", dynlib: avrodll.}
# proc avro_schema_record_size*(schema: AvroSchemaT):int
#   {.cdecl, importc: "avro_schema_record_size", dynlib: avrodll.}
