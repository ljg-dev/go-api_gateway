# Variables
REGISTRY ?= ghcr.io/<you>
VERSION ?= $(shell git describe --tags --always --dirty || echo dev)
GOLANGCI_LINT_VERSION = v2.4.0
MODULES := pkg gateway ratelimitd
MODULE_PACKAGES := $(addsuffix /...,$(addprefix ./,$(MODULES)))

# Phony
.PHONY: all tidy test build docker up down fmt lint

all: tidy test build

tidy:
	@for m in $(MODULES); do (cd $$m && go mod tidy); done

fmt:
	@gofmt -s -w .
	@for m in $(MODULES); do (cd $$m && go vet ./...); done

lint:
	GOFLAGS="-buildvcs=false" go run github.com/golangci/golangci-lint/v2/cmd/golangci-lint@$(GOLANGCI_LINT_VERSION) run --timeout 15m $(MODULE_PACKAGES)

lint-branch:
	GOFLAGS="-buildvcs=false" go run github.com/golangci/golangci-lint/v2/cmd/golangci-lint@$(GOLANGCI_LINT_VERSION) run --new-from.rev=dev --timeout 15m $(MODULE_PACKAGES)

test:
	go test -race -count=1 $(MODULE_PACKAGES)

build:
	GOFLAGS=-trimpath CGO_ENABLED=0 go build $(MODULE_PACKAGES)

docker:
	docker build -f Dockerfile.gateway   -t $(REGISTRY)/gateway:$(VERSION) .
	docker build -f Dockerfile.ratelimitd -t $(REGISTRY)/ratelimitd:$(VERSION) .

up:
	docker compose -f deploy/docker-compose.yml up -d --build

down:
	docker compose -f deploy/docker-compose.yml down -v

init:
	@if git rev-parse --git-dir >/dev/null 2>&1; then \
		echo "🔧 Setting up repo Git hooks..."; \
		git config --local core.hooksPath .githooks; \
		chmod +x .githooks/* 2>/dev/null || true; \
		echo "✅ Hooks installed. (core.hooksPath = .githooks)"; \
	else \
		echo "⚠️  Not a git repo, skipping hook setup."; \
	fi
