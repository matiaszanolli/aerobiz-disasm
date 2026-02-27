; ============================================================================
; PlaceIconTiles -- Place tile icons by game element type (switch on type 1-4)
; Called: 13 times.
; 166 bytes | $00595E-$005A03
; ============================================================================
PlaceIconTiles:                                                  ; $00595E
    link    a6,#-$4
    movem.l d2-d7,-(sp)
    move.l  $000c(a6),d6
    move.l  $0008(a6),d7
    move.w  #$8404,d3
    move.w  d7,d0
    ext.l   d0
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l598a
    moveq   #$2,d1
    cmp.w   d1,d0
    beq.b   .l5990
    moveq   #$3,d1
    cmp.w   d1,d0
    beq.b   .l5996
    bra.b   .l599a
.l598a:                                                 ; $00598A
    move.w  #$010f,d2
    bra.b   .l599a
.l5990:                                                 ; $005990
    move.w  #$0117,d2
    bra.b   .l599a
.l5996:                                                 ; $005996
    move.w  #$0113,d2
.l599a:                                                 ; $00599A
    move.w  d2,d5
    addq.w  #$2,d5
    move.w  d2,d4
    addq.w  #$3,d4
    cmpi.w  #$4,d7
    bne.b   .l59b0
    move.w  #$011b,d5
    move.w  #$011c,d4
.l59b0:                                                 ; $0059B0
    cmpi.w  #$1,d6
    bne.b   .l59c0
    move.w  d2,d0
    add.w   d3,d0
    move.w  d0,-$0004(a6)
    bra.b   .l59d0
.l59c0:                                                 ; $0059C0
    move.w  d5,d0
    add.w   d3,d0
    move.w  d0,-$0004(a6)
    move.w  d4,d0
    add.w   d3,d0
    move.w  d0,-$0002(a6)
.l59d0:                                                 ; $0059D0
    pea     -$0004(a6)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  $0016(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    movem.l -$001c(a6),d2-d7
    unlk    a6
    rts
