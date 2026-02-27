; ============================================================================
; CompareCharCode -- Render char-code display tiles in reverse order (6 to 0) from $0005FA6E for a wipe-out animation of the char code display.
; 60 bytes | $023E04-$023E3F
; ============================================================================
CompareCharCode:
    move.l  d2, -(a7)
    moveq   #$6,d2
l_23e08:
    pea     ($0004).w
    pea     ($0015).w
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$0005FA6E,a0
    pea     (a0, d0.w)
    jsr DisplaySetup
    pea     ($0002).w
    pea     ($000E).w
    jsr GameCommand
    lea     $14(a7), a7
    subq.w  #$1, d2
    tst.w   d2
    bge.b   l_23e08
    move.l  (a7)+, d2
    rts
