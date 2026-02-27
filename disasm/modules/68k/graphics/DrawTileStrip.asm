; ============================================================================
; DrawTileStrip -- Build a null-terminated strip of fill tiles (with half-tile overhang) and place it
; Called: ?? times.
; 154 bytes | $005C64-$005CFD
; ============================================================================
DrawTileStrip:                                                  ; $005C64
    link    a6,#-$2c
    movem.l d2-d6/a2,-(sp)
    move.l  $0010(a6),d4
    move.l  $000c(a6),d5
    move.l  $0008(a6),d6
    lea     -$002a(a6),a2
    move.w  d4,d0
    ext.l   d0
    bge.b   .l5c84
    addq.l  #$1,d0
.l5c84:                                                 ; $005C84
    asr.l   #$1,d0
    move.l  d0,d3
    moveq   #$0,d2
    bra.b   .l5c9a
.l5c8c:                                                 ; $005C8C
    move.l  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$852f,(a2,a0.l)
    addq.l  #$1,d2
.l5c9a:                                                 ; $005C9A
    cmp.l   d3,d2
    blt.b   .l5c8c
    move.w  d4,d0
    ext.l   d0
    moveq   #$2,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    tst.l   d0
    beq.b   .l5cba
    move.l  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$8530,(a2,a0.l)
.l5cba:                                                 ; $005CBA
    move.l  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    clr.w   (a2,a0.l)
    tst.l   d3
    ble.b   .l5cd2
    move.l  a2,-(sp)
    pea     ($0001).w
    move.l  d3,-(sp)
    bra.b   .l5cdc
.l5cd2:                                                 ; $005CD2
    move.l  a2,-(sp)
    pea     ($0001).w
    pea     ($0001).w
.l5cdc:                                                 ; $005CDC
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    movem.l -$0044(a6),d2-d6/a2
    unlk    a6
    rts
