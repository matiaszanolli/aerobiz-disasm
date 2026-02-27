; ============================================================================
; ManageCharStatsS2 -- Manages post-transfer stat application: computes affordable stat points from salary/budget, shows the upgrade count dialog, then runs a DrawCharPanelS2 loop where the player confirms stat allocation, deducts funds, and updates the character record
; 970 bytes | $02DAA0-$02DE69
; ============================================================================
ManageCharStatsS2:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d7
    movea.l  #$00000D64,a5
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  #$1, -$2(a6)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (FindCharSlotInGroup,PC)
    nop
    move.w  d0, -$86(a6)
    move.w  d4, d0
    mulu.w  #$14, d0
    move.w  -$86(a6), d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d7, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d7, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr CalcWeightedStat
    move.w  d0, d6
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   .l2db58
    moveq   #$0,d0
    move.w  d6, d0
    bge.b   .l2db54
    addq.l  #$1, d0
.l2db54:
    asr.l   #$1, d0
    move.w  d0, d6
.l2db58:
    move.l  $6(a4), d0
    moveq   #$0,d1
    move.w  d6, d1
    jsr SignedDiv
    move.w  d0, d3
    cmpi.w  #$a, d3
    bcc.b   .l2db74
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   .l2db76
.l2db74:
    moveq   #$A,d0
.l2db76:
    move.w  d0, d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    ble.b   .l2db92
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   .l2db9e
.l2db92:
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.l  d1, d0
.l2db9e:
    move.w  d0, d3
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$63,d1
    sub.l   d0, d1
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    ble.b   .l2dbc0
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   .l2dbd2
.l2dbc0:
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$63,d1
    sub.l   d0, d1
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.l   d0, d1
    move.l  d1, d0
.l2dbd2:
    move.w  d0, d3
    move.l  #$8000, -(a7)
    pea     ($0005).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    subq.l  #$1, d0
    beq.b   .l2dc04
    pea     ($000446AE).l
    bra.b   .l2dc0a
.l2dc04:
    pea     ($000446A8).l
.l2dc0a:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  ($0004848A).l, -(a7)
    pea     -$84(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$84(a6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)
    nop
    pea     ($0050).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (FinalizeTransfer,PC)
    nop
    clr.l   -(a7)
    jsr ReadInput
    lea     $30(a7), a7
    tst.w   d0
    beq.b   .l2dc5c
    moveq   #$1,d2
    bra.b   .l2dc5e
.l2dc5c:
    moveq   #$0,d2
.l2dc5e:
    tst.w   d2
    beq.b   .l2dc7e
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l2dc7e
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l2dc5e
.l2dc7e:
    clr.w   d2
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    moveq   #$0,d0
    move.w  -$86(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (DrawCharPanelS2,PC)
    nop
    lea     $18(a7), a7
    move.w  d0, -$4(a6)
    andi.w  #$20, d0
    beq.w   .l2ddce
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($000E).w
    pea     ($0016).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    moveq   #$0,d0
    move.w  d6, d0
    moveq   #$0,d1
    move.w  -$2(a6), d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  -$2(a6), d0
    subq.l  #$1, d0
    beq.b   .l2dcfc
    pea     ($000446A0).l
    bra.b   .l2dd02
.l2dcfc:
    pea     ($0004469A).l
.l2dd02:
    moveq   #$0,d0
    move.w  -$2(a6), d0
    move.l  d0, -(a7)
    move.l  ($0004848E).l, -(a7)
    pea     -$84(a6)
    jsr sprintf
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$84(a6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, -$4(a6)
    cmpi.w  #$1, -$4(a6)
    bne.b   .l2dd7c
    moveq   #$0,d0
    move.w  d6, d0
    moveq   #$0,d1
    move.w  -$2(a6), d1
    jsr Multiply32
    sub.l   d0, $6(a4)
    move.b  d7, (a2)
    move.b  -$1(a6), d0
    add.b   d0, $1(a2)
    move.b  #$1, $2(a2)
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048492).l, -(a7)
    bra.w   .l2de0a
.l2dd7c:
    tst.w   -$4(a6)
    bne.w   .l2dc5e
    moveq   #$0,d0
    move.w  d3, d0
    subq.l  #$1, d0
    beq.b   .l2dd94
    pea     ($00044692).l
    bra.b   .l2dd9a
.l2dd94:
    pea     ($0004468C).l
.l2dd9a:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  ($0004848A).l, -(a7)
    pea     -$84(a6)
    jsr sprintf
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$84(a6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $24(a7), a7
    bra.w   .l2dc5e
.l2ddce:
    move.w  -$4(a6), d0
    andi.w  #$10, d0
    beq.w   .l2dc5e
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($000E).w
    pea     ($0016).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048496).l, -(a7)
.l2de0a:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)
    nop
    move.l  #$8000, -(a7)
    pea     ($0007).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $30(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0007).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts
