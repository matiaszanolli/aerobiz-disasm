; ============================================================================
; RenderTextLine -- Flushes the current text line buffer to the VDP via GameCommand $1B; advances the cursor Y and resets X for the next line
; 172 bytes | $03ABA6-$03AC51
; ============================================================================
RenderTextLine:
    link    a6,#$0
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $20(a6), d2
    move.l  $1c(a6), d3
    movea.l $18(a6), a2
    movea.l $8(a6), a3
    movea.l $14(a6), a4
    movea.l $c(a6), a5
    tst.w   (a2)
    beq.b   l_3ac12
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    move.l  (a5), -(a7)
    move.l  a3, d0
    moveq   #$42,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    jsr MemMoveWords
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  ($00FFA77A).l, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  ($00FFBDA6).l, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a4), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($001B).w
    jsr GameCommand
l_3ac12:
    tst.w   d2
    beq.b   l_3ac32
    move.w  ($00FF1290).l, d0
    move.w  d0, ($00FF128A).l
    move.w  d0, (a4)
    move.w  ($00FF99DE).l, d0
    add.w   d0, ($00FFBDA6).l
    bra.b   l_3ac38
l_3ac32:
    move.w  ($00FF128A).l, (a4)
l_3ac38:
    move.l  a3, (a5)
    move.l  a3, d0
    moveq   #$42,d1
    add.l   d1, d0
    movea.l $10(a6), a0
    move.l  d0, (a0)
    clr.w   (a2)
    movem.l -$18(a6), d2-d3/a2-a5
    unlk    a6
    rts
