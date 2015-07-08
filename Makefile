dnsdock: *.go | deps lint
	go build

deps:
	go get

test: | lint
	go test -v

lint:
	go fmt

build:
	docker run --rm -v "$(shell pwd)":/dnsdock -v "${GOPATH}":/go -w /dnsdock -e CGO_ENABLED=0 golang:1.4 go build  -a --installsuffix cgo -v --ldflags="-X main.version `git describe --tags HEAD``if [[ -n $$(command git status --porcelain --untracked-files=no 2>/dev/null) ]]; then echo "-dirty"; fi`"
	docker build -f Dockerfile-bx -t docker.tuxuri.com/tuxgeo/dnsdock:latest .
	rm dnsdock

.PHONY: deps test lint
