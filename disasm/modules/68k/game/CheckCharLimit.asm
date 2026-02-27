; ============================================================================
; CheckCharLimit -- Shows a "character limit reached" info dialog via ShowCharInfoPageS2 and if confirmed shows a second confirmation dialog; returns the dialog result
; 70 bytes | $02F1D2-$02F217
; ============================================================================
CheckCharLimit:
    move.l  d2, -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($000484DA).l, -(a7)
    pea     ($000B).w
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    tst.w   d2
    bne.b   .l2f212
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000484DE).l, -(a7)
    pea     ($000B).w
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7
.l2f212:
    move.w  d2, d0
    move.l  (a7)+, d2
    rts
