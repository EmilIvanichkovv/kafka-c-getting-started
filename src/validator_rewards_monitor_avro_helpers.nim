# import ../libs/nim_avro/nimavro
# import ./avro_helpers

# import std/os
# import std/sequtils
# import std/options

# var foo: AvroValueT
# discard foo.iface.decref == nil


# # DELETE ME LATER
# type
#   TestObj = object
#     source_vote_results: seq[uint64]
#     inclusion_delays: seq[Option[uint64]]


# proc initValidatorRewardsMonitorSchemaMinimal*(): AvroSchemaT =
#   var res: int
#   let
#     source_vote_results = initAvroArrayLongSchema()
#     inclusion_delays = initAvroArrayLongSchema()
#   echo repr(source_vote_results)
#   let validatorRewardsMonitorSchema = avro_schema_record("ValidatorRewardsMonitor", "2")
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "source_vote_results", source_vote_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "inclusion_delays", inclusion_delays)

#   if isNil(validatorRewardsMonitorSchema):
#     echo "Error while creating Validator Rewards Monitor Schema"

#   validatorRewardsMonitorSchema

# proc initValidatorRewardsMonitorSchema*(): AvroSchemaT =
#   var res: int
#   let
#     source_vote_results = initAvroArrayLongSchema()
#     max_source_vote_results = initAvroArrayLongSchema()
#     target_vote_results = initAvroArrayLongSchema()
#     max_target_vote_results = initAvroArrayLongSchema()
#     head_vote_results = initAvroArrayLongSchema()
#     max_head_vote_results = initAvroArrayLongSchema()
#     inclusion_delays = initAvroArrayLongSchema()
#     inclusion_delay_results = initAvroArrayLongSchema()
#     max_inclusion_delay_results = initAvroArrayLongSchema()
#     sync_committee_results = initAvroArrayLongSchema()
#     max_sync_committee_results = initAvroArrayLongSchema()
#     block_proposal_results = initAvroArrayLongSchema()
#     inactivity_leak_results = initAvroArrayLongSchema()
#     slashing_results = initAvroArrayLongSchema()

#   let validatorRewardsMonitorSchema = avro_schema_record("ValidatorRewardsMonitor", "14")
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "source_vote_results", source_vote_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "max_source_vote_results", max_source_vote_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "target_vote_results", target_vote_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "max_target_vote_results", max_target_vote_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "head_vote_results", head_vote_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "max_head_vote_results", max_head_vote_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "inclusion_delays", inclusion_delays)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "inclusion_delay_results", inclusion_delay_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "max_inclusion_delay_results", max_inclusion_delay_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "sync_committee_results", sync_committee_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "max_sync_committee_results", max_sync_committee_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "block_proposal_results", block_proposal_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "inactivity_leak_results", inactivity_leak_results)
#   res = avro_schema_record_field_append(validatorRewardsMonitorSchema, "slashing_results", slashing_results)

#   if isNil(validatorRewardsMonitorSchema):
#     echo "Error while creating Validator Rewards Monitor Schema"

#   validatorRewardsMonitorSchema

# proc createOptionSeq*(): seq[Option[uint64]] =
#   var inclusion_delays: seq[Option[uint64]]
#   for i in 0..6:
#     if i div 2 == 1:
#       inclusion_delays.add(some(150.uint64))
#     else:
#        inclusion_delays.add(none(uint64))
#   inclusion_delays


# proc Testing*(): AvroValueT =
#   var
#     avroArr: AvroValueT
#     avroValueVRMS: AvroValueT
#     vrms = initValidatorRewardsMonitorSchema()
#     vrmsClass = avroGenericClassFromSchema(vrms)
#     jsonRepr: cstring

#   let res = avroGenericValueNew(vrmsClass, avroValueVRMS.addr)
#   printAvroValue(avroValueVRMS.addr)

#   # if avroValueGetByName(avroValueVRMS.addr, "source_vote_results", avroArr.addr, 0 ) == 0:
#   #   var mySeq: seq[int64] = @[1.int64, 4, 5, 8, 9, 7, 4]
#   #   fillAvroArray(mySeq, avroArr.addr)


#   let myTestObj = TestObj(source_vote_results: @[1.uint64, 4, 5, 8, 9, 7, 4],
#                           inclusion_delays: createOptionSeq())

#   fillAvroValueFromObject(myTestObj, avroValueVRMS.addr)
#   printAvroValue(avroValueVRMS.addr)

#   # echo avroSchemaToSpecific(vrms, jsonRepr)

#   avroValueVRMS