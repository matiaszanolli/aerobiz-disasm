; ============================================================================
; ProcessGameUpdateS2 -- Sets up and renders the per-player game update display: decompresses the map background into VRAM, renders the player bar and score area, calls ShowPlayerChart, then displays four stat sub-panels via the sub-function at $10CAC
; 252 bytes | $02FC14-$02FD0F
; ============================================================================
ProcessGameUpdateS2:
    movem.l d2/a2, -(a7)
    move.l  $c(a7), d2
    movea.l  #$00010CAC,a2
    jsr PreLoopInit
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076AFE).l
    jsr DisplaySetup
    move.l  ($000A1B5C).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($00C2).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $20(a7), a7
    pea     ($00072E5C).l
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($077D).w
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr ShowPlayerChart
    pea     ($0006).w
    pea     ($0004).w
    clr.l   -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a2)
    pea     ($000C).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a2)
    pea     ($000C).w
    pea     ($0019).w
    pea     ($0003).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a2)
    lea     $30(a7), a7
    movem.l (a7)+, d2/a2
    rts
