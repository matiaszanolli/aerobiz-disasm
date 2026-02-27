; ============================================================================
; FindAvailableSlot -- Finds a free character slot in a player's roster starting from the given slot index (wrapping if needed); if no slot is free shows a "roster full" dialog and returns $FF
; 242 bytes | $02E374-$02E465
; ============================================================================
FindAvailableSlot:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $28(a7), d2
    move.l  $20(a7), d5
    move.l  $24(a7), d6
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    adda.l  d0, a0
    tst.b   $1(a0)
    beq.b   .l2e3a8
    move.w  d2, d4
    bra.w   .l2e45e
.l2e3a8:
    move.w  #$ff, d4
    move.w  d2, d3
    addq.w  #$1, d3
    cmpi.w  #$10, d3
    bcs.b   .l2e3b8
    clr.w   d3
.l2e3b8:
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0
    lea     (a3,d0.l), a0
    movea.l a0, a2
    move.w  d3, d2
    bra.b   .l2e3d6
.l2e3c8:
    tst.b   $1(a2)
    beq.b   .l2e3d2
    move.w  d2, d4
    bra.b   .l2e3dc
.l2e3d2:
    addq.l  #$2, a2
    addq.w  #$1, d2
.l2e3d6:
    cmpi.w  #$10, d2
    bcs.b   .l2e3c8
.l2e3dc:
    cmpi.w  #$ff, d4
    bne.b   .l2e3fa
    movea.l a3, a2
    clr.w   d2
    bra.b   .l2e3f6
.l2e3e8:
    tst.b   $1(a2)
    beq.b   .l2e3f2
    move.w  d2, d4
    bra.b   .l2e3fa
.l2e3f2:
    addq.l  #$2, a2
    addq.w  #$1, d2
.l2e3f6:
    cmp.w   d3, d2
    bcs.b   .l2e3e8
.l2e3fa:
    cmpi.w  #$ff, d4
    bne.b   .l2e45e
    cmpi.w  #$1, d6
    bne.b   .l2e422
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048486).l, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    bra.b   .l2e456
.l2e422:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000484E2).l, -(a7)
    pea     ($000B).w
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000484E6).l, -(a7)
    pea     ($000B).w
    jsr (ShowCharInfoPageS2,PC)
    nop
.l2e456:
    lea     $14(a7), a7
    move.w  #$ff, d4
.l2e45e:
    move.w  d4, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts
