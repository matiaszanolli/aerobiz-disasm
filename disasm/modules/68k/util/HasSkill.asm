; ============================================================================
; HasSkill -- Returns 1 if skill ID is already learned (type=$3) in the player skill table, 0 otherwise
; 68 bytes | $035540-$035583
; ============================================================================
HasSkill:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d3
    clr.w   d1
    move.w  $e(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_3555e:
    cmpi.b  #$3, $1(a1)
    bne.b   l_35572
    moveq   #$0,d0
    move.b  (a1), d0
    cmp.w   d3, d0
    bne.b   l_35572
    moveq   #$1,d1
    bra.b   l_3557c
l_35572:
    addq.l  #$8, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_3555e
l_3557c:
    move.w  d1, d0
    movem.l (a7)+, d2-d3
    rts
