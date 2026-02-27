; ============================================================================
; ValidateCharPool -- Counts chars in the active pool matching a target tier; returns count of qualifying chars
; 356 bytes | $036D76-$036ED9
; ============================================================================
ValidateCharPool:
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $30(a7), d3
    move.l  $28(a7), d5
    clr.w   d4
    move.w  $2e(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    tst.w   d3
    bne.b   l_36d9e
    clr.w   d7
    bra.b   l_36daa
l_36d9e:
    cmpi.w  #$1, d3
    bne.b   l_36da8
    moveq   #$3,d7
    bra.b   l_36daa
l_36da8:
    moveq   #$2,d7
l_36daa:
    moveq   #$0,d3
    move.b  (a1), d3
    moveq   #$0,d6
    move.w  d3, d6
    move.l  d6, d0
    add.l   d6, d6
    add.l   d0, d6
    add.l   d6, d6
    bra.b   l_36e28
l_36dbc:
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    tst.b   (a0,d0.w)
    beq.b   l_36e24
    movea.l  #$00FF1704,a0
    lea     (a0,d6.w), a2
    movea.l  #$00FF0420,a0
    lea     (a0,d6.w), a3
    clr.w   d2
l_36de8:
    cmpi.b  #$f, (a2)
    beq.b   l_36e18
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_36e18
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmp.w   d7, d0
    bne.b   l_36e18
    addq.w  #$1, d4
l_36e18:
    addq.l  #$1, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    bcs.b   l_36de8
l_36e24:
    addq.l  #$6, d6
    addq.w  #$1, d3
l_36e28:
    moveq   #$0,d0
    move.b  (a1), d0
    moveq   #$0,d1
    move.b  $1(a1), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_36dbc
    moveq   #$0,d3
    move.b  $2(a1), d3
    bra.b   l_36eba
l_36e44:
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    tst.b   (a0,d0.w)
    beq.b   l_36eb8
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
l_36e7c:
    cmpi.b  #$f, (a2)
    beq.b   l_36eac
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_36eac
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmp.w   d7, d0
    bne.b   l_36eac
    addq.w  #$1, d4
l_36eac:
    addq.l  #$1, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_36e7c
l_36eb8:
    addq.w  #$1, d3
l_36eba:
    moveq   #$0,d0
    move.b  $2(a1), d0
    moveq   #$0,d1
    move.b  $3(a1), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.w   l_36e44
    move.w  d4, d0
    movem.l (a7)+, d2-d7/a2-a4
    rts
