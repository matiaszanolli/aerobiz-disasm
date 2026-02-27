; ============================================================================
; InitializeRelationPanel -- Initialize and display the city-relation panel showing city names and relationship values between the current player's cities.
; 268 bytes | $021196-$0212A1
; ============================================================================
InitializeRelationPanel:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d2
    movea.l  #$0003B246,a4
    movea.l  #$0003AB2C,a5
    move.l  ($000A1AFC).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0047).w
    pea     ($01F1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($00071798).l
    pea     ($0003).w
    pea     ($001E).w
    pea     ($000F).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    pea     ($0011).w
    pea     ($0001).w
    jsr     (a5)
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004122A).l
    jsr     (a4)
    lea     $30(a7), a7
    moveq   #$F,d3
    clr.w   d2
l_21252:
    pea     ($000F).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041226).l
    jsr     (a4)
    pea     ($0011).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041222).l
    jsr     (a4)
    lea     $20(a7), a7
    addq.w  #$4, d3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_21252
    movem.l (a7)+, d2-d3/a2-a5
    rts
