; ============================================================================
; VInt_Handler2 -- V-INT sub-handler: fill VRAM rows with repeated tile word over multiple passes
; 116 bytes | $001390-$001403
; ============================================================================
VInt_Handler2:
    movea.l  #$00C00000,a3
    movea.l  #$00C00004,a4
    moveq   #$0,d2
    move.l  d2, d3
    moveq   #$3,d7
    move.b  $4c(a5), d2
    move.b  $4d(a5), d3
    move.w  $52(a5), d4
    move.l  $4e(a5), d0
    move.l  #$400000, d5
    move.b  $10(a5), d6
    andi.b  #$3, d6
    beq.b   l_013d4
    cmpi.b  #$1, d6
    bne.b   l_013cc
    lsl.l   #$1, d5
    bra.b   l_013d4
l_013cc:
    cmpi.b  #$3, d6
    bne.b   l_013d4
    lsl.l   #$2, d5
l_013d4:
    subq.w  #$1, d2
    move.w  #$8f02, (a4)
    move.l  d0, (a4)
l_013dc:
    move.w  d4, (a3)
    dbra    d2, $13DC
    add.l   d5, d0
    move.l  d0, $4e(a5)
    moveq   #$0,d2
    move.b  $4c(a5), d2
    subq.w  #$1, d3
    beq.b   l_013fc
    dbra    d7, $13D4
    move.b  d3, $4d(a5)
    bne.b   l_01402
l_013fc:
    move.b  #$0, $2b(a5)
l_01402:
    rts
