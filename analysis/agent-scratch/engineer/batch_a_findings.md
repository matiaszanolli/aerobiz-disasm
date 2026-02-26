# B-055 Batch A Findings

## Functions Described

- CmdSetVDPReg: Write VDP register command word to control port and cache in work RAM shadow
- CmdSetScrollMode: Set one of five VDP scroll/plane registers by index, caching value in work RAM
- CmdGetVDPReg: Read cached VDP register value from work RAM shadow by register index
- CmdGetVDPStatus: Read VDP H/V counter port ($C00008) and return value in D0
- CmdRunSubroutine: Call InitAnimTable subroutine (thin wrapper)
- CmdSetupDMA: Configure DMA transfer parameters in work RAM and trigger VDP DMA (VRAM/CRAM/VSRAM)
- CmdTransferPlane: Set up DMA params and dispatch VDP write for a nametable plane transfer
- CmdLoadTiles: Set up DMA source/dest for tile or color data and trigger VDPWriteColorsPath
- CmdSetupSprite: Configure VDP DMA command word for sprite table upload, optionally blocking until done
- CmdCopyMemory: Copy N bytes from source address to destination address (byte loop)
- CmdReadInput: Read controller buttons (current + previous) for player 1 or 2 from input tables
- CmdSetupObject: Initialize multi-sprite object in work RAM: set positions, tile IDs, and trigger display
- CmdEnableDisplay: Enable VDP display output by setting bit 6 in mode register 1 shadow and port
- HardwareInit: Initialize VDP display-disable state: clear display bits in mode reg 1 shadow and port
- CmdWaitFrames: Busy-wait for N V-blank intervals by polling a V-INT frame counter
- CmdUpdateSprites: Copy sprite data from ROM table into work RAM sprite buffer, applying position offsets
- CmdClearSprites: Zero out N sprite entries in work RAM sprite buffer and refresh display layout
- CmdTestVRAM: Write test pattern bytes to a Z80-bus-mapped address and read back to detect errors
- ComputeMapCoordOffset: Compute VRAM word offset for a tile map coordinate from scroll params and plane width
- CmdDMABatchWrite: DMA-fill multiple nametable rows from a stack-allocated buffer, repeating a fill word
- CmdDMARowWrite: DMA-copy sequential nametable rows from source data to VRAM, advancing by plane stride each row
- CmdWaitDMA: Queue a V-INT-driven DMA transfer and busy-wait until V-INT signals completion
- CmdSetWorkFlags: Store two word values into scroll work-RAM shadow registers $38 and $3A
- CmdClearCharTable: Zero all character animation table buffers and reset associated control flags
- CmdSetCharState: Update character animation state flags and timer registers in work RAM
- ControllerRead: Animate character sprites via DMA by cycling through frames in the char table
- CmdInitAnimation: Set up character animation parameters (frame count, rate, address) and reset counters
- VInt_Sub1: V-INT animation tick: DMA next animation frame to CRAM and advance frame/delay counters
- WaitVBlank: Read and return VDP status register word from $C00004 (caller checks VBlank bit)
- CmdSetAnimState: Set animation mode and base address in work RAM, resetting current frame index
- CmdSetTimer: Initialize countdown timer from two longword args and return current elapsed count
- CmdConditionalWrite: Write arg to work RAM word unless arg == 2; always return stored value
- CmdInitGameVars: Clear and initialize three game state variables at $FFC46-$FFC4C from args
- CmdClampCoords: Clamp two input coordinates to stored min/max bounds and save results to work RAM
- CmdGetCoords: Read clamped X and Y coordinate words from work RAM into caller-provided pointer slots
- CmdReadCombinedWord: Pack two adjacent work RAM bytes into a 16-bit value (high byte | low byte)
- CmdSetBoundsAndClamp: Store four X/Y min/max bounds, then re-clamp current coordinates to the new range
- CmdSetScrollParam: Store one word to work RAM scroll parameter register $C5A
- CmdScanStatusArray: Scan 8 controller status entries at $FFFC06 and return bitmask of active slots
- CmdSaveBuffer: Save 8 bytes to display buffer or clear display and reset sprite links if arg is zero

