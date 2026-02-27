; ============================================================================
; RenderTextLineS1 -- Variant of DrawTileGrid that uses Multiply32 instead of a jsr-encoded call for the inner tile placement, drawing a row x col grid of tiles from a source buffer via GameCommand DMA (cmd 5).
; 106 bytes | $01D840-$01D8A9
; ============================================================================
RenderTextLineS1:
    move.l  $1c(a7), d3
    move.l  $20(a7), d5
    move.l  $24(a7), d6
    movea.l $28(a7), a2
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d0, d3
    clr.w   d4
    bra.b   l_1d8a0
l_1d85a:
    clr.w   d2
    bra.b   l_1d896
l_1d85e:
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$5, d0
    move.w  d2, d1
    ext.l   d1
    jsr Multiply32
    pea     (a2, d0.l)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0005).w
    jsr GameCommand
    lea     $18(a7), a7
    addi.w  #$20, d3
    addq.w  #$1, d2
l_1d896:
    cmp.w   d6, d2
    blt.b   l_1d85e
    moveq   #$20,d0
    adda.l  d0, a2
    addq.w  #$1, d4
l_1d8a0:
    cmp.w   d5, d4
    blt.b   l_1d85a
    movem.l (a7)+, d2-d6/a2
    rts
