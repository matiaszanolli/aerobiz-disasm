; ============================================================================
; PlaceIconPair -- Place a pair of icon tiles at given screen position, choosing tile set by flag
; Called: 8 times.
; 98 bytes | $0058FC-$00595D
; ============================================================================
PlaceIconPair:                                                  ; $0058FC
    link    a6,#-$4
    lea     -$0004(a6),a0
    move.w  #$8404,d1
    tst.w   $000a(a6)
    bne.b   .l5920
    move.w  d1,d0
    addi.w  #$011d,d0
    move.w  d0,-$0004(a6)
    move.w  d1,d0
    addi.w  #$011e,d0
    bra.b   .l5930
.l5920:                                                 ; $005920
    move.w  d1,d0
    addi.w  #$011f,d0
    move.w  d0,-$0004(a6)
    move.w  d1,d0
    addi.w  #$0120,d0
.l5930:                                                 ; $005930
    move.w  d0,$0002(a0)
    move.l  a0,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    unlk    a6
    rts