## Functions Skipped (no TODO / already described)

- CmdSystemReset: Already has description "GameCommand 30: reset SP and restart"
- CmdInitCharTable: Already has description "GameCommand 31: init character table"
- CmdStoreWorkByte: Has no section header with TODO; only a short inline comment (no change needed)
- CmdTestVRAM_WithA3: Secondary entry point label at $0007DC within CmdTestVRAM body, no separate header
- BusError: No individual function header with TODO; documented by block comment at line 1310
- AddressError: No individual function header with TODO; documented by block comment
- IllegalInstr: No individual function header with TODO; documented by block comment
- ZeroDivide: No individual function header with TODO; documented by block comment
- ChkInstr: No individual function header with TODO; documented by block comment
- TrapvInstr: No individual function header with TODO; documented by block comment
- PrivilegeViol: No individual function header with TODO; documented by block comment
- Trace: No individual function header with TODO; documented by block comment
- LineAEmulator: No individual function header with TODO; documented by block comment
- LineFEmulator: No individual function header with TODO; documented by block comment
- Reserved_0C: No individual function header with TODO; documented by block comment
- Reserved_0D: No individual function header with TODO; documented by block comment
- Reserved_0E: No individual function header with TODO; documented by block comment
- Reserved_0F: No individual function header with TODO; documented by block comment
- ExceptionCommon: No individual function header with TODO; documented by block comment
- ExceptionHalt: No individual function header with TODO; documented by block comment

## Notes

### GameCommand System Architecture
The GameCommand dispatcher (at $000D64) uses a LINK frame where SR is pushed BEFORE the link, creating an unusual stack layout where the command number is at $A(a6) rather than $8(a6). All 47 handlers use A5 = $FFF010 (work RAM base) and A6 for stack frame access.

### Naming Confusion: ControllerRead
The function named ControllerRead (at $000B42) does NOT read from the I/O controller ports. Instead it drives character sprite animation: it DMA-transfers tile data from a character animation table to VRAM, cycling through animation frames on each call. The name is misleading. The actual controller I/O reading happens in CmdReadInput (at $000D64 via $00060C). This is worth noting for future renaming.

### CmdTestVRAM / CmdTestVRAM_WithA3
CmdTestVRAM sets A3 from args then falls into the shared body CmdTestVRAM_WithA3. The test reads/writes via the Z80 bus (VDPWriteZ80Path), not the VDP data port — the name "TestVRAM" is slightly misleading but is the established name. The operation tests Z80 RAM accessible memory at the address in A3.

### CmdSetScrollMode: 5 Sub-modes
The function handles 5 cases (arg1 = 0..4), each writing to a different VDP register and caching at different A5 offsets ($38, $3A, $3C, $3E, $40). These correspond to VDP registers $82, $84, $83, $85, $8D (plane/window scroll mode bits).

### DMA Operations
CmdDMABatchWrite, CmdDMARowWrite, and CmdWaitDMA all call ComputeMapCoordOffset first to get the VRAM destination address. They then build the VDP DMA command word in the format expected by TriggerVDPDMA. The plane stride (width: 64, 128, or 256 cells per row, determined by reg $10 bits 0-1) is computed each time.

### Exception Handler Structure
All exception handlers (BusError through Reserved_0F) follow the identical 2-instruction pattern: `moveq #id,d0; bra.w ExceptionCommon`. ExceptionCommon saves SP + ID on stack and calls ErrorDisplay, then ExceptionHalt loops forever. They have no individual section headers in the source — all are documented by the shared block header at line 1310.

### WaitVBlank Misnomer
WaitVBlank does not actually wait — it just reads the VDP status register and returns. The actual waiting loop is in the caller (Post-Boot code at $000300, which checks bit 1 of the returned value in a loop).
