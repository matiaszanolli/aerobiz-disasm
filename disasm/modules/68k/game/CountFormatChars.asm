; ============================================================================
; CountFormatChars -- Counts printable (non-escape-sequence) characters in a formatted string, skipping ESC control sequences; returns character count in D0
; 86 bytes | $03AB50-$03ABA5
; ============================================================================
CountFormatChars:
    move.l  d2, -(a7)
    clr.w   d2
    movea.l $8(a7), a0
    bra.b   l_3ab9c
l_3ab5a:
    cmpi.b  #$1b, (a0)
    bne.b   l_3ab98
    addq.l  #$1, a0
    moveq   #$0,d0
    move.b  (a0), d0
    moveq   #$3D,d1
    cmp.b   d1, d0
    beq.b   l_3ab92
    moveq   #$52,d1
    cmp.b   d1, d0
    beq.b   l_3ab94
    moveq   #$45,d1
    cmp.b   d1, d0
    beq.b   l_3ab94
    moveq   #$50,d1
    cmp.b   d1, d0
    beq.b   l_3ab94
    moveq   #$47,d1
    cmp.b   d1, d0
    beq.b   l_3ab9a
    moveq   #$57,d1
    cmp.b   d1, d0
    beq.b   l_3ab9a
    moveq   #$4D,d1
    cmp.b   d1, d0
    beq.b   l_3ab9a
    bra.b   l_3ab9a
l_3ab92:
    addq.l  #$1, a0
l_3ab94:
    addq.l  #$1, a0
    bra.b   l_3ab9a
l_3ab98:
    addq.w  #$1, d2
l_3ab9a:
    addq.l  #$1, a0
l_3ab9c:
    tst.b   (a0)
    bne.b   l_3ab5a
    move.w  d2, d0
    move.l  (a7)+, d2
    rts
