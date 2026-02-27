; ============================================================================
; HasPriorityAlliance -- Returns 1 if any active player has a priority-2 alliance entry with a char matching the given range index
; 94 bytes | $03259A-$0325F7
; ============================================================================
HasPriorityAlliance:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d3
    clr.w   d4
    movea.l  #$00FF0018,a2
    clr.w   d2
l_325ac:
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d3, d0
    movea.l  #$00FF0270,a0
    cmpi.b  #$2, (a0,d0.w)
    bne.b   l_325e4
    cmpi.b  #$1, (a2)
    bne.b   l_325e4
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_325e4
    moveq   #$1,d4
    bra.b   l_325f0
l_325e4:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_325ac
l_325f0:
    move.w  d4, d0
    movem.l (a7)+, d2-d4/a2
    rts
