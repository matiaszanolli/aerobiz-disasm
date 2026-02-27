; ============================================================================
; SkipControlChars -- Scans a string pointer counting printable characters while advancing past ESC control sequences (=, R, E, P, G, W, M codes); returns printable count in D0
; 96 bytes | $03AC52-$03ACB1
; ============================================================================
SkipControlChars:
    move.l  d2, -(a7)
    movea.l $8(a7), a0
    clr.w   d2
l_3ac5a:
    cmpi.b  #$20, (a0)
    beq.b   l_3acac
    cmpi.b  #$a, (a0)
    beq.b   l_3acac
    tst.b   (a0)
    beq.b   l_3acac
    cmpi.b  #$1b, (a0)
    bne.b   l_3aca6
    addq.l  #$1, a0
    moveq   #$0,d0
    move.b  (a0), d0
    moveq   #$3D,d1
    cmp.b   d1, d0
    beq.b   l_3acac
    moveq   #$57,d1
    cmp.b   d1, d0
    beq.b   l_3acac
    moveq   #$4D,d1
    cmp.b   d1, d0
    beq.b   l_3acac
    moveq   #$52,d1
    cmp.b   d1, d0
    beq.b   l_3aca2
    moveq   #$45,d1
    cmp.b   d1, d0
    beq.b   l_3aca2
    moveq   #$50,d1
    cmp.b   d1, d0
    beq.b   l_3aca2
    moveq   #$47,d1
    cmp.b   d1, d0
    beq.b   l_3aca8
    bra.b   l_3aca8
l_3aca2:
    addq.l  #$1, a0
    bra.b   l_3aca8
l_3aca6:
    addq.w  #$1, d2
l_3aca8:
    addq.l  #$1, a0
    bra.b   l_3ac5a
l_3acac:
    move.w  d2, d0
    move.l  (a7)+, d2
    rts
