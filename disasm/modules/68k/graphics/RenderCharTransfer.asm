; ============================================================================
; RenderCharTransfer -- Renders the character transfer comparison screen: displays the character's stats panel and city-of-origin label, computes the weighted stat value (halved for AI's own character), and prints the salary and stat score on screen
; 322 bytes | $02D900-$02DA41
; ============================================================================
RenderCharTransfer:
    link    a6,#$0
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d0, d4
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$1, $12(a6)
    bne.b   .l2d984
    cmpi.w  #$1, $16(a6)
    bne.b   .l2d97e
    pea     ($0002).w
    pea     ($0001).w
    pea     ($000A).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowCharProfile
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004E3AC).l
    jsr DisplaySetup
    lea     $24(a7), a7
.l2d97e:
    move.w  d2, ($00FF17C6).l
.l2d984:
    pea     ($0002).w
    pea     ($000A).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowCharStats
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0014).w
    pea     ($0002).w
    jsr     (a4)
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.b  $6(a2), d0
    addi.l  #$76c, d0
    move.l  d0, -(a7)
    pea     ($00044674).l
    jsr     (a3)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcWeightedStat
    move.w  d0, d2
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d4.w), d3
    andi.l  #$ff, d3
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0
    cmp.w   d3, d0
    bne.b   .l2da0e
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2da0a
    addq.l  #$1, d0
.l2da0a:
    asr.l   #$1, d0
    move.w  d0, d2
.l2da0e:
    pea     ($0016).w
    pea     ($0002).w
    jsr     (a4)
    pea     ($0004466E).l
    jsr     (a3)
    pea     ($0016).w
    pea     ($0007).w
    jsr     (a4)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($00044668).l
    jsr     (a3)
    movem.l -$18(a6), d2-d4/a2-a4
    unlk    a6
    rts
