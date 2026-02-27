; ============================================================================
; ProcessLevelUp -- Checks level-up conditions for a char; writes new skill slot and shows promotion dialog if eligible
; 322 bytes | $035122-$035263
; ============================================================================
ProcessLevelUp:
    link    a6,#$0
    movem.l d2-d7/a2, -(a7)
    move.l  $c(a6), d4
    move.l  $8(a6), d5
    clr.w   d6
    moveq   #$0,d0
    move.w  d5, d0
    lsl.l   #$5, d0
    move.l  d0, d7
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    clr.w   d2
l_3514c:
    tst.b   $1(a2)
    bne.b   l_35156
    moveq   #$1,d3
    bra.b   l_3516e
l_35156:
    cmpi.b  #$1, $1(a2)
    bne.b   l_3516e
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bne.b   l_3516e
    clr.w   d3
    bra.b   l_35178
l_3516e:
    addq.l  #$8, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_3514c
l_35178:
    cmpi.w  #$1, d3
    bne.w   l_35258
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcCharAdvantage
    addq.l  #$8, a7
    move.w  d0, d3
    beq.w   l_35258
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    cmpi.w  #$2, d0
    bge.b   l_351b6
    moveq   #$1,d2
    bra.b   l_351b8
l_351b6:
    clr.w   d2
l_351b8:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (FindNextOpenSkillSlot,PC)
    nop
    lea     $10(a7), a7
    move.w  d0, d2
    cmpi.w  #$4, d2
    bcc.w   l_35258
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d7, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d4, (a2)
    move.b  #$1, $1(a2)
    move.b  d3, $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    jsr DrawBox
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00044912).l
    jsr PrintfWide
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr DrawPlayerRoutes
    pea     ($001E).w
    jsr PollInputChange
    moveq   #$1,d6
l_35258:
    move.w  d6, d0
    movem.l -$1c(a6), d2-d7/a2
    unlk    a6
    rts
