; ============================================================================
; WriteColorBitsVRAM -- Bit-pack D2 bits from source word into 16-bit accumulator for VDP tile output
; 122 bytes | $004240-$0042B9
; ============================================================================
WriteColorBitsVRAM:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d2
    movea.l  #$00FFBD50,a3
    movea.l  #$00FF88DA,a4
    movea.l  #$00FF88D8,a5
    move.w  (a4), d0
    lsl.w   d2, d0
    move.w  d0, (a4)
    cmp.w   (a3), d2
    bls.b   l_04296
    sub.w   (a3), d2
    move.w  (a3), d0
    add.w   d0, d0
    movea.l  #$0004686E,a2
    move.w  (a2,d0.w), d3
    and.w   (a5), d3
    andi.l  #$ffff, d3
    move.w  d3, d0
    lsl.w   d2, d0
    or.w    d0, (a4)
    move.b  $1(a1), d0
    lsl.w   #$8, d0
    move.b  (a1), d0
    move.w  d0, (a5)
    addq.l  #$2, a1
    moveq   #$10,d0
    sub.w   d2, d0
    move.w  d0, (a3)
    bra.b   l_04298
l_04296:
    sub.w   d2, (a3)
l_04298:
    moveq   #$0,d0
    move.w  (a3), d0
    moveq   #$0,d1
    move.w  (a5), d1
    asr.l   d0, d1
    move.l  d1, d0
    move.w  d2, d1
    add.w   d1, d1
    movea.l  #$0004686E,a2
    and.w   (a2,d1.w), d0
    or.w    d0, (a4)
    movem.l (a7)+, d2-d3/a2-a5
    rts
