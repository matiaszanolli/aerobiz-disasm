# Function Reference -- Aerobiz Supersonic

Index of all identified functions. Updated as disassembly progresses.

## Summary

- **Total RTS (function endpoints):** 854
- **Total RTE (interrupt returns):** 6
- **Unique call targets:** 2,896
- **Functions named:** 54
- **Functions translated to mnemonics:** 12 (exception handlers, EXT/H-INT/V-INT, boot post-init, Z80 sound interface, GameEntry/GameLoopSetup/MainLoop, GameCommand)

## Most-Called Functions

These are the most frequently called subroutines -- high-priority translation targets.

| Address | Calls | Name | Notes |
|---------|-------|------|-------|
| $000D64 | 306 | GameCommand | Central command dispatcher (47 handlers via jump table) |
| $03E05C | 204 | | In string/UI region |
| $03AB2C | 174 | | |
| $03B22C | 171 | | |
| $03E08A | 169 | | In string/UI region |
| $03A942 | 124 | | |
| $003FEC | 123 | | |
| $00D648 | 114 | | Near main game loop |
| $01D71C | 106 | | |
| $005092 | 101 | DisplaySetup | Display/graphics setup |
| $01E044 | 100 | | |
| $03B270 | 97 | | |
| $01E1EC | 95 | | |
| $01D748 | 95 | | |
| $03E146 | 88 | | In string/UI region |
| $01E0B8 | 77 | | |
| $01D520 | 71 | | |
| $03B246 | 65 | | |
| $01D62C | 65 | | |
| $01D6A4 | 64 | | |

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
| $00D5B6 | GameEntry | Main game entry (called from boot via JMP) |
| $00D602 | GameLoopSetup | One-time pre-loop init, falls into MainLoop |
| $00D608 | MainLoop | Main game loop body (8 calls, loops forever) |
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
| $003FEC | -- | unknown | 123 | unnamed |
| $005092 | DisplaySetup | display | 101 | named |
| $005736 | PreGameInit | game | -- | named |
| $0058EE | ErrorDisplay | exception | -- | named |
| $01819C | GameCall | game | -- | named |
| $01B49A | GameUpdate2 | game | -- | named |
| $01D520 | -- | unknown | 71 | unnamed |
| $01D62C | -- | unknown | 65 | unnamed |
| $01D6A4 | -- | unknown | 64 | unnamed |
| $01D71C | -- | unknown | 106 | unnamed |
| $01D748 | -- | unknown | 95 | unnamed |
| $01E044 | -- | unknown | 100 | unnamed |
| $01E0B8 | -- | unknown | 77 | unnamed |
| $01E1EC | -- | unknown | 95 | unnamed |
| $01E398 | PreLoopInit | game | 57 | named |
| $01E402 | GameUpdate3 | game | -- | named |
| $0213B6 | GameLogic1 | game | -- | named |
| $026128 | GameUpdate4 | game | -- | named |
| $02947A | GameLogic2 | game | -- | named |
| $02F5A6 | GameUpdate1 | game | -- | named |
| $03A942 | -- | unknown | 124 | unnamed |
| $03AB2C | -- | unknown | 174 | unnamed |
| $03B22C | -- | unknown | 171 | unnamed |
| $03B246 | -- | unknown | 65 | unnamed |
| $03B270 | -- | unknown | 97 | unnamed |
| $03B428 | GameSetup1 | game | -- | named |
| $03CA4E | GameSetup2 | game | -- | named |
| $03E05C | -- | ui/string | 204 | unnamed |
| $03E08A | -- | ui/string | 169 | unnamed |
| $03E146 | -- | ui/string | 88 | unnamed |
| $00D5B6 | GameEntry | game | -- | named |
| $00D602 | GameLoopSetup | game | -- | named |
| $00D608 | MainLoop | game | -- | named |
| $00D648 | -- | game | 114 | unnamed |
