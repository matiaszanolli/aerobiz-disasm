; ============================================================================
; OfferCharContract -- Scores all available chars for a player and returns best candidate char index
; 444 bytes | $035B10-$035CCB
; ============================================================================
OfferCharContract:
    link    a6,#-$8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d5
    lea     -$2(a6), a5
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr (FindBestCharValue,PC)
    nop
    move.w  d0, -$6(a6)
    move.w  #$ff, d0
    move.w  d0, -$4(a6)
    move.w  d0, (a5)
    moveq   #$0,d7
    moveq   #$0,d6
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    lea     $c(a7), a7
    move.w  d0, d3
    cmpi.w  #$20, d0
    bcc.b   l_35b66
    move.w  d3, d5
    bra.w   l_35cc0
l_35b66:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  (a4), d3
    bra.w   l_35c9c
l_35b90:
    clr.w   d4
    movea.l  #$00FF0018,a3
    clr.w   d2
l_35b9a:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   l_35bba
    addq.w  #$1, d4
l_35bba:
    moveq   #$24,d0
    adda.l  d0, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_35b9a
    cmpi.w  #$1, d4
    bhi.w   l_35c98
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    addq.l  #$8, a7
    cmp.w   -$6(a6), d0
    bhi.w   l_35c98
    move.w  ($00FFBD4C).l, d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a2), d0
    ext.l   d0
    move.w  ($00FFBD4C).l, d1
    ext.l   d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$64,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.b  $1(a2), d1
    jsr Multiply32
    move.l  d0, d2
    moveq   #$0,d0
    move.b  $3(a2), d0
    andi.l  #$ffff, d0
    moveq   #$5A,d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    addi.w  #$a, d0
    move.w  d0, d4
    moveq   #$0,d1
    move.w  d4, d1
    move.l  d2, d0
    jsr Multiply32
    move.l  d0, d2
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    cmpi.w  #$2, d0
    bge.b   l_35c8e
    cmp.l   d7, d2
    ble.b   l_35c98
    move.w  d3, (a5)
    move.l  d2, d7
    bra.b   l_35c98
l_35c8e:
    cmp.l   d6, d2
    ble.b   l_35c98
    move.w  d3, -$4(a6)
    move.l  d2, d6
l_35c98:
    addq.l  #$4, a2
    addq.w  #$1, d3
l_35c9c:
    moveq   #$0,d0
    move.b  (a4), d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.w   l_35b90
    cmpi.w  #$20, (a5)
    bcc.b   l_35cbc
    move.w  (a5), d5
    bra.b   l_35cc0
l_35cbc:
    move.w  -$4(a6), d5
l_35cc0:
    move.w  d5, d0
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts
