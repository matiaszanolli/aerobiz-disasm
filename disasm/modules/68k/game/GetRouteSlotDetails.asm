; ============================================================================
; GetRouteSlotDetails -- Compute route slot pointer and active occupancy count for a given player/slot index, applying random selection bounded by slot field 3.
; 204 bytes | $02037C-$020447
; ============================================================================
GetRouteSlotDetails:
    link    a6,#$0
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $8(a6), d2
    clr.w   d3
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmp.w   ($00FF09D6).l, d2
    beq.b   l_203cc
    movea.l  #$00FF09CA,a3
    cmpi.b  #$1, (a3)
    bne.b   l_203ce
    move.b  (a2), d0
    cmp.b   $1(a3), d0
    beq.b   l_203cc
    move.b  $1(a2), d0
    cmp.b   $1(a3), d0
    bne.b   l_203ce
l_203cc:
    moveq   #$1,d3
l_203ce:
    cmpi.w  #$1, d3
    bne.b   l_20436
    cmpi.b  #$2, $3(a2)
    bls.b   l_20432
    moveq   #$0,d0
    move.b  $3(a2), d0
    addi.w  #$ffff, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $3(a2), d0
    bge.b   l_203fe
    addq.l  #$1, d0
l_203fe:
    asr.l   #$1, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    ble.b   l_2041a
    moveq   #$0,d0
    move.b  $3(a2), d0
    bge.b   l_20414
    addq.l  #$1, d0
l_20414:
    asr.l   #$1, d0
    ext.l   d0
    bra.b   l_2041e
l_2041a:
    moveq   #$0,d0
    move.w  d2, d0
l_2041e:
    move.w  d0, d2
    cmpi.w  #$1, d2
    bls.b   l_2042c
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_2042e
l_2042c:
    moveq   #$1,d0
l_2042e:
    move.w  d0, d2
    bra.b   l_2043c
l_20432:
    moveq   #$1,d2
    bra.b   l_2043c
l_20436:
    moveq   #$0,d2
    move.b  $3(a2), d2
l_2043c:
    move.w  d2, d0
    movem.l -$10(a6), d2-d3/a2-a3
    unlk    a6
    rts
