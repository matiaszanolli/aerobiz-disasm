; ============================================================================
; ReadMultiNibbles -- Read up to three nibble pairs from port via TH toggle, detect protocol type
; 130 bytes | $001A20-$001AA1
; ============================================================================
ReadMultiNibbles:
l_01a20:
    move.b  #$40, $6(a0)
    moveq   #$2,d3
l_01a28:
    move.l  d1, d0
    andi.b  #$f, d0
    beq.b   l_01a56
    move.b  #$40, (a0)
    nop
    nop
    nop
    nop
    moveq   #$0,d1
    move.b  (a0), d1
    move.b  #$0, (a0)
    nop
    nop
    nop
    nop
    swap    d1
    move.b  (a0), d1
    dbra    d3, $1A28
    bra.b   l_019ee
l_01a56:
    move.b  #$40, (a0)
    nop
    nop
    nop
    nop
    moveq   #$0,d2
    move.b  (a0), d2
    move.b  #$0, (a0)
    nop
    nop
    nop
    nop
    swap    d2
    move.b  (a0), d2
    move.w  #$1, (a1)+
    move.w  d1, d0
    swap    d1
    asl.b   #$2, d0
    andi.w  #$c0, d0
    andi.w  #$3f, d1
    or.b    d1, d0
    not.b   d0
    bsr.b   $1A14
    swap    d2
    move.w  d2, d0
    not.b   d0
    andi.w  #$f, d0
    bsr.w XorAndUpdate
    lea     $4(a1), a1
    rts
