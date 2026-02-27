; ============================================================================
; SetSubstituteFlag -- Sets bit 1 of the flags byte ($A) in a character slot record (marks char as substitute)
; 56 bytes | $0335D4-$03360B
; ============================================================================
SetSubstituteFlag:
    link    a6,#$0
    move.w  $a(a6), d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    move.b  $a(a1), d0
    andi.l  #$2, d0
    bne.b   l_33608
    ori.b   #$2, $a(a1)
l_33608:
    unlk    a6
    rts
