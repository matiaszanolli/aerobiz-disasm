; ============================================================================
; ToggleDisplayMode -- Flips bit 0 of display-mode flag $FF000A, redraws a text window, and prints the new mode label from a pointer table
; 60 bytes | $01781C-$017857
; ============================================================================
ToggleDisplayMode:
    moveq   #$1,d0
    eor.w   d0, ($00FF000A).l
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0006).w
    pea     ($0014).w
    jsr SetTextWindow
    move.w  ($00FF000A).l, d0
    lsl.w   #$2, d0
    movea.l  #$00047A78,a0
    move.l  (a0,d0.w), -(a7)
    jsr PrintfWide
    lea     $14(a7), a7
    rts
