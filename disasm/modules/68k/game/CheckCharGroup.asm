; ============================================================================
; CheckCharGroup -- Iterates the character group transfer loop: calls CheckCharSlotFull to verify a free destination slot, then calls TransferCharacter; on rejection plays a cancel sound, otherwise calls ManageCharStatsS2 to apply stat changes, and repeats
; 136 bytes | $02D264-$02D2EB
; ============================================================================
CheckCharGroup:
    movem.l d2-d4, -(a7)
    move.l  $14(a7), d2
    move.l  $10(a7), d3
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF880C,a0
    move.w  (a0,d0.w), d2
    moveq   #$1,d4
.l2d280:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CheckCharSlotFull,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    beq.b   .l2d2e6
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (TransferCharacter,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    clr.w   d4
    cmpi.w  #$ff, d2
    bne.b   .l2d2d0
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2d2e6
.l2d2d0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ManageCharStatsS2,PC)
    nop
    addq.l  #$8, a7
    bra.b   .l2d280
.l2d2e6:
    movem.l (a7)+, d2-d4
    rts
