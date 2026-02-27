; ============================================================================
; EvalCharMatch -- Displays a character match selection box for up to 4 player slots: prints each slot's status string (selected/unselected) and polls for directional input, toggling the active/inactive flag of each slot byte on button presses, looping until the player exits.
; 248 bytes | $01C54E-$01C645
; ============================================================================
EvalCharMatch:
    movem.l d2/a2-a3, -(a7)
    movea.l  #$00FF0018,a3
    jsr ResourceUnload
    pea     ($0003).w
    pea     ($001D).w
    pea     ($0012).w
    pea     ($0002).w
    jsr DrawBox
    lea     $10(a7), a7
l_1c578:
    movea.l a3, a2
    clr.w   d2
l_1c57c:
    pea     ($0013).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    sub.l   d1, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    cmpi.b  #$1, (a2)
    bne.b   l_1c5aa
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($00041164).l
    bra.b   l_1c5b8
l_1c5aa:
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0004115C).l
l_1c5b8:
    jsr PrintfNarrow
    lea     $10(a7), a7
    addq.w  #$1, d2
    moveq   #$24,d0
    adda.l  d0, a2
    cmpi.w  #$4, d2
    blt.b   l_1c57c
l_1c5ce:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d2
    andi.l  #$d0, d0
    beq.b   l_1c5ce
    move.w  d2, d0
    andi.w  #$40, d0
    beq.b   l_1c5f6
    movea.l a3, a2
    moveq   #$1,d0
    eor.b   d0, (a2)
l_1c5f6:
    move.w  d2, d0
    andi.w  #$10, d0
    beq.b   l_1c608
    movea.l a3, a2
    moveq   #$48,d0
    adda.l  d0, a2
    moveq   #$1,d0
    eor.b   d0, (a2)
l_1c608:
    move.w  d2, d0
    andi.w  #$40, d0
    beq.b   l_1c61a
    movea.l a3, a2
    moveq   #$24,d0
    adda.l  d0, a2
    moveq   #$1,d0
    eor.b   d0, (a2)
l_1c61a:
    move.w  d2, d0
    andi.w  #$80, d0
    beq.b   l_1c62c
    movea.l a3, a2
    moveq   #$6C,d0
    adda.l  d0, a2
    moveq   #$1,d0
    eor.b   d0, (a2)
l_1c62c:
    pea     ($0002).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   l_1c578
    movem.l (a7)+, d2/a2-a3
    rts
