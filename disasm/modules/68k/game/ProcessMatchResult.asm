; ============================================================================
; ProcessMatchResult -- Finds best rival char to challenge; calls RemoveCharRelation and SortCharsByValue on success
; 302 bytes | $034AC0-$034BED
; ============================================================================
ProcessMatchResult:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d4
    lea     -$4(a6), a3
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, -$2(a6)
    move.w  #$ff, d0
    move.w  d0, d7
    move.w  d0, (a3)
    move.l  #$5f5e0ff, d6
    move.l  d6, d5
    move.w  ($00FF0004).l, d2
    ext.l   d2
    addq.l  #$4, d2
    moveq   #$7,d0
    cmp.l   d2, d0
    ble.b   l_34b22
    move.w  ($00FF0004).l, d2
    ext.l   d2
    addq.l  #$4, d2
    bra.b   l_34b24
l_34b22:
    moveq   #$7,d2
l_34b24:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    bsr.w CountAllianceMembers
    addq.l  #$8, a7
    cmp.w   d2, d0
    bcc.w   l_34be4
    clr.w   d2
l_34b38:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_34b8e
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    bsr.w CalcAllianceDifference
    addq.l  #$8, a7
    move.l  d0, d3
    tst.l   d3
    ble.b   l_34b74
    cmp.l   d5, d3
    bge.b   l_34b8e
    move.l  d3, d5
    move.w  d2, d7
    bra.b   l_34b8e
l_34b74:
    cmp.w   -$2(a6), d2
    bne.b   l_34b86
    move.l  d3, d0
    moveq   #$3,d1
    jsr SignedDiv
    move.l  d0, d3
l_34b86:
    cmp.l   d6, d3
    bge.b   l_34b8e
    move.l  d3, d6
    move.w  d2, (a3)
l_34b8e:
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.b   l_34b38
    cmpi.w  #$7, d7
    bcc.b   l_34be4
    cmpi.w  #$7, (a3)
    bcc.b   l_34be4
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (UpdatePlayerRating,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$28, d2
    bcc.b   l_34be4
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (RemoveCharRelation,PC)
    nop
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    bsr.w SortCharsByValue
l_34be4:
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts
