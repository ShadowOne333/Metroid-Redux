# Metroid Redux Compilation Makefile

#-------------------------------------------------------------
# Variables
TIME := $(shell date +'%T %a %d/%b/%Y')
ASAR := bin/asar-standalone
FLIPS := bin/flips
FILE_BASE := Metroid-Redux
OUT_FOLDER := out
PATCHES_FOLDER := patches
CLEAN_ROM := rom/Metroid.nes
PATCHED_ROM := $(OUT_FOLDER)/$(FILE_BASE).nes
ASM_FILE := code/main.asm
CHECKSUM := 166a5b1344b17f98b6b18794094f745f8a7435b8
ORIGINAL_ROM := rom/Metroid (U).nes

#-------------------------------------------------------------
# Phony targets
.PHONY: help clean verify-rom setup patch compile-asm create-bps finalize
#-------------------------------------------------------------
# Default target
.DEFAULT_GOAL := all

all: verify-rom setup patch compile-asm create-bps finalize
	@echo "Redux compilation finished at $(TIME)!"
#-------------------------------------------------------------
# Default target
help:
	@echo "Compile 'Metroid Redux' with one of the following targets:"
	@echo ""
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  help      - Displays this menu"
	@echo "  clean     - Removes generated files"

#-------------------------------------------------------------
# Verify ROM exists with correct name
verify-rom:
	@if [ -f "$(ORIGINAL_ROM)" ]; then \
		echo "ROM detected. Verifying name..."; \
	else \
		echo "ERROR: Incorrect ROM name."; \
		echo "Please rename the ROM to 'Metroid (U).nes' to begin patching."; \
		exit 1; \
	fi

#-------------------------------------------------------------
# Setup: Create directories and verify SHA-1
setup: verify-rom
	@echo ""
	@echo "Base ROM detected with proper name."
	@echo "Verifying SHA-1 checksum hash..."
	@test ! -d "$(OUT_FOLDER)" && mkdir -p "$(OUT_FOLDER)" || true
	@test -f "$(PATCHED_ROM)" && rm "$(PATCHED_ROM)" || true
	@cp "$(ORIGINAL_ROM)" "$(CLEAN_ROM)"
	@if [ -f "$(CLEAN_ROM)" ]; then \
		SHA1=$$(sha1sum "$(CLEAN_ROM)" | awk '{print $$1}'); \
		if [ "$$SHA1" = "$(CHECKSUM)" ]; then \
			echo ""; \
			echo "Base ROM SHA-1 checksum verified."; \
			echo "Starting patching process..."; \
		else \
			echo "ERROR: Base ROM checksum is incorrect."; \
			echo "Use a Metroid ROM with the proper SHA-1 checksum for patching."; \
			exit 1; \
		fi; \
	else \
		echo "ERROR: Base ROM not found."; \
		echo "Place the 'Metroid (U).nes' ROM inside the 'rom' folder."; \
		exit 1; \
	fi

#-------------------------------------------------------------
# Patch: Copy clean ROM for patching
patch: setup
	@cp "$(CLEAN_ROM)" "$(PATCHED_ROM)"

#-------------------------------------------------------------
# Compile: Run Asar on the main assembly code
compile-asm: patch
	@echo "Beginning main assembly code compilation with Asar..."; \
	echo ""; \
	$(ASAR) --no-title-check --fix-checksum=off $(ASM_FILE) $(PATCHED_ROM); \
	echo ""; \
	echo "Main assembly code compilation succeeded!"; \
	echo ""

#-------------------------------------------------------------
# Create BPS patch
create-bps: compile-asm
	@echo "Creating $(FILE_BASE).bps patch..."
	@$(FLIPS) -c -b "$(CLEAN_ROM)" "$(PATCHED_ROM)" "$(PATCHES_FOLDER)/$(FILE_BASE).bps"
	@echo "Creating $(FILE_BASE).ips patch..."
	@$(FLIPS) -c -i "$(CLEAN_ROM)" "$(PATCHED_ROM)" "$(PATCHES_FOLDER)/$(FILE_BASE).ips"

#-------------------------------------------------------------
# Finalize: Rename and clean up
finalize: create-bps
	@cp "$(PATCHES_FOLDER)/$(FILE_BASE).bps" "$(PATCHES_FOLDER)/Metroid Redux.bps"
	@rm "$(PATCHES_FOLDER)/$(FILE_BASE).bps"
	@cp "$(PATCHES_FOLDER)/$(FILE_BASE).ips" "$(PATCHES_FOLDER)/Metroid Redux.ips"
	@rm "$(PATCHES_FOLDER)/$(FILE_BASE).ips"

#-------------------------------------------------------------
# Clean target
clean:
	@echo "Cleaning up generated files..."
	@rm -rf "$(OUT_FOLDER)"
	@rm -f "$(CLEAN_ROM)"
	@rm -f "$(PATCHES_FOLDER)/$(FILE_BASE).ips"
	@rm -f "$(PATCHES_FOLDER)/$(FILE_BASE).bps"
	@rm -f "$(PATCHES_FOLDER)/Metroid Redux.ips"
	@rm -f "$(PATCHES_FOLDER)/Metroid Redux.bps"
	@echo "Clean complete."

#-------------------------------------------------------------
