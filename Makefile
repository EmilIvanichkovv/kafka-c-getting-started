# .ALL: src/producer src/consumer

CFLAGS=-Wall $(shell pkg-config --cflags --libs rdkafka glib-2.0)
CPPFLAGS := $(subst strict-dwarf,,$(CPPFLAGS))
NIMFLAGS := $(shell pkg-config --libs rdkafka)

NIMLIBS := $(shell pkg-config --libs rdkafka)
NIMINCLUDES := $(shell pkg-config --cflags-only-I rdkafka)

producer:
	gcc src/producer.c -o build/producer $(CFLAGS)

producer_cpp:
	g++ src/producer.cpp -o build/producer_cpp -l:librdkafka++.so $(CFLAGS) $(CPPFLAGS)

consumer:
	gcc src/consumer.c -o build/consumer $(CFLAGS)

nimkafka_cpp:
	nim  -o:build/nimkafka  --verbosity:2 cpp libs/nim_kafka/nimkafka.nim

nimkafka_c:
	nim --passL:"$(NIMFLAGS)" --passC:"$(NIMINCLUDES)" -o:build/nimkafka_c  --verbosity:2 c libs/nim_kafka/nimkafka_c.nim

producer_nim:
	make nimkafka_cpp
	nim --verbosity:2 --passL:"$(NIMFLAGS)" --passC:"$(NIMINCLUDES)" -o:build/producer_nim cpp src/producer.nim