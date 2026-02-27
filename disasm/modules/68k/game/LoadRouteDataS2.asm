; ============================================================================
; LoadRouteDataS2 -- For each of the seven route-type slots calls BitFieldSearch to find available chars and, if 1-3 are found, shows a dialog reporting how many chars are available on the new route.
; 346 bytes | $02A7C8-$02A921
; ============================================================================
LoadRouteDataS2:
    link    a6,#-$88
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $8(a6), d5
    lea     -$88(a6), a4
    movea.l  #$00FF00A8,a5
    clr.w   d4
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
.l2a7f0:
    clr.w   d3
    pea     ($0008).w
    clr.l   -(a7)
    pea     -$8(a6)
    jsr MemFillByte
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    lea     $14(a7), a7
    cmpi.w  #$20, d0
    bge.b   .l2a838
    clr.w   d2
    movea.l  #$00FF099C,a0
    lea     (a0,d2.w), a0
    movea.l a0, a2
.l2a82c:
    cmp.w   d5, d2
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   .l2a82c
.l2a838:
    tst.w   d3
    beq.w   .l2a90c
    cmpi.w  #$4, d3
    bcc.w   .l2a90c
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    beq.b   .l2a882
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    lea     $c(a7), a7
    jsr ResourceUnload
.l2a882:
    cmpi.w  #$1, d3
    bne.b   .l2a8aa
    move.l  (a3), -(a7)
    moveq   #$0,d0
    move.w  -$8(a6), d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    pea     ($0004219C).l
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.b   .l2a8f2
.l2a8aa:
    cmpi.w  #$2, d3
    bne.b   .l2a8de
    move.l  (a3), -(a7)
    moveq   #$0,d0
    move.w  -$6(a6), d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    moveq   #$0,d0
    move.w  -$8(a6), d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    pea     ($0004217A).l
    move.l  a4, -(a7)
    jsr sprintf
    lea     $14(a7), a7
    bra.b   .l2a8f2
.l2a8de:
    move.l  (a3), -(a7)
    pea     ($00042152).l
    move.l  a4, -(a7)
    jsr sprintf
    lea     $c(a7), a7
.l2a8f2:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
.l2a90c:
    addq.l  #$4, a3
    addq.w  #$1, d4
    cmpi.w  #$7, d4
    bcs.w   .l2a7f0
    movem.l -$a8(a6), d2-d5/a2-a5
    unlk    a6
    rts
