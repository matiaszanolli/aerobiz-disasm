; ============================================================================
; RankCharCandidatesFull -- Full interactive character selection UI; displays sorted compatible-char list with portrait and detail panels, handles Up/Down navigation, and returns the selected char index.
; 666 bytes | $014DA6-$01503F
; ============================================================================
RankCharCandidatesFull:
    link    a6,#-$54
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d4
    move.l  $c(a6), d5
    move.l  $8(a6), d6
    movea.l  #$00FF13FC,a4
    movea.l  #$00FFA7D8,a5
    clr.w   d7
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($077D).w
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.w  d6, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    clr.w   d3
    bra.b   .l14e5a
.l14e3a:
    cmp.b   (a2), d5
    beq.b   .l14e44
    cmp.b   $1(a2), d5
    bne.b   .l14e54
.l14e44:
    move.w  d3, d0
    add.w   d0, d0
    move.w  d2, -$50(a6, d0.w)
    cmp.w   d2, d4
    bne.b   .l14e52
    move.w  d3, d4
.l14e52:
    addq.w  #$1, d3
.l14e54:
    addq.w  #$1, d2
    moveq   #$14,d0
    adda.l  d0, a2
.l14e5a:
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bgt.b   .l14e3a
    tst.w   d3
    ble.w   .l15016
    move.w  d4, d0
    add.w   d0, d0
    move.w  -$50(a6, d0.w), d0
    mulu.w  #$14, d0
    move.w  d6, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr ClearTileArea
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0013).w
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr FormatRelationStats
    clr.w   -$54(a6)
    clr.l   -(a7)
    jsr ReadInput
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   .l14ed0
    moveq   #$1,d5
    bra.b   .l14ed2
.l14ed0:
    moveq   #$0,d5
.l14ed2:
    clr.w   -$52(a6)
    clr.w   (a4)
    clr.w   (a5)
    move.w  d4, d2
.l14edc:
    tst.w   d7
    beq.b   .l14f38
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$50(a6, d0.w), d0
    mulu.w  #$14, d0
    move.w  d6, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr ClearTileArea
    pea     ($0001).w
    move.w  -$54(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0013).w
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr FormatRelationStats
    pea     ($0020).w
    bsr.w WaitStableInput
    lea     $1c(a7), a7
    clr.w   -$54(a6)
    clr.w   d7
.l14f38:
    moveq   #$1,d4
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeMatch
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    tst.w   d5
    beq.b   .l14f7e
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l14f7e
    pea     ($0002).w
.l14f6e:
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   .l14edc
.l14f7e:
    clr.w   d5
    move.w  -$52(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, -$52(a6)
    cmpi.w  #$1, d4
    move.w  -$52(a6), d0
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l14fbe
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l14fcc
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   .l14fd2
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   .l14ff2
    bra.b   .l1500a
.l14fbe:
    clr.w   (a4)
    clr.w   (a5)
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$50(a6, d0.w), d0
    bra.b   .l15036
.l14fcc:
    clr.w   (a4)
    clr.w   (a5)
    bra.b   .l15032
.l14fd2:
    move.w  #$1, (a4)
    cmpi.w  #$1, d3
    ble.b   .l1500e
    addq.w  #$1, d2
    move.w  d2, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l14fee
    clr.w   d2
.l14fee:
    moveq   #$1,d7
    bra.b   .l1500e
.l14ff2:
    move.w  #$1, (a4)
    cmpi.w  #$1, d3
    ble.b   .l1500e
    subq.w  #$1, d2
    tst.w   d2
    bge.b   .l14fee
    move.w  d3, d2
    addi.w  #$ffff, d2
    bra.b   .l14fee
.l1500a:
    clr.w   (a4)
    clr.w   (a5)
.l1500e:
    pea     ($0004).w
    bra.w   .l14f6e
.l15016:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0003F7FC).l
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
.l15032:
    move.w  #$ff, d0
.l15036:
    movem.l -$7c(a6), d2-d7/a2-a5
    unlk    a6
    rts
