import system/io

const
  avrodll* =  "libavro.so"
  hrr = "avro/value.h"

import system/io

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

  AvroRawArrayT* {.bycopy.} = object
    elementSize*: csize_t
    elementCount*: csize_t
    allocatedSize*: csize_t
    data*: pointer

  AvroSchemaT* = ptr AvroObjT
  PAvroSchemaT* = ptr AvroSchemaT

# Data
type
  AvroWrappedBufferT* {.bycopy.} = object
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

# Value
type
  AvroValueT* {.bycopy.} = object
    iface*:ptr AvroValueIfaceT
    self*: pointer

  AvroValueIfaceT* {.bycopy.} = object
    incref_iface*: proc (iface: ptr AvroValueIfaceT): ptr AvroValueIfaceT {.cdecl.}
    decref_iface*: proc (iface: ptr AvroValueIfaceT) {.cdecl.}
    incref*: proc (value: ptr AvroValueT) {.cdecl.}
    decref*: proc (value: ptr AvroValueT) {.cdecl.}
    reset*: proc (iface: ptr AvroValueIfaceT; self: pointer): cint {.cdecl.}
    get_type*: proc (iface: ptr AvroValueIfaceT; self: pointer): AvroTypeT {.cdecl.}
    get_schema*: proc (iface: ptr AvroValueIfaceT; self: pointer): AvroSchemaT {.cdecl.}
    get_boolean*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr cint): cint {.
        cdecl.}
    get_bytes*: proc (iface: ptr AvroValueIfaceT; self: pointer; buf: ptr pointer;
                   size: ptr int): cint {.cdecl.}
    grab_bytes*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                    dest: ptr AvroWrappedBufferT): int {.cdecl.}
    get_double*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr cdouble): cint {.
        cdecl.}
    get_float*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr cfloat): cint {.
        cdecl.}
    get_int*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr int32): cint {.
        cdecl.}
    get_long*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr int64): cint {.
        cdecl.}
    get_null*: proc (iface: ptr AvroValueIfaceT; self: pointer): cint {.cdecl.}
    get_string*: proc (iface: ptr AvroValueIfaceT; self: pointer; str: cstringArray;
                    size: ptr int): cint {.cdecl.}
    grab_string*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                     dest: ptr AvroWrappedBufferT): cint {.cdecl.}
    get_enum*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr cint): cint {.
        cdecl.}
    get_fixed*: proc (iface: ptr AvroValueIfaceT; self: pointer; buf: ptr pointer;
                   size: ptr int): cint {.cdecl.}
    grab_fixed*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                    dest: ptr AvroWrappedBufferT): cint {.cdecl.}
    set_boolean*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: cint): cint {.cdecl.}
    set_bytes*: proc (iface: ptr AvroValueIfaceT; self: pointer; buf: pointer;
                   size: int): cint {.cdecl.}
    give_bytes*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                    buf: ptr AvroWrappedBufferT): cint {.cdecl.}
    set_double*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: cdouble): cint {.
        cdecl.}
    set_float*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: cfloat): cint {.cdecl.}
    set_int*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: int32): cint {.cdecl.}
    set_long*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: int64): cint {.cdecl.}
    setNull*: proc (iface: ptr AvroValueIfaceT; self: pointer): cint {.cdecl.}
    set_string*: proc (iface: ptr AvroValueIfaceT; self: pointer; str: cstring): cint {.
        cdecl.}
    set_string_len*: proc (iface: ptr AvroValueIfaceT; self: pointer; str: cstring;
                       size: int): cint {.cdecl.}
    give_string_len*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                        buf: ptr AvroWrappedBufferT): cint {.cdecl.}
    set_enum*: proc (iface: ptr AvroValueIfaceT; self: pointer; val: cint): cint {.cdecl.}
    set_fixed*: proc (iface: ptr AvroValueIfaceT; self: pointer; buf: pointer;
                   size: int): cint {.cdecl.}
    give_fixed*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                    buf: ptr AvroWrappedBufferT): cint {.cdecl.}
    get_size*: proc (iface: ptr AvroValueIfaceT; self: pointer; size: ptr int): cint {.
        cdecl.}
    get_by_index*: proc (iface: ptr AvroValueIfaceT; self: pointer; index: int;
                     child: ptr AvroValueT; name: cstringArray): cint {.cdecl.}
    get_by_name*: proc (iface: ptr AvroValueIfaceT; self: pointer; name: cstring;
                    child: ptr AvroValueT; index: ptr int): cint {.cdecl.}
    get_discriminant*: proc (iface: ptr AvroValueIfaceT; self: pointer; `out`: ptr cint): cint {.
        cdecl.}
    get_current_branch*: proc (iface: ptr AvroValueIfaceT; self: pointer;
                           branch: ptr AvroValueT): cint {.cdecl.}
    append*: proc (iface: ptr AvroValueIfaceT; self: pointer; childOut: ptr AvroValueT;
                 newIndex: ptr int): cint {.cdecl.}
    add*: proc (iface: ptr AvroValueIfaceT; self: pointer; key: cstring;
              child: ptr AvroValueT; index: ptr int; isNew: ptr cint): cint {.cdecl.}
    set_branch*: proc (iface: ptr AvroValueIfaceT; self: pointer; discriminant: cint;
                    branch: ptr AvroValueT): cint {.cdecl.}

