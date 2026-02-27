; ============================================================================
; CheckCharAvailable -- Returns 1 if a char type index is already occupied in another player's alliance or match slot
; 204 bytes | $03443A-$034505
; ============================================================================
CheckCharAvailable:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $1c(a7), d4
    clr.w   d5
    movea.l  #$00FF0018,a3
    clr.w   d3
l_3444c:
    tst.b   (a3)
    bne.w   l_344f0
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_34470
l_3446c:
    moveq   #$1,d5
    bra.b   l_344ea
l_34470:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d4, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    bne.b   l_3446c
    move.w  d3, d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_344e2
l_344a4:
    cmpi.w  #$59, (a2)
    bcc.b   l_344dc
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    beq.b   l_3446c
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    beq.b   l_3446c
l_344dc:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_344e2:
    cmp.w   ($00FFA7DA).l, d2
    bcs.b   l_344a4
l_344ea:
    cmpi.w  #$1, d5
    beq.b   l_344fe
l_344f0:
    moveq   #$24,d0
    adda.l  d0, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_3444c
l_344fe:
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2-a3
    rts
