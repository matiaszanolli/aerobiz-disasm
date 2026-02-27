; ============================================================================
; UpdatePlayerAssets -- Calls CalcPlayerFinances then compares loan balance to repayment capacity; formats a debt/payment/balance message via sprintf and calls ShowText to report financial standing
; 422 bytes | $018D14-$018EB9
; ============================================================================
UpdatePlayerAssets:
    link    a6,#-$AC
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $8(a6), d3
    lea     -$ac(a6), a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    pea     -$c(a6)
    pea     -$8(a6)
    pea     -$4(a6)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcPlayerFinances
    lea     $10(a7), a7
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, d2
    movea.l  #$00FF09A2,a0
    tst.l   (a0,d0.w)
    beq.w   l_18eb0
    movea.l  #$00FF09A2,a0
    lea     (a0,d2.w), a2
    movea.l a2, a0
    addq.l  #$4, a0
    movea.l a0, a3
    move.l  (a0), d0
    cmp.l   (a2), d0
    bcc.w   l_18e2e
    movea.l  #$00FF09A2,a0
    move.l  (a0,d2.w), d0
    movea.l  #$00FF09A6,a0
    sub.l   (a0,d2.w), d0
    move.l  d0, d2
    cmp.l   -$c(a6), d2
    blt.b   l_18dc0
    move.l  d2, -(a7)
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CB0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0003).w
    bra.w   l_18ea6
l_18dc0:
    move.l  d2, d0
    moveq   #$64,d1
    jsr Multiply32
    move.l  -$c(a6), d1
    jsr SignedDiv
    move.w  d0, d4
    tst.w   d4
    ble.b   l_18e12
    cmpi.w  #$64, d4
    bge.b   l_18e12
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  d2, -(a7)
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CAC).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $14(a7), a7
    cmpi.w  #$1e, d4
    blt.b   l_18e0a
    moveq   #$1,d0
    bra.b   l_18e0c
l_18e0a:
    moveq   #$0,d0
l_18e0c:
    move.l  d0, -(a7)
    bra.w   l_18ea0
l_18e12:
    move.l  d2, -(a7)
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CB0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.b   l_18e9e
l_18e2e:
    movea.l  #$00FF09A2,a0
    lea     (a0,d2.w), a0
    movea.l a0, a2
    move.l  (a0), d0
    cmp.l   (a3), d0
    bne.b   l_18e4e
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CD0).l, -(a7)
    bra.b   l_18e92
l_18e4e:
    move.l  (a3), d2
    sub.l   (a2), d2
    move.l  d2, -(a7)
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CB4).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0002).w
    move.l  a5, -(a7)
    pea     ($0002).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowText
    lea     $20(a7), a7
    tst.l   $6(a4)
    bge.b   l_18eb0
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CB8).l, -(a7)
l_18e92:
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
l_18e9e:
    clr.l   -(a7)
l_18ea0:
    move.l  a5, -(a7)
    pea     ($0002).w
l_18ea6:
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowText
l_18eb0:
    movem.l -$c8(a6), d2-d4/a2-a5
    unlk    a6
    rts
