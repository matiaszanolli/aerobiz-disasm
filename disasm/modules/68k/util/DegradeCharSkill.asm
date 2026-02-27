; ============================================================================
; DegradeCharSkill -- Reduces char level and alliance stamina; calls AcquireCharSlot or SetSubstituteFlag based on slot state
; 476 bytes | $032FF0-$0331CB
; ============================================================================
DegradeCharSkill:
    movem.l d2-d5/a2-a4, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    movea.l  #$00FFBA80,a4
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d2, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.w   l_331b0
    moveq   #$0,d0
    move.b  $1(a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.w   l_331b0
    cmpi.b  #$1, $3(a2)
    bls.w   l_3315c
    cmpi.b  #$7, $3(a2)
    bls.b   l_3307e
    moveq   #$0,d2
    move.b  $3(a2), d2
    addi.w  #$fff9, d2
    bra.b   l_33080
l_3307e:
    moveq   #$1,d2
l_33080:
    sub.b   d2, $3(a2)
    moveq   #$0,d4
    move.b  $3(a2), d4
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d1
    adda.l  d1, a0
    sub.b   d2, $1(a0)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d1
    adda.l  d1, a0
    sub.b   d2, $1(a0)
    move.b  $2(a2), d2
    andi.w  #$f, d2
    moveq   #$0,d0
    move.b  $3(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr (GetCharTypeBonus,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, d5
    cmp.w   d5, d2
    bls.b   l_33112
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    move.l  a2, -(a7)
    jsr GetByteField4
    lea     $c(a7), a7
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E9,a0
    adda.l  d0, a0
    movea.l a0, a3
    move.b  d2, d0
    sub.b   d5, d0
    add.b   d0, (a3)
l_33112:
    moveq   #$0,d0
    move.b  $3(a2), d0
    cmp.w   d4, d0
    beq.w   l_331c2
    moveq   #$0,d0
    move.b  $3(a2), d0
    sub.w   d0, d4
    tst.w   d4
    bge.b   l_3312c
    neg.w   d4
l_3312c:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d1
    adda.l  d1, a0
    sub.b   d4, $1(a0)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d1
    adda.l  d1, a0
    sub.b   d4, $1(a0)
    bra.b   l_331c2
l_3315c:
    pea     ($000A).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w AcquireCharSlot
    lea     $c(a7), a7
    moveq   #$0,d0
    move.w  $e(a2), d0
    add.l   d0, d0
    moveq   #$0,d1
    move.w  $6(a2), d1
    cmp.l   d1, d0
    ble.b   l_331a2
l_33186:
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CalcRecruitmentCost,PC)
    nop
    lea     $c(a7), a7
    bra.b   l_331c2
l_331a2:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a3), d1
    cmp.l   d1, d0
    blt.b   l_33186
l_331b0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (SetSubstituteFlag,PC)
    nop
l_331c2:
    movem.l -$1c(a6), d2-d5/a2-a4
    unlk    a6
    rts
