# Variables
BINARY_NAME=demo
BUILD_DIR=build
CMD_DIR=cmd
GOLANGCI_LINT=golangci-lint

# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod
GOFMT=$(GOCMD) fmt
GOVET=$(GOCMD) vet
LINTER=$(GOLANGCI_LINT) run

# Build targets for different platforms
PLATFORMS=linux/amd64 darwin/amd64 darwin/arm64 windows/amd64

.PHONY: all ci test build clean fmt vet tidy build-all help

# Default target
all: ci

# CI target - runs all checks and tests
ci: fmt vet tidy lint test build

# Run tests
test:
	$(GOTEST) -v ./...

# Build for current platform
build:
	$(GOBUILD) -o $(BUILD_DIR)/$(BINARY_NAME) ./$(CMD_DIR)

# Clean build artifacts
clean:
	$(GOCLEAN)
	rm -rf $(BUILD_DIR)

# Format code
fmt:
	$(GOFMT) ./...

# Run go vet
vet:
	$(GOVET) ./...

# Tidy dependencies
tidy:
	$(GOMOD) tidy

# lint
lint:
	$(LINTER)

# Build for all platforms (used by release workflow)
build-all: clean
	mkdir -p $(BUILD_DIR)
	GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 ./$(CMD_DIR)
	GOOS=darwin GOARCH=amd64 $(GOBUILD) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-amd64 ./$(CMD_DIR)
	GOOS=darwin GOARCH=arm64 $(GOBUILD) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-arm64 ./$(CMD_DIR)
	GOOS=windows GOARCH=amd64 $(GOBUILD) -o $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe ./$(CMD_DIR)

# Help target
help:
	@echo "Available targets:"
	@echo "  all       - Run CI pipeline (default)"
	@echo "  ci        - Run all checks and tests"
	@echo "  test      - Run tests"
	@echo "  build     - Build for current platform"
	@echo "  build-all - Build for all platforms (linux, darwin, windows)"
	@echo "  clean     - Clean build artifacts"
	@echo "  fmt       - Format code"
	@echo "  vet       - Run go vet"
	@echo "  tidy      - Tidy dependencies"
	@echo "  help      - Show this help message"