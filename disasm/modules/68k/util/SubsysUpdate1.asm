; ============================================================================
; SubsysUpdate1 -- Update scroll position from velocity for each active display object, clamped to bounds
; 136 bytes | $0016D4-$00175B
; ============================================================================
SubsysUpdate1:
    movea.l  #$00FFF010,a5
    move.w  $c5a(a5), d4
    eori.w  #$3, d4
    move.w  #$0, $c60(a5)
    movea.l  #$00FFFC06,a0
    moveq   #$7,d5
l_016f0:
    cmpi.w  #$2, (a0)
    bne.b   l_01750
    move.w  $6(a0), d0
    ext.l   d0
    divs.w  d4, d0
    add.w   $c5c(a5), d0
    cmp.w   $c52(a5), d0
    bgt.b   l_0170e
    move.w  $c52(a5), d0
    bra.b   l_01718
l_0170e:
    cmp.w   $c56(a5), d0
    ble.b   l_01718
    move.w  $c56(a5), d0
l_01718:
    move.w  d0, $c5c(a5)
    move.w  $8(a0), d1
    ext.l   d1
    divs.w  d4, d1
    add.w   $c5e(a5), d1
    cmp.w   $c54(a5), d1
    bgt.b   l_01734
    move.w  $c54(a5), d1
    bra.b   l_0173e
l_01734:
    cmp.w   $c58(a5), d1
    ble.b   l_0173e
    move.w  $c58(a5), d1
l_0173e:
    move.w  d1, $c5e(a5)
    move.w  $2(a0), d2
    asr.w   #$4, d2
    andi.w  #$f0f, d2
    or.w    d2, $c60(a5)
l_01750:
    adda.l  #$a, a0
    dbra    d5, $16F0
    rts
