; ============================================================================
; WritePortToggle -- Toggle TH line, combine high/low nibbles, and update input state slot
; 44 bytes | $0019E8-$001A13
; ============================================================================
WritePortToggle:
l_019e8:
    move.w  #$f, (a1)+
    bra.b   l_019f0
l_019ee:
    clr.w   (a1)+
l_019f0:
    move.b  #$40, $6(a0)
    move.w  d1, d0
    swap    d1
    move.b  #$40, (a0)
    asl.b   #$2, d0
    andi.w  #$c0, d0
    andi.w  #$3f, d1
    or.b    d1, d0
    not.b   d0
    bsr.b   $1A14
    lea     $6(a1), a1
    rts
