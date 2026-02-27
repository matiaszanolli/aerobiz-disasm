; ============================================================================
; GetPlayerModelSelect -- Determine AI opponent hub city for single-player games based on player count and existing selection
; 250 bytes | $00B2FA-$00B3F3
; ============================================================================
GetPlayerModelSelect:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d3
    movea.l  #$00FF0002,a2
    move.w  #$ff, d2
    jsr CountActivePlayers
    move.w  d0, d4
    cmpi.w  #$1, d4
    bne.w   .l0b3b0
    cmpi.w  #$1, d3
    bne.w   .l0b3b0
    moveq   #$0,d3
    move.b  ($00FF0019).l, d3
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d4
    tst.w   d4
    bne.b   .l0b348
    tst.w   d3
    beq.b   .l0b3b0
    clr.w   d2
    bra.b   .l0b3b0
.l0b348:
    cmpi.w  #$3, d4
    bne.b   .l0b358
    cmpi.w  #$c, d3
    beq.b   .l0b3b0
    moveq   #$C,d2
    bra.b   .l0b3b0
.l0b358:
    cmpi.w  #$4, d4
    bne.b   .l0b368
    cmpi.w  #$13, d3
    beq.b   .l0b3b0
    moveq   #$13,d2
    bra.b   .l0b3b0
.l0b368:
    cmpi.w  #$5, d4
    bne.b   .l0b3a2
    cmpi.w  #$17, d3
    beq.b   .l0b3b0
    cmpi.w  #$19, d3
    beq.b   .l0b3b0
    tst.w   (a2)
    bne.b   .l0b382
.l0b37e:
    moveq   #$17,d2
    bra.b   .l0b3b0
.l0b382:
    pea     ($0064).w
    pea     ($0001).w
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$2,d1
    jsr SignedMod
    tst.l   d0
    beq.b   .l0b37e
    moveq   #$19,d2
    bra.b   .l0b3b0
.l0b3a2:
    cmpi.w  #$6, d4
    bne.b   .l0b3b0
    cmpi.w  #$1d, d3
    beq.b   .l0b3b0
    moveq   #$1D,d2
.l0b3b0:
    cmpi.w  #$ff, d2
    bne.b   .l0b3ec
    clr.w   d2
    moveq   #$8,d3
    cmpi.w  #$2, (a2)
    bge.b   .l0b3c4
    moveq   #$7,d3
    bra.b   .l0b3cc
.l0b3c4:
    cmpi.w  #$3, (a2)
    bne.b   .l0b3cc
    moveq   #$1,d2
.l0b3cc:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr RandRange
    addq.l  #$8, a7
    add.w   d0, d0
    movea.l  #$0005FD24,a0
    move.w  (a0,d0.w), d2
.l0b3ec:
    move.w  d2, d0
    movem.l (a7)+, d2-d4/a2
    rts
