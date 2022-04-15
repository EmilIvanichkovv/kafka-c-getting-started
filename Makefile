# .ALL: src/producer src/consumer

CFLAGS=-Wall $(shell pkg-config --cflags --libs rdkafka glib-2.0)
CPPFLAGS := $(subst strict-dwarf,,$(CPPFLAGS))

producer:
	gcc src/producer.c -o build/producer $(CFLAGS)

producer_cpp:
	g++ src/producer.cpp -o build/producercpp -l:librdkafka++.so $(CFLAGS) $(CPPFLAGS)
consumer:
	gcc src/consumer.c -o build/consumer $(CFLAGS)