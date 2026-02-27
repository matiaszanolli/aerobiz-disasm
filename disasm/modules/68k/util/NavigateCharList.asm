; ============================================================================
; NavigateCharList -- Toggles the view-mode or page flag depending on parameter, redraws the mode label, and calls SetDisplayMode or SetDisplayPage accordingly
; 174 bytes | $017858-$017905
; ============================================================================
NavigateCharList:
    movem.l d2/a2-a3, -(a7)
    move.l  $10(a7), d2
    movea.l  #$00FF000C,a2
    movea.l  #$00FF000E,a3
    cmpi.w  #$1, d2
    bne.b   l_178c4
    moveq   #$1,d0
    eor.w   d0, (a2)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0004).w
    pea     ($0014).w
    jsr SetTextWindow
    move.w  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047A78,a0
    move.l  (a0,d0.w), -(a7)
    jsr PrintfWide
    move.w  (a2), d0
    move.l  d0, -(a7)
    jsr SetDisplayMode
    pea     ($0001).w
    move.w  ($00FF9A1C).l, d0
    addq.w  #$2, d0
    move.l  d0, -(a7)
    jsr MenuSelectEntry
    lea     $20(a7), a7
    bra.b   l_17900
l_178c4:
    moveq   #$1,d0
    eor.w   d0, (a3)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0006).w
    pea     ($0014).w
    jsr SetTextWindow
    move.w  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$00047A78,a0
    move.l  (a0,d0.w), -(a7)
    jsr PrintfWide
    move.w  (a3), d0
    move.l  d0, -(a7)
    jsr SetDisplayPage
    lea     $18(a7), a7
l_17900:
    movem.l (a7)+, d2/a2-a3
    rts
