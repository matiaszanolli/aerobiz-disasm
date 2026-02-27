; ============================================================================
; MakeAIDecision -- For each AI player, generates three random stat-adjustment values using table-driven ranges and adds them to the player's three decision bytes in the route-priority table.
; 136 bytes | $0294F8-$02957F
; ============================================================================
MakeAIDecision:
    movem.l d2/a2-a4, -(a7)
    movea.l  #$000090F4,a4
    movea.l  #$00FF0120,a2
    movea.l  #$00FF03F0,a3
    clr.w   d2
l_29510:
    moveq   #$0,d0
    move.b  $9(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    add.b   $1(a2), d0
    move.b  d0, $1(a2)
    moveq   #$0,d0
    move.b  $a(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    add.b   $2(a2), d0
    move.b  d0, $2(a2)
    moveq   #$0,d0
    move.b  $b(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $24(a7), a7
    add.b   $3(a2), d0
    move.b  d0, $3(a2)
    addq.l  #$4, a2
    moveq   #$C,d0
    adda.l  d0, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_29510
    movem.l (a7)+, d2/a2-a4
    rts
