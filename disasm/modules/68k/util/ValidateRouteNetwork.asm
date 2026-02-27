; ============================================================================
; ValidateRouteNetwork -- Formats a two-city confirmation message and shows a yes/no dialog; returns 1 if the player confirmed, 0 otherwise.
; 96 bytes | $02A07E-$02A0DD
; ============================================================================
ValidateRouteNetwork:
    link    a6,#-$84
    move.l  d2, -(a7)
    move.w  $e(a6), d0
    lsl.w   #$2, d0
    movea.l  #$000483B8,a0
    move.l  (a0,d0.w), -(a7)
    move.w  $12(a6), d0
    lsl.w   #$2, d0
    movea.l  #$000483A4,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$80(a6)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$80(a6)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    cmpi.w  #$1, d0
    bne.b   l_2a0d2
    moveq   #$1,d2
    bra.b   l_2a0d4
l_2a0d2:
    clr.w   d2
l_2a0d4:
    move.w  d2, d0
    move.l  -$88(a6), d2
    unlk    a6
    rts
