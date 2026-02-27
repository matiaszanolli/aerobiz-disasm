; ============================================================================
; LoadRouteMapDisplay -- Renders the route map display panel for a player, placing decompressed tile graphics and route name text at computed screen positions for each route entry.
; 286 bytes | $0257FA-$025917
; ============================================================================
LoadRouteMapDisplay:
    link    a6,#-$3C
    movem.l d2-d7/a2-a4, -(a7)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($000767DE).l
    jsr DisplaySetup
    lea     $c(a7), a7
    move.w  #$640, d4
    moveq   #$3,d5
    moveq   #$3,d7
    clr.w   d6
    move.w  $12(a6), d0
    add.w   d0, d0
    movea.l  #$0005F908,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d3
    move.b  (a4), d3
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    add.l   $14(a6), d0
    movea.l d0, a3
    bra.w   .l258fc
.l2584a:
    cmpi.w  #$1, $1a(a6)
    bne.b   .l258c4
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0009C840,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($001E).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     -$3c(a6), a2
    clr.w   d2
.l2588a:
    move.w  d4, d0
    add.w   d2, d0
    ori.w   #$4000, d0
    move.w  d0, (a2)+
    addq.w  #$1, d2
    cmpi.w  #$1e, d2
    blt.b   .l2588a
    pea     -$3c(a6)
    pea     ($0005).w
    pea     ($0006).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
.l258c4:
    move.w  d7, d0
    ext.l   d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000413E6).l
    jsr PrintfNarrow
    lea     $10(a7), a7
    add.w   (a3), d6
    addi.w  #$1e, d4
    addq.w  #$7, d5
    addq.l  #$2, a3
    addq.w  #$1, d3
.l258fc:
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    cmp.l   d1, d0
    ble.w   .l2584a
    move.w  d6, d0
    movem.l -$60(a6), d2-d7/a2-a4
    unlk    a6
    rts
