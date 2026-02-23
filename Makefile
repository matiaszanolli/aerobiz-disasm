# ============================================================================
# Aerobiz Supersonic (Genesis/Mega Drive) - Reassembly Build System
# ============================================================================

# Tools
ASM = tools/vasmm68k_mot
PYTHON = python3

# Directories
BUILD_DIR = build
DISASM_DIR = disasm
TOOLS_DIR = tools

# ROM settings
# Place your original ROM in the project root with this name:
ORIGINAL_ROM = Aerobiz Supersonic (USA).gen
OUTPUT_ROM = $(BUILD_DIR)/aerobiz.bin

# Assembly flags
# -Fbin = binary output
# -m68000 = target CPU
# -no-opt = no optimization (preserve original code byte-for-byte)
# -spaces = allow spaces in operands
# -quiet = suppress info messages
ASMFLAGS = -Fbin -m68000 -no-opt -spaces -quiet

# Source files
M68K_SRC = $(DISASM_DIR)/aerobiz.asm

.PHONY: all clean verify help

# ============================================================================
# Main targets
# ============================================================================

all: dirs $(OUTPUT_ROM)

dirs:
	@mkdir -p $(BUILD_DIR)

$(OUTPUT_ROM): $(M68K_SRC)
	@echo "==> Assembling 68000 code..."
	$(ASM) $(ASMFLAGS) -o $@ $<
	@echo "==> Build complete: $@"
	@ls -lh $@

# ============================================================================
# Verification
# ============================================================================

# Compare rebuilt ROM against original
verify: $(OUTPUT_ROM)
	@if [ -f "$(ORIGINAL_ROM)" ]; then \
		echo "==> Comparing ROM checksums..."; \
		ORIG_MD5=$$(md5sum "$(ORIGINAL_ROM)" | cut -d' ' -f1); \
		NEW_MD5=$$(md5sum "$(OUTPUT_ROM)" | cut -d' ' -f1); \
		if [ "$$ORIG_MD5" = "$$NEW_MD5" ]; then \
			echo "==> MATCH: ROMs are byte-identical ($$ORIG_MD5)"; \
		else \
			echo "==> MISMATCH:"; \
			echo "    Original: $$ORIG_MD5"; \
			echo "    Rebuilt:  $$NEW_MD5"; \
			echo "    Size comparison:"; \
			ls -l "$(ORIGINAL_ROM)" "$(OUTPUT_ROM)"; \
		fi \
	else \
		echo "==> Original ROM not found: $(ORIGINAL_ROM)"; \
		echo "    Place your ROM in the project root to enable verification."; \
	fi

# ============================================================================
# Disassembly helper
# ============================================================================

# Quick disassemble from ROM offset
# Usage: make disasm-at OFFSET=0x200 COUNT=50
disasm-at:
	@if [ -f "$(ORIGINAL_ROM)" ]; then \
		$(PYTHON) $(TOOLS_DIR)/m68k_disasm.py "$(ORIGINAL_ROM)" $(OFFSET) $(COUNT); \
	else \
		echo "==> Original ROM not found: $(ORIGINAL_ROM)"; \
	fi

# ============================================================================
# Clean
# ============================================================================

clean:
	rm -rf $(BUILD_DIR)

# ============================================================================
# Help
# ============================================================================

help:
	@echo "Aerobiz Supersonic Disassembly Build System"
	@echo ""
	@echo "Targets:"
	@echo "  all          Build ROM from disassembly sources"
	@echo "  clean        Remove build artifacts"
	@echo "  verify       Compare rebuilt ROM against original (md5sum)"
	@echo "  disasm-at    Disassemble from ROM (OFFSET=0x... COUNT=N)"
	@echo "  help         Show this help message"
	@echo ""
	@echo "Usage:"
	@echo "  make all                          # Build the ROM"
	@echo "  make clean && make all            # Full rebuild"
	@echo "  make verify                       # Check byte-identical"
	@echo "  make disasm-at OFFSET=0x200 COUNT=50"
