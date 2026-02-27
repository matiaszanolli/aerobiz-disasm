; ============================================================================
; WriteCharUIDisplay -- Upload character sprite data via GameCommand(8, 2) and copy to display buffer
; 90 bytes | $004B6C-$004BC5
; ============================================================================
WriteCharUIDisplay:
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $1c(a7), d2
    move.l  $18(a7), d3
    movea.l $14(a7), a2
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0
    movea.l d0, a3
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    jsr GameCommand
    move.w  d2, d0
    add.w   d0, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$00FF1400,a0
    pea     (a0, d0.w)
    move.l  a2, -(a7)
    bsr.w MemMove
    lea     $28(a7), a7
    movem.l (a7)+, d2-d3/a2-a3
    rts
