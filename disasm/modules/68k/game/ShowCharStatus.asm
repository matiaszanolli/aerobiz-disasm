; ============================================================================
; ShowCharStatus -- Shows the character status screen for a player: on the last turn of the year loads the portrait/screen and shows turn-count info strings; otherwise calls RenderStatusScreenS2 and ShowAnnualReport if funds are negative
; 330 bytes | $02B61C-$02B765
; ============================================================================
ShowCharStatus:
    link    a6,#-$C8
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $8(a6), d2
    movea.l  #$00007912,a3
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  ($00FF0002).l, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$4, d0
    sub.l   d1, d0
    lsl.l   #$2, d0
    addq.l  #$1, d0
    move.w  ($00FF0006).l, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.w   .l2b73e
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ResourceLoad
    jsr ClearBothPlanes
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    jsr ResourceUnload
    move.w  ($00FF0004).l, d3
    addq.w  #$4, d3
    cmpi.w  #$7, d3
    bcc.b   .l2b6ba
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   .l2b6bc
.l2b6ba:
    moveq   #$7,d0
.l2b6bc:
    move.w  d0, d3
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($00042730).l
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $28(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($000426C2).l
    pea     -$c8(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$c8(a6)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004267A).l
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0004263A).l
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $28(a7), a7
    bra.b   .l2b75c
.l2b73e:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (RenderStatusScreenS2,PC)
    nop
    addq.l  #$4, a7
    tst.l   $6(a2)
    ble.b   .l2b75c
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr ShowAnnualReport
.l2b75c:
    movem.l -$d8(a6), d2-d3/a2-a3
    unlk    a6
    rts
