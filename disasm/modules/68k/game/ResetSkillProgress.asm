; ============================================================================
; ResetSkillProgress -- Iterates skill slots; calls ApplyCharBonus to award or clamp accumulated skill XP points
; 124 bytes | $035782-$0357FD
; ============================================================================
ResetSkillProgress:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d3
    move.l  $18(a7), d4
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_357a0:
    moveq   #$0,d0
    move.b  $1(a2), d0
    tst.w   d0
    ble.b   l_357ee
    tst.w   d4
    bne.b   l_357bc
    moveq   #$0,d0
    move.b  $1(a2), d0
    andi.l  #$ffff, d0
    bra.b   l_357d6
l_357bc:
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmpi.w  #$a, d0
    ble.b   l_357ee
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    subi.l  #$a, d0
l_357d6:
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ApplyCharBonus,PC)
    nop
    lea     $c(a7), a7
l_357ee:
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    bcs.b   l_357a0
    movem.l (a7)+, d2-d4/a2
    rts
