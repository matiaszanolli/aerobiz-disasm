; ============================================================================
; ApplyRelationBonus -- Initialises a relation record struct, computes max skill bonus from char types, calls CalcCharCompat
; 348 bytes | $033CE2-$033E3D
; ============================================================================
ApplyRelationBonus:
    link    a6,#$0
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $8(a6), d3
    movea.l $c(a6), a2
    move.b  $13(a6), (a2)
    move.b  $17(a6), $1(a2)
    moveq   #$0,d0
    move.w  $1a(a6), d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr SetHighNibble
    clr.w   $e(a2)
    clr.w   $6(a2)
    clr.b   $a(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d2
    move.b  (a3), d2
    moveq   #$0,d0
    move.b  $1(a3), d0
    sub.w   d0, d2
    moveq   #$0,d4
    move.b  (a4), d4
    moveq   #$0,d0
    move.b  $1(a4), d0
    sub.w   d0, d4
    move.l  a2, -(a7)
    jsr GetByteField4
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E8,a0
    adda.l  d0, a0
    movea.l a0, a3
    cmp.w   d4, d2
    bcc.b   l_33d8c
    moveq   #$0,d3
    move.w  d2, d3
    bra.b   l_33d90
l_33d8c:
    moveq   #$0,d3
    move.w  d4, d3
l_33d90:
    cmpi.w  #$e, d3
    bcc.b   l_33d9c
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   l_33d9e
l_33d9c:
    moveq   #$E,d0
l_33d9e:
    move.w  d0, d3
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr (GetCharTypeBonus,PC)
    nop
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bge.b   l_33dc6
    moveq   #$0,d0
    move.b  $1(a3), d0
    bra.b   l_33dca
l_33dc6:
    moveq   #$0,d0
    move.w  d2, d0
l_33dca:
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    moveq   #$0,d0
    move.b  $b(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, d1
    lsl.l   #$3, d0
    add.l   d1, d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d2
    cmp.w   d3, d2
    bcc.b   l_33e00
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_33e04
l_33e00:
    moveq   #$0,d0
    move.w  d3, d0
l_33e04:
    move.w  d0, d2
    cmpi.w  #$e, d2
    bcc.b   l_33e12
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_33e14
l_33e12:
    moveq   #$E,d0
l_33e14:
    move.w  d0, d2
    cmpi.w  #$1, d2
    bls.b   l_33e22
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_33e24
l_33e22:
    moveq   #$1,d0
l_33e24:
    move.b  d0, $3(a2)
    move.l  a2, -(a7)
    jsr (CalcCharCompat,PC)
    nop
    move.w  d0, $4(a2)
    movem.l -$18(a6), d2-d4/a2-a4
    unlk    a6
    rts
