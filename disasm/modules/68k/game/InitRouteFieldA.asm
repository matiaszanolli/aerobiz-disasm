; ============================================================================
; InitRouteFieldA -- Tick down countdown timers on active $FF09C2 route field A records and trigger ProcessEventState when a timer expires.
; 62 bytes | $021408-$021445
; ============================================================================
InitRouteFieldA:
    movem.l d2/a2, -(a7)
    movea.l  #$00FF09C2,a2
    clr.w   d2
l_21414:
    cmpi.b  #$ff, (a2)
    beq.b   l_21436
    tst.b   $3(a2)
    beq.b   l_21424
    subq.b  #$1, $3(a2)
l_21424:
    tst.b   $3(a2)
    bne.b   l_21436
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr (ProcessEventState,PC)
    nop
    addq.l  #$4, a7
l_21436:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   l_21414
    movem.l (a7)+, d2/a2
    rts
