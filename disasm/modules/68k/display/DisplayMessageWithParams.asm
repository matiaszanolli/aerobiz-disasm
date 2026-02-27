; ============================================================================
; DisplayMessageWithParams -- Draw a character info panel with formatted message, optionally calling SelectPreviewPage or PollAction
; 108 bytes | $00C61E-$00C689
; ============================================================================
DisplayMessageWithParams:
    link    a6,#$0
    move.l  d2, -(a7)
    move.l  $c(a6), -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0780).w
    pea     ($0035).w
    jsr DrawCharInfoPanel
    lea     $20(a7), a7
    cmpi.w  #$1, $16(a6)
    bne.b   .l0c66a
    pea     ($001A).w
    pea     ($0008).w
    jsr SelectPreviewPage
    addq.l  #$8, a7
    move.w  d0, d2
    bra.b   .l0c680
.l0c66a:
    cmpi.w  #$1, $1a(a6)
    bne.b   .l0c680
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
.l0c680:
    move.w  d2, d0
    move.l  -$4(a6), d2
    unlk    a6
    rts
