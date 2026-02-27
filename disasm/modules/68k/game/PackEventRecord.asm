; ============================================================================
; PackEventRecord -- Builds a compact byte list of city indices or route IDs affected by a scheduled event record based on the event type, and returns the count.
; 270 bytes | $028DB0-$028EBD
; ============================================================================
PackEventRecord:
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $14(a7), d3
    movea.l $18(a7), a2
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$0005FAB6,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    movea.l a0, a3
    cmpi.b  #$1, $4(a3)
    beq.b   l_28de0
    cmpi.b  #$2, $4(a3)
    bne.w   l_28e66
l_28de0:
    moveq   #$1,d2
    cmpi.b  #$34, $5(a3)
    bne.b   l_28df2
    move.b  #$1f, (a2)
    bra.w   l_28eb6
l_28df2:
    cmpi.b  #$1d, $5(a3)
    bne.b   l_28e02
    move.b  #$35, (a2)
    bra.w   l_28eb6
l_28e02:
    cmpi.b  #$16, $5(a3)
    bne.b   l_28e12
    move.b  #$7, (a2)
    bra.w   l_28eb6
l_28e12:
    cmpi.b  #$1f, $5(a3)
    bne.b   l_28e22
    move.b  #$a, (a2)
    bra.w   l_28eb6
l_28e22:
    cmpi.b  #$19, $5(a3)
    bne.b   l_28e32
    move.b  #$33, (a2)
    bra.w   l_28eb6
l_28e32:
    cmpi.b  #$1b, $5(a3)
    bne.b   l_28e40
    move.b  #$34, (a2)
    bra.b   l_28eb6
l_28e40:
    cmpi.b  #$20, $5(a3)
    bne.b   l_28e58
    moveq   #$3,d2
    move.b  #$b, (a2)+
    move.b  #$38, (a2)+
    move.b  #$39, (a2)
    bra.b   l_28eb6
l_28e58:
    cmpi.b  #$17, $5(a3)
    bne.b   l_28eb6
    move.b  #$31, (a2)
    bra.b   l_28eb6
l_28e66:
    cmpi.b  #$4, $4(a3)
    bne.b   l_28e8e
    movea.l  #$00FF1298,a3
    clr.w   d2
    clr.w   d3
l_28e78:
    cmpi.b  #$9, (a3)
    bne.b   l_28e82
    move.b  d3, (a2)+
    addq.w  #$1, d2
l_28e82:
    addq.l  #$4, a3
    addq.w  #$1, d3
    cmpi.w  #$59, d3
    bcs.b   l_28e78
    bra.b   l_28eb6
l_28e8e:
    clr.w   d2
    movea.l a1, a3
    move.w  d3, d1
    bra.b   l_28eb0
l_28e96:
    cmp.w   d3, d1
    beq.b   l_28ea6
    cmp.w   d3, d1
    bls.b   l_28eb6
    cmpi.b  #$ff, $4(a3)
    bne.b   l_28eb6
l_28ea6:
    move.b  $5(a3), (a2)+
    addq.w  #$1, d2
    addq.l  #$8, a3
    addq.w  #$1, d1
l_28eb0:
    cmpi.w  #$37, d1
    bcs.b   l_28e96
l_28eb6:
    move.w  d2, d0
    movem.l (a7)+, d2-d3/a2-a3
    rts
