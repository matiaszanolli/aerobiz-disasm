; ============================================================================
; InitLeaderboardData -- Clears the leaderboard working buffer at $FF14B0 and initialises it by writing each player index in order.
; 62 bytes | $02655A-$026597
; ============================================================================
InitLeaderboardData:
    movem.l d2/a2-a3, -(a7)
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($00FF14B0).l
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF99E0,a3
    movea.l  #$00FF14B0,a2
    clr.w   d2
l_26582:
    move.w  d2, (a2)
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_26582
    movem.l (a7)+, d2/a2-a3
    rts


; === Translated block $026598-$027184 ===
; 5 functions, 3052 bytes