proc avroValueToJson*(value: ptr AvroValueT, oneLine: int, jsonStr: ptr cstring):int
  {.cdecl, importc: "avro_value_to_json", dynlib: avrodll.}

proc avroValueIncref*(value: ptr AvroValueT) {.cdecl, importc: "avro_value_incref",
    dynlib: avrodll.}

# Macros from value.h
proc avroValueGrabBytes*(value: ptr AvroValueT, dest: ptr AvroWrappedBufferT): int
  {. header:"avro/value.h" importc: "avro_value_grab_bytes".}

proc avroValueSetLong*(value: ptr AvroValueT, src: int64): int
  {. header:"avro/value.h" importc: "avro_value_set_long".}

proc avroValueSetDouble*(value: ptr AvroValueT, src: float): int
  {. header:"avro/value.h" importc: "avro_value_set_double".}

proc avroValueSetString*(value: ptr AvroValueT, src: cstring): int
  {. header:"avro/value.h" importc: "avro_value_set_string".}

proc avroValueGetByName*(value: ptr AvroValueT, name: cstring,
                         child: ptr AvroValueT, index: int): int
  {. header:"avro/value.h" importc: "avro_value_get_by_name".}

proc avroValueGetString*(value: ptr AvroValueT, dest: ptr cstring, size: int): int
  {. header:"avro/value.h" importc: "avro_value_get_string".}

proc avroValueGetSchema*(value: ptr AvroValueT): int
  {. header:"avro/value.h" importc: "avro_value_get_schema".}

proc avroValueAppend*(value: ptr AvroValueT, child: ptr AvroValueT, newIndex: ptr int): int
  {. header:"avro/value.h" importc: "avro_value_append".}

# Data
proc avroRawArrayInit*(array: ptr AvroRawArrayT; elementSize: int) {.cdecl,
    importc: "avro_raw_array_init", dynlib: avrodll.}

# IO
type
  AvroReaderT* = object
  AvroWriterT* = object

proc avroWriterFlush*(writer: AvroWriterT) {.cdecl, importc: "avro_writer_flush",
    dynlib: avrodll.}

proc avroWriterFree*(writer: AvroWriterT) {.cdecl, importc: "avro_writer_free",
    dynlib: avrodll.}

proc avroWriterReset*(writer: AvroWriterT) {.cdecl, importc: "avro_writer_reset",
    dynlib: avrodll.}

proc avroSchemaToJson*(schema: AvroSchemaT; `out`: AvroWriterT): cint {.cdecl,
    importc: "avro_schema_to_json", dynlib: avrodll.}

proc avroWriterMemory*(buf: cstring; len: int64): AvroWriterT {.cdecl,
    importc: "avro_writer_memory", dynlib: avrodll.}

proc avroWriterDump*(writer: AvroWriterT; fp: ptr File) {.cdecl,
    importc: "avro_writer_dump", dynlib: avrodll.}


proc avroValueWrite*(writer: AvroWriterT; src: ptr AvroValueT): int {.cdecl,
    importc: "avro_value_write", dynlib: avrodll.}

