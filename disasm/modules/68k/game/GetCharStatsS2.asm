; ============================================================================
; GetCharStatsS2 -- Update character availability flags in route slot tables ($FF0420, $FF04E0) by scanning $FF0338 type-5 event records and setting high bits accordingly.
; 266 bytes | $023386-$02348F
; ============================================================================
GetCharStatsS2:
    movem.l d2-d5/a2, -(a7)
    move.l  $18(a7), d5
    tst.w   d5
    bne.b   l_23396
    moveq   #$1,d4
    bra.b   l_233a0
l_23396:
    cmpi.w  #$1, d5
    bne.w   l_2348a
    moveq   #$2,d4
l_233a0:
    clr.w   d3
l_233a2:
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_233b4:
    cmpi.b  #$5, $1(a2)
    bne.b   l_233f4
    cmpi.b  #$20, (a2)
    bcc.b   l_233da
    moveq   #$0,d0
    move.b  (a2), d0
    mulu.w  #$6, d0
    moveq   #$0,d1
    move.b  $2(a2), d1
    add.w   d1, d0
    movea.l  #$00FF0420,a0
    bra.b   l_233ee
l_233da:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    moveq   #$0,d1
    move.b  $2(a2), d1
    add.w   d1, d0
    movea.l  #$00FF04E0,a0
l_233ee:
    move.b  #$ff, (a0,d0.w)
l_233f4:
    moveq   #$0,d0
    move.b  $1(a2), d0
    andi.l  #$ffff, d0
    subq.l  #$1, d0
    moveq   #$5,d1
    cmp.l   d1, d0
    bhi.b   l_23474
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $000C
    dc.w    $0062
    dc.w    $000C
    dc.w    $0062
    dc.w    $000C
    dc.w    $0032
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    and.w   d4, d0
    cmp.w   d4, d0
    bne.b   l_23474
    tst.w   d5
    bne.b   l_2346e
l_2343c:
    ori.b   #$40, $1(a2)
    bra.b   l_23474
    clr.l   -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr CheckEventMatch
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_2343c
    pea     ($0001).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr CheckEventMatch
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_23474
l_2346e:
    ori.b   #$80, $1(a2)
l_23474:
    addq.l  #$8, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.w   l_233b4
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.w   l_233a2
l_2348a:
    movem.l (a7)+, d2-d5/a2
    rts
