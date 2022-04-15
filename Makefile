# .ALL: src/producer src/consumer

CFLAGS=-Wall $(shell pkg-config --nimflags --libs rdkafka glib-2.0)
CPPFLAGS := $(subst strict-dwarf,,$(CPPFLAGS))
NIMFLAGS := $(shell pkg-config --libs rdkafka)

producer:
	gcc src/producer.c -o build/producer $(CFLAGS)

producer_cpp:
	g++ src/producer.cpp -o build/producer_cpp -l:librdkafka++.so $(CFLAGS) $(CPPFLAGS)

producer_nim:
	nim --passL:"$(NIMFLAGS)" -o:build/producer_nim c -r src/producer.nim

consumer:
	gcc src/consumer.c -o build/consumer $(CFLAGS)
