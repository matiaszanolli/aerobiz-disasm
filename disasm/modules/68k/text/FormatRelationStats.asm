; ============================================================================
; FormatRelationStats -- Draws the compact relation stats cell: renders both character names, compatibility fraction, portrait icon, and score value into a tile panel at the given position
; Called: ?? times.
; 922 bytes | $019660-$0199F9
; ============================================================================
FormatRelationStats:                                                  ; $019660
    link    a6,#-$10
    movem.l d2-d5/a2-a5,-(sp)
    move.l  $0018(a6),d3
    move.l  $0014(a6),d4
    movea.l $0008(a6),a2
    movea.l #$0003b270,a3
    movea.l #$0003ab2c,a4
    movea.l #$00ff1804,a5
    moveq   #$1,d5
    dc.w    $4eb9,$0003,$77c8                           ; jsr $0377C8
    move.l  #$8000,-(sp)
    pea     ($000C).w
    pea     ($0020).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    lea     $0024(sp),sp
    tst.w   d0
    beq.b   .l196d0
    moveq   #$2,d2
    bra.b   .l196d2
.l196d0:                                                ; $0196D0
    moveq   #$1,d2
.l196d2:                                                ; $0196D2
    pea     ($075E).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    lea     $0020(sp),sp
    pea     ($075F).w
    move.w  $000e(a6),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    lea     $0020(sp),sp
    pea     ($077E).w
    pea     ($0004).w
    pea     ($000B).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    pea     ($077E).w
    pea     ($0004).w
    pea     ($000B).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$13,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    cmpi.w  #$1,d3
    bne.b   .l197c6
    pea     ($0004DCE8).l
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($001A).w
    pea     ($0328).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $001c(sp),sp
.l197c6:                                                ; $0197C6
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    jsr     (a4)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0004110C).l
    jsr     (a3)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$c,d0
    move.l  d0,-(sp)
    jsr     (a4)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    addq.l  #$8,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    pea     ($00041108).l
    jsr     (a3)
    lea     $0030(sp),sp
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$13,d0
    move.l  d0,-(sp)
    jsr     (a4)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$b,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$12,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$11,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$595e                           ; jsr $00595E
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($00041104).l
    jsr     (a3)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    jsr     (a4)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    addq.l  #$4,sp
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
    movea.l #$00ff1278,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    lsl.w   #$2,d0
    movea.l #$0005ecfc,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410FC).l
    jsr     (a3)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$00da                                 ; jsr $0199FA
    nop
    lea     $0030(sp),sp
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$f,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$049c                                 ; jsr $019DE6
    nop
    lea     $0014(sp),sp
    moveq   #-$1,d3
    move.b  $000a(a2),d0
    btst    #$02,d0
    beq.b   .l19962
    moveq   #$0,d3
    bra.b   .l1997c
.l19962:                                                ; $019962
    move.b  $000a(a2),d0
    btst    #$01,d0
    beq.b   .l19970
    moveq   #$10,d3
    bra.b   .l1997c
.l19970:                                                ; $019970
    move.b  $000a(a2),d0
    btst    #$00,d0
    beq.b   .l1997c
    moveq   #$8,d3
.l1997c:                                                ; $01997C
    moveq   #-$1,d0
    cmp.l   d3,d0
    bge.b   .l199f0
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    add.l   d3,d0
    addi.l  #$637b,d0
    move.l  d0,d3
.l19992:                                                ; $019992
    move.w  d2,d0
    add.w   d0,d0
    move.w  d3,-$10(a6,d0.w)
    addq.l  #$1,d3
    addq.w  #$1,d2
    cmpi.w  #$8,d2
    blt.b   .l19992
    pea     -$0010(a6)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0004E28A).l
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0018).w
    pea     ($037B).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
.l199f0:                                                ; $0199F0
    movem.l -$0030(a6),d2-d5/a2-a5
    unlk    a6
    rts
