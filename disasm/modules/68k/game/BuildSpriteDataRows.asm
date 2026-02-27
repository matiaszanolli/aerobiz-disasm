; ============================================================================
; BuildSpriteDataRows -- Build sprite attribute table rows from source data with Y/link/attr/X layout
; 80 bytes | $004B1C-$004B6B
; ============================================================================
BuildSpriteDataRows:
    movem.l d2-d5, -(a7)
    move.l  $18(a7), d1
    move.l  $1c(a7), d0
    movea.l $20(a7), a1
    movea.l $14(a7), a0
    clr.w   d4
    bra.b   l_04b62
l_04b34:
    clr.w   d2
    moveq   #$0,d5
    move.w  d4, d5
    lsl.l   #$3, d5
    addi.l  #$80, d5
    moveq   #$0,d3
    move.w  d2, d3
    lsl.l   #$3, d3
    addi.l  #$80, d3
    bra.b   l_04b5c
l_04b50:
    move.w  d5, (a1)+
    clr.w   (a1)+
    move.w  (a0)+, (a1)+
    move.w  d3, (a1)+
    addq.l  #$8, d3
    addq.w  #$1, d2
l_04b5c:
    cmp.w   d1, d2
    bcs.b   l_04b50
    addq.w  #$1, d4
l_04b62:
    cmp.w   d0, d4
    bcs.b   l_04b34
    movem.l (a7)+, d2-d5
    rts
