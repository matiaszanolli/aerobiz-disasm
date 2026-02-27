; ============================================================================
; TransitionEffect -- Looks up a character's slot assignment for a given player/city pair: scans the player's route entry list at $FF9A20 (up to the count in byte +4 of the airline record) comparing the source and destination city indices, and returns the matched slot index in D0 (or 0xFF if not found).
; 110 bytes | $01F7C0-$01F82D
; ============================================================================
TransitionEffect:
    movem.l d2-d5/a2, -(a7)
    move.l  $20(a7), d3
    move.l  $1c(a7), d4
    move.l  $18(a7), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    move.w  d5, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  #$ff, d5
    clr.w   d2
    bra.b   l_1f818
l_1f7fc:
    cmp.w   (a2), d4
    bne.b   l_1f80a
    cmp.w   $2(a2), d3
l_1f804:
    bne.b   l_1f814
    move.w  d2, d5
    bra.b   l_1f826
l_1f80a:
    cmp.w   (a2), d3
    bne.b   l_1f814
    cmp.w   $2(a2), d4
    bra.b   l_1f804
l_1f814:
    addq.l  #$8, a2
    addq.w  #$1, d2
l_1f818:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a1), d1
    cmp.l   d1, d0
    blt.b   l_1f7fc
l_1f826:
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2
    rts
