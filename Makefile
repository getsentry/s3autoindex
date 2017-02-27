GOPATH=$(realpath ../../../../)
GOBIN=$(GOPATH)/bin
GOENV=GOPATH=$(GOPATH) GOBIN=$(GOBIN)
GO=$(GOENV) go
APP=s3autoindex

OK_COLOR=\033[32;01m
NO_COLOR=\033[0m
BOLD=\033[1m

CROSSPLATFORMS=\
	linux/amd64 \
	darwin/amd64

build:
	echo "$(OK_COLOR)->$(NO_COLOR) Building $(BOLD)$(APP)$(NO_COLOR)"
	echo "$(OK_COLOR)==>$(NO_COLOR) Installing dependencies"
	$(GO) get -v -d ./...
	echo "$(OK_COLOR)==>$(NO_COLOR) Compiling"
	$(GO) install -v ./...
	echo

run: build
	@echo "$(OK_COLOR)==>$(NO_COLOR) Running"
	$(GOBIN)/$(APP) -b=127.0.0.1:8000 -bucket=getsentry-mattstuff -proxy

test:
	$(GO) test -v ./...

clean:
	rm -rf $(GOBIN)/*
	rm -rf $(GOPATH)/pkg/*
	rm -rf dist/

docker:
	docker build --rm -t $(APP):dev -f Dockerfile.build .
	docker run -it --rm -v $(PWD):/go/src/$(APP) $(APP):dev
	docker build --rm -t $(APP) .

.PHONY: build run test clean docker
