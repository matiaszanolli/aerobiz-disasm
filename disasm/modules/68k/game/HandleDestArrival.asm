; ============================================================================
; HandleDestArrival -- Decompress and place destination arrival tile graphic at specified screen position with palette attribute
; 162 bytes | $00EA86-$00EB27
; ============================================================================
HandleDestArrival:
    link    a6,#-$3C
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a6), d3
    pea     ($0010).w
    pea     ($0030).w
    pea     ($000767DE).l
    jsr DisplaySetup
    move.w  $a(a6), d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0009C840,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($001E).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $20(a7), a7
    lea     -$3c(a6), a2
    clr.w   d2
l_0eae4:
    move.w  d3, d0
    add.w   d2, d0
    ori.w   #$6000, d0
    move.w  d0, (a2)+
    addq.w  #$1, d2
    cmpi.w  #$1e, d2
    blt.b   l_0eae4
    pea     -$3c(a6)
    pea     ($0005).w
    pea     ($0006).w
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    movem.l -$48(a6), d2-d3/a2
    unlk    a6
    rts
