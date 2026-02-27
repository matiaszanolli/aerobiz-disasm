; ============================================================================
; CmdInitCharTable -- GameCommand 31: init character table
; 124 bytes | $000A6C-$000AE7
; ============================================================================
CmdInitCharTable:
    moveq   #$0,d0
    move.b  d0, $2fb(a5)
    move.w  $2fc(a5), d5
    bne.b   l_00a92
    move.l  $16(a6), d2
    subq.w  #$1, d2
    move.b  d2, $2fe(a5)
    move.b  d0, $2ff(a5)
    move.l  $1a(a6), d2
    move.w  d2, $300(a5)
    move.w  d2, $302(a5)
l_00a92:
    move.l  $e(a6), d1
    move.l  d1, d3
    move.l  d1, d4
    lsl.l   #$7, d1
    movea.l  #$00FFF336,a0
    moveq   #$0,d2
    move.b  $2fe(a5), d2
    addq.w  #$1, d2
    lsl.l   #$5, d2
    subq.w  #$1, d2
    movea.l $22(a6), a1
l_00ab2:
    move.b  (a1)+, (a0,d1.w)
    addq.w  #$1, d1
    dbra    d2, $AB2
    lsl.l   #$1, d3
    move.l  $12(a6), d0
    lsl.l   #$5, d0
    movea.l  #$00FFF316,a0
    move.w  d0, (a0,d3.w)
    moveq   #$0,d0
    bset    d4, d0
    or.w    d0, d5
    move.w  d5, $2fc(a5)
    move.l  $1e(a6), d0
    move.w  d0, $304(a5)
    bset    #$0, $2fb(a5)
    rts
