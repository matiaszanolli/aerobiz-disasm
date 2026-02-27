; ============================================================================
; ProcessGameFrame -- Displays the end-of-turn/end-of-game summary for a player: branches on the player state byte ($22: $63=won, $62=bankrupt, $61=special) to show sprintf-formatted outcome messages, then shows profitable-route count and total character value if applicable
; 564 bytes | $02FD90-$02FFC3
; ============================================================================
ProcessGameFrame:
    link    a6,#-$A0
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d5
    lea     -$a0(a6), a3
    movea.l  #$0002FBD6,a4
    movea.l  #$00047C40,a5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d0, d6
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $22(a2), d0
    moveq   #$63,d1
    cmp.b   d1, d0
    beq.b   l_2fde2
    moveq   #$62,d1
    cmp.b   d1, d0
    beq.b   l_2fe1c
    moveq   #$61,d1
    cmp.b   d1, d0
    beq.b   l_2fe3c
    bra.w   l_2fe86
l_2fde2:
    pea     ($0002).w
    move.l  ($00047C40).l, -(a7)
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d5, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  $8(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    lea     $1c(a7), a7
    pea     ($0002).w
    move.l  a3, -(a7)
    bra.b   l_2fe90
l_2fe1c:
    pea     ($0002).w
    move.l  $4(a5), -(a7)
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $10(a7), a7
    pea     ($0002).w
    move.l  $c(a5), -(a7)
    bra.b   l_2fe90
l_2fe3c:
    move.w  d5, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  $10(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    pea     ($0002).w
    move.l  a3, -(a7)
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    pea     ($0002).w
    move.l  $14(a5), -(a7)
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $2c(a7), a7
    pea     ($0002).w
    move.l  $18(a5), -(a7)
    bra.b   l_2fe90
l_2fe86:
    pea     ($0002).w
    move.l  ($00047C40).l, -(a7)
l_2fe90:
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.l  $1c(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr SumPlayerStats
    lea     $2c(a7), a7
    tst.w   d0
    ble.b   l_2ff2a
    moveq   #$0,d3
    clr.w   d2
l_2fec8:
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d4
    andi.l  #$ff, d4
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcCharScore
    addq.l  #$4, a7
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    add.l   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   l_2fec8
    move.l  d3, -(a7)
    move.l  $20(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0002).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $1c(a7), a7
l_2ff2a:
    movea.l  #$00FF0018,a0
    lea     (a0,d6.w), a2
    moveq   #$0,d0
    move.b  $4(a2), d0
    moveq   #$0,d1
    move.b  $5(a2), d1
    add.w   d1, d0
    ble.b   l_2ff8e
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CountProfitableRelations
    addq.l  #$4, a7
    move.w  d0, d2
    tst.w   d2
    ble.b   l_2ff8e
    cmpi.w  #$1, d2
    bne.b   l_2ff64
    pea     ($00044762).l
    bra.b   l_2ff6a
l_2ff64:
    pea     ($0004475A).l
l_2ff6a:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $24(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0001).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
l_2ff8e:
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcTotalCharValue
    addq.l  #$4, a7
    move.l  d0, d2
    beq.b   l_2ffba
    move.l  d2, -(a7)
    move.l  $28(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0003).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
l_2ffba:
    movem.l -$c4(a6), d2-d6/a2-a5
    unlk    a6
    rts


; === Translated block $02FFC4-$030000 ===
; 1 functions, 60 bytes
