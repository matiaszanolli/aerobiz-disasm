; ============================================================================
; CalculateTurnCapacity -- Probabilistically determine if a player has turn capacity, clamping to 20 with a +10 bonus in the final quarter phase and returning 1 if random < capacity/100.
; 84 bytes | $021C9C-$021CEF
; ============================================================================
CalculateTurnCapacity:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
    cmpi.w  #$14, d2
    bge.b   l_21cb0
    move.w  d2, d0
    ext.l   d0
    bra.b   l_21cb2
l_21cb0:
    moveq   #$14,d0
l_21cb2:
    move.w  ($00FF0006).l, d1
    andi.l  #$3, d1
    moveq   #$3,d3
    cmp.l   d1, d3
    bne.b   l_21cc8
    moveq   #$A,d1
    bra.b   l_21cca
l_21cc8:
    moveq   #$0,d1
l_21cca:
    add.w   d1, d0
    move.w  d0, d2
    pea     ($0063).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bge.b   l_21ce8
    moveq   #$1,d0
    bra.b   l_21cea
l_21ce8:
    moveq   #$0,d0
l_21cea:
    movem.l (a7)+, d2-d3
    rts
