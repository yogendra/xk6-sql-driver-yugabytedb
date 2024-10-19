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

ci_version := $(shell git tag --points-at HEAD)
ci_user := $(shell id -u)
ci_group := $(shell id -g)
build-ci:
	GOOS=darwin GOARCH=amd64 xk6 build latest --output k6-darwin-amd64-${ci_version} --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=.
	GOOS=darwin GOARCH=arm64 xk6 build latest --output k6-darwin-arm64-${ci_version} --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=.
	GOOS=linux GOARCH=amd64 xk6 build latest --output k6-linux-amd64-${ci_version} --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=.
	GOOS=linux GOARCH=arm64 xk6 build latest --output k6-linux-arm64-${ci_version} --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=.
	GOOS=windows GOARCH=amd64 xk6 build latest --output k6-windows-amd64-${ci_version} --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=.
	GOOS=windows GOARCH=arm64 xk6 build latest --output k6-windows-arm64-${ci_version} --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=.


.PHONY: test build-ci clean format all example
