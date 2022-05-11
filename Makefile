# .ALL: src/producer src/consumer

CFLAGS=-Wall $(shell pkg-config --cflags --libs rdkafka glib-2.0 serdes )
CPPFLAGS := $(subst strict-dwarf,,$(CPPFLAGS))
NIMFLAGS := $(shell pkg-config --libs rdkafka)
SERDESFLAGS :=$(shell pkg-config --libs serdes)

NIMLIBS := $(shell pkg-config --libs rdkafka serdes)
NIMINCLUDES := $(shell pkg-config --cflags-only-I rdkafka serdes)

producer:
	gcc src/producer.c -o build/producer $(CFLAGS)

producer_cpp:
	g++ src/producer.cpp -o build/producer_cpp -l:librdkafka++.so $(CFLAGS) $(CPPFLAGS)

consumer:
	gcc src/consumer.c -o build/consumer $(CFLAGS) -I/nix/store/v6cl3vv8a8x9fn80n9d9xrbalnhld8g8-avro-c-1.11.0/include -L/nix/store/v6cl3vv8a8x9fn80n9d9xrbalnhld8g8-avro-c-1.11.0/lib -lavro

nimkafka_cpp:
	nim  -o:build/nimkafka  --verbosity:2 cpp libs/nim_kafka/nimkafka.nim

nimkafka_c:
	nim --passL:"$(NIMFLAGS)" --passC:"$(NIMINCLUDES)" -o:build/nimkafka_c  --verbosity:2 c libs/nim_kafka/nimkafka_c.nim

producer_nim:
	make nimkafka_cpp
	nim --verbosity:2 -o:build/producer_nim cpp src/producer.nim

avro-example_c:
	gcc src/avro_example.c -o build/avro_example -I/nix/store/v6cl3vv8a8x9fn80n9d9xrbalnhld8g8-avro-c-1.11.0/include -L/nix/store/v6cl3vv8a8x9fn80n9d9xrbalnhld8g8-avro-c-1.11.0/lib -lavro

nimavro:
	nim --passL:"-L/nix/store/v6cl3vv8a8x9fn80n9d9xrbalnhld8g8-avro-c-1.11.0/lib"\
	 --passC:"-I/nix/store/v6cl3vv8a8x9fn80n9d9xrbalnhld8g8-avro-c-1.11.0/include"\
	  -o:build/nimavro  --verbosity:2 cpp libs/nim_avro/nimavro.nim

avro_example_nim:
	make nimavro
	nim --verbosity:2 -o:build/avro_example_nim cpp src/avro_example.nim

nimserdes:
	nim --passL:"$(NIMFLAGS)" --passC:"$(NIMINCLUDES)" -o:build/nimserdes  --verbosity:2 c libs/nim_serdes/nimserdes.nim
