; ============================================================================
; GetAllianceScore -- Formats a profit/loss score message for a character pair in an alliance slot, shows text to player
; 328 bytes | $030B48-$030C8F
; ============================================================================
GetAllianceScore:
    link    a6,#-$A0
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $8(a6), d3
    movea.l  #$0005E680,a3
    lea     -$a0(a6), a4
    movea.l  #$0001D6A4,a5
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    jsr LoadScreenPalette
    addq.l  #$8, a7
    moveq   #$0,d2
    move.w  $e(a2), d2
    moveq   #$0,d0
    move.w  $6(a2), d0
    sub.l   d0, d2
    tst.l   d2
    bge.b   .l30bf2
    neg.l   d2
    move.l  d2, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    move.l  ($00047B2C).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $14(a7), a7
    bra.b   .l30c6e
.l30bf2:
    tst.l   d2
    ble.b   .l30c2a
    move.l  d2, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    move.l  ($00047B30).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $14(a7), a7
    pea     ($0001).w
    bra.b   .l30c70
.l30c2a:
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.b   .l30c86
    move.b  $a(a2), d0
    andi.l  #$4, d0
    bne.b   .l30c86
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    move.l  ($00047B34).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
.l30c6e:
    clr.l   -(a7)
.l30c70:
    move.l  a4, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w ShowText
.l30c86:
    movem.l -$b8(a6), d2-d3/a2-a5
    unlk    a6
    rts
