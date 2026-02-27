; ============================================================================
; GetActiveCharCount -- Returns 1 if the given char-type pair has a non-zero stamina byte in the alliance table, else 0
; 38 bytes | $0339B6-$0339DB
; ============================================================================
GetActiveCharCount:
    move.l  d2, -(a7)
    clr.w   d2
    move.w  $12(a7), d0
    lsl.w   #$3, d0
    move.w  $a(a7), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    tst.b   (a0,d0.w)
    bne.b   l_339d6
    moveq   #$1,d2
l_339d6:
    move.w  d2, d0
    move.l  (a7)+, d2
    rts
