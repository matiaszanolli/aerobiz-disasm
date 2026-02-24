# Function Reference -- Aerobiz Supersonic

Index of all identified functions. Updated as disassembly progresses.

## Summary

- **Total RTS (function endpoints):** 854
- **Total RTE (interrupt returns):** 6
- **Unique call targets:** 2,896
- **Functions named:** 96
- **Functions translated to mnemonics:** 61 (exception handlers, EXT/H-INT/V-INT, boot post-init, Z80 sound interface, GameEntry/GameLoopSetup/MainLoop, GameCommand, RangeLookup, utility cluster: MemFillByte/MemCopy/MemFillWord/VRAMBulkLoad/PollAction/RandRange/ByteSum/ResourceLoad/ResourceUnload/TilePlacement/GameCmd16/ReadInput, math: Multiply32/SignedDiv/UnsignedDivide/UDiv_Overflow/UDiv_Full32/UnsignedMod/SignedMod + 5 FromPtr entries, text: SetTextWindow/SetTextCursor/sprintf/PrintfNarrow/PrintfWide, compression: LZ_Decompress, display: DisplaySetup/DisplayInitRows/DisplayInit15/DisplayInit0/DisplaySetupScaled/DisplayTileSetup, graphics: CmdPlaceTile/CmdPlaceTile2/CmdSetBackground, memory: MemMove, game: BitFieldSearch/PreLoopInit/ShowDialog/ShowTextDialog, util: GetLowNibble/GetByteField4, input: ProcessInputLoop/PollInputChange)

## Most-Called Functions

These are the most frequently called subroutines -- high-priority translation targets.

| Address | Calls | Name | Notes |
|---------|-------|------|-------|
| $000D64 | 306 | GameCommand | Central command dispatcher (47 handlers via jump table) |
| $03E05C | 204 | Multiply32 | 32x32->32 unsigned multiply (cross-product MULU.W) |
| $03AB2C | 174 | SetTextCursor | Set text cursor X/Y position |
| $03B22C | 171 | sprintf | Format string to buffer (C-style varargs) |
| $03E08A | 169 | SignedDiv | Signed 32/32 divide (fast DIVS.W + slow unsigned path) |
| $03A942 | 124 | SetTextWindow | Define text rendering window bounds |
| $003FEC | 123 | LZ_Decompress | LZSS/LZ77 decompressor (variable-length bitstream) |
| $00D648 | 114 | RangeLookup | Map value to table index (0-7) via cumulative thresholds |
| $01D71C | 106 | ResourceLoad | Load resource if not loaded, set flag |
| $005092 | 101 | DisplaySetup | Display/graphics setup |
| $01E044 | 100 | TilePlacement | Build tile params, call GameCmd #15 |
| $03B270 | 97 | PrintfWide | Format + display string (2-tile wide font) |
| $01E1EC | 95 | ReadInput | Read joypad via GameCmd #10, mode select |
| $01D748 | 95 | ResourceUnload | Unload resource if loaded, clear flag |
| $03E146 | 88 | SignedMod | Signed 32/32 modulo (sign follows dividend) |
| $01E0B8 | 77 | GameCmd16 | Thin wrapper for GameCommand #16 |
| $01D520 | 71 | MemFillByte | Fill memory with byte value |
| $03B246 | 65 | PrintfNarrow | Format + display string (1-tile narrow font) |
| $01D62C | 65 | PollAction | Flush-then-wait input polling |
| $01D6A4 | 64 | RandRange | Random int in [min,max] via LCG |

## Functions by Category

### Boot / Initialization

| Address | Name | Description |
|---------|------|-------------|
| $000200 | EntryPoint | TMSS security check + hardware init |
| $0002FA | GameInit | Game initialization (after TMSS) |
| $000CDC | WaitVBlank | Wait for V-Blank (poll VDP status) |
| $003BE8 | EarlyInit | Early init (RAM/VDP setup) |
| $00070A | HardwareInit | Hardware init subroutine |
| $001036 | VDP_Init1 | VDP/display init |
| $00101C | VDP_Init2 | Init subroutine |
| $00107A | VDP_Init3 | Init subroutine |
| $0010FE | VDP_Init4 | Init subroutine |
| $0010DA | Init5 | Init subroutine |
| $001090 | Init6 | Init subroutine |
| $00260A | Z80_SoundInit | Load Z80 sound driver to Z80 RAM |

### Main Game

