; ============================================================================
; FindNextOpenSkillSlot -- Returns next open skill slot index (forward or reverse) from the player skill table
; 96 bytes | $03617A-$0361D9
; ============================================================================
FindNextOpenSkillSlot:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
    move.l  $10(a7), d3
    move.w  #$ff, d1
    tst.w   d3
    bne.b   l_3619a
    move.w  d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    bra.b   l_361a4
l_3619a:
    move.w  d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0350,a0
l_361a4:
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_361ac:
    tst.b   $1(a1)
    bne.b   l_361c0
    tst.w   d3
    bne.b   l_361ba
    move.w  d2, d1
    bra.b   l_361d2
l_361ba:
    moveq   #$3,d1
    sub.w   d2, d1
    bra.b   l_361d2
l_361c0:
    tst.w   d3
    bne.b   l_361c8
    addq.l  #$8, a1
    bra.b   l_361ca
l_361c8:
    subq.l  #$8, a1
l_361ca:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_361ac
l_361d2:
    move.w  d1, d0
    movem.l (a7)+, d2-d3
    rts
