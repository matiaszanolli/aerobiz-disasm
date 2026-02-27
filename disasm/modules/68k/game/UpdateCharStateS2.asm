; ============================================================================
; UpdateCharStateS2 -- Advances pending char-countdown timers for a player's route assignments: when a timer expires shows the station detail and credits the char's bonus to route popularity (human player), then marks the assignment complete.
; 294 bytes | $02AB44-$02AC69
; ============================================================================
UpdateCharStateS2:
    link    a6,#-$80
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $8(a6), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d3, d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
.l2ab76:
    tst.b   $2(a2)
    beq.w   .l2ac54
    subq.b  #$1, $2(a2)
    tst.b   $2(a2)
    bne.b   .l2abe4
    moveq   #$0,d2
    move.b  (a2), d2
    cmpi.b  #$1, (a4)
    bne.b   .l2abb2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (DisplayStationDetail,PC)
    nop
    lea     $c(a7), a7
.l2abb2:
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.b  $1(a2), d0
    add.b   d0, (a3)
    move.b  $1(a2), d0
    add.b   d0, $1(a3)
    move.b  #$ff, (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    bra.b   .l2ac54
.l2abe4:
    moveq   #$0,d2
    move.b  (a2), d2
    cmpi.b  #$1, (a4)
    bne.b   .l2ac54
    jsr ClearBothPlanes
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    jsr ResourceUnload
    movea.l  #$00FF1278,a0
    move.b  (a0,d2.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004227A).l
    pea     -$80(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     -$80(a6)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $2c(a7), a7
.l2ac54:
    addq.l  #$4, a2
    addq.w  #$1, d4
    cmpi.w  #$5, d4
    bcs.w   .l2ab76
    movem.l -$98(a6), d2-d4/a2-a4
    unlk    a6
    rts
