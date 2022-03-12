#------------------ VARIABLES ------------------ 

BINARIES_FOLDER=/usr/local/bin

SWIFT_BUILD_FLAGS=--configuration release -Xlinker -dead_strip --disable-sandbox

TOOL_NAME=bearhuntercli
EXECUTABLE_X86=$(shell swift build $(SWIFT_BUILD_FLAGS) --arch x86_64 --show-bin-path)/$(TOOL_NAME)
EXECUTABLE_ARM64=$(shell swift build $(SWIFT_BUILD_FLAGS) --arch arm64 --show-bin-path)/$(TOOL_NAME)
EXECUTABLE_PARENT_DIRECTORY=.build/universal
EXECUTABLE=$(EXECUTABLE_PARENT_DIRECTORY)/$(TOOL_NAME)
HOMEBREW_CACHES_DIRECTORY=~/Library/Caches/Homebrew/$(TOOL_NAME)--git

#------------------ FUNCTIONS ------------------ 

cleanFunc = $(shell \
	rm -rf .build \
	rm -rf $(HOMEBREW_CACHES_DIRECTORY) \
	swift package clean)

#------------------ PUBLIC TARGETS ------------------ 

.PHONY: environment install uninstall cleanup

environment: homebrew xcode-defaults

install: build
	echo "> Install bearhuntercli tool"
	install -d "$(BINARIES_FOLDER)"
	install "$(EXECUTABLE)" "$(BINARIES_FOLDER)"
	echo "> Done"

uninstall:
	$(call cleanFunc)
	echo "> Uninstall bearhuntercli tool"
	rm -f "$(BINARIES_FOLDER)/$(TOOL_NAME)"
	echo "> Done"

#------------------ PRIVATE TARGETS ------------------ 

homebrew:
	@./scripts/install_homebrew_formulae.sh

xcode-defaults:
	@./scripts/set_up_xcode_defaults.sh

cleanup:
	echo "> Cleanup"
	$(call cleanFunc)

build:
	echo "> Cleanup"
	$(call cleanFunc)
	echo "> Build x86_64 executable"
	swift build $(SWIFT_BUILD_FLAGS) --arch x86_64
	echo "> Build arm_64 executable"
	swift build $(SWIFT_BUILD_FLAGS) --arch arm64
	mkdir -p $(EXECUTABLE_PARENT_DIRECTORY)
	echo "> Build universal executable"
	lipo -create -output "$(EXECUTABLE)" "$(EXECUTABLE_X86)" "$(EXECUTABLE_ARM64)"
