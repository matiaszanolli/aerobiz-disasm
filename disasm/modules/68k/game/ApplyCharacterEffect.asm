; ============================================================================
; ApplyCharacterEffect -- Interactive UI for applying a char effect to a target slot; shows match slots, runs Up/Down/A/B input loop for target selection, calls BrowsePartners on B, returns selected slot index.
; 698 bytes | $014AAA-$014D63
; ============================================================================
ApplyCharacterEffect:
    link    a6,#-$4
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d4
    movea.l $10(a6), a2
    movea.l  #$00FF13FC,a3
    movea.l  #$00005092,a4
    movea.l  #$00000D64,a5
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckMatchSlots
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l14b1a
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0014).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0003F7D8).l
    jsr PrintfNarrow
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $24(a7), a7
.l14b1a:
    move.w  #$88a, -$2(a6)
    move.w  #$448, -$4(a6)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    jsr     (a4)
    lea     $c(a7), a7
.l14b40:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   .l14b40
    clr.w   d3
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
.l14b5a:
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    jsr     (a4)
    lea     $c(a7), a7
.l14b74:
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0014).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    move.w  d0, d3
    andi.l  #$bc, d0
    beq.b   .l14b74
    move.w  d3, d0
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l14bb8
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l14be2
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.b   .l14bea
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l14c3a
    cmpi.w  #$80, d0
    beq.w   .l14c7c
    bra.w   .l14d4a
.l14bb8:
    clr.w   (a3)
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0014).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
.l14bdc:
    move.w  d2, d0
    bra.w   .l14d5a
.l14be2:
    clr.w   (a3)
    move.w  #$ff, d2
    bra.b   .l14bdc
.l14bea:
    move.w  #$1, (a3)
    cmpi.w  #$6, d2
    bge.b   .l14c26
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$4(a6)
    jsr     (a4)
    addq.w  #$1, d2
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    jsr     (a4)
    lea     $18(a7), a7
.l14c26:
    cmpi.w  #$6, d2
    bge.b   .l14c32
.l14c2c:
    move.w  d2, d0
    ext.l   d0
    bra.b   .l14c34
.l14c32:
    moveq   #$6,d0
.l14c34:
    move.w  d0, d2
    bra.w   .l14d4a
.l14c3a:
    move.w  #$1, (a3)
    tst.w   d2
    ble.b   .l14c74
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$4(a6)
    jsr     (a4)
    subq.w  #$1, d2
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    jsr     (a4)
    lea     $18(a7), a7
.l14c74:
    tst.w   d2
    bgt.b   .l14c2c
    moveq   #$0,d0
    bra.b   .l14c34
.l14c7c:
    clr.w   (a3)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowsePartners
    lea     $28(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckMatchSlots
    lea     $30(a7), a7
    tst.w   d0
    beq.b   .l14d3a
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0014).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0003F7B4).l
    jsr PrintfNarrow
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $24(a7), a7
.l14d3a:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   .l14d3a
.l14d4a:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   .l14b5a
.l14d5a:
    movem.l -$20(a6), d2-d4/a2-a5
    unlk    a6
    rts
