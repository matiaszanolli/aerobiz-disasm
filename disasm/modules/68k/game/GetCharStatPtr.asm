; ============================================================================
; GetCharStatPtr -- Returns stat multiplier tier (30/35/50/100/150/200) based on CharCodeCompare score
; 114 bytes | $036050-$0360C1
; ============================================================================
GetCharStatPtr:
    link    a6,#$0
    movem.l d2-d3, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    move.w  d0, d3
    cmpi.w  #$3200, d3
    bls.b   l_3607a
    moveq   #$1E,d2
    bra.b   l_360a8
l_3607a:
    cmpi.w  #$1900, d3
    bls.b   l_36084
    moveq   #$23,d2
    bra.b   l_360a8
l_36084:
    cmpi.w  #$c80, d3
    bls.b   l_3608e
    moveq   #$32,d2
    bra.b   l_360a8
l_3608e:
    cmpi.w  #$640, d3
    bls.b   l_36098
    moveq   #$64,d2
    bra.b   l_360a8
l_36098:
    cmpi.w  #$320, d3
    bls.b   l_360a4
    move.w  #$96, d2
    bra.b   l_360a8
l_360a4:
    move.w  #$c8, d2
l_360a8:
    cmpi.w  #$1e, d2
    ble.b   l_360b4
    move.w  d2, d0
    ext.l   d0
    bra.b   l_360b6
l_360b4:
    moveq   #$1E,d0
l_360b6:
    move.w  d0, d2
    movem.l -$8(a6), d2-d3
    unlk    a6
    rts
