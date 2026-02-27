; ============================================================================
; UpdateGameStateCounters -- Age time-limited game state counter records at $FF0338, decrementing each type-6 counter and clearing the record when it reaches zero.
; 70 bytes | $020A1E-$020A63
; ============================================================================
UpdateGameStateCounters:
    movea.l  #$00FF0338,a0
    clr.w   d0
l_20a26:
    clr.w   d1
l_20a28:
    cmpi.b  #$6, $1(a0)
    bne.b   l_20a50
    subq.b  #$1, $3(a0)
    tst.b   $3(a0)
    bne.b   l_20a50
    clr.b   (a0)
    clr.b   $1(a0)
    clr.b   $2(a0)
    clr.b   $3(a0)
    clr.w   $4(a0)
    clr.w   $6(a0)
l_20a50:
    addq.l  #$8, a0
    addq.w  #$1, d1
    cmpi.w  #$4, d1
    bcs.b   l_20a28
    addq.w  #$1, d0
    cmpi.w  #$4, d0
    bcs.b   l_20a26
    rts
