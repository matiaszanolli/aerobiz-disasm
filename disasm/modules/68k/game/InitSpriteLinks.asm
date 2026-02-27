; ============================================================================
; InitSpriteLinks -- Initialize sprite link-chain bytes in sprite table buffer
; 58 bytes | $000FE2-$00101B
; ============================================================================
InitSpriteLinks:
    movem.l d0-d2/a0, -(a7)
    movea.l  #$00FFF01C,a0
    btst    #$0, (a0)
    bne.b   l_00ff6
    moveq   #$3F,d1
    bra.b   l_00ff8
l_00ff6:
    moveq   #$4F,d1
l_00ff8:
    moveq   #$1,d0
    movea.l  #$00FFF08A,a0
    moveq   #$3,d2
l_01002:
    move.b  d0, (a0,d2.w)
    addq.l  #$1, d0
    addq.l  #$8, d2
    dbra    d1, $1002
    moveq   #$0,d0
    subq.l  #$8, d2
    move.b  d0, (a0,d2.w)
    movem.l (a7)+, d0-d2/a0
    rts
