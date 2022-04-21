
{.link: "/nix/store/zwbf01pncrclfvlgrkwgmfwyhbb0zcnf-rdkafka-1.8.2/lib/librdkafka++.so"}

import cppstl

const
  librdkafka* = "librdkafka++.so"
  irr = "<librdkafka/rdkafkacpp.h>"

type
  List*[T]                              {.importcpp: "std::list", header: "<list>".} = object
  ListIter*[T]                          {.importcpp: "std::list<'0>::iterator", header: "<list>".} = object

proc initList*[T](): List[T]            {.importcpp: "std::list<'*0>()", constructor, header: "<list>".}
proc size*(l: List): csize_t            {.importcpp: "size", header: "<list>".}
proc begin*[T](l: List[T]): ListIter[T] {.importcpp: "begin", header: "<list>".}
proc `[]`*[T](it: ListIter[T]): T       {.importcpp: "*#", header: "<list>".}
proc next*[T](it: ListIter[T]; n = 1): ListIter[T] {.importcpp: "next(@)", header: "<iterator>".}
proc toSeq*[T](l: List[T]): seq[T] =
  echo l.size()
  var
    result: seq[CppString]
    it = l.begin()
  # echo result.len
  for i in 0 ..< l.size():
    echo i
    echo it[]
    if it == nil:
      echo "ERROR"
    result.add(it[])
    it = it.next()
  result


# VERSION

proc rd_kafka_version_cpp*(): int {.
                                    dynlib: librdkafka,
                                    header: irr,
                                    importcpp: "RdKafka::version()"
                                    .}

# CONF Utils:

type

  Conf* {.header: irr,
         importcpp: "RdKafka::Conf".} = object
  PConf* = ptr Conf
  ConfType* = enum
    CONF_GLOBAL, CONF_TOPIC

  ConfResult* = enum
    CONF_UNKNOWN = - 2,
    CONF_INVALID = - 1,
    CONF_OK = 0

proc create* (confType: ConfType):ptr Conf
  {.header: irr, importcpp: "RdKafka::Conf::create(@)".}


proc set* (this: PConf, name, value: CppString, errstr: var CppString ): ConfResult
  {.header: irr, importcpp: "#.set(@)".}

proc dump*(this: PConf): ptr List[CppString]
 {.header: irr, importcpp: "#.dump()".}

# ErrorCode Utils:

type
  ErrorCode = enum
      ERR_BEGIN = "Begin internal error codes"
      ERR_BAD_MSG = "Received message is incorrect"
      ERR_BAD_COMPRESSION = "Bad/unknown compression"
      ERR_DESTROY = "Broker is going away"
      ERR_FAIL = "Generic failure"
      ERR_TRANSPORT = "Broker transport failure"
      ERR_CRIT_SYS_RESOURCE = "Critical system resource"
      ERR_RESOLVE = "Failed to resolve broker"
      ERR_MSG_TIMED_OUT = "Produced message timed out"
      ERR_PARTITION_EOF = "Reached the end of the topic+partition queue on the broker. Not really an error. This event is disabled by default, see the enable.partition.eof configuration property."
      ERR_UNKNOWN_PARTITION = "Permanent: Partition does not exist in cluster."
      ERR_FS = "File or filesystem error"
      ERR_UNKNOWN_TOPIC = "Permanent: Topic does not exist in cluster."
      ERR_ALL_BROKERS_DOWN = "All broker connections are down."
      ERR_INVALID_ARG = "Invalid argument, or invalid configuration"
      ERR_TIMED_OUT = "Operation timed out"
      ERR_QUEUE_FULL = "Queue is full"
      ERR_ISR_INSUFF = "ISR count < required.acks"
      ERR_NODE_UPDATE = "Broker node update"
      ERR_SSL = "SSL error"
      ERR_WAIT_COORD = "Waiting for coordinator to become available."
      ERR_UNKNOWN_GROUP = "Unknown client group"
      ERR_IN_PROGRESS = "Operation in progress"
      ERR_PREV_IN_PROGRESS = "Previous operation in progress, wait for it to finish."
      ERR_EXISTING_SUBSCRIPTION = "his operation would interfere with an existing subscription"
      ERR_ASSIGN_PARTITIONS = "Assigned partitions (rebalance_cb)"
      ERR_REVOKE_PARTITIONS = "Revoked partitions (rebalance_cb)"
      ERR_CONFLICT = "Conflicting use"
      ERR_STATE = "Wrong state"
      ERR_UNKNOWN_PROTOCOL = "Unknown protocol"
      ERR_NOT_IMPLEMENTED = "Not implemented"
      ERR_AUTHENTICATION = "Authentication failure"
      ERR_NO_OFFSET = "No stored offset"
      ERR_OUTDATED = "Outdated"
      ERR_TIMED_OUT_QUEUE = "Timed out in queue"
      ERR_UNSUPPORTED_FEATURE = "Feature not supported by broker"
      ERR_WAIT_CACHE = "Awaiting cache update"
      ERR_INTR = "Operation interrupted"
      ERR_KEY_SERIALIZATION = "Key serialization error"
      ERR_VALUE_SERIALIZATION = "Value serialization error"
      ERR_KEY_DESERIALIZATION = "Key deserialization error"
      ERR_VALUE_DESERIALIZATION = "Value deserialization error"
      ERR_PARTIAL = "Partial response"
      ERR_READ_ONLY = "Modification attempted on read-only object"
      ERR_NOENT = "No such entry / item not found"
      ERR_UNDERFLOW = "Read underflow"
      ERR_INVALID_TYPE = "Invalid type"
      ERR_RETRY = "Retry operation"
      ERR_PURGE_QUEUE = "Purged in queue"
      ERR_PURGE_INFLIGHT = "Purged in flight"
      ERR_FATAL = "Fatal error: see RdKafka::Handle::fatal_error()"
      ERR_INCONSISTENT = "Inconsistent state"
      ERR_GAPLESS_GUARANTEE = "Gap-less ordering would not be guaranteed if proceeding"
      ERR_MAX_POLL_EXCEEDED = "Maximum poll interval exceeded"
      ERR_UNKNOWN_BROKER = "Unknown broker"
      ERR_NOT_CONFIGURED = "Functionality not configured"
      ERR_FENCED = "Instance has been fenced"
      ERR_APPLICATION = "Application generated error"
      ERR_ASSIGNMENT_LOST = "Assignment lost"
      ERR_NOOP = "No operation performed"
      ERR_AUTO_OFFSET_RESET = "No offset to automatically reset to"
      ERR_END = "End internal error codes"
      ERR_UNKNOWN = "Unknown broker error"
      ERR_NO_ERROR = "Success"
      ERR_OFFSET_OUT_OF_RANGE = "Offset out of range"
      ERR_INVALID_MSG = "Invalid message"
      ERR_UNKNOWN_TOPIC_OR_PART = "Unknown topic or partition"
      ERR_INVALID_MSG_SIZE = "Invalid message size"
      ERR_LEADER_NOT_AVAILABLE = "Leader not available"
      ERR_NOT_LEADER_FOR_PARTITION = "Not leader for partition"
      ERR_REQUEST_TIMED_OUT = "Request timed out"
      ERR_BROKER_NOT_AVAILABLE = "Broker not available"
      ERR_REPLICA_NOT_AVAILABLE = "Replica not available"
      ERR_MSG_SIZE_TOO_LARGE = "Message size too large"
      ERR_STALE_CTRL_EPOCH = "StaleControllerEpochCode"
      ERR_OFFSET_METADATA_TOO_LARGE = "Offset metadata string too large"
      ERR_NETWORK_EXCEPTION = "Broker disconnected before response received"
      ERR_COORDINATOR_LOAD_IN_PROGRESS = "Coordinator load in progress"
      ERR_COORDINATOR_NOT_AVAILABLE = "Coordinator not available"
      ERR_NOT_COORDINATOR = "Not coordinator"
      ERR_TOPIC_EXCEPTION = "Invalid topic"
      ERR_RECORD_LIST_TOO_LARGE = "Message batch larger than configured server segment size"
      ERR_NOT_ENOUGH_REPLICAS = "Not enough in-sync replicas"
      ERR_NOT_ENOUGH_REPLICAS_AFTER_APPEND = "Message(s) written to insufficient number of in-sync replicas"
      ERR_INVALID_REQUIRED_ACKS = "Invalid required acks value"
      ERR_ILLEGAL_GENERATION = "Specified group generation id is not valid"
      ERR_INCONSISTENT_GROUP_PROTOCOL = "Inconsistent group protocol"
      ERR_INVALID_GROUP_ID = "Invalid group.id"
      ERR_UNKNOWN_MEMBER_ID = "Unknown member"
      ERR_INVALID_SESSION_TIMEOUT = "Invalid session timeout"
      ERR_REBALANCE_IN_PROGRESS = "Group rebalance in progress"
      ERR_INVALID_COMMIT_OFFSET_SIZE = "Commit offset data size is not valid"
      ERR_TOPIC_AUTHORIZATION_FAILED = "Topic authorization failed"
      ERR_GROUP_AUTHORIZATION_FAILED = "Group authorization failed"
      ERR_CLUSTER_AUTHORIZATION_FAILED = "Cluster authorization failed"
      ERR_INVALID_TIMESTAMP = "Invalid timestamp"
      ERR_UNSUPPORTED_SASL_MECHANISM = "Unsupported SASL mechanism"
      ERR_ILLEGAL_SASL_STATE = "Illegal SASL state"
      ERR_UNSUPPORTED_VERSION = "Unuspported version"
      ERR_TOPIC_ALREADY_EXISTS = "Topic already exists"
      ERR_INVALID_PARTITIONS = "Invalid number of partitions"
      ERR_INVALID_REPLICATION_FACTOR = "Invalid replication factor"
      ERR_INVALID_REPLICA_ASSIGNMENT = "Invalid replica assignment"
      ERR_INVALID_CONFIG = "Invalid config"
      ERR_NOT_CONTROLLER = "Not controller for cluster"
      ERR_INVALID_REQUEST = "Invalid request"
      ERR_UNSUPPORTED_FOR_MESSAGE_FORMAT = "Message format on broker does not support request"
      ERR_POLICY_VIOLATION = "Policy violation"
      ERR_OUT_OF_ORDER_SEQUENCE_NUMBER = "Broker received an out of order sequence number"
      ERR_DUPLICATE_SEQUENCE_NUMBER = "Broker received a duplicate sequence number"
      ERR_INVALID_PRODUCER_EPOCH = "Producer attempted an operation with an old epoch"
      ERR_INVALID_TXN_STATE = "Producer attempted a transactional operation in an invalid state"
      ERR_INVALID_PRODUCER_ID_MAPPING = "Producer attempted to use a producer id which is not currently assigned to its transactional id"
      ERR_INVALID_TRANSACTION_TIMEOUT = "Transaction timeout is larger than the maximum value allowed by the broker's max.transaction.timeout.ms"
      ERR_CONCURRENT_TRANSACTIONS = "Producer attempted to update a transaction while another concurrent operation on the same transaction was ongoing"
      ERR_TRANSACTION_COORDINATOR_FENCED = "Indicates that the transaction coordinator sending a WriteTxnMarker is no longer the current coordinator for a given producer"
      ERR_TRANSACTIONAL_ID_AUTHORIZATION_FAILED = "Transactional Id authorization failed"
      ERR_SECURITY_DISABLED = "Security features are disabled"
      ERR_OPERATION_NOT_ATTEMPTED = "Operation not attempted"
      ERR_KAFKA_STORAGE_ERROR = "Disk error when trying to access log file on the disk"
      ERR_LOG_DIR_NOT_FOUND = "The user-specified log directory is not found in the broker config"
      ERR_SASL_AUTHENTICATION_FAILED = "SASL Authentication failed"
      ERR_UNKNOWN_PRODUCER_ID = "Unknown Producer Id"
      ERR_REASSIGNMENT_IN_PROGRESS = "Partition reassignment is in progress"
      ERR_DELEGATION_TOKEN_AUTH_DISABLED = "Delegation Token feature is not enabled"
      ERR_DELEGATION_TOKEN_NOT_FOUND = "Delegation Token is not found on server"
      ERR_DELEGATION_TOKEN_OWNER_MISMATCH = "Specified Principal is not valid Owner/Renewer"
      ERR_DELEGATION_TOKEN_REQUEST_NOT_ALLOWED = "Delegation Token requests are not allowed on this connection"
      ERR_DELEGATION_TOKEN_AUTHORIZATION_FAILED = "Delegation Token authorization failed"
      ERR_DELEGATION_TOKEN_EXPIRED = "Delegation Token is expired"
      ERR_INVALID_PRINCIPAL_TYPE = "Supplied principalType is not supported"
      ERR_NON_EMPTY_GROUP = "The group is not empty"
      ERR_GROUP_ID_NOT_FOUND = "The group id does not exist"
      ERR_FETCH_SESSION_ID_NOT_FOUND = "The fetch session ID was not found"
      ERR_INVALID_FETCH_SESSION_EPOCH = "The fetch session epoch is invalid"
      ERR_LISTENER_NOT_FOUND = "No matching listener"
      ERR_TOPIC_DELETION_DISABLED = "Topic deletion is disabled"
      ERR_FENCED_LEADER_EPOCH = "Leader epoch is older than broker epoch"
      ERR_UNKNOWN_LEADER_EPOCH = "Leader epoch is newer than broker epoch"
      ERR_UNSUPPORTED_COMPRESSION_TYPE = "Unsupported compression type"
      ERR_STALE_BROKER_EPOCH = "Broker epoch has changed"
      ERR_OFFSET_NOT_AVAILABLE = "Leader high watermark is not caught up"
      ERR_MEMBER_ID_REQUIRED = "Group member needs a valid member ID"
      ERR_PREFERRED_LEADER_NOT_AVAILABLE = "Preferred leader was not available"
      ERR_GROUP_MAX_SIZE_REACHED = "Consumer group has reached maximum size"
      ERR_FENCED_INSTANCE_ID = "Static consumer fenced by other consumer with same group.instance.id."
      ERR_ELIGIBLE_LEADERS_NOT_AVAILABLE = "Eligible partition leaders are not available"
      ERR_ELECTION_NOT_NEEDED = "Leader election not needed for topic partition"
      ERR_NO_REASSIGNMENT_IN_PROGRESS = "No partition reassignment is in progress"
      ERR_GROUP_SUBSCRIBED_TO_TOPIC = "Deleting offsets of a topic while the consumer group is subscribed to it"
      ERR_INVALID_RECORD = "Broker failed to validate record"
      ERR_UNSTABLE_OFFSET_COMMIT = "There are unstable offsets that need to be cleared"
      ERR_THROTTLING_QUOTA_EXCEEDED = "Throttling quota has been exceeded"
      ERR_PRODUCER_FENCED = "There is a newer producer with the same transactionalId which fences the current one"
      ERR_RESOURCE_NOT_FOUND = "Request illegally referred to resource that does not exist"
      ERR_DUPLICATE_RESOURCE = "Request illegally referred to the same resource twice"
      ERR_UNACCEPTABLE_CREDENTIAL = "Requested credential would not meet criteria for acceptability"
      ERR_INCONSISTENT_VOTER_SET = "Indicates that the either the sender or recipient of a voter-only request is not one of the expected voters"
      ERR_INVALID_UPDATE_VERSION = "Invalid update version"
      ERR_FEATURE_UPDATE_FAILED = "Unable to update finalized features due to server error"
      ERR_PRINCIPAL_DESERIALIZATION_FAILURE = "Request principal deserialization failed during forwarding "

# Headers Utils:

type
  Headers* {.header: irr,
             importcpp: "RdKafka::Headers".} = object
  PHeaders = ptr Headers
# Topic Utils:

const PARTITION_UA*:int32 = -1

# Producer Utils:

type
  Producer* {.header: irr,
             importcpp: "RdKafka::Producer".} = object
  PProducer* = ptr Producer

const
  RK_MSG_FREE* = 1
  RK_MSG_COPY* = 2
  RK_MSG_BLOCK* = 4

proc create* (conf: PConf, errstr: var CppString): ptr Producer
  {.header: irr, importcpp: "RdKafka::Producer::create(@)".}

proc produce*(producer: PProducer,
              topic: CppString,
              partition: int32,
              msgFlags: int,
              payload: pointer,
              len: int,
              key: pointer,
              key_len: int,
              timestamp: int64,
              headers: PHeaders,
              msg_opague: pointer): int
  {.header: irr, importcpp: "#.produce(@)".}

proc flush*(producer: PProducer,
            timepot_sec: int): int
  {.header: irr, importcpp: "#.flush(@)".}
