# .ALL: src/producer src/consumer

CFLAGS=-Wall $(shell pkg-config --cflags --libs rdkafka glib-2.0 serdes avro-c)
CPPFLAGS := $(subst strict-dwarf,,$(CPPFLAGS))
NIMFLAGS := $(shell pkg-config --libs rdkafka avro-c)
SERDESFLAGS :=$(shell pkg-config --libs serdes)

NIMLIBS := $(shell pkg-config --libs rdkafka serdes)
NIMINCLUDES := $(shell pkg-config --cflags-only-I rdkafka serdes)


consumer:
	gcc src/consumer.c -o build/consumer $(CFLAGS) -lavro

producer:
	nim --passL:"$(NIMFLAGS)"\
	  --verbosity:2 -o:build/producer c src/producer.nim

nimavro:
	nim --passL:"$(NIMFLAGS)"\
	  -o:build/nimavro  --verbosity:2 cpp libs/nim_avro/nimavro.nim

avro_helpers:
	nim --verbosity:2 -o:build/avro_helpers cpp src/avro_helpers.nim

avro_example_nim:
	nim --verbosity:2 -o:build/avro_example_nim cpp src/avro_example.nim

nimserdes:
	nim --passL:"$(NIMFLAGS)" --passC:"$(NIMINCLUDES)" -o:build/nimserdes  --verbosity:2 c libs/nim_serdes/nimserdes.nim