| Address | Name | Description |
|---------|------|-------------|
| $000D64 | GameCommand | Central command dispatcher (306 calls, 47 handlers via jump table) |
| $01E1EC | ReadInput | Read joypad input via GameCmd #10 (95 calls, 3 modes) |
| $01D62C | PollAction | Flush-then-wait input polling (65 calls) |
| $01D6A4 | RandRange | Random integer in [min,max] via C LCG (64 calls) |
| $01D71C | ResourceLoad | Load resource if not loaded, set flag (106 calls) |
| $01D748 | ResourceUnload | Unload resource, clear flag (95 calls) |
| $01E044 | TilePlacement | Build tile parameters, call GameCmd #15 (100 calls) |
| $01E0B8 | GameCmd16 | Thin wrapper for GameCommand #16 (77 calls) |
| $00D5B6 | GameEntry | Main game entry (called from boot via JMP) |
| $00D602 | GameLoopSetup | One-time pre-loop init, falls into MainLoop |
| $00D608 | MainLoop | Main game loop body (8 calls, loops forever) |
| $00D648 | RangeLookup | Map value to table index (0-7) via cumulative thresholds (114 calls) |
| $005736 | PreGameInit | Pre-game initialization |
| $03B428 | GameSetup1 | Game setup (title/scenario?) |
| $03CA4E | GameSetup2 | Game setup |
| $005092 | DisplaySetup | Display/title screen setup (101 calls) |
| $01E398 | PreLoopInit | Called once before main loop (57 calls total) |
| $02F5A6 | GameUpdate1 | Main loop: first update call |
| $01B49A | GameUpdate2 | Main loop: second update call |
| $0213B6 | GameLogic1 | Main loop: game logic (quarterly turn?) |
| $02947A | GameLogic2 | Main loop: game logic (events/AI?) |
| $01819C | GameCall | Main loop: parameterized call |
| $01E402 | GameUpdate3 | Main loop: third update call |
| $026128 | GameUpdate4 | Main loop: fourth update call |
| $01D568 | VRAMBulkLoad | Chunked DMA transfer to VRAM via GameCommand (46 calls) |
| $007912 | ShowDialog | Display dialog with table lookup and optional input (38 calls) |
| $01183A | ShowTextDialog | Display text dialog with PrintfWide and table lookup (31 calls) |

### Interrupt Handlers

| Address | Name | Description |
|---------|------|-------------|
| $001480 | ExtInterrupt | EXT INT (Level 2) -- NOP + RTE, unused |
| $001484 | HBlankInt | H-INT (Level 4) -- HScroll raster effect |
| $0014E6 | VBlankInt | V-INT (Level 6) -- Main frame handler |

### V-INT Sub-handlers

| Address | Name | Trigger | Description |
|---------|------|---------|-------------|
| $00163E | DMA_Transfer | Flag $004B(A5) | DMA/VRAM transfer |
| $001660 | DisplayUpdate | Byte $0B2A(A5) | Display update |
| $000C38 | VInt_Sub1 | Byte $0BD4(A5) | Unknown |
| $0016CC | VInt_Sub2 | Word $0BCE(A5) | Unknown |
| $000B42 | ControllerRead | Byte $02FB(A5) | Controller/input read |
| $001346 | VInt_Handler1 | Bit 0 of $002B(A5) | Conditional handler |
| $001390 | VInt_Handler2 | Bit 1 of $002B(A5) | Conditional handler |
| $001404 | VInt_Handler3 | Bit 2 of $002B(A5) | Conditional handler |
| $00192E | ControllerPoll | Always | Controller polling |
| $0016D4 | SubsysUpdate1 | Always | Subsystem update (PC-relative) |
| $00175C | SubsysUpdate2 | Always | Subsystem update (PC-relative) |
| $001864 | SubsysUpdate3 | Always | Subsystem update (PC-relative) |
| $0018D0 | SubsysUpdate4 | Always | Subsystem update (PC-relative) |

### Exception Handlers

| Address | Name | Exception ID |
|---------|------|-------------|
| $000F84 | BusError | 2 |
| $000F8A | AddressError | 3 |
| $000F90 | IllegalInstr | 4 |
| $000F96 | ZeroDivide | 5 |
| $000F9C | ChkInstr | 6 |
| $000FA2 | TrapvInstr | 7 |
| $000FA8 | PrivilegeViol | 8 |
| $000FAE | Trace | 9 |
| $000FB4 | LineAEmulator | 10 |
| $000FBA | LineFEmulator | 11 |
| $000FC0 | Reserved_0C | 12 |
| $000FC6 | Reserved_0D | 13 |
| $000FCC | Reserved_0E | 14 |
| $000FD2 | Reserved_0F | 15 (falls through) |
| $000FD4 | ExceptionCommon | -- (common handler, calls $58EE then halts) |
| $000FE0 | ExceptionHalt | -- (infinite loop) |
| $0058EE | ErrorDisplay | -- (error display routine) |

