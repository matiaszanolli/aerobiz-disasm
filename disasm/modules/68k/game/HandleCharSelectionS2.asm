; ============================================================================
; HandleCharSelectionS2 -- AI-driven character selection: rolls a random char slot, validates it, then shows the character info pages and hire dialog if the owner flag is set
; 326 bytes | $02B43A-$02B57F
; ============================================================================
HandleCharSelectionS2:
    link    a6,#-$80
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $8(a6), d3
    lea     -$80(a6), a3
    movea.l  #$0005F04C,a4
    movea.l  #$0003B22C,a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  #$ff, ($00FF09A0).l
    pea     ($000F).w
    pea     ($0001).w
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$2,d1
    cmp.l   d0, d1
    ble.w   .l2b576
    pea     ($000A).w
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ValidateCharSlot,PC)
    nop
    lea     $10(a7), a7
    cmpi.w  #$1, d0
    bne.w   .l2b576
    move.b  d2, ($00FF09A0).l
    cmpi.b  #$1, (a2)
    bne.w   .l2b576
    jsr PreLoopInit
    jsr ResourceUnload
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    pea     ($00042604).l
    move.l  a3, -(a7)
    jsr     (a5)
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    pea     ($000425C8).l
    move.l  a3, -(a7)
    jsr     (a5)
    lea     $2c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr ShowCharInfoPage
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00042580).l
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr ShowCharInfoPage
    lea     $28(a7), a7
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    pea     ($0004254A).l
    move.l  a3, -(a7)
    jsr     (a5)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowDialog
.l2b576:
    movem.l -$98(a6), d2-d3/a2-a5
    unlk    a6
    rts
