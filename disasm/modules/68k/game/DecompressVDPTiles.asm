; ============================================================================
; DecompressVDPTiles -- Decompress LZ-encoded 4bpp tile data directly into VDP VRAM via data port
; Called: ?? times.
; 624 bytes | $004342-$0045B1
; ============================================================================
DecompressVDPTiles:                                                  ; $004342
    movem.l d2-d7/a2-a6,-(sp)
    movea.l $0030(sp),a0
    movea.l $0034(sp),a1
    movea.l #$00ff88da,a3
    movea.l #$4240,a4
    movea.l #$00c00000,a5
    movea.l #$00c00004,a6
    clr.w   ($00FFBD50).l
    pea     ($0010).w
    jsr     (a4)
    addq.l  #$4,sp
.l4374:                                                 ; $004374
    move.b  (a1)+,($00FF128E).l
    clr.w   d4
.l437c:                                                 ; $00437C
    move.b  ($00FF128E).l,d0
    btst    #$07,d0
    beq.b   .l4394
    move.b  (a1)+,d0
    dc.w    $4eba,$ff64                                 ; jsr $0042F0
    addq.l  #$1,a0
    bra.w   .l458a
.l4394:                                                 ; $004394
    move.w  (a3),d0
    andi.w  #$8000,d0
    beq.b   .l43a2
    moveq   #$1,d3
    bra.w   .l4458
.l43a2:                                                 ; $0043A2
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
    move.w  (a3),d0
    andi.w  #$0800,d0
    beq.b   .l440a
    move.w  (a3),d3
    andi.l  #$0f80,d3
    asr.l   #$7,d3
    pea     ($0008).w
    bra.b   .l4454
.l440a:                                                 ; $00440A
    move.w  (a3),d0
    andi.w  #$0400,d0
    beq.b   .l4422
    move.w  (a3),d3
    andi.l  #$07e0,d3
    asr.l   #$5,d3
    pea     ($000A).w
    bra.b   .l4454
.l4422:                                                 ; $004422
    move.w  (a3),d0
    andi.w  #$0200,d0
    beq.b   .l443a
    move.w  (a3),d3
    andi.l  #$03f8,d3
    asr.l   #$3,d3
    pea     ($000C).w
    bra.b   .l4454
.l443a:                                                 ; $00443A
    move.w  (a3),d3
    andi.l  #$01fc,d3
    asr.l   #$2,d3
    addi.w  #$80,d3
    cmpi.w  #$ff,d3
    beq.w   .l45a4
    pea     ($000D).w
.l4454:                                                 ; $004454
    jsr     (a4)
    addq.l  #$4,sp
.l4458:                                                 ; $004458
    andi.w  #$7fff,(a3)
    cmpi.w  #$0800,(a3)
    bcc.b   .l4476
    move.w  (a3),d2
    andi.l  #$0600,d2
    moveq   #$9,d0
    asr.l   d0,d2
    pea     ($0007).w
    bra.w   .l455a
.l4476:                                                 ; $004476
    cmpi.w  #$0c00,(a3)
    bcc.b   .l4490
    move.w  (a3),d2
    andi.l  #$0300,d2
    asr.l   #$8,d2
    addq.w  #$4,d2
    pea     ($0008).w
    bra.w   .l455a
.l4490:                                                 ; $004490
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
    cmpi.w  #$4000,(a3)
    bcc.b   .l44f2
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$5,d2
    pea     ($000B).w
    bra.b   .l455a
.l44f2:                                                 ; $0044F2
    cmpi.w  #$5000,(a3)
    bcc.b   .l450e
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$4,d2
    pea     ($000C).w
    bra.b   .l455a
.l450e:                                                 ; $00450E
    cmpi.w  #$6000,(a3)
    bcc.b   .l452a
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$3,d2
    pea     ($000D).w
    bra.b   .l455a
.l452a:                                                 ; $00452A
    cmpi.w  #$7000,(a3)
    bcc.b   .l4546
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$2,d2
    pea     ($000E).w
    bra.b   .l455a
.l4546:                                                 ; $004546
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$1,d2
    pea     ($000F).w
.l455a:                                                 ; $00455A
    jsr     (a4)
    addq.l  #$4,sp
    moveq   #$0,d0
    move.w  d2,d0
    move.l  a0,d1
    sub.l   d0,d1
    subq.l  #$1,d1
    movea.l d1,a2
    clr.w   d2
    bra.b   .l457c
.l456e:                                                 ; $00456E
    dc.w    $4eba,$fd4a                                 ; jsr $0042BA
    dc.w    $4eba,$fd7c                                 ; jsr $0042F0
    addq.l  #$1,a0
    addq.l  #$1,a2
    addq.w  #$1,d2
.l457c:                                                 ; $00457C
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$0,d1
    move.w  d3,d1
    addq.l  #$1,d1
    cmp.l   d1,d0
    blt.b   .l456e
.l458a:                                                 ; $00458A
    move.b  ($00FF128E).l,d0
    add.b   d0,($00FF128E).l
    addq.w  #$1,d4
    cmpi.w  #$8,d4
    bcs.w   .l437c
    bra.w   .l4374
.l45a4:                                                 ; $0045A4
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