### Math

| Address | Name | Description |
|---------|------|-------------|
| $03E05A | Multiply32_FromPtr | Alternate entry: load multiplier from (A0) |
| $03E05C | Multiply32 | 32x32->32 unsigned multiply via cross-product MULU.W (204 calls) |
| $03E086 | SignedDiv_FromPtr | Alternate entry: load from (A0), swap D0/D1 |
| $03E08A | SignedDiv | Signed 32/32 divide, fast DIVS.W path + slow unsigned (169 calls) |
| $03E0C2 | UnsignedDiv_FromPtr | Alternate entry: load from (A0), swap D0/D1 |
| $03E0C6 | UnsignedDivide | Unsigned 32/32 divide, D0=quotient D1=remainder |
| $03E0DE | UDiv_Overflow | Two-step 32/16 divide (quotient > 16 bits) |
| $03E0FE | UDiv_Full32 | Bit-by-bit 32/32 shift-subtract (16 iterations) |
| $03E126 | UnsignedMod_FromPtr | Alternate entry: load from (A0), swap D0/D1 |
| $03E12A | UnsignedMod | Unsigned 32/32 modulo, D0=remainder |
| $03E142 | SignedMod_FromPtr | Alternate entry: load from (A0), swap D0/D1 |
| $03E146 | SignedMod | Signed 32/32 modulo, sign follows dividend (88 calls) |

### Compression

| Address | Name | Description |
|---------|------|-------------|
| $003FEC | LZ_Decompress | LZSS/LZ77 decompressor, 596 bytes (123 calls) |

### Text

| Address | Name | Description |
|---------|------|-------------|
| $03A942 | SetTextWindow | Define text window bounds: left/top/width/height (124 calls) |
| $03AB2C | SetTextCursor | Set text cursor X/Y position (174 calls) |
| $03B22C | sprintf | Format string to buffer, C-style varargs (171 calls) |
| $03B246 | PrintfNarrow | Format + display string, 1-tile narrow font (65 calls) |
| $03B270 | PrintfWide | Format + display string, 2-tile wide font (97 calls) |

### Sound

| Address | Name | Description |
|---------|------|-------------|
| $00260A | Z80_SoundInit | Load Z80 driver from ROM $2696 to Z80 RAM |
| $002662 | Z80_RequestBus | Request Z80 bus and wait for grant |
| $002678 | Z80_ReleaseBus | Release Z80 bus |
| $002688 | Z80_Delay | Delay loop (D0 = $18CE iterations) |

## Quick Lookup (flat, Ctrl+F friendly)

