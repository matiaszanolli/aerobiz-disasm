; ============================================================================
; UpdatePlayerHealthBars -- Adjusts each player's health-bar byte: increments if the player has positive balance (capping at $65), decrements if negative (flooring at $63).
; 70 bytes | $0275F6-$02763B
; ============================================================================
UpdatePlayerHealthBars:
    movea.l  #$00FF0018,a0
    clr.w   d1
l_275fe:
    tst.l   $6(a0)
    blt.b   l_2761a
    cmpi.b  #$64, $22(a0)
    bls.b   l_27612
    addq.b  #$1, $22(a0)
    bra.b   l_2762e
l_27612:
    move.b  #$65, $22(a0)
    bra.b   l_2762e
l_2761a:
    cmpi.b  #$64, $22(a0)
    bcs.b   l_2762a
    move.b  #$63, $22(a0)
    bra.b   l_2762e
l_2762a:
    subq.b  #$1, $22(a0)
l_2762e:
    moveq   #$24,d0
    adda.l  d0, a0
    addq.w  #$1, d1
    cmpi.w  #$4, d1
    bcs.b   l_275fe
    rts
