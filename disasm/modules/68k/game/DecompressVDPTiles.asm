; ============================================================================
; DecompressVDPTiles -- Decompress LZ-encoded 4bpp tile data directly into VDP VRAM via data port
; Called: ?? times.
; 624 bytes | $004342-$0045B1
; ============================================================================
; --- Phase: Setup ---
DecompressVDPTiles:                                                  ; $004342
    movem.l d2-d7/a2-a6,-(sp)
    ; a0 = VRAM destination pointer (arg 1 from caller's stack, after saving 11 regs = $2C bytes)
    movea.l $0030(sp),a0
    ; a1 = pointer to the compressed tile bitstream in ROM
    movea.l $0034(sp),a1
    ; a3 = $FF88DA = decomp_a3 working area base (scratch buffer for lookahead window)
    movea.l #$00ff88da,a3
    ; a4 = $4240 used as a function pointer: jsr (a4) calls an internal advance/shift routine
    movea.l #$4240,a4
    ; a5 = $C00000 = VDP data port (writes tile pixels here directly during decompression)
    movea.l #$00c00000,a5
    ; a6 = $C00004 = VDP control port (set VRAM write address before each tile)
    movea.l #$00c00004,a6
    ; Clear decomp_flag ($FFBD50): signals decompression is in progress
    clr.w   ($00FFBD50).l
    ; Call internal shift routine (at $4240) with arg $10: initializes 16-bit bitstream word
    pea     ($0010).w
    jsr     (a4)
    addq.l  #$4,sp
; --- Phase: Outer Loop -- Read Control Byte ---
; Each iteration processes one 8-bit control byte, then decodes 8 tokens (d4 counts 0..7)
.l4374:                                                 ; $004374
    ; Load next control byte from bitstream into decomp_ctrl2 ($FF128E)
    ; This byte's bits determine whether each subsequent token is a literal or a back-reference
    move.b  (a1)+,($00FF128E).l
    ; d4 = inner bit counter (0..7, one bit per token within the control byte)
    clr.w   d4
; --- Phase: Inner Loop -- Decode Token ---
.l437c:                                                 ; $00437C
    ; Check bit 7 of the control byte: 1 = literal pixel byte follows directly
    move.b  ($00FF128E).l,d0
    btst    #$07,d0
    beq.b   .l4394
    ; --- Literal path: read one pixel byte from stream, write to VRAM, advance VRAM ptr ---
    move.b  (a1)+,d0
    ; jsr $0042F0: internal helper -- writes d0 pixel byte to VDP data port at a5
    dc.w    $4eba,$ff64                                 ; jsr $0042F0
    ; a0 tracks how many bytes have been written to VRAM (output position)
    addq.l  #$1,a0
    bra.w   .l458a
; --- Back-Reference Decoding ---
; The bitstream window at (a3) encodes the back-reference length/offset using a
; multi-tier Huffman-like prefix scheme (higher priority bits = shorter code = more common).
; Each tier extracts different bit-fields for (d3=match_length, then advance bits read).
.l4394:                                                 ; $004394
    ; Tier 1: bit 15 set -> length = 1 (single-byte repeat, most common)
    move.w  (a3),d0
    andi.w  #$8000,d0
    beq.b   .l43a2
    moveq   #$1,d3
    bra.w   .l4458
.l43a2:                                                 ; $0043A2
    ; Tier 2: bit 14 set -> length field in bits [13:13] (2 bits -> 0-1, shifted right 13)
    ; Advance 2 bits from the window
    move.w  (a3),d0
    andi.w  #$4000,d0
    beq.b   .l43be
    move.w  (a3),d3
    andi.l  #$6000,d3
    moveq   #$d,d0
    asr.l   d0,d3
    pea     ($0002).w
    bra.w   .l4454
.l43be:                                                 ; $0043BE
    ; Tier 3: bit 13 set -> length field in bits [12:11] (3 bits, shifted right 11)
    move.w  (a3),d0
    andi.w  #$2000,d0
    beq.b   .l43d8
    move.w  (a3),d3
    andi.l  #$3800,d3
    moveq   #$b,d0
    asr.l   d0,d3
    pea     ($0004).w
    bra.b   .l4454
.l43d8:                                                 ; $0043D8
    ; Tier 4: bit 12 set -> length field in bits [11:9] (4 bits, shifted right 9)
    move.w  (a3),d0
    andi.w  #$1000,d0
    beq.b   .l43f2
    move.w  (a3),d3
    andi.l  #$1e00,d3
    moveq   #$9,d0
    asr.l   d0,d3
    pea     ($0006).w
    bra.b   .l4454
.l43f2:                                                 ; $0043F2
    ; Tier 5: bit 11 set -> length field in bits [10:7] (5 bits, shifted right 7)
    move.w  (a3),d0
    andi.w  #$0800,d0
    beq.b   .l440a
    move.w  (a3),d3
    andi.l  #$0f80,d3
    asr.l   #$7,d3
    pea     ($0008).w
    bra.b   .l4454
.l440a:                                                 ; $00440A
    ; Tier 6: bit 10 set -> length field in bits [9:5] (6 bits, shifted right 5)
    move.w  (a3),d0
    andi.w  #$0400,d0
    beq.b   .l4422
    move.w  (a3),d3
    andi.l  #$07e0,d3
    asr.l   #$5,d3
    pea     ($000A).w
    bra.b   .l4454
.l4422:                                                 ; $004422
    ; Tier 7: bit 9 set -> length field in bits [8:3] (7 bits, shifted right 3)
    move.w  (a3),d0
    andi.w  #$0200,d0
    beq.b   .l443a
    move.w  (a3),d3
    andi.l  #$03f8,d3
    asr.l   #$3,d3
    pea     ($000C).w
    bra.b   .l4454
.l443a:                                                 ; $00443A
    ; Tier 8 (fallthrough): bits [7:2] (7 bits, shifted right 2); add $80 bias
    ; If result == $FF: end-of-stream sentinel -- jump to termination
    move.w  (a3),d3
    andi.l  #$01fc,d3
    asr.l   #$2,d3
    addi.w  #$80,d3
    cmpi.w  #$ff,d3
    beq.w   .l45a4
    ; Not end-of-stream: advance 13 more bits from the bitstream window
    pea     ($000D).w
.l4454:                                                 ; $004454
    ; Advance the bit window by the count pushed on stack (consumes that many bits)
    jsr     (a4)
    addq.l  #$4,sp
; --- Phase: Decode Back-Reference Offset ---
; After determining match length (d3), decode the back-reference offset (d2)
; using another Huffman-like multi-tier scheme based on the remaining window bits.
; d2 will be the byte distance back into the output stream.
.l4458:                                                 ; $004458
    ; Clear bit 15 of window (consume the length prefix bit)
    andi.w  #$7fff,(a3)
    ; Offset tier 1: window < $0800 -> small offset (bits [10:9], 2-bit field)
    cmpi.w  #$0800,(a3)
    bcc.b   .l4476
    move.w  (a3),d2
    andi.l  #$0600,d2
    moveq   #$9,d0
    asr.l   d0,d2
    ; d2 = offset value 0..3; advance 7 bits
    pea     ($0007).w
    bra.w   .l455a
.l4476:                                                 ; $004476
    ; Offset tier 2: $0800 <= window < $0C00 -> offset bits [9:8] + 4 bias
    cmpi.w  #$0c00,(a3)
    bcc.b   .l4490
    move.w  (a3),d2
    andi.l  #$0300,d2
    asr.l   #$8,d2
    ; Add bias so offsets 4..7 map to this tier
    addq.w  #$4,d2
    pea     ($0008).w
    bra.w   .l455a
.l4490:                                                 ; $004490
    ; Offset tier 3: $0C00 <= window < $1800 -> subtract base, extract bits [11:7] + 8 bias
    cmpi.w  #$1800,(a3)
    bcc.b   .l44b2
    moveq   #$0,d2
    move.w  (a3),d2
    subi.l  #$0c00,d2
    andi.l  #$0f80,d2
    asr.l   #$7,d2
    addq.w  #$8,d2
    pea     ($0009).w
    bra.w   .l455a
.l44b2:                                                 ; $0044B2
    ; Offset tier 4: $1800 <= window < $3000 -> bits [12:6], subtract $1800, + $20 bias
    cmpi.w  #$3000,(a3)
    bcc.b   .l44d6
    moveq   #$0,d2
    move.w  (a3),d2
    subi.l  #$1800,d2
    andi.l  #$1fc0,d2
    asr.l   #$6,d2
    addi.w  #$20,d2
    pea     ($000A).w
    bra.w   .l455a
.l44d6:                                                 ; $0044D6
    ; Offset tier 5: $3000 <= window < $4000 -> bits [12:0] OR $1000, shifted right 5
    cmpi.w  #$4000,(a3)
    bcc.b   .l44f2
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$5,d2
    pea     ($000B).w
    bra.b   .l455a
.l44f2:                                                 ; $0044F2
    ; Offset tier 6: $4000 <= window < $5000 -> same mask, shifted right 4
    cmpi.w  #$5000,(a3)
    bcc.b   .l450e
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$4,d2
    pea     ($000C).w
    bra.b   .l455a
.l450e:                                                 ; $00450E
    ; Offset tier 7: $5000 <= window < $6000 -> shifted right 3
    cmpi.w  #$6000,(a3)
    bcc.b   .l452a
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$3,d2
    pea     ($000D).w
    bra.b   .l455a
.l452a:                                                 ; $00452A
    ; Offset tier 8: $6000 <= window < $7000 -> shifted right 2
    cmpi.w  #$7000,(a3)
    bcc.b   .l4546
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$2,d2
    pea     ($000E).w
    bra.b   .l455a
.l4546:                                                 ; $004546
    ; Offset tier 9 (largest): window >= $7000 -> shifted right 1 (longest offsets)
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$1,d2
    pea     ($000F).w
.l455a:                                                 ; $00455A
    ; Consume offset bits from the window (count is on stack)
    jsr     (a4)
    addq.l  #$4,sp
    ; --- Phase: Copy Back-Reference Bytes ---
    ; a2 = source pointer = current output position (a0) - offset (d2) - 1
    ; This is the LZ77 back-reference: copy d3+1 bytes from a2 to a0
    moveq   #$0,d0
    move.w  d2,d0
    move.l  a0,d1
    sub.l   d0,d1
    subq.l  #$1,d1
    ; a2 = back-reference source address in already-decompressed output
    movea.l d1,a2
    ; d2 reused as loop counter (counts bytes copied so far)
    clr.w   d2
    bra.b   .l457c
.l456e:                                                 ; $00456E
    ; jsr $0042BA: internal read-from-output helper (reads byte from a2)
    dc.w    $4eba,$fd4a                                 ; jsr $0042BA
    ; jsr $0042F0: internal write-to-VRAM helper (writes byte to VDP data port)
    dc.w    $4eba,$fd7c                                 ; jsr $0042F0
    addq.l  #$1,a0
    addq.l  #$1,a2
    addq.w  #$1,d2
; --- Phase: Back-Reference Loop Condition ---
.l457c:                                                 ; $00457C
    ; Loop d3+1 times (d3 = match length decoded above)
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$0,d1
    move.w  d3,d1
    addq.l  #$1,d1
    cmp.l   d1,d0
    blt.b   .l456e
; --- Phase: Advance Control Byte Bit ---
.l458a:                                                 ; $00458A
    ; Shift the control byte left by 1: the next bit is now in bit 7 for the next token
    ; This is a self-modifying rotation: add decomp_ctrl2 to itself = logical shift left 1
    move.b  ($00FF128E).l,d0
    add.b   d0,($00FF128E).l
    ; Increment inner token counter; loop back if < 8 tokens processed
    addq.w  #$1,d4
    cmpi.w  #$8,d4
    bcs.w   .l437c
    ; Fetch next control byte and reset inner counter
    bra.w   .l4374
; --- Phase: End of Stream ---
.l45a4:                                                 ; $0045A4
    ; Return value = number of bytes written to VRAM
    ; d0 = a0 (current output position) - original start address (from stack arg)
    move.l  $0030(sp),d1
    move.l  a0,d0
    sub.l   d1,d0
    movem.l (sp)+,d2-d7/a2-a6
    rts
; === MemMove ($0045B2, 52B) ===
MemMove:                                                              ; $0045B2
    MOVE.L  $C(SP),D1                                                 ; count
    MOVEA.L $8(SP),A1                                                 ; dest
    MOVEA.L $4(SP),A0                                                 ; src
    CMPA.W  A1,A0                                                     ; compare src vs dest
    BLS.S   .mm_backward                                              ; if src <= dest, copy backward
    BRA.S   .mm_fwd_check
.mm_fwd_loop:                                                         ; $0045C4
    MOVE.B  (A0)+,(A1)+                                               ; copy forward
    SUBQ.W  #1,D1
.mm_fwd_check:                                                        ; $0045C8
    TST.W   D1
    BNE.S   .mm_fwd_loop
    BRA.S   .mm_done
.mm_backward:                                                         ; $0045CE
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    ADDA.L  D0,A1                                                     ; dest += count
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    ADDA.L  D0,A0                                                     ; src += count
    BRA.S   .mm_bwd_check
.mm_bwd_loop:                                                         ; $0045DC
    MOVE.B  -(A0),-(A1)                                               ; copy backward
    SUBQ.W  #1,D1
.mm_bwd_check:                                                        ; $0045E0
    TST.W   D1
    BNE.S   .mm_bwd_loop
.mm_done:                                                             ; $0045E4
    RTS
; === CmdPlaceTile2 ($0045E6, 64B) ===
CmdPlaceTile2:                                                        ; $0045E6
    MOVE.L  D2,-(SP)
    MOVE.L  $10(SP),D2                                                ; arg3 (count)
    MOVE.L  $C(SP),D1                                                 ; arg2 (tile address)
    MOVEA.L $8(SP),A0                                                 ; arg1 (src)
    MOVE.W  D1,D0
    ANDI.L  #$000007FF,D0
    LSL.L   #5,D0                                                     ; * 32
    MOVEA.L D0,A1
    CLR.L   -(SP)                                                     ; push 0
    CLR.L   -(SP)                                                     ; push 0
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    LSL.L   #4,D0                                                     ; count * 16
    MOVE.L  D0,-(SP)
    MOVE.L  A1,-(SP)
    MOVE.L  A0,-(SP)
    PEA     ($0002).W                                                 ; sub-command 2
    PEA     ($0008).W                                                 ; command 8
    jsr GameCommand
    LEA     $1C(SP),SP                                                ; pop 7 args
    MOVE.L  (SP)+,D2
    RTS
; === Translated block $004626-$004668 ===
; 1 functions, 66 bytes
