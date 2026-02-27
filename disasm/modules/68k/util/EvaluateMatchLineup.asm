; ============================================================================
; EvaluateMatchLineup -- Checks stamina and substitute status for a single match slot pair; calls FindOpenCharSlot2 if needed
; 306 bytes | $0336E0-$033811
; ============================================================================
EvaluateMatchLineup:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $18(a7), d3
    move.l  $1c(a7), d4
    moveq   #$1,d2
    move.w  d3, d0
    mulu.w  #$30, d0
    move.w  d4, d1
    mulu.w  #$c, d1
    add.w   d1, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$59, (a2)
    bcc.w   l_337c2
    move.w  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    sub.l   d1, d0
    ble.b   l_3373c
    move.w  #$3, $6(a2)
    bra.b   l_3374c
l_3373c:
    clr.w   d2
    cmpi.w  #$2, $6(a2)
    beq.b   l_3374c
    move.w  #$1, $6(a2)
l_3374c:
    move.w  $2(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    sub.l   d1, d0
    ble.b   l_3377a
    move.w  #$3, $8(a2)
    bra.b   l_3378a
l_3377a:
    clr.w   d2
    cmpi.w  #$2, $8(a2)
    beq.b   l_3378a
    move.w  #$1, $8(a2)
l_3378a:
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  $4(a2), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    tst.b   $1(a3)
    beq.b   l_337b0
    move.w  #$3, $a(a2)
    bra.b   l_337c4
l_337b0:
    clr.w   d2
    cmpi.w  #$2, $a(a2)
    beq.b   l_337c4
    move.w  #$1, $a(a2)
    bra.b   l_337c4
l_337c2:
    clr.w   d2
l_337c4:
    cmpi.w  #$1, d2
    bne.b   l_3380a
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (FindOpenCharSlot2,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d3
    tst.w   d3
    bne.b   l_3380a
    move.w  #$ff, d0
    move.w  d0, $2(a2)
    move.w  d0, (a2)
    clr.w   $4(a2)
    clr.w   $6(a2)
    clr.w   $8(a2)
    clr.w   $a(a2)
    clr.w   d2
l_3380a:
    move.w  d2, d0
    movem.l (a7)+, d2-d4/a2-a3
    rts
