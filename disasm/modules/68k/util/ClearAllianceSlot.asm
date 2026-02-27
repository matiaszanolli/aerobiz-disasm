; ============================================================================
; ClearAllianceSlot -- Resets alliance display slot to default ordering, updates VDP tile display
; 116 bytes | $030C90-$030D03
; ============================================================================
ClearAllianceSlot:
    link    a6,#-$10
    movem.l d2-d5/a2, -(a7)
    move.l  $c(a6), d4
    move.l  $8(a6), d5
    lea     -$10(a6), a2
    moveq   #$0,d3
    move.b  ($00FF0016).l, d3
    pea     ($0010).w
    move.l  a2, -(a7)
    pea     ($00076ACE).l
    jsr MemMove
    clr.w   d2
.l30cc0:
    cmp.w   d2, d5
    beq.b   .l30cc8
    cmp.w   d2, d4
    bne.b   .l30ce2
.l30cc8:
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  d0, (a2,a0.l)
.l30ce2:
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   .l30cc0
    pea     ($0008).w
    pea     ($0038).w
    move.l  a2, -(a7)
    jsr DisplaySetup
    movem.l -$24(a6), d2-d5/a2
    unlk    a6
    rts
