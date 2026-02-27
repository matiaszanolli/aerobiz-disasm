; ============================================================================
; FadePalette -- Clamp each RGB channel of palette entries toward a target level and write to output
; Called: ?? times.
; 240 bytes | $004BC6-$004CB5
; ============================================================================
FadePalette:                                                  ; $004BC6
    link    a6,#-$80
    movem.l d2-d7,-(sp)
    move.l  $0014(a6),d2
    move.l  $000c(a6),d7
    cmpi.w  #$7,d2
    bhi.w   .l4cac
    moveq   #$7,d0
    sub.w   d2,d0
    move.w  d0,d2
    move.w  d7,d6
    movea.l $0008(a6),a1
    bra.w   .l4c80
.l4bee:                                                 ; $004BEE
    move.w  (a1),d5
    andi.l  #$0e00,d5
    moveq   #$9,d0
    asr.l   d0,d5
    move.w  (a1),d4
    andi.l  #$e0,d4
    asr.l   #$5,d4
    move.w  (a1),d3
    andi.l  #$e,d3
    asr.l   #$1,d3
    moveq   #$0,d0
    move.w  d5,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    ble.b   .l4c26
    moveq   #$0,d0
    move.w  d5,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    bra.b   .l4c28
.l4c26:                                                 ; $004C26
    moveq   #$0,d0
.l4c28:                                                 ; $004C28
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    ble.b   .l4c42
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    bra.b   .l4c44
.l4c42:                                                 ; $004C42
    moveq   #$0,d0
.l4c44:                                                 ; $004C44
    move.w  d0,d4
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    ble.b   .l4c5e
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    bra.b   .l4c60
.l4c5e:                                                 ; $004C5E
    moveq   #$0,d0
.l4c60:                                                 ; $004C60
    move.w  d0,d3
    move.w  d5,d0
    moveq   #$9,d1
    lsl.w   d1,d0
    move.w  d4,d1
    lsl.w   #$5,d1
    add.w   d1,d0
    move.w  d3,d1
    add.w   d1,d1
    add.w   d1,d0
    move.w  d6,d1
    add.w   d1,d1
    move.w  d0,-$80(a6,d1.w)
    addq.w  #$1,d6
    addq.l  #$2,a1
.l4c80:                                                 ; $004C80
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.w  $0012(a6),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d6,d1
    cmp.l   d1,d0
    bgt.w   .l4bee
    move.w  $0012(a6),d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    add.w   d0,d0
    pea     -$80(a6,d0.w)
    bsr.w WriteCharUIDisplay
.l4cac:                                                 ; $004CAC
    movem.l -$0098(a6),d2-d7
    unlk    a6
    rts
