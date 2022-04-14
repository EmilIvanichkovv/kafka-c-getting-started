# .ALL: src/producer src/consumer

CFLAGS=-Wall $(shell pkg-config --cflags --libs rdkafka glib-2.0)

producer:
	gcc src/producer.c -o build/producer $(CFLAGS)

producer_cpp:
	g++ src/producer.cpp -o build/producer  $(CFLAGS)

consumer:
	gcc src/consumer.c -o build/consumer $(CFLAGS)