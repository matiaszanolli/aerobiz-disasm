; ============================================================================
; UpdateScrollDisplay -- If in full-map quadrant mode, update scroll offsets and apply via GameCommand #29
; 82 bytes | $0057A0-$0057F1
; ============================================================================
UpdateScrollDisplay:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d2
    move.l  $c(a7), d3
    cmpi.w  #$20, ($00FFA77E).l
    bne.b   l_057ec
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$B,d1
    lsl.l   d1, d0
    moveq   #$0,d1
    move.w  ($00FFA6B4).l, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$B,d1
    lsl.l   d1, d0
    moveq   #$0,d1
    move.w  ($00FF88D6).l, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($001D).w
    jsr GameCommand
    lea     $c(a7), a7
l_057ec:
    movem.l (a7)+, d2-d3
    rts
