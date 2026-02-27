; ============================================================================
; LookupCharCode -- Render a sequence of 7 char-code display tiles from $0005FA6E by calling DisplaySetup and GameCommand $E per entry (char code build-up animation).
; 62 bytes | $023DC6-$023E03
; ============================================================================
LookupCharCode:
    move.l  d2, -(a7)
    clr.w   d2
l_23dca:
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
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   l_23dca
    move.l  (a7)+, d2
    rts
