; ============================================================================
; FormatRelationDisplay -- Draws the relation detail panel for a character pair: loads portrait sprite, draws compatibility gauge, prints both names and score, and displays relation icon tiles
; Called: ?? times.
; 1052 bytes | $019244-$01965F
; ============================================================================
FormatRelationDisplay:                                                  ; $019244
    link    a6,#-$10
    movem.l d2-d5/a2-a5,-(sp)
    move.l  $0018(a6),d2
    move.l  $000c(a6),d3
    move.l  $0014(a6),d4
    movea.l $0008(a6),a2
    movea.l #$00ff1804,a3
    movea.l #$0003ab2c,a4
    movea.l #$00ffba80,a5
    moveq   #$1,d5
    move.l  #$8000,-(sp)
    pea     ($000D).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    cmpi.w  #$1,d2
    bne.w   .l1933a
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    tst.w   d0
    beq.b   .l192c4
    move.l  ($000A1B50).l,-(sp)
    bra.b   .l192ca
.l192c4:                                                ; $0192C4
    move.l  ($000A1B4C).l,-(sp)
.l192ca:                                                ; $0192CA
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0010).w
    pea     ($0001).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($0004DCE8).l
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.l  a3,-(sp)
    pea     ($001A).w
    pea     ($0328).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($00072AC0).l
    pea     ($000D).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0030(sp),sp
.l1933a:                                                ; $01933A
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
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
    pea     ($000410F8).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$c,d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0028(sp),sp
    move.w  d4,d0
    addq.w  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$b,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
    move.w  d4,d0
    addq.w  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$12,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
    move.w  d4,d0
    addq.w  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$11,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$595e                           ; jsr $00595E
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
    pea     ($000410F4).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0030(sp),sp
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$13,d0
    move.l  d0,-(sp)
    jsr     (a4)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410F0).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    jsr     (a4)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
    move.b  (a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
    move.b  $0001(a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    pea     ($000410E6).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$14,d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $002c(sp),sp
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
    move.b  (a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
    move.b  $0001(a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    pea     ($000410DC).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    move.w  d4,d0
    ext.l   d0
    addi.l  #$b,d0
    move.l  d0,-(sp)
    pea     ($000E).w
    jsr     (a4)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    addq.l  #$4,sp
    move.l  d0,-(sp)
    pea     ($000410D8).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    lea     $001c(sp),sp
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$a5a8                           ; jsr $03A5A8
    move.w  d2,d0
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
    dc.w    $4eba,$0476                                 ; jsr $0199FA
    nop
    lea     $002c(sp),sp
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$8,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$f,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$0838                                 ; jsr $019DE6
    nop
    lea     $0014(sp),sp
    moveq   #-$1,d3
    move.b  $000a(a2),d0
    btst    #$02,d0
    beq.b   .l195c6
    moveq   #$0,d3
    bra.b   .l195e0
.l195c6:                                                ; $0195C6
    move.b  $000a(a2),d0
    btst    #$01,d0
    beq.b   .l195d4
    moveq   #$10,d3
    bra.b   .l195e0
.l195d4:                                                ; $0195D4
    move.b  $000a(a2),d0
    btst    #$00,d0
    beq.b   .l195e0
    moveq   #$8,d3
.l195e0:                                                ; $0195E0
    moveq   #-$1,d0
    cmp.l   d3,d0
    bge.b   .l19656
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    add.l   d3,d0
    addi.l  #$037b,d0
    move.l  d0,d3
.l195f6:                                                ; $0195F6
    move.w  d2,d0
    add.w   d0,d0
    move.w  d3,-$10(a6,d0.w)
    addq.l  #$1,d3
    addq.w  #$1,d2
    cmpi.w  #$8,d2
    blt.b   .l195f6
    pea     -$0010(a6)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0004E28A).l
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a3,-(sp)
    pea     ($0018).w
    pea     ($037B).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
.l19656:                                                ; $019656
    movem.l -$0030(a6),d2-d5/a2-a5
    unlk    a6
    rts
