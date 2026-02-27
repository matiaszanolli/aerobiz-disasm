; ============================================================================
; CheckAffinityThreshold -- Scans char relations; calls RemoveCharRelation for slots that have exceeded their limit
; 154 bytes | $0359C4-$035A5D
; ============================================================================
CheckAffinityThreshold:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $20(a7), d4
    move.l  $1c(a7), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
l_359e2:
    moveq   #$0,d0
    move.b  $4(a3), d0
    mulu.w  #$14, d0
    move.w  d5, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  $4(a3), d3
    moveq   #$0,d0
    move.b  $5(a3), d0
    add.w   d0, d3
    moveq   #$0,d2
    move.b  $4(a3), d2
    bra.b   l_35a50
l_35a16:
    tst.w   d4
    bne.b   l_35a3a
    move.b  $a(a2), d0
    btst    #$1, d0
    beq.b   l_35a4a
l_35a24:
    pea     ($0001).w
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    bsr.w RemoveCharRelation
    lea     $c(a7), a7
    bra.b   l_35a54
l_35a3a:
    cmpi.w  #$1, d4
    bne.b   l_35a4a
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcs.b   l_35a24
l_35a4a:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_35a50:
    cmp.w   d3, d2
    bcs.b   l_35a16
l_35a54:
    cmp.w   d3, d2
    bcs.b   l_359e2
    movem.l (a7)+, d2-d5/a2-a3
    rts
