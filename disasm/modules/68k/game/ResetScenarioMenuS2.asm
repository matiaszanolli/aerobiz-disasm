; ============================================================================
; ResetScenarioMenuS2 -- Resets $FF0A32 to $FFFF, then randomly rolls a valid scenario: picks a city index, validates against a whitelist, finds the matching group in the scenario table, and writes the packed (group<<8|city) value to $FF0A32
; 172 bytes | $02C8D0-$02C97B
; ============================================================================
ResetScenarioMenuS2:
    movem.l d2-d6/a2, -(a7)
    clr.w   d4
    move.w  #$ffff, ($00FF0A32).l
    pea     ($0020).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$1A,d1
    cmp.l   d0, d1
    bge.w   l_2c976
    pea     ($0058).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$20, d6
    blt.b   l_2c922
    cmpi.w  #$26, d6
    beq.b   l_2c922
    cmpi.w  #$28, d6
    beq.b   l_2c922
    cmpi.w  #$32, d6
    blt.b   l_2c976
    cmpi.w  #$36, d6
    bgt.b   l_2c976
l_2c922:
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    movea.l  #$0005FCF2,a2
    clr.w   d3
l_2c93e:
    clr.w   d2
l_2c940:
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d5, d0
    bne.b   l_2c94c
    moveq   #$1,d4
    bra.b   l_2c956
l_2c94c:
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   l_2c940
l_2c956:
    cmpi.w  #$1, d4
    beq.b   l_2c964
    addq.w  #$1, d3
    cmpi.w  #$7, d3
    blt.b   l_2c93e
l_2c964:
    tst.w   d4
    bne.b   l_2c96a
    moveq   #$7,d3
l_2c96a:
    move.w  d3, d0
    lsl.w   #$8, d0
    or.w    d6, d0
    move.w  d0, ($00FF0A32).l
l_2c976:
    movem.l (a7)+, d2-d6/a2
    rts
