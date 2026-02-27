; ============================================================================
; HandleEventConsequence -- Clears per-player event-consequence flags, then scans all route slots looking for completed type-3 slots; for each found sets the corresponding bit in the player's route-result byte.
; 120 bytes | $029402-$029479
; ============================================================================
HandleEventConsequence:
    movem.l d2-d4/a2, -(a7)
    clr.w   d2
l_29408:
    pea     ($0004).w
    clr.l   -(a7)
    movea.l  #$00FF099C,a0
    pea     (a0, d2.w)
    jsr MemFillByte
    lea     $c(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_29408
    movea.l  #$00FF0338,a2
    clr.w   d2
l_29432:
    clr.w   d3
l_29434:
    cmpi.b  #$3, $1(a2)
    bne.b   l_29462
    cmpi.b  #$1, $3(a2)
    bhi.b   l_29462
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d4
    moveq   #$1,d0
    lsl.b   d4, d0
    movea.l  #$00FF099C,a0
    or.b    d0, (a0,d2.w)
l_29462:
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_29434
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_29432
    movem.l (a7)+, d2-d4/a2
    rts
