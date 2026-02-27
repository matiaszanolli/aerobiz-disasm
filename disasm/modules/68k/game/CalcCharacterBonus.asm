; ============================================================================
; CalcCharacterBonus -- Displays the character bonus detail screen; reads char type and nibble fields, decompresses portrait, places tiles, and prints char name, type string, and bonus values.
; 312 bytes | $014972-$014AA9
; ============================================================================
CalcCharacterBonus:
    movem.l d2-d3/a2-a4, -(a7)
    movea.l $18(a7), a2
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    move.l  a2, -(a7)
    jsr GetByteField4
    move.w  d0, d3
    move.l  a2, -(a7)
    jsr GetLowNibble
    move.w  d0, d2
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00076A1E).l
    jsr DisplaySetup
    move.l  ($000A1B00).l, -(a7)
    pea     ($00FF899C).l
    jsr LZ_Decompress
    lea     $28(a7), a7
    pea     ($0080).w
    pea     ($006A).w
    pea     ($00FF899C).l
    jsr CmdPlaceTile
    pea     ($0007184C).l
    pea     ($0004).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $28(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0003).w
    pea     ($0009).w
    jsr     (a4)
    movea.l  #$00FF1278,a0
    move.b  (a0,d3.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003F7B0).l
    jsr     (a3)
    pea     ($0003).w
    pea     ($0011).w
    jsr     (a4)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F7AC).l
    jsr     (a3)
    lea     $30(a7), a7
    pea     ($0003).w
    pea     ($0015).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.l  d0, -(a7)
    pea     ($0003F7A8).l
    jsr     (a3)
    pea     ($0003).w
    pea     ($001A).w
    jsr     (a4)
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    pea     ($0003F7A4).l
    jsr     (a3)
    lea     $20(a7), a7
    movem.l (a7)+, d2-d3/a2-a4
    rts
