; ============================================================================
; ValidateCharSlots -- Clears invalid char slot pairs for a player: removes dead chars and mismatched route assignments
; 228 bytes | $03272E-$032811
; ============================================================================
ValidateCharSlots:
    move.l  a2, -(a7)
    move.w  $a(a7), d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d1
    bra.w   l_32804
l_3274a:
    cmpi.w  #$59, (a2)
    bcc.w   l_327fe
    cmpi.w  #$20, (a2)
    bcc.b   l_32778
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    cmpi.b  #$6, (a1)
    bls.b   l_32778
    move.w  #$ff, (a2)
    move.w  #$ff, $2(a2)
l_32778:
    cmpi.w  #$20, $2(a2)
    bcc.b   l_327a2
    move.w  $2(a2), d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    cmpi.b  #$6, (a1)
    bls.b   l_327a2
    move.w  #$ff, (a2)
    move.w  #$ff, $2(a2)
l_327a2:
    cmpi.w  #$20, (a2)
    bcs.b   l_327ca
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    move.b  (a1), d0
    cmp.b   $1(a1), d0
    bhi.b   l_327ca
    move.w  #$ff, (a2)
    move.w  #$ff, $2(a2)
l_327ca:
    cmpi.w  #$20, $2(a2)
    bcs.b   l_327fe
    cmpi.w  #$59, $2(a2)
    bcc.b   l_327fe
    move.w  $2(a2), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    move.b  (a1), d0
    cmp.b   $1(a1), d0
    bhi.b   l_327fe
    move.w  #$ff, (a2)
    move.w  #$ff, $2(a2)
l_327fe:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d1
l_32804:
    cmp.w   ($00FFA7DA).l, d1
    bcs.w   l_3274a
    movea.l (a7)+, a2
    rts
