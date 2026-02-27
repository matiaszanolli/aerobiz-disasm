; ============================================================================
; ClearSubstituteFlag -- Clears bit 1 of the flags byte ($A) in a character slot record (marks char as no longer a substitute)
; 54 bytes | $03359E-$0335D3
; ============================================================================
ClearSubstituteFlag:
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
    btst    #$1, d0
    beq.b   l_335d0
    moveq   #$2,d0
    eor.b   d0, $a(a1)
l_335d0:
    unlk    a6
    rts