| Address | Name | Category | Calls | Status |
|---------|------|----------|-------|--------|
| $000200 | EntryPoint | boot | -- | named |
| $0002FA | GameInit | boot | -- | named |
| $00070A | HardwareInit | boot | -- | named |
| $000B42 | ControllerRead | vint | -- | named |
| $000C38 | VInt_Sub1 | vint | -- | named |
| $000CDC | WaitVBlank | boot | -- | named |
| $000D64 | GameCommand | game | 306 | translated |
| $000F84 | BusError | exception | -- | named |
| $000FD4 | ExceptionCommon | exception | -- | named |
| $001036 | VDP_Init1 | boot | -- | named |
| $001090 | Init6 | boot | -- | named |
| $0010DA | Init5 | boot | -- | named |
| $00101C | VDP_Init2 | boot | -- | named |
| $00107A | VDP_Init3 | boot | -- | named |
| $0010FE | VDP_Init4 | boot | -- | named |
| $001346 | VInt_Handler1 | vint | -- | named |
| $001390 | VInt_Handler2 | vint | -- | named |
| $001404 | VInt_Handler3 | vint | -- | named |
| $001480 | ExtInterrupt | interrupt | -- | named |
| $001484 | HBlankInt | interrupt | -- | named |
| $0014E6 | VBlankInt | interrupt | -- | named |
| $00163E | DMA_Transfer | vint | -- | named |
| $001660 | DisplayUpdate | vint | -- | named |
| $0016CC | VInt_Sub2 | vint | -- | named |
| $0016D4 | SubsysUpdate1 | vint | -- | named |
| $001760 | SubsysUpdate2 | vint | -- | named |
| $001864 | SubsysUpdate3 | vint | -- | named |
| $0018D4 | SubsysUpdate4 | vint | -- | named |
| $00192E | ControllerPoll | vint | -- | named |
| $00260A | Z80_SoundInit | sound | -- | named |
| $002662 | Z80_RequestBus | sound | -- | named |
| $002678 | Z80_ReleaseBus | sound | -- | named |
| $002688 | Z80_Delay | sound | -- | named |
| $003BE8 | EarlyInit | boot | -- | named |
| $003FEC | LZ_Decompress | compression | 123 | translated |
| $0045B2 | MemMove | memory | 19 | translated |
| $0045E6 | CmdPlaceTile2 | graphics | 23 | translated |
| $004668 | CmdPlaceTile | graphics | 46 | translated |
| $005092 | DisplaySetup | display | 101 | translated |
| $0050E2 | DisplayInitRows | display | -- | translated |
| $005126 | DisplayInit15 | display | -- | translated |
| $005132 | DisplayInit0 | display | -- | translated |
| $00513C | DisplaySetupScaled | display | -- | translated |
| $005170 | DisplayTileSetup | display | -- | translated |
| $00538E | CmdSetBackground | graphics | 46 | translated |
| $005736 | PreGameInit | game | -- | named |
| $0058EE | ErrorDisplay | exception | -- | named |
| $006EEA | BitFieldSearch | game | 47 | translated |
| $007402 | GetLowNibble | util | 20 | translated |
| $0074E0 | GetByteField4 | util | 36 | translated |
| $007912 | ShowDialog | game | 38 | translated |
| $01183A | ShowTextDialog | game | 31 | translated |
| $01819C | GameCall | game | -- | named |
| $01B49A | GameUpdate2 | game | -- | named |
| $01D520 | MemFillByte | util | 71 | translated |
| $01D538 | MemCopy | util | -- | translated |
| $01D550 | MemFillWord | util | -- | translated |
| $01D568 | VRAMBulkLoad | graphics | 46 | translated |
| $01D62C | PollAction | game | 65 | translated |
| $01D6A4 | RandRange | math | 64 | translated |
| $01D6FC | ByteSum | util | -- | translated |
| $01D71C | ResourceLoad | game | 106 | translated |
| $01D748 | ResourceUnload | game | 95 | translated |
| $01E044 | TilePlacement | graphics | 100 | translated |
| $01E0B8 | GameCmd16 | game | 77 | translated |
| $01E1EC | ReadInput | input | 95 | translated |
| $01E290 | ProcessInputLoop | input | 42 | translated |
| $01E2F4 | PollInputChange | input | 18 | translated |
| $01E398 | PreLoopInit | game | 57 | translated |
| $01E402 | GameUpdate3 | game | -- | named |
| $0213B6 | GameLogic1 | game | -- | named |
| $026128 | GameUpdate4 | game | -- | named |
| $02947A | GameLogic2 | game | -- | named |
| $02F5A6 | GameUpdate1 | game | -- | named |
| $03A942 | SetTextWindow | text | 124 | translated |
| $03AB2C | SetTextCursor | text | 174 | translated |
| $03B22C | sprintf | text | 171 | translated |
| $03B246 | PrintfNarrow | text | 65 | translated |
| $03B270 | PrintfWide | text | 97 | translated |
| $03B428 | GameSetup1 | game | -- | named |
| $03CA4E | GameSetup2 | game | -- | named |
| $03E05A | Multiply32_FromPtr | math | -- | translated |
| $03E05C | Multiply32 | math | 204 | translated |
| $03E086 | SignedDiv_FromPtr | math | -- | translated |
| $03E08A | SignedDiv | math | 169 | translated |
| $03E0C2 | UnsignedDiv_FromPtr | math | -- | translated |
| $03E0C6 | UnsignedDivide | math | -- | translated |
| $03E0DE | UDiv_Overflow | math | -- | translated |
| $03E0FE | UDiv_Full32 | math | -- | translated |
| $03E126 | UnsignedMod_FromPtr | math | -- | translated |
| $03E12A | UnsignedMod | math | -- | translated |
| $03E142 | SignedMod_FromPtr | math | -- | translated |
| $03E146 | SignedMod | math | 88 | translated |
| $00D5B6 | GameEntry | game | -- | named |
| $00D602 | GameLoopSetup | game | -- | named |
| $00D608 | MainLoop | game | -- | named |
| $00D648 | RangeLookup | game | 114 | translated |
