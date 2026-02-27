; ============================================================================
; CountAllianceMembers -- Counts how many alliance slots for a player index are marked as active (status byte = 1)
; 80 bytes | $032662-$0326B1
; ============================================================================
CountAllianceMembers:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d4
    clr.w   d3
    move.w  d4, d0
    lsl.w   #$3, d0
    movea.l  #$00FF0270,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_3267e:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_326a0
    cmpi.b  #$1, (a2)
    bne.b   l_326a0
    addq.w  #$1, d3
l_326a0:
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.b   l_3267e
    move.w  d3, d0
    movem.l (a7)+, d2-d4/a2
    rts
