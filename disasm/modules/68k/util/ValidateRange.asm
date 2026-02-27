; ============================================================================
; ValidateRange -- Sums the aircraft count fields (bytes at offsets +4 and +5) across all 4 player records at $FF0018, returning the total in D0.W; used to check whether any player has aircraft assigned.
; 50 bytes | $01E4BA-$01E4EB
; ============================================================================
ValidateRange:
    movem.l d2-d3, -(a7)
    clr.w   d3
    movea.l  #$00FF0018,a0
    clr.w   d2
l_1e4c8:
    moveq   #$0,d0
    move.b  $4(a0), d0
    moveq   #$0,d1
    move.b  $5(a0), d1
    add.w   d1, d0
    add.w   d0, d3
    moveq   #$24,d0
    adda.l  d0, a0
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1e4c8
    move.w  d3, d0
    movem.l (a7)+, d2-d3
    rts
