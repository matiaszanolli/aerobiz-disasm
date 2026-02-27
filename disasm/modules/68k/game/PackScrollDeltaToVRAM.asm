; ============================================================================
; PackScrollDeltaToVRAM -- Packs scroll/display state into a VRAM buffer: fills a working area at $FF1804+$5000, optionally writes a signed scroll-delta word at the computed column offset for each of N rows, then DMA-transfers the packed buffer to VRAM address $FC00 via GameCommand.
; 164 bytes | $01D990-$01DA33
; ============================================================================
PackScrollDeltaToVRAM:
    move.l  $28(a7), d2
    move.l  $2c(a7), d3
    move.l  $24(a7), d4
    move.l  $20(a7), d5
    movea.l  #$00000D64,a3
    movea.l  #$00FF1804,a4
    pea     ($0800).w
    clr.l   -(a7)
    move.l  a4, d0
    addi.l  #$5000, d0
    move.l  d0, -(a7)
    bsr.w MemFillByte
    lea     $c(a7), a7
    tst.w   d3
    bne.b   l_1d9d6
    move.l  #$8b00, -(a7)
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    bra.b   l_1da0a
l_1d9d6:
    move.l  #$8b02, -(a7)
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$5, d0
    lea     (a4,d0.l), a0
    lea     $5000(a0), a0
    movea.l a0, a2
    cmpi.w  #$1, d5
    bne.b   l_1d9fa
    addq.l  #$2, a2
l_1d9fa:
    neg.w   d3
    bra.b   l_1da06
l_1d9fe:
    move.w  d3, (a2)
    subq.w  #$1, d2
    moveq   #$20,d0
    adda.l  d0, a2
l_1da06:
    tst.w   d2
    bgt.b   l_1d9fe
l_1da0a:
    clr.l   -(a7)
    move.l  #$fc00, -(a7)
    move.l  a4, d0
    addi.l  #$5000, d0
    move.l  d0, -(a7)
    pea     ($0200).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    lea     $18(a7), a7
    movem.l (a7)+, d2-d5/a2-a4
    rts
