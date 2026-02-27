; ============================================================================
; IsCharAttrValid -- Validates that a character type's attributes are usable; checks both primary and secondary attribute byte ranges against the $FF09D8 table, returning 1 if all non-zero.
; 130 bytes | $0131DA-$01325B
; ============================================================================
IsCharAttrValid:
    movem.l d2-d4/a2, -(a7)
    moveq   #$1,d1
    move.w  $16(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    movea.l a0, a2
    move.b  (a0), d3
    andi.l  #$ff, d3
    moveq   #$0,d4
    move.b  $1(a1), d4
    clr.w   d2
    bra.b   l_1321e
l_13206:
    movea.l  #$00FF09D8,a0
    move.b  (a0,d3.w), d0
    andi.b  #$3, d0
    beq.b   l_1321a
    clr.w   d1
    bra.b   l_13222
l_1321a:
    addq.w  #$1, d2
    addq.w  #$1, d3
l_1321e:
    cmp.w   d4, d2
    blt.b   l_13206
l_13222:
    cmpi.w  #$1, d1
    bne.b   l_13254
    moveq   #$0,d3
    move.b  $2(a2), d3
    moveq   #$0,d4
    move.b  $3(a2), d4
    clr.w   d2
    bra.b   l_13250
l_13238:
    movea.l  #$00FF09D8,a0
    move.b  (a0,d3.w), d0
    andi.b  #$3, d0
    beq.b   l_1324c
    clr.w   d1
    bra.b   l_13254
l_1324c:
    addq.w  #$1, d2
    addq.w  #$1, d3
l_13250:
    cmp.w   d4, d2
    blt.b   l_13238
l_13254:
    move.w  d1, d0
    movem.l (a7)+, d2-d4/a2
    rts
