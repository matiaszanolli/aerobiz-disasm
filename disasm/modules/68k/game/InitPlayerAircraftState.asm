; ============================================================================
; InitPlayerAircraftState -- Initialize runtime route slot fields for all players: revenue, passenger count, city traffic, compatibility scores
; 804 bytes | $00CEEA-$00D20D
; ============================================================================
InitPlayerAircraftState:
    link    a6,#-$8
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0018,a4
    clr.w   d2
.l0cefa:
    moveq   #$0,d0
    move.b  $1(a4), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  d1, (a0,d0.w)
    move.w  d2, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
    move.w  d2, d0
    mulu.w  #$7, d0
    movea.l  #$00FFA7BC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d2, d0
    mulu.w  #$e, d0
    movea.l  #$00FFBD6C,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
.l0cf4c:
    cmpi.b  #$ff, (a2)
    beq.w   .l0d110
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d3
    cmpi.b  #$20, (a2)
    bcc.b   .l0cf84
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    bra.b   .l0cfb2
.l0cf84:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECBE,a0
    move.b  (a0,d1.w), d1
    andi.l  #$ff, d1
    sub.w   d1, d0
    moveq   #$1,d1
    lsl.w   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    add.l   -$4(a6), d1
    movea.l d1, a0
    or.w    d0, (a0)
.l0cfb2:
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d5
    cmpi.b  #$20, $1(a2)
    bcc.b   .l0cfe8
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    bra.b   .l0d018
.l0cfe8:
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d5, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECBE,a0
    move.b  (a0,d1.w), d1
    andi.l  #$ff, d1
    sub.w   d1, d0
    moveq   #$1,d1
    lsl.w   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    ext.l   d1
    add.l   d1, d1
    add.l   -$4(a6), d1
    movea.l d1, a0
    or.w    d0, (a0)
.l0d018:
    cmp.w   d5, d3
    beq.b   .l0d030
    moveq   #$1,d0
    lsl.b   d5, d0
    movea.w d3, a0
    or.b    d0, (a5,a0.w)
    moveq   #$1,d0
    lsl.b   d3, d0
    movea.w d5, a0
    or.b    d0, (a5,a0.w)
.l0d030:
    moveq   #$0,d0
    move.w  $8(a2), d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    andi.l  #$ffff, d1
    jsr SignedDiv
    move.w  d0, $10(a2)
    moveq   #$0,d0
    move.w  $8(a2), d0
    moveq   #$0,d1
    move.w  $4(a2), d1
    jsr Multiply32
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  #$2710, d1
    jsr SignedDiv
    move.w  d0, $e(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$8(a6)
    move.b  $3(a2), d0
    add.b   d0, $1(a3)
    movea.l -$8(a6), a0
    move.b  $3(a2), d0
    add.b   d0, $1(a0)
    move.b  $2(a2), d3
    andi.w  #$f, d3
    moveq   #$0,d5
    move.b  $2(a2), d5
    asr.l   #$4, d5
    andi.w  #$f, d5
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    sub.b   d3, $1(a3)
    move.l  a2, -(a7)
    jsr CalcCompatScore
    lea     $c(a7), a7
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$14,d1
    jsr SignedDiv
    move.b  d0, $b(a2)
.l0d110:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d4
    cmpi.w  #$28, d4
    blt.w   .l0cf4c
    moveq   #$24,d0
    adda.l  d0, a4
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.w   .l0cefa
    movea.l  #$00FFBA80,a3
    movea.l  #$00FF8824,a4
    movea.l  #$00FF1298,a2
    clr.w   d3
.l0d140:
    clr.w   d2
.l0d142:
    move.b  (a3), d0
    add.b   d0, $1(a4)
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0d142
    addq.l  #$4, a2
    addq.l  #$2, a4
    addq.w  #$1, d3
    cmpi.w  #$59, d3
    blt.b   .l0d140
    movea.l  #$00FF0018,a4
    clr.w   d2
.l0d166:
    move.w  d2, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    bra.b   .l0d1e8
.l0d18e:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  $8(a2), d0
    bge.b   .l0d1b2
    moveq   #$7F,d1
    add.l   d1, d0
.l0d1b2:
    asr.l   #$7, d0
    add.l   d0, (a3)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$8, a7
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  $8(a2), d0
    bge.b   .l0d1de
    moveq   #$7F,d1
    add.l   d1, d0
.l0d1de:
    asr.l   #$7, d0
    add.l   d0, (a3)
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d4
.l0d1e8:
    move.w  d4, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $4(a4), d1
    cmp.l   d1, d0
    blt.b   .l0d18e
    moveq   #$24,d0
    adda.l  d0, a4
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.w   .l0d166
    movem.l -$28(a6), d2-d5/a2-a5
    unlk    a6
    rts
