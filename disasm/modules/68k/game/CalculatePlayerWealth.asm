; ============================================================================
; CalculatePlayerWealth -- Accumulates net-asset totals across all four players (cash + loans + route-revenue forecast), zeroing the buffers at quarter boundaries, then calls CalcPlayerWealth for each player.
; 200 bytes | $0261A8-$02626F
; ============================================================================
CalculatePlayerWealth:
    link    a6,#-$4
    movem.l d2-d3/a2-a5, -(a7)
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   .l261ee
    pea     ($0030).w
    clr.l   -(a7)
    pea     ($00FF00E8).l
    jsr MemFillByte
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF0130).l
    jsr MemFillByte
    lea     $18(a7), a7
.l261ee:
    move.l  #$ff0018, -$4(a6)
    movea.l  #$00FF00E8,a4
    movea.l  #$00FF09A2,a5
    movea.l  #$00FF01B0,a3
    movea.l  #$00FF0130,a2
    clr.w   d3
.l26210:
    movea.l -$4(a6), a0
    move.l  $12(a0), d0
    add.l   d0, $8(a4)
    movea.l -$4(a6), a0
    move.l  $a(a0), d2
    add.l   (a5), d2
    add.l   d2, (a4)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcPlayerWealth,PC)
    nop
    addq.l  #$4, a7
    add.l   $4(a5), d0
    move.l  d0, d2
    add.l   d2, $4(a4)
    clr.w   d2
.l26242:
    move.l  (a3), d0
    add.l   d0, (a2)
    addq.l  #$4, a3
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    bcs.b   .l26242
    moveq   #$24,d0
    add.l   d0, -$4(a6)
    moveq   #$C,d0
    adda.l  d0, a4
    addq.l  #$8, a5
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l26210
    movem.l -$1c(a6), d2-d3/a2-a5
    unlk    a6
    rts
