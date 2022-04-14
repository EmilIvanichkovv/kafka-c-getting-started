.PHONY: src

# ALL: producer consumer

CFLAGS=-Wall $(shell pkg-config --cflags --libs rdkafka glib-2.0)

build:
	@mkdir -p build
	gcc src/common.c -o build/app $(CFLAGS)

run:
	@make build
	@echo ------------------------------------------------------------------------------------------------------------------------------------------------------
	@build/app

clean:
	rm -rf build

test:
	@make build