# B-055 Batch B Findings

## Functions Described

### VDP Init + DMA Setup

- **InitSpriteLinks**: Initialize sprite link-chain bytes in sprite table buffer
- **VDP_Init2**: Zero sprite table buffer in RAM and reinitialize sprite links
- **VDP_Init1**: Clear VRAM, CRAM, and VSRAM by bulk-writing zeros via VDP data port
- **VDP_Init3**: Set all three I/O port control registers to output mode ($40)
- **Init6**: Initialize scroll/viewport bounds and display limit variables in work RAM
- **Init5**: Bulk-copy 800 bytes from ROM data table ($1D88) to VRAM via VDP data port
- **VDP_Init4**: Request Z80 bus and reset Z80, then wait for bus grant with IRQs disabled
- **TriggerVDPDMA**: Invoke ConfigVDPDMA to program and fire a DMA transfer
- **DispatchVDPWrite**: Write scroll data to VDP then wait for FIFO idle before continuing
- **ReleaseZ80BusDirect**: Write zero to Z80 bus-request register to release Z80 bus
- **SetVDPDisplayBit**: Write VDP register 1 with display enabled and DMA disabled
- **WaitVDPAndWrite**: Poll VDP until not busy, then write auto-increment register from RAM
- **ConfigVDPDMA**: Program VDP DMA registers from RAM parameters and trigger the transfer
- **ConfigVDPScroll**: Set VDP DMA registers and VRAM destination for scroll data transfer
- **ConfigVDPColors**: Set VDP DMA registers and CRAM destination, then write one color word

### Interrupt Handlers + Frame Update

- **VInt_Handler1**: V-INT sub-handler: copy a block of words from RAM buffer to VRAM
- **BulkCopyVDP**: Issue VDP command word then loop-write D1 words from A0 to VDP data port
- **VInt_Handler2**: V-INT sub-handler: fill VRAM rows with repeated tile word over multiple passes
- **VInt_Handler3**: V-INT sub-handler: read VRAM rows back into a RAM buffer over multiple passes
- **SelectVDPInit**: Dispatch to DMA, scroll, or color VDP write based on D0 flag bits
- **InitDisplayLayout**: Set up sprite DMA parameters (source, dest, length) and trigger transfer
- **DMA_Transfer**: Write 11 words from RAM palette buffer ($FFF06A) to VDP CRAM
- **DisplayUpdate**: On timer tick, copy or clear sprite entries then reinitialize display layout
- **VInt_Sub2**: Invoke per-frame V-INT callback via function pointer stored in work RAM
- **SubsysUpdate1**: Update scroll position from velocity for each active display object, clamped to bounds
- **SubsysUpdate2**: Process directional input to scroll the display with acceleration and deceleration
- **SubsysUpdate3**: Update cursor sprite position by scroll offsets and write to VRAM sprite table
- **SubsysUpdate4**: Accumulate button state from both controller records into combined input longword

### Input System

- **InitInputArrays**: Dead stub (infinite loop) immediately preceding ControllerPoll entry point
- **ReadPortByte**: Read one I/O port and dispatch to handler based on detected controller protocol
- **InputCaseDispatch**: PC-relative jump table for controller type dispatch plus 3-button read handler
- **CountInputBits**: Count how many 2-bit groups in the port byte are non-zero
- **StubReturn**: No-op stub that returns immediately (unhandled controller protocol cases)
- **WritePortToggle**: Toggle TH line, combine high/low nibbles, and update input state slot
- **XorAndUpdate**: Store new button byte at A1 and write newly-pressed bits (changed AND new)
- **ReadMultiNibbles**: Read up to three nibble pairs from port via TH toggle, detect protocol type
- **WaitInputReady**: Wait for port device ready signal then initiate input data parse
- **ParseInputData**: Read two nibble pairs from port to assemble a 16-bit input data packet
- **ParseInputExtended**: Decode extended device packet: mark type 2, sign-extend XY movement deltas
- **InputStateMachine**: Drive multi-step read sequence collecting 4 data bytes from extended device
- **ParseInputDispatch**: Dispatch one input packet parse step via type-code indexed jump table
- **ParseInputNibbles**: Read two nibbles, combine into button byte, update current/pressed state
- **WriteNibble**: Handle type-0 packet: read combined nibble and update button state slot
- **CombineNibbles**: Poll two nibbles from port and combine into an inverted 8-bit button byte
- **PollInputStatus**: Alternating poll: odd calls wait for zero, even calls wait for data bit4 set
- **WaitInputZero**: Set port to zero and spin until bit 4 rises; set carry on timeout
- **ReturnError**: Set carry flag and return to signal timeout or error to caller

## Functions Skipped (no TODO)

- **VDPWriteColorsPath** ($001138): inline label within DispatchVDPWrite, no header
- **VDPWriteZ80Path** ($00114A): inline label within DispatchVDPWrite, no header
- **ExtInterrupt** ($001480): already described as "EXT Interrupt Handler -- Level 2 (unused)"
- **HBlankInt** ($001484): already described as "H-Blank Interrupt Handler -- Level 4 / Raster scroll effect"
- **VBlankInt** ($0014E6): already described as "V-Blank Interrupt Handler -- Level 6 / Main per-frame handler"
- **ControllerPoll** ($00192E): inline label within InitInputArrays block, no separate header
- **PollInputStatus_Main** ($001C72): inline label within PollInputStatus block, no separate header

## Notes

### VDP DMA Architecture
ConfigVDPDMA and ConfigVDPScroll are closely related: both program VDP regs $93-$97
(DMA length bytes and source address bytes). ConfigVDPDMA calls the RAM subroutine at
$FFF000 to fire the DMA, while ConfigVDPScroll sets up scroll-table writes. ConfigVDPColors
programs for CRAM (bit 14 set in destination address) and then does a direct write of one
color word.

### VInt_Handler1/2/3 Pattern
These three handlers are dispatched by bit flags in $002B(A5):
- Bit 0 -> VInt_Handler1: copy RAM buffer -> VRAM (DMA-style CPU copy)
- Bit 1 -> VInt_Handler2: fill VRAM rows with constant tile word (tile clear)
- Bit 2 -> VInt_Handler3: read VRAM rows -> RAM buffer (VRAM readback)

### Input Protocol State Machine
The input system supports multiple device types via a dispatch table in InputCaseDispatch.
The protocol detection sequence uses bit-group counting (CountInputBits) on an initial port
read. Confirmed device types:
- Type 0: simple no-data case
- Type 1: standard 3-button/6-button (two nibble reads per update)
- Type 2: extended device (mouse/multitap) with XY delta decoding

ReadMultiNibbles is the 6-button detection: it toggles TH three times looking for the
Mega Drive 6-button signature (all four direction bits low during third TH-high). If found,
marks as extended; otherwise falls back to standard protocol.

### SubsysUpdate Architecture
- SubsysUpdate1: scroll position integration (velocity -> position, clamped to bounds)
- SubsysUpdate2: scroll acceleration from d-pad input, manages deceleration timer ($C6E)
- SubsysUpdate3: cursor sprite positioning (applies scroll offset to sprite table entry)
- SubsysUpdate4: raw button accumulation for the display subsystem

### InitInputArrays Dead Stub
The InitInputArrays label at $001928 loads from stack ($42(a7)) and immediately branches to
itself in an infinite loop. This is unreachable dead code -- no jsr to InitInputArrays
exists in the ROM. The 52-byte range for "InitInputArrays" actually encompasses both this
dead stub (6 bytes) and the real ControllerPoll function (46 bytes).
