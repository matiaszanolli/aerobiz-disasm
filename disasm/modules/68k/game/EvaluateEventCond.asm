; ============================================================================
; EvaluateEventCond -- Shows a yes/no dialog; if accepted and all players have the event flag set shows a confirmation and calls GameSetup1; otherwise clears the player event flag and decrements the event counter
; 260 bytes | $017B6A-$017C6D
; ============================================================================
EvaluateEventCond:
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FFA792,a3
    movea.l  #$00000D64,a4
    movea.l  #$00FF0018,a5
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($00047A94).l, -(a7)
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
    move.w  d0, d5
    cmpi.w  #$1, d0
    bne.w   l_17c66
    moveq   #$1,d4
    clr.w   d2
    move.w  (a3), d3
l_17bae:
    cmp.w   d3, d2
    beq.b   l_17bcc
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    cmpi.b  #$1, (a5,a0.l)
    bne.b   l_17bcc
    clr.w   d4
    bra.b   l_17bd4
l_17bcc:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_17bae
l_17bd4:
    cmpi.w  #$1, d4
    bne.b   l_17c2a
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($00047A98).l, -(a7)
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $30(a7), a7
    tst.w   d0
    bne.b   l_17c44
    pea     ($000A).w
    pea     ($0013).w
    jsr     (a4)
    clr.l   -(a7)
    jsr GameSetup1
    lea     $c(a7), a7
    bra.b   l_17c60
l_17c2a:
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_17c44:
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a2
    clr.b   (a2)
    move.w  #$1, ($00FF1296).l
l_17c60:
    subq.w  #$1, ($00FF0A34).l
l_17c66:
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2-a5
    rts
