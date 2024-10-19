all: test build example

test: *.go testdata/*.js
	go test -count 1 ./...

build: k6

k6: *.go go.mod go.sum
	xk6 build --with github.com/grafana/xk6-sql@latest --with  $(shell go list -m)=.

clean:
	rm -f ./k6

example: k6
	./k6 run examples/example.js

format:
	go fmt ./...

.PHONY: test clean format all example
