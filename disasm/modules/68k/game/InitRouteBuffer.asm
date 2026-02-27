; ============================================================================
; InitRouteBuffer -- Populates the $FF9A10 route-summary buffer from a caller-supplied revenue array; sums positive revenue and counts active slots for three bucket groups.
; 144 bytes | $013E62-$013EF1
; ============================================================================
InitRouteBuffer:
    movem.l d2-d4/a2-a5, -(a7)
    movea.l $24(a7), a5
    clr.w   d4
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($00FF9A10).l
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF9A10,a3
    clr.w   d3
l_13e8a:
    tst.w   d3
    bne.b   l_13e92
    clr.w   d2
    bra.b   l_13e9e
l_13e92:
    cmpi.w  #$1, d3
    bne.b   l_13e9c
    moveq   #$3,d2
    bra.b   l_13e9e
l_13e9c:
    moveq   #$2,d2
l_13e9e:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005F908,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d2
    move.b  (a4), d2
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    lea     (a5,d0.l), a0
    movea.l a0, a2
    bra.b   l_13ed2
l_13ec0:
    tst.w   (a2)
    ble.b   l_13ece
    move.w  (a2), d0
    add.w   d0, (a3)
    addq.w  #$1, $2(a3)
    moveq   #$1,d4
l_13ece:
    addq.l  #$2, a2
    addq.w  #$1, d2
l_13ed2:
    move.w  d2, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    cmp.l   d1, d0
    ble.b   l_13ec0
    addq.l  #$4, a3
    addq.w  #$1, d3
    cmpi.w  #$3, d3
    blt.b   l_13e8a
    move.w  d4, d0
    movem.l (a7)+, d2-d4/a2-a5
    rts
