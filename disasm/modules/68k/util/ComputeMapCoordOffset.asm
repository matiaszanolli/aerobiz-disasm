; ============================================================================
; ComputeMapCoordOffset -- Compute VRAM word offset for a tile map coordinate from scroll params and plane width
; 96 bytes | $000816-$000875
; ============================================================================
ComputeMapCoordOffset:
    move.l  $e(a6), d0
    andi.b  #$3, d0
    beq.b   l_00832
    cmpi.b  #$1, d0
    beq.b   l_0082c
    move.w  $3c(a5), d0
    bra.b   l_00836
l_0082c:
    move.w  $3a(a5), d0
    bra.b   l_00836
l_00832:
    move.w  $38(a5), d0
l_00836:
    move.l  $12(a6), d2
    andi.w  #$ff, d2
    lsl.l   #$1, d2
    add.w   d2, d0
    moveq   #$40,d1
    move.b  $10(a5), d6
    andi.l  #$3, d6
    beq.b   l_00862
    cmpi.b  #$1, d6
    beq.b   l_00860
    cmpi.b  #$3, d6
    beq.b   l_0085e
l_0085c:
    bra.b   l_0085c
l_0085e:
    lsl.l   #$1, d1
l_00860:
    lsl.l   #$1, d1
l_00862:
    move.l  $16(a6), d3
    andi.w  #$ff, d3
    muls.w  d3, d1
    add.w   d1, d0
    andi.l  #$ffff, d0
    rts
