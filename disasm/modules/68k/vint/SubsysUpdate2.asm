; ============================================================================
; SubsysUpdate2 -- Process directional input to scroll the display with acceleration and deceleration
; 264 bytes | $00175C-$001863
; ============================================================================
SubsysUpdate2:
    btst    #$0, $c6c(a5)
    beq.w   l_01862
    moveq   #$0,d2
    movea.l  #$00FFFC06,a0
    moveq   #$7,d5
l_01770:
    cmpi.w  #$2, (a0)
    bcc.b   l_0177c
    move.w  $2(a0), d0
    or.w    d0, d2
l_0177c:
    adda.l  #$a, a0
    dbra    d5, $1770
    move.w  d2, d0
    andi.w  #$f00, d0
    bne.b   l_01794
    move.w  #$20, $c6e(a5)
l_01794:
    cmpi.w  #$0, $c6e(a5)
    beq.b   l_017bc
    subq.w  #$1, $c6e(a5)
    cmpi.w  #$10, $c6e(a5)
    bcs.b   l_017ae
    moveq   #-$1,d3
    moveq   #$1,d4
    bra.b   l_017c8
l_017ae:
    moveq   #-$2,d3
    moveq   #$2,d4
    sub.w   $c5a(a5), d3
    add.w   $c5a(a5), d4
    bra.b   l_017c8
l_017bc:
    moveq   #-$3,d3
    moveq   #$3,d4
    sub.w   $c5a(a5), d3
    add.w   $c5a(a5), d4
l_017c8:
    btst    #$8, d2
    beq.b   l_017e2
    move.w  d3, d1
    add.w   $c5e(a5), d1
    cmp.w   $c54(a5), d1
    bgt.b   l_017de
    move.w  $c54(a5), d1
l_017de:
    move.w  d1, $c5e(a5)
l_017e2:
    btst    #$9, d2
    beq.b   l_017fc
    move.w  d4, d1
    add.w   $c5e(a5), d1
    cmp.w   $c58(a5), d1
    ble.b   l_017f8
    move.w  $c58(a5), d1
l_017f8:
    move.w  d1, $c5e(a5)
l_017fc:
    btst    #$a, d2
    beq.b   l_01816
    move.w  d3, d0
    add.w   $c5c(a5), d0
    cmp.w   $c52(a5), d0
    bgt.b   l_01812
    move.w  $c52(a5), d0
l_01812:
    move.w  d0, $c5c(a5)
l_01816:
    btst    #$b, d2
    beq.b   l_01830
    move.w  d4, d0
    add.w   $c5c(a5), d0
    cmp.w   $c56(a5), d0
    ble.b   l_0182c
    move.w  $c56(a5), d0
l_0182c:
    move.w  d0, $c5c(a5)
l_01830:
    btst    #$c, d2
    beq.b   l_0183c
    bset    #$1, $c60(a5)
l_0183c:
    move.w  d2, d0
    andi.w  #$6000, d0
    beq.b   l_0184a
    bset    #$0, $c60(a5)
l_0184a:
    btst    #$4, d2
    beq.b   l_01856
    bset    #$1, $c61(a5)
l_01856:
    andi.w  #$60, d2
    beq.b   l_01862
    bset    #$0, $c61(a5)
l_01862:
    rts