type
  AvroFileReaderT* = object
  AvroFileWriterT* = object
  PAvroFileWriterT* = ptr AvroFileWriterT

proc avroFileWriterCreate*(path: cstring; schema: AvroSchemaT;
                          writer: ptr PAvroFileWriterT): cint {.cdecl,
    importc: "avro_file_writer_create", dynlib: avrodll.}

proc avroFileWriterCreateWithCodec*(path: cstring; schema: AvroSchemaT;
                                   writer: ptr AvroFileWriterT; codec: cstring;
                                   blockSize: int): cint {.cdecl,
    importc: "avro_file_writer_create_with_codec", dynlib: avrodll.}

proc avroFileWriterSync*(writer: AvroFileWriterT): cint {.cdecl,
    importc: "avro_file_writer_sync", dynlib: avrodll.}

proc avroFileReaderReadValue*(reader: AvroFileReaderT; dest: ptr AvroValueT): cint {.
    cdecl, importc: "avro_file_reader_read_value", dynlib: avrodll.}

proc avroFileWriterAppendValue*(writer: PAvroFileWriterT; src: ptr AvroValueT): cint {.
    cdecl, importc: "avro_file_writer_append_value", dynlib: avrodll.}

proc avroFileWriterOpen*(path: cstring; writer: ptr AvroFileWriterT): cint {.cdecl,
    importc: "avro_file_writer_open", dynlib: avrodll.}


proc avroFileWriterFlush*(writer: PAvroFileWriterT): cint {.cdecl,
    importc: "avro_file_writer_flush", dynlib: avrodll.}

# Generic
proc avroGenericClassFromSchema*(schema: AvroSchemaT): ptr AvroValueIfaceT {.cdecl,
    importc: "avro_generic_class_from_schema", dynlib: avrodll.}

proc avroGenericValueNew*(iface: ptr AvroValueIfaceT; dest: ptr AvroValueT): int {.
    cdecl, importc: "avro_generic_value_new", dynlib: avrodll.}

proc avroGenericBooleanNew*(value: ptr AvroValueT; val: cint): cint {.cdecl,
    importc: "avro_generic_boolean_new", dynlib: avrodll.}
proc avroGenericBytesNew*(value: ptr AvroValueT; buf: pointer; size: int): cint {.
    cdecl, importc: "avro_generic_bytes_new", dynlib: avrodll.}
proc avroGenericDoubleNew*(value: ptr AvroValueT; val: cdouble): cint {.cdecl,
    importc: "avro_generic_double_new", dynlib: avrodll.}
proc avroGenericFloatNew*(value: ptr AvroValueT; val: cfloat): cint {.cdecl,
    importc: "avro_generic_float_new", dynlib: avrodll.}
proc avroGenericIntNew*(value: ptr AvroValueT; val: int32): cint {.cdecl,
    importc: "avro_generic_int_new", dynlib: avrodll.}
proc avroGenericLongNew*(value: ptr AvroValueT; val: int64): cint {.cdecl,
    importc: "avro_generic_long_new", dynlib: avrodll.}
proc avroGenericNullNew*(value: ptr AvroValueT): cint {.cdecl,
    importc: "avro_generic_null_new", dynlib: avrodll.}
proc avroGenericStringNew*(value: ptr AvroValueT; val: cstring): cint {.cdecl,
    importc: "avro_generic_string_new", dynlib: avrodll.}
proc avroGenericStringNewLength*(value: ptr AvroValueT; val: cstring; size: int): cint {.
    cdecl, importc: "avro_generic_string_new_length", dynlib: avrodll.}

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

proc avroSchemaArray*(items: AvroSchemaT): AvroSchemaT {.cdecl,
    importc: "avro_schema_array", dynlib: avrodll.}

proc avroSchemaArrayItems*(array: AvroSchemaT): AvroSchemaT {.cdecl,
    importc: "avro_schema_array_items", dynlib: avrodll.}

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

proc avroSchemaToSpecific*(schema: AvroSchemaT; prefix: cstring): int {.cdecl,
    importc: "avro_schema_to_specific", dynlib: avrodll.}
