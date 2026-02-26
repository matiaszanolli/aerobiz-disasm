; ===========================================================================
; ROM Data: $030000-$03FFFF
; 65536 bytes (32768 words)
; ===========================================================================

; === Translated block $030000-$03204A ===
; 10 functions, 8266 bytes

; ============================================================================
; func_030000 -- (TODO: name)
; 708 bytes | $030000-$0302C3
; ============================================================================
func_030000:
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a3
    bra.w   .l30144
.l30010:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$ff, d2
    bne.b   .l30092
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d4, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    beq.b   .l30092
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d7
    move.b  (a2), d7
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d7
    moveq   #$0,d3
    move.b  (a2), d3
    bra.b   .l3008e
.l3006c:
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   $1(a2)
    beq.b   .l3008c
    move.w  d3, d2
    bra.b   .l30092
.l3008c:
    addq.w  #$1, d3
.l3008e:
    cmp.w   d7, d3
    blt.b   .l3006c
.l30092:
    cmpi.w  #$ff, d2
    beq.w   .l30142
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  (a2), d0
    cmp.b   $1(a2), d0
    beq.w   .l30142
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, (a3)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$74F8                           ; jsr $0074F8
    addq.l  #$8, a7
    move.w  d0, d2
    tst.w   d2
    bne.b   .l30110
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    sub.w   d1, d0
    lsl.w   #$2, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    add.w   d1, d0
    add.w   d0, d0
    bra.b   .l30136
.l30110:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    ext.l   d1
    sub.l   d1, d0
    lsl.l   #$2, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    ext.l   d1
    add.l   d1, d0
    move.w  d2, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
.l30136:
    addi.w  #$64, d0
    move.w  d0, $2(a3)
    addq.l  #$4, a3
    addq.w  #$1, d6
.l30142:
    addq.w  #$1, d4
.l30144:
    cmpi.w  #$7, d4
    blt.w   .l30010
    move.w  d6, d0
    move.l  d0, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0001,$09FA                           ; jsr $0109FA
    addq.l  #$8, a7
    clr.w   d7
    clr.w   d3
    clr.w   d4
    movea.l a5, a2
    addq.l  #$8, a2
.l30164:
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d6
    tst.w   d4
    bne.b   .l30184
    move.w  -$1c(a6), d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.w   .l3026e
    bra.b   .l301b6
.l30184:
    move.w  (a2), d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   .l301a2
    pea     ($0001).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    tst.l   d0
    bne.b   .l301a2
    move.w  (a2), d6
.l301a2:
    move.w  d6, d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.b   .l301b6
    move.w  -$1c(a6), d6
    pea     ($0002).w
    bra.b   .l301ba
.l301b6:
    pea     ($0001).w
.l301ba:
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$052E                           ; jsr $01052E
    lea     $c(a7), a7
    move.w  d0, d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.w   .l30264
    pea     (-$1).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$00F2                           ; jsr $0100F2
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044768).l
    pea     -$15c(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     -$15c(a6)
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00047B80,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$bc(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     -$bc(a6)
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F97C                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    addq.w  #$1, d3
    moveq   #$1,d7
.l30264:
    addq.w  #$1, d4
    cmpi.w  #$2, d4
    blt.w   .l30164
.l3026e:
    move.w  d7, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0048                                 ; jsr $0302C4(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d7
    tst.w   d7
    bne.b   .l302b0
    clr.l   -(a7)
    move.l  ($00047B90).l, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F92E                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    bra.b   .l302ba
.l302b0:
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$01CA                           ; jsr $0101CA
.l302ba:
    movem.l -$184(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_0302C4 -- (TODO: name)
; 1012 bytes | $0302C4-$0306B7
; ============================================================================
func_0302C4:
    link    a6,#-$18C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$5CCC                           ; jsr $035CCC
    addq.l  #$4, a7
    move.w  d0, -$42(a6)
    clr.w   -$44(a6)
    clr.w   -$46(a6)
    clr.w   d3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    lea     -$24(a6), a5
    move.w  -$44(a6), d0
    lsl.w   #$2, d0
    lea     -$40(a6, d0.w), a0
    movea.l a0, a4
.l3030c:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$ff, d4
    bne.b   .l30384
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    beq.b   .l30384
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.w   d1, d0
    move.w  d0, -$48(a6)
    moveq   #$0,d2
    move.b  (a3), d2
    bra.b   .l3037e
.l3035c:
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   $1(a2)
    beq.b   .l3037c
    move.w  d2, d4
    bra.b   .l30384
.l3037c:
    addq.w  #$1, d2
.l3037e:
    cmp.w   -$48(a6), d2
    blt.b   .l3035c
.l30384:
    cmpi.w  #$ff, d4
    bne.w   .l30440
    pea     ($0008).w
    clr.l   -(a7)
    pea     -$8(a6)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    lea     $c(a7), a7
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.w   d1, d0
    move.w  d0, -$48(a6)
    moveq   #$0,d2
    move.b  (a3), d2
    bra.b   .l30422
.l303b6:
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  (a2), d4
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $2(a2), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    add.l   d1, d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    moveq   #$0,d1
    move.b  $1(a2), d1
    mulu.w  d1, d0
    move.w  d4, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    move.w  d0, -$2(a6)
    move.w  d2, -$4(a6)
    pea     ($0002).w
    pea     -$8(a6)
    dc.w    $4EB9,$0001,$09FA                           ; jsr $0109FA
    addq.l  #$8, a7
    addq.w  #$1, d2
.l30422:
    cmp.w   -$48(a6), d2
    blt.b   .l303b6
    tst.w   -$6(a6)
    beq.b   .l30460
    move.w  -$8(a6), (a4)
    move.w  -$6(a6), $2(a4)
    addq.l  #$4, a4
    addq.w  #$1, -$44(a6)
    bra.b   .l30460
.l30440:
    move.w  d4, (a5)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$74F8                           ; jsr $0074F8
    addq.l  #$8, a7
    move.w  d0, $2(a5)
    addq.l  #$4, a5
    addq.w  #$1, -$46(a6)
.l30460:
    addq.l  #$4, a3
    addq.w  #$1, d3
    cmpi.w  #$7, d3
    blt.w   .l3030c
    move.w  -$46(a6), d0
    move.l  d0, -(a7)
    pea     -$24(a6)
    dc.w    $4EB9,$0001,$09FA                           ; jsr $0109FA
    move.w  -$44(a6), d0
    move.l  d0, -(a7)
    pea     -$40(a6)
    dc.w    $4EB9,$0001,$09FA                           ; jsr $0109FA
    lea     $10(a7), a7
    clr.w   -$4a(a6)
    clr.w   d3
    bra.w   .l305aa
.l3049a:
    move.w  d2, d0
    lsl.w   #$2, d0
    move.w  -$24(a6, d0.w), d5
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    addq.l  #$8, a7
    move.w  d0, d4
    cmp.w   -$42(a6), d4
    bhi.w   .l3059e
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$957C                           ; jsr $00957C
    lea     $c(a7), a7
    cmpi.w  #$ff, d0
    bne.w   .l3059e
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$00F2                           ; jsr $0100F2
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004477A).l
    pea     -$18a(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     -$18a(a6)
    move.w  $e(a6), d0
    lsl.w   #$2, d0
    movea.l  #$00047B80,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$ea(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     -$ea(a6)
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F662                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    move.w  #$1, $12(a6)
    addq.w  #$1, $e(a6)
    cmpi.w  #$2, $e(a6)
    ble.b   .l305a8
    move.w  #$1, -$4a(a6)
    bra.b   .l305a8
.l30594:
    move.w  d3, d0
    lsl.w   #$2, d0
    move.w  -$24(a6, d0.w), d6
    move.w  d3, d2
.l3059e:
    addq.w  #$1, d2
    cmp.w   -$46(a6), d2
    blt.w   .l3049a
.l305a8:
    addq.w  #$1, d3
.l305aa:
    cmp.w   -$46(a6), d3
    bge.b   .l305b6
    tst.w   -$4a(a6)
    beq.b   .l30594
.l305b6:
    clr.w   -$4a(a6)
    clr.w   d2
    bra.w   .l3069c
.l305c0:
    move.w  d2, d0
    lsl.w   #$2, d0
    move.w  -$24(a6, d0.w), d6
    clr.w   d3
    bra.w   .l30692
.l305ce:
    move.w  d3, d0
    lsl.w   #$2, d0
    move.w  -$40(a6, d0.w), d5
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    addq.l  #$8, a7
    move.w  d0, d4
    cmp.w   -$42(a6), d4
    bhi.w   .l30690
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$00F2                           ; jsr $0100F2
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047B8C).l, -(a7)
    pea     -$ea(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    clr.l   -(a7)
    pea     -$ea(a6)
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F55A                                 ; bsr.w $02FBD6
    lea     $2c(a7), a7
    move.w  #$1, $12(a6)
    move.w  #$1, -$4a(a6)
    bra.b   .l3069a
.l30690:
    addq.w  #$1, d3
.l30692:
    cmp.w   -$44(a6), d3
    blt.w   .l305ce
.l3069a:
    addq.w  #$1, d2
.l3069c:
    cmp.w   -$46(a6), d2
    bge.b   .l306aa
    tst.w   -$4a(a6)
    beq.w   .l305c0
.l306aa:
    move.w  $12(a6), d0
    movem.l -$1b4(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_0306B8 -- (TODO: name)
; 324 bytes | $0306B8-$0307FB
; ============================================================================
func_0306B8:
    link    a6,#-$A0
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $8(a6), d2
    movea.l  #$0002FBD6,a3
    movea.l  #$00047B0C,a4
    clr.w   d4
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $4(a2), d0
    moveq   #$0,d1
    move.b  $5(a2), d1
    add.w   d1, d0
    cmpi.w  #$28, d0
    blt.w   .l307f0
    moveq   #$1,d4
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0002,$7184                           ; jsr $027184
    addq.l  #$4, a7
    move.w  d0, d3
    cmpi.w  #$6, d0
    bge.w   .l3079c
    clr.l   -(a7)
    move.l  $c(a4), -(a7)
    clr.l   -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    moveq   #$6,d0
    sub.w   d3, d0
    move.w  d0, d3
    cmpi.w  #$1, d3
    bne.b   .l30736
    pea     ($00044794).l
    bra.b   .l3073c
.l30736:
    pea     ($0004478C).l
.l3073c:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    cmpi.w  #$1, d3
    bne.b   .l30750
    pea     ($000447A0).l
    bra.b   .l30756
.l30750:
    pea     ($0004479C).l
.l30756:
    move.l  $18(a4), -(a7)
    pea     -$a0(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     -$a0(a6)
    clr.l   -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    lea     $18(a7), a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   .l30794
    clr.l   -(a7)
    move.l  $10(a4), -(a7)
    bra.b   .l307e6
.l30794:
    clr.l   -(a7)
    move.l  $14(a4), -(a7)
    bra.b   .l307e6
.l3079c:
    clr.l   -(a7)
    move.l  ($00047B0C).l, -(a7)
    pea     ($0001).w
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    lea     $18(a7), a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   .l307e0
    clr.l   -(a7)
    move.l  $c(a4), -(a7)
    clr.l   -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $10(a7), a7
    clr.l   -(a7)
    move.l  $8(a4), -(a7)
    clr.l   -(a7)
    bra.b   .l307ea
.l307e0:
    clr.l   -(a7)
    move.l  $4(a4), -(a7)
.l307e6:
    pea     ($0001).w
.l307ea:
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
.l307f0:
    move.w  d4, d0
    movem.l -$b8(a6), d2-d4/a2-a4
    unlk    a6
    rts

; ============================================================================
; func_0307FC -- (TODO: name)
; 536 bytes | $0307FC-$030A13
; ============================================================================
func_0307FC:
    link    a6,#-$F0
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    movea.l  #$000101CA,a3
    lea     -$a0(a6), a4
    movea.l  #$00047B94,a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01E0                                 ; jsr $030A14(pc)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    beq.w   .l30a0a
    moveq   #$0,d5
    move.b  $4(a2), d5
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d5
    tst.w   d2
    ble.w   .l309c8
    cmpi.w  #$1, d2
    bne.b   .l30864
    pea     ($000447BC).l
    bra.b   .l3086a
.l30864:
    pea     ($000447B4).l
.l3086a:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00047B94).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F34C                                 ; bsr.w $02FBD6
    lea     $20(a7), a7
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
    clr.w   d2
    bra.b   .l30904
.l308a8:
    moveq   #$0,d6
    move.w  $e(a2), d6
    moveq   #$0,d0
    move.w  $6(a2), d0
    sub.l   d0, d6
    tst.l   d6
    bge.b   .l308f0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0284                                 ; jsr $030B48(pc)
    nop
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0A48                                 ; jsr $03131A(pc)
    nop
    clr.l   -(a7)
    pea     ($0003).w
    dc.w    $4EB9,$0001,$D62C                           ; jsr $01D62C
    lea     $18(a7), a7
    cmpi.w  #$10, d0
    bne.b   .l308fe
    bra.w   .l30a04
.l308f0:
    move.w  d4, d0
    add.w   d0, d0
    lea     -$f0(a6), a0
    move.w  d2, (a0,d0.w)
    addq.w  #$1, d4
.l308fe:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
.l30904:
    cmp.w   d5, d2
    blt.b   .l308a8
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a3)
    addq.l  #$4, a7
    tst.w   d4
    ble.b   .l3098c
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    move.l  $14(a5), -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $18(a7), a7
    cmpi.w  #$1, d0
    bne.w   .l30a0a
    clr.w   d2
    move.w  d2, d0
    add.w   d0, d0
    lea     -$f0(a6), a0
    lea     (a0,d0.w), a1
    movea.l a1, a2
    bra.b   .l30986
.l3094e:
    move.w  (a2), d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01F0                                 ; jsr $030B48(pc)
    nop
    move.w  (a2), d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$09B4                                 ; jsr $03131A(pc)
    nop
    clr.l   -(a7)
    pea     ($0003).w
    dc.w    $4EB9,$0001,$D62C                           ; jsr $01D62C
    lea     $18(a7), a7
    cmpi.w  #$10, d0
    beq.w   .l30a04
    addq.l  #$2, a2
    addq.w  #$1, d2
.l30986:
    cmp.w   d4, d2
    blt.b   .l3094e
    bra.b   .l30a04
.l3098c:
    pea     ($000447A4).l
    move.l  $4(a5), -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     ($0002).w
    move.l  a4, -(a7)
    pea     ($0004).w
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F228                                 ; bsr.w $02FBD6
    clr.l   -(a7)
    move.l  $10(a5), -(a7)
    pea     ($0004).w
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F216                                 ; bsr.w $02FBD6
    lea     $2c(a7), a7
    bra.b   .l30a0a
.l309c8:
    clr.w   d2
    bra.b   .l30a00
.l309cc:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0172                                 ; jsr $030B48(pc)
    nop
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0936                                 ; jsr $03131A(pc)
    nop
    clr.l   -(a7)
    pea     ($0003).w
    dc.w    $4EB9,$0001,$D62C                           ; jsr $01D62C
    lea     $18(a7), a7
    cmpi.w  #$10, d0
    beq.b   .l30a04
    addq.w  #$1, d2
.l30a00:
    cmp.w   d5, d2
    blt.b   .l309cc
.l30a04:
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a3)
.l30a0a:
    movem.l -$114(a6), d2-d6/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_030A14 -- (TODO: name)
; 308 bytes | $030A14-$030B47
; ============================================================================
func_030A14:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    lea     $a(a6), a3
    movea.l  #$00047B94,a4
    movea.l  #$0001D6A4,a5
    move.w  (a3), d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d7
    move.b  $4(a2), d7
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d7
    tst.w   d7
    bne.b   .l30a74
    clr.l   -(a7)
    move.l  $c(a4), -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  (a3), d0
    move.l  d0, -(a7)
    dc.w    $6100,$F16E                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    moveq   #$1,d0
    bra.w   .l30b3e
.l30a74:
    move.w  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$00FF0121,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$2(a6)
    clr.w   d5
    clr.w   d4
    move.w  (a3), d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    bra.b   .l30ada
.l30aa6:
    addq.w  #$1, d4
    moveq   #$0,d2
    move.b  $b(a2), d2
    moveq   #$0,d6
    move.b  $3(a2), d6
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0064).w
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E11C                           ; jsr $01E11C
    lea     $c(a7), a7
    move.w  d0, d2
    cmp.w   -$2(a6), d2
    ble.b   .l30ad4
    addq.w  #$1, d5
.l30ad4:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d3
.l30ada:
    cmp.w   d7, d3
    blt.b   .l30aa6
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($0064).w
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E11C                           ; jsr $01E11C
    lea     $c(a7), a7
    cmpi.w  #$32, d0
    bls.b   .l30b3c
    cmpi.w  #$5, d4
    ble.b   .l30b20
    pea     ($0002).w
    move.l  $50(a4), -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  (a3), d0
    move.l  d0, -(a7)
    dc.w    $6100,$F0BC                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
.l30b20:
    pea     ($0002).w
    move.l  $54(a4), -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  (a3), d0
    move.l  d0, -(a7)
    dc.w    $6100,$F09C                                 ; bsr.w $02FBD6
.l30b3c:
    moveq   #$0,d0
.l30b3e:
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_030B48 -- (TODO: name)
; 328 bytes | $030B48-$030C8F
; ============================================================================
func_030B48:
    link    a6,#-$A0
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $8(a6), d3
    movea.l  #$0005E680,a3
    lea     -$a0(a6), a4
    movea.l  #$0001D6A4,a5
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$00F2                           ; jsr $0100F2
    addq.l  #$8, a7
    moveq   #$0,d2
    move.w  $e(a2), d2
    moveq   #$0,d0
    move.w  $6(a2), d0
    sub.l   d0, d2
    tst.l   d2
    bge.b   .l30bf2
    neg.l   d2
    move.l  d2, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    move.l  ($00047B2C).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $14(a7), a7
    bra.b   .l30c6e
.l30bf2:
    tst.l   d2
    ble.b   .l30c2a
    move.l  d2, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    move.l  ($00047B30).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $14(a7), a7
    pea     ($0001).w
    bra.b   .l30c70
.l30c2a:
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.b   .l30c86
    move.b  $a(a2), d0
    andi.l  #$4, d0
    bne.b   .l30c86
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    move.l  ($00047B34).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $10(a7), a7
.l30c6e:
    clr.l   -(a7)
.l30c70:
    move.l  a4, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$EF52                                 ; bsr.w $02FBD6
.l30c86:
    movem.l -$b8(a6), d2-d3/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_030C90 -- (TODO: name)
; 116 bytes | $030C90-$030D03
; ============================================================================
func_030C90:
    link    a6,#-$10
    movem.l d2-d5/a2, -(a7)
    move.l  $c(a6), d4
    move.l  $8(a6), d5
    lea     -$10(a6), a2
    moveq   #$0,d3
    move.b  ($00FF0016).l, d3
    pea     ($0010).w
    move.l  a2, -(a7)
    pea     ($00076ACE).l
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    clr.w   d2
.l30cc0:
    cmp.w   d2, d5
    beq.b   .l30cc8
    cmp.w   d2, d4
    bne.b   .l30ce2
.l30cc8:
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  d0, (a2,a0.l)
.l30ce2:
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   .l30cc0
    pea     ($0008).w
    pea     ($0038).w
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    movem.l -$24(a6), d2-d5/a2
    unlk    a6
    rts

; ============================================================================
; func_030D04 -- (TODO: name)
; 1558 bytes | $030D04-$031319
; ============================================================================
func_030D04:
    link    a6,#-$320
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    movea.l  #$00000D64,a3
    lea     -$17a(a6), a4
    movea.l  #$00FF13FC,a5
    clr.w   -$16c(a6)
    pea     ($000E).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FCCA                                 ; bsr.w $030A14
    lea     $10(a7), a7
    cmpi.w  #$1, d0
    beq.w   .l31310
    moveq   #$0,d2
    move.b  $4(a2), d2
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d2
    move.w  d7, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d5
    bra.w   .l30dfe
.l30d7e:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d3
    mulu.w  #$3c, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    lea     -$31e(a6), a0
    move.w  d5, (a0,d0.w)
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$8, a7
    move.w  d0, d4
    cmp.w   d4, d3
    beq.b   .l30df8
    move.w  d4, d0
    mulu.w  #$3c, d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    lea     -$31e(a6), a0
    move.w  d5, (a0,d0.w)
    move.w  d4, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)
.l30df8:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d5
.l30dfe:
    cmp.w   d2, d5
    blt.w   .l30d7e
    clr.l   -(a7)
    pea     ($000B).w
    pea     ($000B).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    move.l  ($00047B58).l, -(a7)
    pea     -$16a(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    pea     -$16a(a6)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    pea     ($0004A63A).l
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $2c(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0025).w
    pea     ($0330).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $1c(a7), a7
    pea     ($0004A5DA).l
    pea     ($0006).w
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($0015).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  ($00FF9A1C).l, d2
.l30ede:
    cmpi.w  #$7, d2
    blt.b   .l30ee6
    clr.w   d2
.l30ee6:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    tst.w   (a4,a0.l)
    bgt.b   .l30ef8
    addq.w  #$1, d2
    bra.b   .l30ede
.l30ef8:
    clr.w   d5
    moveq   #-$1,d3
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    lea     $28(a7), a7
    tst.w   d0
    beq.b   .l30f10
    moveq   #$1,d0
    bra.b   .l30f12
.l30f10:
    moveq   #$0,d0
.l30f12:
    move.w  d0, -$320(a6)
    clr.w   -$2(a6)
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    moveq   #$1,d6
.l30f24:
    tst.w   d6
    beq.w   .l310ba
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    pea     (-$1).w
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FD4A                                 ; bsr.w $030C90
    lea     $18(a7), a7
    pea     ($077E).w
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    pea     ($0013).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $2c(a7), a7
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECA0,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000447CA).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    move.w  d7, d0
    mulu.w  #$320, d0
    move.w  d2, d1
    mulu.w  #$3c, d1
    movea.l d7, a0
    move.w  d5, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    lea     -$31e(a6), a0
    move.w  (a0,d1.w), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d4
    move.b  $1(a2), d4
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    cmp.w   d2, d0
    beq.b   .l30ff2
    moveq   #$0,d4
    move.b  (a2), d4
    moveq   #$0,d3
    move.b  $1(a2), d3
.l30ff2:
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($0017).w
    pea     ($0015).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $30(a7), a7
    pea     ($0015).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000447C6).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($0015).w
    move.w  ($00FF128A).l, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    dc.w    $4EB9,$0000,$595E                           ; jsr $00595E
    pea     ($0015).w
    moveq   #$0,d0
    move.w  ($00FF128A).l, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000447C2).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $30(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $10(a7), a7
    move.w  d2, d0
    mulu.w  #$3c, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    lea     -$31e(a6), a0
    move.w  (a0,d0.w), d3
.l310ba:
    tst.w   -$320(a6)
    beq.b   .l310e0
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l310e0
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    clr.w   d6
    bra.w   .l30f24
.l310e0:
    clr.w   -$320(a6)
    clr.w   d6
    move.w  -$2(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    andi.w  #$3f, d0
    move.w  d0, -$2(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l31134
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   .l311e2
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   .l311f4
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   .l31214
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l31230
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l31256
    bra.w   .l31276
.l31134:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FA02                                 ; bsr.w $030B48
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01C8                                 ; jsr $03131A(pc)
    nop
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    lea     $14(a7), a7
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.l  (a7)+, d1
    cmp.w   d1, d0
    beq.b   .l31190
    pea     (-$1).w
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FB04                                 ; bsr.w $030C90
    addq.l  #$8, a7
.l31190:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($00047B58).l, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a3)
    lea     $20(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    bra.w   .l3127e
.l311e2:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  #$1, -$16c(a6)
    bra.w   .l3127e
.l311f4:
    move.w  #$1, (a5)
    moveq   #$1,d6
    subq.w  #$1, d5
    tst.w   d5
    bge.w   .l3127e
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d5
    addi.w  #$ffff, d5
    bra.b   .l3127e
.l31214:
    move.w  #$1, (a5)
    moveq   #$1,d6
    addq.w  #$1, d5
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    cmp.w   d5, d0
    bgt.b   .l3127e
.l3122c:
    clr.w   d5
    bra.b   .l3127e
.l31230:
    move.w  #$1, (a5)
    moveq   #$1,d6
    move.w  d2, d4
.l31238:
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   .l31242
    clr.w   d2
.l31242:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    tst.w   (a4,a0.l)
    ble.b   .l31238
.l31250:
    cmp.w   d2, d4
    beq.b   .l3127e
    bra.b   .l3122c
.l31256:
    move.w  #$1, (a5)
    moveq   #$1,d6
    move.w  d2, d4
.l3125e:
    subq.w  #$1, d2
    tst.w   d2
    bge.b   .l31266
    moveq   #$6,d2
.l31266:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    tst.w   (a4,a0.l)
    ble.b   .l3125e
    bra.b   .l31250
.l31276:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
.l3127e:
    cmpi.w  #$1, -$16c(a6)
    bne.w   .l30f24
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.l  ($000A1B28).l, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $2c(a7), a7
    pea     ($003E).w
    pea     ($0109).w
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    pea     ($000725D8).l
    pea     ($0008).w
    pea     ($0008).w
    pea     ($0008).w
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $30(a7), a7
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$01CA                           ; jsr $0101CA
.l31310:
    movem.l -$348(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03131A -- (TODO: name)
; 2986 bytes | $03131A-$031EC3
; ============================================================================
func_03131A:
    link    a6,#-$B8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    lea     -$ae(a6), a5
    move.w  d7, d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a4), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7610                           ; jsr $007610
    addq.l  #$8, a7
    move.w  d0, -$b6(a6)
    tst.w   $6(a4)
    beq.w   .l31dc6
    move.b  $a(a4), d0
    andi.l  #$2, d0
    bne.w   .l31dc6
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$70DC                           ; jsr $0070DC
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l313a4
    addq.l  #$1, d0
.l313a4:
    asr.l   #$1, d0
    move.w  d0, d3
    move.w  d2, d0
    add.w   d3, d0
    move.w  d0, -$6(a6)
    moveq   #$0,d0
    move.b  $1(a4), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    lea     $10(a7), a7
    move.w  d0, -$8(a6)
    clr.w   -$c(a6)
    clr.w   d6
    clr.w   d2
.l313e0:
    cmp.w   d7, d2
    beq.b   .l31442
    move.w  d2, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d5
    move.b  $4(a2), d5
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d5
    clr.w   d3
    bra.b   .l3143e
.l3141a:
    move.b  (a3), d0
    cmp.b   (a4), d0
    bne.b   .l3143c
    move.b  $1(a3), d0
    cmp.b   $1(a4), d0
    bne.b   .l3143c
    moveq   #$0,d0
    move.b  $3(a3), d0
    tst.w   d0
    ble.b   .l3143c
    addq.w  #$1, d6
    move.w  d2, -$e(a6)
    bra.b   .l31442
.l3143c:
    addq.w  #$1, d3
.l3143e:
    cmp.w   d5, d3
    blt.b   .l3141a
.l31442:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l313e0
    cmpi.w  #$1, d6
    bne.b   .l31478
    move.w  -$e(a6), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  ($00047BD0).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    bra.b   .l31486
.l31478:
    cmpi.w  #$2, d6
    blt.b   .l314a2
    clr.l   -(a7)
    move.l  ($00047BD4).l, -(a7)
.l31486:
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$E73A                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
.l314a2:
    move.l  a4, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0A1A                                 ; jsr $031EC4(pc)
    nop
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    mulu.w  #$a, d3
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0064).w
    move.w  $10(a4), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E11C                           ; jsr $01E11C
    lea     $18(a7), a7
    move.w  d0, -$b4(a6)
    cmpi.w  #$5c, -$b4(a6)
    blt.w   .l317e2
    move.w  $e(a4), d0
    cmp.w   $6(a4), d0
    bcs.w   .l31716
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    sub.w   d1, d0
    move.w  d0, -$2(a6)
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    cmp.w   -$2(a6), d2
    ble.b   .l3155a
    move.w  -$2(a6), d0
    bra.b   .l3155c
.l3155a:
    move.w  d2, d0
.l3155c:
    ext.l   d0
    move.w  d0, -$4(a6)
    move.b  $3(a4), d0
    cmp.b   $b(a4), d0
    bcc.b   .l315a0
    tst.w   -$4(a6)
    ble.b   .l315a0
    cmpi.b  #$e, $3(a4)
    bcc.b   .l315a0
    pea     ($000448B0).l
    move.l  ($00047BB0).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
    pea     ($0001).w
    move.l  a5, -(a7)
    pea     ($0002).w
    bra.w   .l31cd0
.l315a0:
    clr.w   d6
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    addq.l  #$4, a7
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    movea.l  #$00FFA6B8,a2
    moveq   #-$1,d5
    move.w  #$7530, -$b0(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    sub.l   d1, d0
    bge.b   .l315dc
    addq.l  #$3, d0
.l315dc:
    asr.l   #$2, d0
    move.w  d0, -$b2(a6)
    clr.w   d2
.l315e4:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$FEDA                           ; jsr $00FEDA
    addq.l  #$8, a7
    tst.w   d0
    beq.b   .l3162c
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d3, d0
    ble.b   .l3162c
    move.w  $2(a2), d0
    cmp.w   -$8(a6), d0
    bcs.b   .l3162c
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  -$b2(a6), d4
    sub.w   d0, d4
    tst.w   d4
    bge.b   .l3161e
    neg.w   d4
.l3161e:
    cmp.w   -$b0(a6), d4
    bge.b   .l3162c
    move.w  d4, -$b0(a6)
    move.w  d2, d5
    moveq   #$1,d6
.l3162c:
    addq.w  #$1, d2
    moveq   #$C,d0
    adda.l  d0, a2
    cmpi.w  #$10, d2
    blt.b   .l315e4
    cmpi.w  #$1, d6
    bne.w   .l316da
    cmpi.w  #$5f, -$b4(a6)
    blt.w   .l316da
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l3167a
    pea     ($0001).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    tst.l   d0
    bne.b   .l316b0
.l3167a:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000448A8).l
    move.l  ($00047BB4).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $10(a7), a7
    bra.b   .l316c0
.l316b0:
    pea     ($00044878).l
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    addq.l  #$8, a7
.l316c0:
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0002).w
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$E508                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
.l316da:
    move.w  $4(a4), d0
    cmp.w   -$6(a6), d0
    bcc.w   .l31ce2
    cmpi.w  #$62, -$b4(a6)
    blt.w   .l31ce2
    cmpi.w  #$1, d6
    bne.b   .l31702
.l316f6:
    clr.l   -(a7)
    move.l  ($00047BB8).l, -(a7)
    bra.w   .l31ccc
.l31702:
    move.l  ($00047BBC).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    addq.l  #$8, a7
    bra.w   .l31cc8
.l31716:
    clr.w   -$c(a6)
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$32DE                           ; jsr $0332DE
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$ff, d5
    beq.w   .l317ca
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l31770
    pea     ($0002).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    tst.l   d0
    beq.b   .l317a0
.l31770:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BC0).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
    bra.b   .l317b0
.l317a0:
    pea     ($0004483C).l
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    addq.l  #$8, a7
.l317b0:
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0001).w
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$E418                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
.l317ca:
    move.w  $4(a4), d0
    cmp.w   -$6(a6), d0
    bcc.w   .l31ce2
    cmpi.w  #$ff, d5
    bne.w   .l316f6
    bra.w   .l31702
.l317e2:
    move.w  $e(a4), d0
    cmp.w   $6(a4), d0
    bcc.w   .l318ac
    cmpi.w  #$2, -$b6(a6)
    blt.w   .l3187c
    cmpi.w  #$3, -$b6(a6)
    bne.b   .l3182a
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BF4).l, -(a7)
    bra.b   .l31852
.l3182a:
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047C04).l, -(a7)
.l31852:
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     ($0002).w
    move.l  a5, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$E360                                 ; bsr.w $02FBD6
    lea     $20(a7), a7
.l3187c:
    cmpi.w  #$1, ($00FF99A0).l
    bne.b   .l318ac
    pea     ($0002).w
    move.l  ($00047BC8).l, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$E330                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
.l318ac:
    clr.w   d6
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    movea.l  #$00FFA6B8,a2
    moveq   #-$1,d5
    pea     ($0001).w
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    addq.l  #$4, a7
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0002,$06EE                           ; jsr $0206EE
    lea     $14(a7), a7
    move.w  d0, d4
    clr.w   d2
.l31904:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$FEDA                           ; jsr $00FEDA
    addq.l  #$8, a7
    tst.w   d0
    beq.b   .l3195a
    move.w  $2(a2), d0
    cmp.w   -$8(a6), d0
    bcs.b   .l3195a
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0002,$06EE                           ; jsr $0206EE
    lea     $10(a7), a7
    move.w  d0, -$a(a6)
    cmp.w   -$a(a6), d4
    ble.b   .l3195a
    move.w  -$a(a6), d4
    move.w  d2, d5
    moveq   #$1,d6
.l3195a:
    addq.w  #$1, d2
    moveq   #$C,d0
    adda.l  d0, a2
    cmpi.w  #$10, d2
    blt.b   .l31904
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmpi.w  #$3, d0
    blt.w   .l31a4a
    cmpi.w  #$46, -$b4(a6)
    bge.w   .l31a4a
    pea     ($00044832).l
    move.l  ($00047BB0).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     ($0002).w
    move.l  a5, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$E236                                 ; bsr.w $02FBD6
    lea     $1c(a7), a7
    move.w  #$1, -$c(a6)
    cmpi.w  #$1, d6
    bne.w   .l31b40
    move.w  d5, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    cmp.w   d3, d0
    bge.w   .l31b40
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l31a00
    pea     ($0002).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    tst.l   d0
    beq.b   .l31a1e
.l31a00:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    bra.b   .l31a24
.l31a1e:
    pea     ($00044824).l
.l31a24:
    move.l  ($00047BCC).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0002).w
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$E196                                 ; bsr.w $02FBD6
    lea     $1c(a7), a7
    bra.w   .l31b40
.l31a4a:
    cmpi.w  #$1, d6
    bne.w   .l31b40
    move.w  d5, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    cmp.w   d3, d0
    bge.w   .l31af8
    cmpi.w  #$46, -$b4(a6)
    bge.w   .l31b40
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l31aa8
    pea     ($0002).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    tst.l   d0
    beq.b   .l31ade
.l31aa8:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004481C).l
    move.l  ($00047BB4).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $10(a7), a7
    bra.b   .l31aee
.l31ade:
    pea     ($000447EA).l
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    addq.l  #$8, a7
.l31aee:
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0002).w
    bra.b   .l31b2e
.l31af8:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BC0).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0001).w
.l31b2e:
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$E0A2                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
.l31b40:
    clr.w   d4
    clr.w   d2
    clr.w   d3
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$70DC                           ; jsr $0070DC
    addq.l  #$8, a7
    move.w  d0, d5
    move.w  $4(a4), d0
    sub.w   d5, d0
    ext.l   d0
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.w  d5, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d6
    move.w  d6, d5
    addi.w  #$fffb, d5
    move.w  d5, d0
    ext.l   d0
    moveq   #-$32,d1
    cmp.l   d0, d1
    bge.b   .l31b94
    move.w  d5, d0
    ext.l   d0
    bra.b   .l31b96
.l31b94:
    moveq   #-$32,d0
.l31b96:
    move.w  d0, d5
    cmp.w   d5, d6
    beq.b   .l31bce
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7158                           ; jsr $007158
    addq.l  #$8, a7
    tst.w   d0
    bne.b   .l31bce
    cmpi.w  #$32, -$b4(a6)
    bgt.b   .l31bce
    move.w  $e(a4), d0
    cmp.w   $6(a4), d0
    bls.b   .l31bce
    moveq   #$1,d4
.l31bce:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$2D7A                           ; jsr $032D7A
    lea     $c(a7), a7
    cmp.w   $e(a4), d0
    bls.b   .l31bf6
    moveq   #$1,d3
    bra.b   .l31c2e
.l31bf6:
    move.w  d6, d5
    addq.w  #$5, d5
    cmpi.w  #$32, d5
    bge.b   .l31c06
    move.w  d5, d0
    ext.l   d0
    bra.b   .l31c08
.l31c06:
    moveq   #$32,d0
.l31c08:
    move.w  d0, d5
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$2D7A                           ; jsr $032D7A
    lea     $c(a7), a7
    cmp.w   $e(a4), d0
    bls.b   .l31c2e
    moveq   #$1,d2
.l31c2e:
    cmpi.w  #$1, d4
    bne.b   .l31c62
    cmpi.w  #$1, d2
    bne.b   .l31c62
    clr.l   -(a7)
    move.l  ($00047C08).l, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.l  d0, -(a7)
.l31c52:
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$DF7E                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    bra.w   .l31ce2
.l31c62:
    cmpi.w  #$1, d3
    bne.b   .l31c9a
    cmpi.w  #$1, -$c(a6)
    bne.b   .l31c92
    pea     ($000447E4).l
.l31c76:
    move.l  ($00047BEC).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0003).w
    bra.b   .l31c52
.l31c92:
    pea     ($000447DA).l
    bra.b   .l31cb6
.l31c9a:
    cmpi.w  #$1, d2
    bne.b   .l31ce2
    cmpi.w  #$1, -$c(a6)
    bne.b   .l31cb0
    pea     ($000447D6).l
    bra.b   .l31c76
.l31cb0:
    pea     ($000447CE).l
.l31cb6:
    move.l  ($00047BF0).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
.l31cc8:
    clr.l   -(a7)
    move.l  a5, -(a7)
.l31ccc:
    pea     ($0003).w
.l31cd0:
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$DF00                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
.l31ce2:
    cmpi.w  #$1, -$c(a6)
    beq.w   .l31eba
    move.w  $e(a4), d6
    cmp.w   $6(a4), d6
    bhi.b   .l31cfa
    moveq   #$1,d6
    bra.b   .l31cfc
.l31cfa:
    moveq   #$0,d6
.l31cfc:
    cmpi.w  #$1, d6
    bne.w   .l31dba
    move.w  d7, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$FDC4                           ; jsr $00FDC4
    addq.l  #$8, a7
    tst.w   d0
    bne.w   .l31db0
    pea     ($0002).w
    move.l  ($00047BD8).l, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$DE9E                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    moveq   #$0,d0
    move.w  $e(a4), d0
    addi.l  #$64, d0
    moveq   #$0,d1
    move.w  $6(a4), d1
    cmp.l   d1, d0
    bge.w   .l31eba
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7158                           ; jsr $007158
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.w   .l31eba
    cmpi.w  #$2, -$b6(a6)
    bne.b   .l31d9c
    clr.l   -(a7)
    move.l  ($00047B38).l, -(a7)
.l31d88:
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.l  d0, -(a7)
    bra.w   .l31eb2
.l31d9c:
    cmpi.w  #$3, -$b6(a6)
    bne.w   .l31eba
    clr.l   -(a7)
    move.l  ($00047B3C).l, -(a7)
    bra.b   .l31d88
.l31db0:
    clr.l   -(a7)
    move.l  ($00047C00).l, -(a7)
    bra.b   .l31d88
.l31dba:
    pea     ($0001).w
    move.l  ($00047BC4).l, -(a7)
    bra.b   .l31d88
.l31dc6:
    move.b  $a(a4), d0
    btst    #$1, d0
    beq.b   .l31e0c
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BAC).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $10(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    bra.w   .l31eb0
.l31e0c:
    move.b  $a(a4), d0
    btst    #$2, d0
    beq.b   .l31e64
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BDC).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    clr.l   -(a7)
    move.l  a5, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$DD84                                 ; bsr.w $02FBD6
    lea     $20(a7), a7
    pea     ($0001).w
    move.l  ($00047BE0).l, -(a7)
    bra.b   .l31eb0
.l31e64:
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BF8).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    clr.l   -(a7)
    move.l  a5, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$DD36                                 ; bsr.w $02FBD6
    lea     $20(a7), a7
    pea     ($0001).w
    move.l  ($00047BFC).l, -(a7)
.l31eb0:
    clr.l   -(a7)
.l31eb2:
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $6100,$DD1E                                 ; bsr.w $02FBD6
.l31eba:
    movem.l -$e0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_031EC4 -- (TODO: name)
; 390 bytes | $031EC4-$032049
; ============================================================================
func_031EC4:
    link    a6,#-$A0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    movea.l $c(a6), a2
    lea     -$a0(a6), a3
    movea.l  #$0002FBD6,a4
    movea.l  #$0003B22C,a5
    move.b  (a2), d5
    move.b  $1(a2), d4
    movea.l  #$00FF09C2,a2
    clr.w   d3
.l31ef2:
    cmpi.b  #$ff, (a2)
    beq.w   .l31fd8
    clr.w   d6
    moveq   #$0,d0
    move.b  (a2), d0
    beq.b   .l31f0c
    moveq   #$1,d1
    cmp.b   d1, d0
    beq.b   .l31f6c
    bra.w   .l31fd8
.l31f0c:
    clr.w   d2
.l31f0e:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    add.w   d2, d0
    movea.l  #$0005F9E1,a0
    move.b  (a0,d0.w), d0
    cmp.b   d5, d0
    beq.b   .l31f3e
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    add.w   d2, d0
    movea.l  #$0005F9E1,a0
    move.b  (a0,d0.w), d0
    cmp.b   d4, d0
    bne.b   .l31f42
.l31f3e:
    moveq   #$1,d6
    bra.b   .l31f4a
.l31f42:
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    blt.b   .l31f0e
.l31f4a:
    cmpi.w  #$1, d6
    bne.w   .l31fd8
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047CD4).l, -(a7)
    bra.b   .l31fc2
.l31f6c:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d0
    cmp.b   d5, d0
    beq.b   .l31f98
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d0
    cmp.b   d4, d0
    bne.b   .l31fd8
.l31f98:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047CD8).l, -(a7)
.l31fc2:
    move.l  a3, -(a7)
    jsr     (a5)
    pea     ($0002).w
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $1c(a7), a7
.l31fd8:
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$2, d3
    blt.w   .l31ef2
    movea.l  #$00FF09CA,a2
    tst.b   (a2)
    bne.b   .l32040
    move.b  $1(a2), d3
    cmp.b   d5, d3
    beq.b   .l31ffa
    cmp.b   d4, d3
    bne.b   .l32040
.l31ffa:
    moveq   #$0,d0
    move.b  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0002,$32B6                           ; jsr $0232B6
    move.w  d0, d2
    moveq   #$0,d0
    move.b  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047D94,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047CDC).l, -(a7)
    move.l  a3, -(a7)
    jsr     (a5)
    pea     ($0002).w
    move.l  a3, -(a7)
    pea     ($0001).w
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr     (a4)
.l32040:
    movem.l -$c8(a6), d2-d7/a2-a5
    unlk    a6
    rts

RunAIStrategy:                                                  ; $03204A
    movem.l d2/a2,-(sp)
    move.w  #$3,($00FFA7DA).l
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0154                                 ; jsr $0321DC
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0304                                 ; jsr $032398
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0772                                 ; jsr $032812
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0682                                 ; jsr $03272E
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$1554                                 ; jsr $03360C
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$32fc                                 ; jsr $0353C0
    nop
    moveq   #$0,d0
    move.b  $0004(a2),d0
    moveq   #$0,d1
    move.b  $0005(a2),d1
    add.l   d1,d0
    moveq   #$28,d1
    cmp.l   d0,d1
    ble.b   .l320ea
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$1f4a                                 ; jsr $03402E
    nop
    bra.b   .l320f6
.l320ea:                                                ; $0320EA
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$29ce                                 ; jsr $034AC0
    nop
.l320f6:                                                ; $0320F6
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$150e                                 ; jsr $03360C
    nop
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$3674                                 ; jsr $035782
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$32a6                                 ; jsr $0353C0
    nop
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$2e60                                 ; jsr $034F8A
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$344e                                 ; jsr $035584
    nop
    addq.l  #$8,sp
    move.w  ($00FF0002).l,d0
    ext.l   d0
    move.l  #$01f4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    addi.l  #$01f4,d0
    cmp.l   $0006(a2),d0
    ble.b   .l3216a
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$3718                                 ; jsr $03587C
    nop
    addq.l  #$4,sp
.l3216a:                                                ; $03216A
    move.w  ($00FF0002).l,d0
    ext.l   d0
    move.l  #$1f40,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    addi.l  #$3e80,d0
    cmp.l   $0006(a2),d0
    bge.b   .l32198
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$405e                                 ; jsr $0361F0
    nop
    addq.l  #$4,sp
.l32198:                                                ; $032198
    dc.w    $4eba,$4040                                 ; jsr $0361DA
    nop
    cmpi.w  #$14,d0
    bls.b   .l321c8
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    moveq   #$1,d1
    cmp.l   d0,d1
    bne.b   .l321c8
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$46d2                                 ; jsr $036894
    nop
    addq.l  #$4,sp
.l321c8:                                                ; $0321C8
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$388e                                 ; jsr $035A5E
    nop
    addq.l  #$4,sp
    movem.l (sp)+,d2/a2
    rts
    dc.w    $48E7,$303C; $0321DC
; === Translated block $0321E0-$032D7A ===
; 11 functions, 2970 bytes

; ============================================================================
; func_0321E0 -- (TODO: name)
; 440 bytes | $0321E0-$032397
; ============================================================================
func_0321E0:
    move.l  $1c(a7), d3
    movea.l  #$00FFA794,a3
    movea.l a3, a4
    moveq   #$16,d0
    adda.l  d0, a4
    movea.l a3, a5
    moveq   #$14,d0
    adda.l  d0, a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  $1(a2), d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.w  d0, d3
    move.w  #$5, ($00FFA794).l
    move.w  #$6, $2(a3)
    clr.w   $4(a3)
    move.w  #$1, $6(a3)
    move.w  #$3, $8(a3)
    move.w  #$4, $a(a3)
    clr.w   $c(a3)
    move.w  #$2, $e(a3)
    clr.w   $10(a3)
    move.w  #$5, $12(a3)
    move.w  #$2, (a5)
    move.w  #$3, (a4)
    cmpi.w  #$1, d3
    bne.b   l_32288
    move.w  #$1, $c(a3)
    move.w  #$2, $e(a3)
    clr.w   $8(a3)
    move.w  #$1, $a(a3)
    move.w  #$3, $4(a3)
    move.w  #$4, $6(a3)
    bra.b   l_322f4
l_32288:
    cmpi.w  #$2, d3
    bne.b   l_3229c
    move.w  #$1, $4(a3)
    move.w  #$2, $6(a3)
    bra.b   l_322f4
l_3229c:
    tst.w   ($00FF0002).l
    ble.b   l_322f4
    tst.w   d3
    beq.b   l_322b4
    cmpi.w  #$5, d3
    beq.b   l_322b4
    cmpi.w  #$6, d3
    bne.b   l_322bc
l_322b4:
    clr.w   (a5)
    move.w  #$3, (a4)
    bra.b   l_322d2
l_322bc:
    cmpi.w  #$3, d3
    beq.b   l_322c8
    cmpi.w  #$4, d3
    bne.b   l_322d2
l_322c8:
    clr.w   $c(a3)
    move.w  #$3, $e(a3)
l_322d2:
    cmpi.w  #$1, d3
    bne.b   l_322e2
    move.w  #$1, (a5)
    move.w  #$3, (a4)
    bra.b   l_322f4
l_322e2:
    cmpi.w  #$3, d3
    bne.b   l_322f4
    move.w  #$3, $4(a3)
    move.w  #$1, $6(a3)
l_322f4:
    cmpi.w  #$c, d2
    bne.b   l_3230a
l_322fa:
    move.w  #$3, $10(a3)
    move.w  #$5, $12(a3)
    bra.w   l_32392
l_3230a:
    cmpi.w  #$1c, d2
    beq.b   l_32316
    cmpi.w  #$19, d2
    bne.b   l_32320
l_32316:
    move.w  #$3, (a5)
    move.w  #$5, (a4)
    bra.b   l_32392
l_32320:
    cmpi.w  #$6, d2
    bne.b   l_3232e
    clr.w   (a5)
    move.w  #$3, (a4)
    bra.b   l_32392
l_3232e:
    cmpi.w  #$d, d2
    bne.b   l_32340
    clr.w   $c(a3)
    move.w  #$3, $e(a3)
    bra.b   l_32392
l_32340:
    cmpi.w  #$e, d2
    bne.b   l_3234e
    tst.w   ($00FF0002).l
    bgt.b   l_322fa
l_3234e:
    cmpi.w  #$1d, d2
    beq.b   l_3235a
    cmpi.w  #$1e, d2
    bne.b   l_3236e
l_3235a:
    tst.w   ($00FF0002).l
    ble.b   l_3236e
    clr.w   $10(a3)
    move.w  #$6, $12(a3)
    bra.b   l_32392
l_3236e:
    tst.w   d2
    beq.b   l_3237e
    cmpi.w  #$1, d2
    beq.b   l_3237e
    cmpi.w  #$4, d2
    bne.b   l_32392
l_3237e:
    tst.w   ($00FF0002).l
    ble.b   l_32392
    clr.w   ($00FFA794).l
    move.w  #$6, $2(a3)
l_32392:
    movem.l (a7)+, d2-d3/a2-a5
    rts

; ============================================================================
; func_032398 -- (TODO: name)
; 514 bytes | $032398-$032599
; ============================================================================
func_032398:
    link    a6,#-$10
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    lea     -$10(a6), a4
    movea.l  #$00FF0270,a5
    move.w  ($00FF0004).l, d7
    ext.l   d7
    addq.l  #$4, d7
    moveq   #$7,d0
    cmp.l   d7, d0
    ble.b   l_323ca
    move.w  ($00FF0004).l, d7
    ext.l   d7
    addq.l  #$4, d7
    bra.b   l_323cc
l_323ca:
    moveq   #$7,d7
l_323cc:
    dc.w    $4EB9,$0002,$7AA4                           ; jsr $027AA4
    move.w  d0, d4
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d2
    pea     ($0010).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    lea     $10(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    lea     (a5,d0.l), a0
    moveq   #$0,d1
    move.w  d2, d1
    adda.l  d1, a0
    cmpi.b  #$1, (a0)
    bne.b   l_3244a
    cmpi.w  #$1, d4
    bne.b   l_3244a
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$016C                                 ; jsr $03259A(pc)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.b   l_3246e
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    addi.w  #$c8, (a4,a0.l)
    bra.b   l_3246e
l_3244a:
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    lea     (a5,d0.l), a0
    moveq   #$0,d1
    move.w  d2, d1
    adda.l  d1, a0
    cmpi.b  #$1, (a0)
    bls.b   l_3246e
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    addi.w  #$7d0, (a4,a0.l)
l_3246e:
    movea.l a4, a2
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    lea     (a5,d0.l), a0
    movea.l a0, a3
    clr.w   d4
    clr.w   d2
l_32480:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$20, d0
    bcc.w   l_32536
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01BC                                 ; jsr $032662(pc)
    nop
    addq.l  #$4, a7
    cmp.w   d7, d0
    bcc.b   l_324d0
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$759E                           ; jsr $00759E
    addq.l  #$8, a7
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.b   l_324d0
    addi.w  #$190, (a2)
l_324d0:
    dc.w    $4EBA,$3D08                                 ; jsr $0361DA(pc)
    nop
    cmpi.w  #$14, d0
    bcc.b   l_324ec
    cmpi.w  #$5, d2
    beq.b   l_324e8
    cmpi.w  #$3, d2
    bne.b   l_324ec
l_324e8:
    addi.w  #$64, (a2)
l_324ec:
    cmpi.b  #$1, (a3)
    bne.b   l_324f8
    addi.w  #$c8, (a2)
    bra.b   l_32514
l_324f8:
    cmpi.b  #$2, (a3)
    bne.b   l_32504
    addi.w  #$190, (a2)
    bra.b   l_32514
l_32504:
    cmpi.b  #$3, (a3)
    beq.b   l_32510
    cmpi.b  #$4, (a3)
    bne.b   l_32514
l_32510:
    addi.w  #$12c, (a2)
l_32514:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00D6                                 ; jsr $0325F8(pc)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_32532
    addi.w  #$c8, (a2)
l_32532:
    addq.w  #$1, d4
    bra.b   l_32538
l_32536:
    clr.w   (a2)
l_32538:
    addq.l  #$2, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.w   l_32480
    cmpi.w  #$7, d4
    bcc.b   l_32552
    addi.w  #$320, $e(a4)
l_32552:
    clr.w   d3
l_32554:
    movea.l a4, a2
    moveq   #-$A,d4
    clr.w   d2
l_3255a:
    cmp.w   (a2), d4
    bge.b   l_32562
    move.w  (a2), d4
    move.w  d2, d5
l_32562:
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    bcs.b   l_3255a
    moveq   #$0,d0
    move.w  d5, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$ff9c, (a4,a0.l)
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$00FFA7AC,a0
    move.w  d5, (a0,d0.w)
    addq.w  #$1, d3
    cmpi.w  #$8, d3
    bcs.b   l_32554
    movem.l -$38(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03259A -- (TODO: name)
; 94 bytes | $03259A-$0325F7
; ============================================================================
func_03259A:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d3
    clr.w   d4
    movea.l  #$00FF0018,a2
    clr.w   d2
l_325ac:
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d3, d0
    movea.l  #$00FF0270,a0
    cmpi.b  #$2, (a0,d0.w)
    bne.b   l_325e4
    cmpi.b  #$1, (a2)
    bne.b   l_325e4
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_325e4
    moveq   #$1,d4
    bra.b   l_325f0
l_325e4:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_325ac
l_325f0:
    move.w  d4, d0
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; func_0325F8 -- (TODO: name)
; 106 bytes | $0325F8-$032661
; ============================================================================
func_0325F8:
    movem.l d2-d5, -(a7)
    move.l  $18(a7), d4
    moveq   #$1,d5
    move.w  $16(a7), d0
    lsl.w   #$3, d0
    add.w   d4, d0
    movea.l  #$00FF0270,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    cmpi.w  #$1, d3
    bne.b   l_32624
l_32620:
    clr.w   d5
    bra.b   l_3265a
l_32624:
    movea.l  #$00FF0018,a1
    clr.w   d2
l_3262c:
    tst.b   (a1)
    bne.b   l_3264e
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d4, d0
    movea.l  #$00FF0270,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    blt.b   l_32620
l_3264e:
    moveq   #$24,d0
    adda.l  d0, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_3262c
l_3265a:
    move.w  d5, d0
    movem.l (a7)+, d2-d5
    rts

; ============================================================================
; func_032662 -- (TODO: name)
; 80 bytes | $032662-$0326B1
; ============================================================================
func_032662:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d4
    clr.w   d3
    move.w  d4, d0
    lsl.w   #$3, d0
    movea.l  #$00FF0270,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_3267e:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_326a0
    cmpi.b  #$1, (a2)
    bne.b   l_326a0
    addq.w  #$1, d3
l_326a0:
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.b   l_3267e
    move.w  d3, d0
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; func_0326B2 -- (TODO: name)
; 124 bytes | $0326B2-$03272D
; ============================================================================
func_0326B2:
    movem.l d2-d7/a2, -(a7)
    move.l  $24(a7), d5
    move.l  $20(a7), d6
    movea.l  #$00FF0130,a1
    clr.w   d2
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d5, d0
    movea.l  #$00FF0270,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_326d8:
    cmpi.b  #$1, (a2)
    bne.b   l_326e2
    move.w  d2, d3
    bra.b   l_326ea
l_326e2:
    cmpi.b  #$2, (a2)
    bne.b   l_326ea
    move.w  d2, d4
l_326ea:
    addq.l  #$8, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_326d8
    cmp.w   d6, d3
    bne.b   l_326fe
    moveq   #$0,d0
    move.w  d4, d0
    bra.b   l_32702
l_326fe:
    moveq   #$0,d0
    move.w  d3, d0
l_32702:
    lsl.l   #$5, d0
    lea     (a1,d0.l), a0
    moveq   #$0,d1
    move.w  d5, d1
    lsl.l   #$2, d1
    adda.l  d1, a0
    move.l  (a0), d0
    moveq   #$0,d1
    move.w  d6, d1
    lsl.l   #$5, d1
    lea     (a1,d1.l), a0
    moveq   #$0,d7
    move.w  d5, d7
    lsl.l   #$2, d7
    adda.l  d7, a0
    sub.l   (a0), d0
    move.l  d0, d5
    movem.l (a7)+, d2-d7/a2
    rts

; ============================================================================
; func_03272E -- (TODO: name)
; 228 bytes | $03272E-$032811
; ============================================================================
func_03272E:
    move.l  a2, -(a7)
    move.w  $a(a7), d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d1
    bra.w   l_32804
l_3274a:
    cmpi.w  #$59, (a2)
    bcc.w   l_327fe
    cmpi.w  #$20, (a2)
    bcc.b   l_32778
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    cmpi.b  #$6, (a1)
    bls.b   l_32778
    move.w  #$ff, (a2)
    move.w  #$ff, $2(a2)
l_32778:
    cmpi.w  #$20, $2(a2)
    bcc.b   l_327a2
    move.w  $2(a2), d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    cmpi.b  #$6, (a1)
    bls.b   l_327a2
    move.w  #$ff, (a2)
    move.w  #$ff, $2(a2)
l_327a2:
    cmpi.w  #$20, (a2)
    bcs.b   l_327ca
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    move.b  (a1), d0
    cmp.b   $1(a1), d0
    bhi.b   l_327ca
    move.w  #$ff, (a2)
    move.w  #$ff, $2(a2)
l_327ca:
    cmpi.w  #$20, $2(a2)
    bcs.b   l_327fe
    cmpi.w  #$59, $2(a2)
    bcc.b   l_327fe
    move.w  $2(a2), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    move.b  (a1), d0
    cmp.b   $1(a1), d0
    bhi.b   l_327fe
    move.w  #$ff, (a2)
    move.w  #$ff, $2(a2)
l_327fe:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d1
l_32804:
    cmp.w   ($00FFA7DA).l, d1
    bcs.w   l_3274a
    movea.l (a7)+, a2
    rts

; ============================================================================
; func_032812 -- (TODO: name)
; 236 bytes | $032812-$0328FD
; ============================================================================
func_032812:
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $14(a7), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.w   l_328e0
l_32844:
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.b   l_32898
    moveq   #$0,d0
    move.w  $6(a2), d0
    moveq   #$6E,d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    moveq   #$0,d1
    move.w  $e(a2), d1
    cmp.l   d1, d0
    bgt.b   l_32884
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0080                                 ; jsr $0328FE(pc)
    nop
    bra.b   l_328d8
l_32884:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$075A                                 ; jsr $032FEC(pc)
    nop
    bra.b   l_328d8
l_32898:
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.b   l_328da
    moveq   #$0,d0
    move.b  $1(a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.b   l_328da
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0CCA                                 ; jsr $03359E(pc)
    nop
l_328d8:
    addq.l  #$8, a7
l_328da:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_328e0:
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.w   l_32844
    movem.l (a7)+, d2-d3/a2-a3
    rts

; ============================================================================
; func_0328FE -- (TODO: name)
; 298 bytes | $0328FE-$032A27
; ============================================================================
func_0328FE:
    movem.l d2-d5/a2-a4, -(a7)
    move.l  $24(a7), d2
    move.l  $20(a7), d3
    movea.l  #$00032CA0,a4
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d2, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    addq.l  #$4, a7
    move.w  d0, d4
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    mulu.w  #$a, d0
    move.w  d0, d4
    moveq   #$0,d0
    move.w  $10(a2), d0
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d4, d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d4
    clr.w   d5
    cmpi.w  #$5a, d4
    bcs.b   l_329e2
    cmpi.b  #$e, $3(a2)
    bcc.b   l_329a6
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$008E                                 ; jsr $032A28(pc)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    beq.b   l_32a22
l_329a6:
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0816                                 ; jsr $0331CC(pc)
    nop
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    beq.b   l_32a22
    pea     ($000A).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_32a22
    bra.b   l_32a22
l_329e2:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a3), d1
    cmp.l   d1, d0
    bge.b   l_32a08
    pea     (-$14).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
    move.w  d0, d5
l_32a08:
    tst.w   d5
    bne.b   l_32a22
    pea     (-$A).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
l_32a22:
    movem.l (a7)+, d2-d5/a2-a4
    rts

; ============================================================================
; func_032A28 -- (TODO: name)
; 632 bytes | $032A28-$032C9F
; ============================================================================
func_032A28:
    link    a6,#$0
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $8(a6), d4
    clr.w   d2
    move.w  d4, d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    move.w  d0, d7
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d1
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$70DC                           ; jsr $0070DC
    lea     $c(a7), a7
    move.w  d0, d3
    move.w  $4(a2), d0
    sub.w   d3, d0
    ext.l   d0
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.w  d3, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d3
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    tst.w   d3
    ble.w   l_32c94
    moveq   #$0,d3
    move.b  (a4), d3
    moveq   #$0,d0
    move.b  $1(a4), d0
    sub.w   d0, d3
    moveq   #$0,d6
    move.b  (a3), d6
    moveq   #$0,d0
    move.b  $1(a3), d0
    sub.w   d0, d6
    moveq   #$0,d0
    move.b  $b(a2), d0
    andi.l  #$ffff, d0
    moveq   #$5F,d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    moveq   #$0,d1
    move.b  $3(a2), d1
    sub.w   d1, d0
    move.w  d0, d5
    moveq   #$0,d0
    move.b  $3(a2), d0
    moveq   #$E,d1
    sub.l   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    ble.b   l_32b34
    move.w  d5, d0
    ext.l   d0
    bra.b   l_32b40
l_32b34:
    moveq   #$0,d0
    move.b  $3(a2), d0
    moveq   #$E,d1
    sub.l   d0, d1
    move.l  d1, d0
l_32b40:
    move.w  d0, d5
    tst.w   d3
    beq.b   l_32bbc
    tst.w   d6
    beq.b   l_32bbc
    tst.w   d5
    ble.b   l_32bbc
    cmp.w   d6, d3
    bcc.b   l_32b58
    moveq   #$0,d2
    move.w  d3, d2
    bra.b   l_32b5c
l_32b58:
    moveq   #$0,d2
    move.w  d6, d2
l_32b5c:
    moveq   #$0,d0
    move.w  d2, d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_32b6e
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_32b72
l_32b6e:
    move.w  d5, d0
    ext.l   d0
l_32b72:
    move.w  d0, d2
    cmpi.b  #$7, $3(a2)
    bcs.b   l_32b8c
    cmpi.w  #$2, d2
    bcc.b   l_32b88
l_32b82:
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_32bac
l_32b88:
    moveq   #$2,d0
    bra.b   l_32bac
l_32b8c:
    moveq   #$0,d0
    move.b  $3(a2), d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_32b82
    moveq   #$0,d0
    move.b  $3(a2), d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, d0
l_32bac:
    move.w  d0, d2
    add.b   d2, $3(a2)
    add.b   d2, $1(a4)
    add.b   d2, $1(a3)
    moveq   #$1,d2
l_32bbc:
    tst.w   d2
    bne.w   l_32c94
    tst.w   d3
    bne.b   l_32bf6
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$248A                                 ; jsr $035060(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_32bf6
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$2532                                 ; jsr $035122(pc)
    nop
    addq.l  #$8, a7
l_32bf6:
    tst.w   d6
    bne.b   l_32c2e
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$2454                                 ; jsr $035060(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_32c2e
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$24FA                                 ; jsr $035122(pc)
    nop
    addq.l  #$8, a7
l_32c2e:
    tst.w   d5
    bgt.b   l_32c94
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
    addq.l  #$4, a7
    move.w  d0, d3
    cmpi.w  #$9, d0
    bcc.b   l_32c94
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    tst.b   (a0,d0.w)
    beq.b   l_32c82
    addq.w  #$1, d3
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$73A6                           ; jsr $0073A6
    addq.l  #$8, a7
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    subq.b  #$1, (a0,d0.w)
    bra.b   l_32c94
l_32c82:
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$2958                                 ; jsr $0355E8(pc)
    nop
l_32c94:
    move.w  d2, d0
    movem.l -$24(a6), d2-d7/a2-a4
    unlk    a6
    rts

; ============================================================================
; func_032CA0 -- (TODO: name)
; 218 bytes | $032CA0-$032D79
; ============================================================================
func_032CA0:
    movem.l d2-d6/a2, -(a7)
    move.l  $24(a7), d2
    move.l  $1c(a7), d3
    move.l  $20(a7), d6
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d6, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$70DC                           ; jsr $0070DC
    move.w  d0, d5
    move.w  $4(a2), d0
    sub.w   d5, d0
    ext.l   d0
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.w  d5, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d4
    add.w   d2, d0
    move.w  d0, d2
    cmpi.w  #$32, d2
    bge.b   l_32d10
    move.w  d2, d0
    ext.l   d0
    bra.b   l_32d12
l_32d10:
    moveq   #$32,d0
l_32d12:
    move.w  d0, d2
    ext.l   d0
    moveq   #-$32,d1
    cmp.l   d0, d1
    bge.b   l_32d22
    move.w  d2, d0
    ext.l   d0
    bra.b   l_32d24
l_32d22:
    moveq   #-$32,d0
l_32d24:
    move.w  d0, d2
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0042                                 ; jsr $032D7A(pc)
    nop
    lea     $14(a7), a7
    cmp.w   $6(a2), d0
    bcc.b   l_32d48
    move.w  d4, d2
l_32d48:
    cmp.w   d4, d2
    bne.b   l_32d50
    clr.w   d3
    bra.b   l_32d72
l_32d50:
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    addi.l  #$64, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, $4(a2)
    moveq   #$1,d3
l_32d72:
    move.w  d3, d0
    movem.l (a7)+, d2-d6/a2
    rts

CalcRelationScore:                                                  ; $032D7A
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0028(sp),d2
    move.l  $002c(sp),d3
    move.l  $0030(sp),d4
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    mulu.w  #$0320,d0
    move.w  d3,d1
    mulu.w  #$14,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
    move.w  d0,d2
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  $0004(a3),d1
    cmp.l   d1,d0
    bge.b   .l32e54
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    lsl.w   #$2,d0
    movea.l #$00ffbde4,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$8,sp
    lsl.w   #$2,d0
    movea.l #$00ffbde4,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  $0003(a4),d0
    moveq   #$0,d1
    move.w  (a4),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0003(a3),d0
    moveq   #$0,d1
    move.w  (a3),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$0,d1
    move.w  (a3),d1
    moveq   #$0,d2
    move.w  (a4),d2
    add.l   d2,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    bra.w   .l32eda
.l32e54:                                                ; $032E54
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  $0003(a4),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0001(a4),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0003(a3),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    andi.l  #$ffff,d1
    moveq   #$0,d2
    move.b  $0001(a4),d2
    andi.l  #$ffff,d2
    add.l   d2,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
.l32eda:                                                ; $032EDA
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$70dc                           ; jsr $0070DC
    addq.l  #$8,sp
    move.w  d0,d3
    move.w  $0004(a2),d0
    sub.w   d3,d0
    ext.l   d0
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.w  d3,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d2,d0
    move.w  d4,d1
    ext.l   d1
    sub.l   d1,d0
    addi.l  #$32,d0
    moveq   #$0,d1
    move.w  $0008(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2,d1
    move.w  d5,d6
    ext.l   d6
    sub.l   d6,d1
    addi.l  #$32,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0001(a5),d0
    andi.l  #$ffff,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    add.l   d0,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    ble.b   .l32f7c
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l32fa2
.l32f7c:                                                ; $032F7C
    moveq   #$0,d0
    move.b  $0001(a5),d0
    andi.l  #$ffff,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    add.l   d0,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
.l32fa2:                                                ; $032FA2
    move.w  d0,d2
    move.w  d3,d0
    ext.l   d0
    move.w  d4,d1
    ext.l   d1
    addi.l  #$64,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d3
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  #$2710,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    movem.l (sp)+,d2-d6/a2-a5
    rts
    dc.w    $4E56,$0000; $032FEC
; === Translated block $032FF0-$0332DE ===
; 2 functions, 750 bytes

; ============================================================================
; func_032FF0 -- (TODO: name)
; 476 bytes | $032FF0-$0331CB
; ============================================================================
func_032FF0:
    movem.l d2-d5/a2-a4, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    movea.l  #$00FFBA80,a4
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d2, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.w   l_331b0
    moveq   #$0,d0
    move.b  $1(a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.w   l_331b0
    cmpi.b  #$1, $3(a2)
    bls.w   l_3315c
    cmpi.b  #$7, $3(a2)
    bls.b   l_3307e
    moveq   #$0,d2
    move.b  $3(a2), d2
    addi.w  #$fff9, d2
    bra.b   l_33080
l_3307e:
    moveq   #$1,d2
l_33080:
    sub.b   d2, $3(a2)
    moveq   #$0,d4
    move.b  $3(a2), d4
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d1
    adda.l  d1, a0
    sub.b   d2, $1(a0)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d1
    adda.l  d1, a0
    sub.b   d2, $1(a0)
    move.b  $2(a2), d2
    andi.w  #$f, d2
    moveq   #$0,d0
    move.b  $3(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EBA,$0D70                                 ; jsr $033E3E(pc)
    nop
    addq.l  #$8, a7
    move.w  d0, d5
    cmp.w   d5, d2
    bls.b   l_33112
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$73A6                           ; jsr $0073A6
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    lea     $c(a7), a7
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E9,a0
    adda.l  d0, a0
    movea.l a0, a3
    move.b  d2, d0
    sub.b   d5, d0
    add.b   d0, (a3)
l_33112:
    moveq   #$0,d0
    move.b  $3(a2), d0
    cmp.w   d4, d0
    beq.w   l_331c2
    moveq   #$0,d0
    move.b  $3(a2), d0
    sub.w   d0, d4
    tst.w   d4
    bge.b   l_3312c
    neg.w   d4
l_3312c:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d1
    adda.l  d1, a0
    sub.b   d4, $1(a0)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d1
    adda.l  d1, a0
    sub.b   d4, $1(a0)
    bra.b   l_331c2
l_3315c:
    pea     ($000A).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FB32                                 ; bsr.w $032CA0
    lea     $c(a7), a7
    moveq   #$0,d0
    move.w  $e(a2), d0
    add.l   d0, d0
    moveq   #$0,d1
    move.w  $6(a2), d1
    cmp.l   d1, d0
    ble.b   l_331a2
l_33186:
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0034                                 ; jsr $0331CC(pc)
    nop
    lea     $c(a7), a7
    bra.b   l_331c2
l_331a2:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a3), d1
    cmp.l   d1, d0
    blt.b   l_33186
l_331b0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0416                                 ; jsr $0335D4(pc)
    nop
l_331c2:
    movem.l -$1c(a6), d2-d5/a2-a4
    unlk    a6
    rts

; ============================================================================
; func_0331CC -- (TODO: name)
; 274 bytes | $0331CC-$0332DD
; ============================================================================
func_0331CC:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    move.l  $10(a6), d4
    move.l  $c(a6), d5
    clr.w   d7
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00E8                                 ; jsr $0332DE(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    cmpi.w  #$10, d2
    bcc.w   l_332d2
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d5, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.l  a3, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    move.w  d0, d6
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.l  a3, -(a7)
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
    addq.l  #$8, a7
    move.w  d0, d6
    tst.w   d4
    bne.b   l_332b4
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    mulu.w  d1, d0
    move.w  d0, -$2(a6)
    moveq   #$0,d4
    move.b  $1(a5), d4
    mulu.w  d6, d4
    cmp.w   -$2(a6), d4
    bhi.b   l_332c0
l_33294:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01B6                                 ; jsr $03345E(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d7
    bra.b   l_332d2
l_332b4:
    cmpi.w  #$1, d4
    bne.b   l_332d2
    tst.b   $1(a2)
    bne.b   l_33294
l_332c0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$231A                                 ; jsr $0355E8(pc)
    nop
l_332d2:
    move.w  d7, d0
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

FindBestCharForSlot:                                                  ; $0332DE
    link    a6,#-$4
    movem.l d2-d7/a2-a3,-(sp)
    move.l  $000c(a6),d2
    move.l  $0010(a6),d5
    move.w  #$ff,d6
    move.w  $000a(a6),d0
    mulu.w  #$0320,d0
    move.w  d2,d1
    mulu.w  #$14,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0001(a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    move.w  d0,-$0002(a6)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    lea     $000c(sp),sp
    move.w  d0,d2
    tst.w   d5
    bne.b   .l33354
    move.w  d2,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b9,a0
    move.b  (a0,d0.w),d3
    andi.l  #$ff,d3
    bra.b   .l3338e
.l33354:                                                ; $033354
    cmpi.w  #$1,d5
    bne.b   .l3338e
    pea     ($0001).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0001(a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$06ee                           ; jsr $0206EE
    lea     $0010(sp),sp
    move.w  d0,d3
.l3338e:                                                ; $03338E
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l3339a
    addq.l  #$3,d0
.l3339a:                                                ; $03339A
    asr.l   #$2,d0
    addi.w  #$37,d0
    move.w  d0,d7
    movea.l #$00ffa6b8,a2
    clr.w   d2
.l333aa:                                                ; $0333AA
    move.w  $0002(a2),d0
    cmp.w   -$0002(a6),d0
    bcs.w   .l33444
    moveq   #$0,d0
    move.b  $0006(a2),d0
    addi.w  #$ffff,d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d7,d1
    cmp.l   d1,d0
    bgt.b   .l33444
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.b  $0007(a2),d1
    ext.l   d1
    subq.l  #$2,d1
    cmp.l   d1,d0
    bge.b   .l33444
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$8016                           ; jsr $008016
    addq.l  #$8,sp
    cmpi.w  #$ffff,d0
    beq.b   .l33444
    tst.w   d5
    bne.b   .l3340e
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
    ble.b   .l33444
    moveq   #$0,d3
    move.b  $0001(a2),d3
    bra.b   .l33442
.l3340e:                                                ; $03340E
    cmpi.w  #$1,d5
    bne.b   .l33444
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0001(a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$06ee                           ; jsr $0206EE
    lea     $0010(sp),sp
    move.w  d0,d4
    cmp.w   d3,d4
    bcc.b   .l33444
    move.w  d4,d3
.l33442:                                                ; $033442
    move.w  d2,d6
.l33444:                                                ; $033444
    moveq   #$c,d0
    adda.l  d0,a2
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    bcs.w   .l333aa
    move.w  d6,d0
    movem.l -$0024(a6),d2-d7/a2-a3
    unlk    a6
    rts
; === Translated block $03345E-$034CC4 ===
; 26 functions, 6246 bytes

; ============================================================================
; func_03345E -- (TODO: name)
; 320 bytes | $03345E-$03359D
; ============================================================================
func_03345E:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    move.l  $10(a6), d5
    clr.w   d6
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d2, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d7
    move.b  $3(a2), d7
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    move.w  d0, d2
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    move.w  d0, -$2(a6)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
    lea     $10(a7), a7
    move.w  d0, d4
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  -$2(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d5, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    cmp.w   $2(a5), d2
    bhi.w   l_33592
    tst.b   $1(a3)
    beq.b   l_33592
    moveq   #$0,d2
    move.b  $1(a3), d2
    cmp.w   d4, d2
    bls.b   l_33526
    moveq   #$0,d2
    move.w  d4, d2
    bra.b   l_33532
l_33526:
    moveq   #$0,d2
    move.b  $1(a3), d2
    andi.l  #$ffff, d2
l_33532:
    add.b   d4, $1(a4)
    sub.b   d2, $1(a3)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7390                           ; jsr $007390
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$73A6                           ; jsr $0073A6
    moveq   #$0,d2
    move.b  $3(a2), d2
    move.w  d7, d0
    sub.w   d2, d0
    move.w  d0, d2
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    sub.b   d2, (a0,d0.w)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    sub.b   d2, (a0,d0.w)
    moveq   #$1,d6
l_33592:
    move.w  d6, d0
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03359E -- (TODO: name)
; 54 bytes | $03359E-$0335D3
; ============================================================================
func_03359E:
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

; ============================================================================
; func_0335D4 -- (TODO: name)
; 56 bytes | $0335D4-$03360B
; ============================================================================
func_0335D4:
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

; ============================================================================
; func_03360C -- (TODO: name)
; 212 bytes | $03360C-$0336DF
; ============================================================================
func_03360C:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $18(a7), d4
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d4, d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.w   l_336c2
l_3363e:
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    moveq   #$28,d1
    cmp.l   d0, d1
    ble.b   l_336bc
    cmpi.w  #$59, (a2)
    bcc.b   l_336bc
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$007A                                 ; jsr $0336E0(pc)
    nop
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$1, d3
    bne.b   l_336bc
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$034A                                 ; jsr $0339DC(pc)
    nop
    lea     $10(a7), a7
    move.w  d0, d3
    cmpi.w  #$1, d3
    bne.b   l_336bc
    move.w  #$ff, d0
    move.w  d0, $2(a2)
    move.w  d0, (a2)
    clr.w   $4(a2)
    clr.w   $6(a2)
    clr.w   $8(a2)
    clr.w   $a(a2)
l_336bc:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_336c2:
    cmp.w   ($00FFA7DA).l, d2
    bcs.w   l_3363e
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$088E                                 ; jsr $033F62(pc)
    nop
    addq.l  #$4, a7
    movem.l (a7)+, d2-d4/a2-a3
    rts

; ============================================================================
; func_0336E0 -- (TODO: name)
; 306 bytes | $0336E0-$033811
; ============================================================================
func_0336E0:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $18(a7), d3
    move.l  $1c(a7), d4
    moveq   #$1,d2
    move.w  d3, d0
    mulu.w  #$30, d0
    move.w  d4, d1
    mulu.w  #$c, d1
    add.w   d1, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$59, (a2)
    bcc.w   l_337c2
    move.w  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    sub.l   d1, d0
    ble.b   l_3373c
    move.w  #$3, $6(a2)
    bra.b   l_3374c
l_3373c:
    clr.w   d2
    cmpi.w  #$2, $6(a2)
    beq.b   l_3374c
    move.w  #$1, $6(a2)
l_3374c:
    move.w  $2(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    sub.l   d1, d0
    ble.b   l_3377a
    move.w  #$3, $8(a2)
    bra.b   l_3378a
l_3377a:
    clr.w   d2
    cmpi.w  #$2, $8(a2)
    beq.b   l_3378a
    move.w  #$1, $8(a2)
l_3378a:
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  $4(a2), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    tst.b   $1(a3)
    beq.b   l_337b0
    move.w  #$3, $a(a2)
    bra.b   l_337c4
l_337b0:
    clr.w   d2
    cmpi.w  #$2, $a(a2)
    beq.b   l_337c4
    move.w  #$1, $a(a2)
    bra.b   l_337c4
l_337c2:
    clr.w   d2
l_337c4:
    cmpi.w  #$1, d2
    bne.b   l_3380a
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0032                                 ; jsr $033812(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d3
    tst.w   d3
    bne.b   l_3380a
    move.w  #$ff, d0
    move.w  d0, $2(a2)
    move.w  d0, (a2)
    clr.w   $4(a2)
    clr.w   $6(a2)
    clr.w   $8(a2)
    clr.w   $a(a2)
    clr.w   d2
l_3380a:
    move.w  d2, d0
    movem.l (a7)+, d2-d4/a2-a3
    rts

; ============================================================================
; func_033812 -- (TODO: name)
; 212 bytes | $033812-$0338E5
; ============================================================================
func_033812:
    link    a6,#-$4
    movem.l d2-d7/a2, -(a7)
    move.l  $10(a6), d2
    move.l  $c(a6), d3
    move.l  $8(a6), d5
    lea     -$2(a6), a2
    clr.w   d6
    cmpi.w  #$59, d3
    bcc.w   l_338da
    cmpi.w  #$59, d2
    bcc.w   l_338da
    cmp.w   d2, d3
    beq.w   l_338da
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, (a2)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d7
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    move.w  d0, d4
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    move.w  d0, -$4(a6)
    cmp.w   d3, d4
    beq.b   l_33892
    cmp.w   -$4(a6), d2
    bne.b   l_338da
l_33892:
    cmp.w   d3, d4
    beq.b   l_3389c
    move.w  d3, d4
    move.w  d2, d3
    move.w  d4, d2
l_3389c:
    cmp.w   (a2), d7
    beq.b   l_338c0
    cmpi.w  #$20, d2
    bcc.b   l_338da
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$002C                                 ; jsr $0338E6(pc)
    nop
    bra.b   l_338d8
l_338c0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00E2                                 ; jsr $0339B6(pc)
    nop
l_338d8:
    move.w  d0, d6
l_338da:
    move.w  d6, d0
    movem.l -$20(a6), d2-d7/a2
    unlk    a6
    rts

; ============================================================================
; func_0338E6 -- (TODO: name)
; 208 bytes | $0338E6-$0339B5
; ============================================================================
func_0338E6:
    movem.l d2-d7/a2, -(a7)
    move.l  $24(a7), d2
    move.l  $20(a7), d3
    move.l  $28(a7), d6
    clr.w   d5
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d4
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    lea     $10(a7), a7
    move.w  d0, d7
    moveq   #$0,d0
    move.w  d4, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    mulu.w  #$7, d1
    add.w   d2, d1
    movea.l  #$00FFA7BC,a0
    move.b  (a0,d1.w), d1
    andi.l  #$ff, d1
    and.l   d1, d0
    bne.b   l_339ae
    cmp.w   d6, d7
    beq.b   l_339ac
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  (a2), d2
    bra.b   l_33984
l_3396c:
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    tst.b   (a0,d0.w)
    bne.b   l_33998
    addq.w  #$1, d2
l_33984:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_3396c
l_33998:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_339ae
l_339ac:
    moveq   #$1,d5
l_339ae:
    move.w  d5, d0
    movem.l (a7)+, d2-d7/a2
    rts

; ============================================================================
; func_0339B6 -- (TODO: name)
; 38 bytes | $0339B6-$0339DB
; ============================================================================
func_0339B6:
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

; ============================================================================
; func_0339DC -- (TODO: name)
; 774 bytes | $0339DC-$033CE1
; ============================================================================
func_0339DC:
    link    a6,#-$18
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    move.l  $10(a6), d4
    move.l  $c(a6), d5
    movea.l  #$00FFA6A0,a4
    lea     -$18(a6), a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    pea     ($0003).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$A506                           ; jsr $01A506
    lea     $c(a7), a7
    move.l  d0, (a5)
    move.l  $6(a2), d0
    cmp.l   (a5), d0
    ble.w   l_33cd4
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d6
    cmp.w   d6, d2
    beq.b   l_33a54
    addq.b  #$1, $4(a2)
    bra.b   l_33a58
l_33a54:
    addq.b  #$1, $5(a2)
l_33a58:
    pea     ($0014).w
    clr.l   -(a7)
    pea     -$14(a6)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    lea     -$14(a6), a3
    moveq   #$0,d0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0258                                 ; jsr $033CE2(pc)
    nop
    move.b  #$4, $a(a3)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$82E4                           ; jsr $0082E4
    lea     $30(a7), a7
    cmp.w   d6, d2
    beq.b   l_33b08
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    moveq   #$1,d0
    lsl.b   d6, d0
    move.w  d3, d1
    mulu.w  #$7, d1
    add.w   d2, d1
    movea.l  #$00FFA7BC,a0
    or.b    d0, (a0,d1.w)
    moveq   #$1,d0
    lsl.b   d2, d0
    move.w  d3, d1
    mulu.w  #$7, d1
    add.w   d6, d1
    movea.l  #$00FFA7BC,a0
    or.b    d0, (a0,d1.w)
    bra.w   l_33bba
l_33b08:
    cmpi.w  #$20, d5
    bcc.b   l_33b26
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    bra.b   l_33b60
l_33b26:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d5, d7
    sub.w   d0, d7
    moveq   #$1,d0
    lsl.w   d7, d0
    move.w  d3, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  d2, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    or.w    d0, (a0,d1.w)
    addq.b  #$1, $3(a2)
l_33b60:
    cmpi.w  #$20, d4
    bcc.b   l_33b80
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    bra.b   l_33bba
l_33b80:
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d4, d7
    sub.w   d0, d7
    moveq   #$1,d0
    lsl.w   d7, d0
    move.w  d3, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  d6, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    or.w    d0, (a0,d1.w)
    addq.b  #$1, $3(a2)
l_33bba:
    clr.b   $2(a2)
    clr.w   d2
l_33bc0:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    and.l   (a4,a0.l), d0
    beq.b   l_33bdc
    addq.b  #$1, $2(a2)
l_33bdc:
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    bcs.b   l_33bc0
    move.l  (a5), d0
    sub.l   d0, $6(a2)
    move.l  a3, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E9,a0
    adda.l  d0, a0
    movea.l a0, a2
    move.l  a3, -(a7)
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
    sub.b   d0, (a2)
    move.w  d5, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a3), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a3), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($000448BA).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $28(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$68CA                           ; jsr $0068CA
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6B78                           ; jsr $006B78
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$C43C                           ; jsr $01C43C
    pea     ($001E).w
    dc.w    $4EB9,$0001,$E2F4                           ; jsr $01E2F4
    moveq   #$1,d3
    bra.b   l_33cd6
l_33cd4:
    clr.w   d3
l_33cd6:
    move.w  d3, d0
    movem.l -$40(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_033CE2 -- (TODO: name)
; 348 bytes | $033CE2-$033E3D
; ============================================================================
func_033CE2:
    link    a6,#$0
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $8(a6), d3
    movea.l $c(a6), a2
    move.b  $13(a6), (a2)
    move.b  $17(a6), $1(a2)
    moveq   #$0,d0
    move.w  $1a(a6), d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7390                           ; jsr $007390
    clr.w   $e(a2)
    clr.w   $6(a2)
    clr.b   $a(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d2
    move.b  (a3), d2
    moveq   #$0,d0
    move.b  $1(a3), d0
    sub.w   d0, d2
    moveq   #$0,d4
    move.b  (a4), d4
    moveq   #$0,d0
    move.b  $1(a4), d0
    sub.w   d0, d4
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E8,a0
    adda.l  d0, a0
    movea.l a0, a3
    cmp.w   d4, d2
    bcc.b   l_33d8c
    moveq   #$0,d3
    move.w  d2, d3
    bra.b   l_33d90
l_33d8c:
    moveq   #$0,d3
    move.w  d4, d3
l_33d90:
    cmpi.w  #$e, d3
    bcc.b   l_33d9c
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   l_33d9e
l_33d9c:
    moveq   #$E,d0
l_33d9e:
    move.w  d0, d3
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EBA,$0094                                 ; jsr $033E3E(pc)
    nop
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bge.b   l_33dc6
    moveq   #$0,d0
    move.b  $1(a3), d0
    bra.b   l_33dca
l_33dc6:
    moveq   #$0,d0
    move.w  d2, d0
l_33dca:
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$73A6                           ; jsr $0073A6
    moveq   #$0,d0
    move.b  $b(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, d1
    lsl.l   #$3, d0
    add.l   d1, d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d2
    cmp.w   d3, d2
    bcc.b   l_33e00
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_33e04
l_33e00:
    moveq   #$0,d0
    move.w  d3, d0
l_33e04:
    move.w  d0, d2
    cmpi.w  #$e, d2
    bcc.b   l_33e12
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_33e14
l_33e12:
    moveq   #$E,d0
l_33e14:
    move.w  d0, d2
    cmpi.w  #$1, d2
    bls.b   l_33e22
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_33e24
l_33e22:
    moveq   #$1,d0
l_33e24:
    move.b  d0, $3(a2)
    move.l  a2, -(a7)
    dc.w    $4EBA,$0068                                 ; jsr $033E94(pc)
    nop
    move.w  d0, $4(a2)
    movem.l -$18(a6), d2-d4/a2-a4
    unlk    a6
    rts

; ============================================================================
; func_033E3E -- (TODO: name)
; 86 bytes | $033E3E-$033E93
; ============================================================================
func_033E3E:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    movea.l $10(a7), a2
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7412                           ; jsr $007412
    addq.l  #$4, a7
    move.w  d0, d3
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    moveq   #$0,d1
    move.w  d3, d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d2
    cmpi.w  #$1, d2
    bls.b   l_33e7a
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_33e7c
l_33e7a:
    moveq   #$1,d0
l_33e7c:
    move.w  d0, d2
    cmpi.w  #$9, d2
    bcc.b   l_33e8a
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_33e8c
l_33e8a:
    moveq   #$9,d0
l_33e8c:
    move.w  d0, d2
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; func_033E94 -- (TODO: name)
; 206 bytes | $033E94-$033F61
; ============================================================================
func_033E94:
    movem.l d2-d3/a2-a4, -(a7)
    movea.l $18(a7), a2
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $3(a3), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    andi.l  #$ffff, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a4), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    andi.l  #$ffff, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    add.l   (a7)+, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    andi.l  #$ffff, d1
    moveq   #$0,d3
    move.b  $1(a3), d3
    andi.l  #$ffff, d3
    add.l   d3, d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    addi.w  #$32, d0
    move.w  d0, d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$70DC                           ; jsr $0070DC
    addq.l  #$8, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  d3, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d2
    movem.l (a7)+, d2-d3/a2-a4
    rts

; ============================================================================
; func_033F62 -- (TODO: name)
; 204 bytes | $033F62-$03402D
; ============================================================================
func_033F62:
    link    a6,#-$30
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$00FF88DC,a4
    movea.l  #$0001D538,a5
    pea     ($0030).w
    pea     -$30(a6)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$4, d0
    move.l  d0, d2
    move.l  d0, d3
    pea     (a4, d0.l)
    clr.l   -(a7)
    jsr     (a5)
    pea     ($0030).w
    clr.l   -(a7)
    pea     (a4, d2.l)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    lea     $20(a7), a7
    move.w  #$ff, (a4,d2.l)
    lea     (a4,d2.l), a0
    movea.l a0, a2
    move.w  #$ff, $2(a0)
    moveq   #$1,d2
    bra.b   l_33fe6
l_33fc4:
    pea     ($000C).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    pea     (a2, d0.l)
    clr.l   -(a7)
    move.l  a2, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    addq.w  #$1, d2
l_33fe6:
    cmp.w   ($00FFA7DA).l, d2
    bcs.b   l_33fc4
    lea     -$30(a6), a2
    lea     (a4,d3.l), a3
    clr.w   d2
    bra.b   l_3401c
l_33ffa:
    cmpi.w  #$59, (a2)
    bcc.b   l_34016
    pea     ($000C).w
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    moveq   #$C,d0
    adda.l  d0, a3
l_34016:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_3401c:
    cmp.w   ($00FFA7DA).l, d2
    bcs.b   l_33ffa
    movem.l -$48(a6), d2-d3/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03402E -- (TODO: name)
; 324 bytes | $03402E-$034171
; ============================================================================
func_03402E:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d3
    lea     -$2(a6), a3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.w  d0, d7
    clr.w   (a3)
    bra.w   l_3415c
l_3406a:
    pea     ($00FE).w
    pea     ($00FE).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$08FE                                 ; jsr $034978(pc)
    nop
    lea     $c(a7), a7
    cmpi.w  #$ff, d0
    beq.w   l_34168
    clr.w   d4
l_3408c:
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FFA7AC,a0
    move.w  (a0,d0.w), d2
    cmpi.w  #$7, d2
    bcc.w   l_34142
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bcc.w   l_34150
    clr.w   d6
    cmp.w   d7, d2
    bne.b   l_340c8
    moveq   #$1,d5
    bra.b   l_340ca
l_340c8:
    moveq   #$2,d5
l_340ca:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$009A                                 ; jsr $034172(pc)
    nop
    addq.l  #$8, a7
    cmp.w   d5, d0
    bls.b   l_340f8
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0416                                 ; jsr $034506(pc)
    nop
    addq.l  #$8, a7
    move.w  d0, d6
l_340f8:
    tst.w   d6
    bne.b   l_34150
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$05B6                                 ; jsr $0346C0(pc)
    nop
    addq.l  #$8, a7
    cmp.w   d7, d2
    bne.b   l_34150
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$E4D6                                 ; bsr.w $0325F8
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_34150
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0586                                 ; jsr $0346C0(pc)
    nop
    addq.l  #$8, a7
    bra.b   l_34150
l_34142:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0078                                 ; jsr $0341C2(pc)
    nop
    addq.l  #$4, a7
l_34150:
    addq.w  #$1, d4
    cmpi.w  #$8, d4
    bcs.w   l_3408c
    addq.w  #$1, (a3)
l_3415c:
    move.w  (a3), d0
    cmp.w   ($00FFA7DA).l, d0
    bcs.w   l_3406a
l_34168:
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts

; ============================================================================
; func_034172 -- (TODO: name)
; 80 bytes | $034172-$0341C1
; ============================================================================
func_034172:
    movem.l d2-d6, -(a7)
    move.l  $1c(a7), d4
    move.l  $18(a7), d5
    clr.w   d3
    clr.w   d2
l_34182:
    move.w  d2, d0
    mulu.w  #$1c, d0
    move.w  d4, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF1004,a0
    move.l  (a0,d0.w), d0
    move.w  d5, d1
    mulu.w  #$1c, d1
    move.w  d4, d6
    lsl.w   #$2, d6
    add.w   d6, d1
    movea.l  #$00FF1004,a0
    cmp.l   (a0,d1.w), d0
    bcs.b   l_341b2
    addq.w  #$1, d3
l_341b2:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_34182
    move.w  d3, d0
    movem.l (a7)+, d2-d6
    rts

; ============================================================================
; func_0341C2 -- (TODO: name)
; 632 bytes | $0341C2-$034439
; ============================================================================
func_0341C2:
    link    a6,#-$1C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d6
    lea     -$c(a6), a4
    movea.l  #$00006EEA,a5
    pea     ($000C).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    lea     $10(a7), a7
    move.w  d0, d4
    dc.w    $4EB9,$0002,$7AA4                           ; jsr $027AA4
    move.w  d0, -$1a(a6)
    movea.l  #$00FFA794,a2
    clr.w   d3
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0
    lea     (a4,d0.l), a0
    movea.l a0, a3
l_3422c:
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.w  d0, d5
    cmpi.w  #$ff, d5
    bne.b   l_34244
    moveq   #-$2,d5
l_34244:
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $10(a7), a7
    move.w  d0, d2
    cmpi.w  #$ff, d2
    bne.b   l_34262
    moveq   #-$2,d2
l_34262:
    move.w  d5, d0
    addq.w  #$1, d0
    move.w  d2, d1
    addq.w  #$1, d1
    mulu.w  d1, d0
    move.w  d0, d2
    tst.w   d2
    bge.w   l_34302
    tst.w   d5
    bge.b   l_34282
    move.w  $2(a2), d2
    move.w  (a2), $2(a2)
    move.w  d2, (a2)
l_34282:
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0390                                 ; jsr $034628(pc)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_34302
    addi.w  #$64, (a3)
    cmp.w   (a2), d4
    beq.b   l_342b2
    cmp.w   $2(a2), d4
    bne.b   l_342b6
l_342b2:
    addi.w  #$1e, (a3)
l_342b6:
    cmpi.w  #$1, -$1a(a6)
    bne.b   l_342d6
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0172                                 ; jsr $03443A(pc)
    nop
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_342d6
    addi.w  #$64, (a3)
l_342d6:
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0508                                 ; jsr $0347E8(pc)
    nop
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_342ee
    addi.w  #$14, (a3)
l_342ee:
    cmpi.w  #$3, $2(a2)
    beq.b   l_342fe
    cmpi.w  #$5, $2(a2)
    bne.b   l_34302
l_342fe:
    addi.w  #$32, (a3)
l_34302:
    tst.w   (a3)
    bgt.b   l_34310
    move.w  #$ff, d0
    move.w  d0, (a2)
    move.w  d0, $2(a2)
l_34310:
    addq.l  #$4, a2
    addq.l  #$2, a3
    addq.w  #$1, d3
    cmpi.w  #$6, d3
    bcs.w   l_3422c
    clr.w   d4
l_34320:
    movea.l a4, a2
    moveq   #-$A,d2
    clr.w   d3
l_34326:
    cmp.w   (a2), d2
    bge.b   l_3432e
    move.w  (a2), d2
    move.w  d3, d7
l_3432e:
    addq.l  #$2, a2
    addq.w  #$1, d3
    cmpi.w  #$6, d3
    bcs.b   l_34326
    moveq   #$0,d0
    move.w  d7, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$ff9c, (a4,a0.l)
    move.w  d4, d0
    add.w   d0, d0
    move.w  d7, -$18(a6, d0.w)
    addq.w  #$1, d4
    cmpi.w  #$6, d4
    bcs.b   l_34320
    clr.w   d4
l_34358:
    move.w  d4, d0
    add.w   d0, d0
    move.w  -$18(a6, d0.w), d0
    lsl.w   #$2, d0
    movea.l  #$00FFA794,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$ff, (a2)
    beq.w   l_34430
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.w  d0, d3
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1774                                 ; jsr $035B10(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    cmpi.w  #$20, d3
    bcc.b   l_34426
    cmpi.w  #$20, d2
    bcc.b   l_34426
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$045A                                 ; jsr $034820(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$10, d5
    bcc.b   l_34426
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$058E                                 ; jsr $034978(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d7
    cmp.w   ($00FFA7DA).l, d7
    bcc.b   l_34430
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$05D6                                 ; jsr $0349F2(pc)
    nop
    lea     $14(a7), a7
    bra.b   l_34430
l_34426:
    addq.w  #$1, d4
    cmpi.w  #$6, d4
    bcs.w   l_34358
l_34430:
    movem.l -$44(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03443A -- (TODO: name)
; 204 bytes | $03443A-$034505
; ============================================================================
func_03443A:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $1c(a7), d4
    clr.w   d5
    movea.l  #$00FF0018,a3
    clr.w   d3
l_3444c:
    tst.b   (a3)
    bne.w   l_344f0
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_34470
l_3446c:
    moveq   #$1,d5
    bra.b   l_344ea
l_34470:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d4, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    bne.b   l_3446c
    move.w  d3, d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_344e2
l_344a4:
    cmpi.w  #$59, (a2)
    bcc.b   l_344dc
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    beq.b   l_3446c
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    beq.b   l_3446c
l_344dc:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_344e2:
    cmp.w   ($00FFA7DA).l, d2
    bcs.b   l_344a4
l_344ea:
    cmpi.w  #$1, d5
    beq.b   l_344fe
l_344f0:
    moveq   #$24,d0
    adda.l  d0, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_3444c
l_344fe:
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2-a3
    rts

; ============================================================================
; func_034506 -- (TODO: name)
; 290 bytes | $034506-$034627
; ============================================================================
func_034506:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d3
    move.l  $c(a6), d7
    lea     -$4(a6), a2
    lea     -$2(a6), a3
    clr.w   (a3)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$20, d0
    bcc.w   l_3461c
    clr.w   d4
l_34540:
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FFA7AC,a0
    move.w  (a0,d0.w), d2
    cmpi.w  #$7, d2
    bcc.w   l_34612
    cmp.w   d7, d2
    beq.w   l_34612
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$20, d0
    bcc.w   l_34612
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$009A                                 ; jsr $034628(pc)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_34612
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0272                                 ; jsr $034820(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, (a2)
    cmpi.w  #$10, (a2)
    bcc.b   l_34612
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$03A6                                 ; jsr $034978(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    cmp.w   ($00FFA7DA).l, d2
    bcc.b   l_34612
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$03EE                                 ; jsr $0349F2(pc)
    nop
    lea     $14(a7), a7
    move.w  #$1, (a3)
    bra.b   l_3461c
l_34612:
    addq.w  #$1, d4
    cmpi.w  #$8, d4
    bcs.w   l_34540
l_3461c:
    move.w  (a3), d0
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts

; ============================================================================
; func_034628 -- (TODO: name)
; 152 bytes | $034628-$0346BF
; ============================================================================
func_034628:
    movem.l d2-d7/a2, -(a7)
    move.l  $20(a7), d2
    move.l  $28(a7), d5
    move.l  $24(a7), d6
    moveq   #$1,d7
    moveq   #$1,d0
    lsl.b   d5, d0
    move.w  d2, d1
    mulu.w  #$7, d1
    add.w   d6, d1
    movea.l  #$00FFA7BC,a0
    and.b   (a0,d1.w), d0
    bne.b   l_346b8
    move.w  d2, d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_346a6
l_34668:
    cmpi.w  #$59, (a2)
    bcc.b   l_346a0
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d4
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$8, a7
    move.w  d0, d3
    cmp.w   d6, d4
    bne.b   l_34698
    cmp.w   d5, d3
    bne.b   l_346a0
    bra.b   l_346ae
l_34698:
    cmp.w   d5, d4
    bne.b   l_346a0
    cmp.w   d6, d3
    beq.b   l_346ae
l_346a0:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_346a6:
    cmp.w   ($00FFA7DA).l, d2
    bcs.b   l_34668
l_346ae:
    cmp.w   ($00FFA7DA).l, d2
    bne.b   l_346b8
    clr.w   d7
l_346b8:
    move.w  d7, d0
    movem.l (a7)+, d2-d7/a2
    rts

; ============================================================================
; func_0346C0 -- (TODO: name)
; 296 bytes | $0346C0-$0347E7
; ============================================================================
func_0346C0:
    movem.l d2-d6/a2, -(a7)
    move.l  $20(a7), d2
    move.l  $1c(a7), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$20, d5
    bcc.w   l_347e2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00E4                                 ; jsr $0347E8(pc)
    nop
    cmpi.w  #$1, d0
    bls.b   l_34712
    clr.w   d4
    bra.b   l_34714
l_34712:
    moveq   #$1,d4
l_34714:
    move.w  ($00FF0002).l, d0
    ext.l   d0
    move.l  #$12c, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0002,$6270                           ; jsr $026270
    addq.l  #$4, a7
    add.l   $e(a2), d0
    add.l   (a7)+, d0
    addi.l  #$12c, d0
    cmp.l   $a(a2), d0
    bls.b   l_3474c
    moveq   #$1,d4
l_3474c:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$15E6                                 ; jsr $035D46(pc)
    nop
    lea     $10(a7), a7
    move.w  d0, d2
    cmpi.w  #$59, d2
    bcc.b   l_347e2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$009C                                 ; jsr $034820(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d4
    cmpi.w  #$10, d4
    bcc.b   l_347e2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01D0                                 ; jsr $034978(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d6
    cmp.w   ($00FFA7DA).l, d6
    bcc.b   l_347e2
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0218                                 ; jsr $0349F2(pc)
    nop
    lea     $14(a7), a7
l_347e2:
    movem.l (a7)+, d2-d6/a2
    rts

; ============================================================================
; func_0347E8 -- (TODO: name)
; 56 bytes | $0347E8-$03481F
; ============================================================================
func_0347E8:
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d4
    clr.w   d3
    clr.w   d2
l_347f4:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_34810
    addq.w  #$1, d3
l_34810:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_347f4
    move.w  d3, d0
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; func_034820 -- (TODO: name)
; 344 bytes | $034820-$034977
; ============================================================================
func_034820:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d3
    lea     -$6(a6), a4
    lea     -$2(a6), a5
    move.w  #$ff, d0
    move.w  d0, -$8(a6)
    move.w  d0, (a4)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$865E                           ; jsr $00865E
    move.w  d0, -$a(a6)
    move.l  #$270fd8f0, d6
    move.l  d6, d5
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    lea     $10(a7), a7
    move.w  d0, -$4(a6)
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_34886
    addq.l  #$3, d0
l_34886:
    asr.l   #$2, d0
    addi.w  #$37, d0
    move.w  d0, d4
    movea.l  #$00FFA6B8,a2
    move.w  $a(a6), d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d3
l_348a8:
    move.w  $2(a2), d0
    cmp.w   -$4(a6), d0
    bls.w   l_3494e
    moveq   #$0,d0
    move.b  $6(a2), d0
    addi.w  #$ffff, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bgt.w   l_3494e
    moveq   #$0,d0
    move.w  d4, d0
    moveq   #$0,d1
    move.b  $7(a2), d1
    ext.l   d1
    subq.l  #$2, d1
    cmp.l   d1, d0
    bge.b   l_3494e
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$8016                           ; jsr $008016
    addq.l  #$8, a7
    cmpi.w  #$ffff, d0
    beq.b   l_3494e
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    moveq   #$0,d2
    move.w  -$a(a6), d2
    sub.l   d0, d2
    tst.l   d2
    bge.b   l_34914
    moveq   #$0,d0
    sub.l   d2, d0
    move.l  d0, d2
l_34914:
    moveq   #$0,d0
    move.w  $4(a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d7
    moveq   #$0,d1
    move.w  d7, d1
    move.l  d2, d0
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, d2
    cmp.l   d5, d2
    bgt.b   l_34940
    move.l  d2, d5
    move.w  d3, -$8(a6)
l_34940:
    tst.b   $1(a3)
    beq.b   l_3494e
    cmp.l   d6, d2
    bgt.b   l_3494e
    move.l  d2, d6
    move.w  d3, (a4)
l_3494e:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$2, a3
    addq.w  #$1, d3
    cmpi.w  #$10, d3
    bcs.w   l_348a8
    cmpi.w  #$10, (a4)
    bcc.b   l_34968
    move.w  (a4), (a5)
    bra.b   l_3496c
l_34968:
    move.w  -$8(a6), (a5)
l_3496c:
    move.w  (a5), d0
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_034978 -- (TODO: name)
; 122 bytes | $034978-$0349F1
; ============================================================================
func_034978:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $20(a7), d3
    move.l  $24(a7), d4
    movea.l  #$00FFA7DA,a1
    move.w  #$ff, d1
    move.w  $1e(a7), d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l a0, a2
    clr.w   d2
    move.w  (a1), d5
    bra.b   l_349c6
l_349aa:
    cmp.w   (a2), d3
    bne.b   l_349b6
    cmp.w   $2(a2), d4
    bne.b   l_349c0
    bra.b   l_349ca
l_349b6:
    cmp.w   (a2), d4
    bne.b   l_349c0
    cmp.w   $2(a2), d3
    beq.b   l_349ca
l_349c0:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_349c6:
    cmp.w   d5, d2
    bcs.b   l_349aa
l_349ca:
    cmp.w   (a1), d2
    bne.b   l_349ea
    movea.l a3, a2
    clr.w   d2
    move.w  (a1), d3
    bra.b   l_349e6
l_349d6:
    cmpi.w  #$ff, (a2)
    bne.b   l_349e0
    move.w  d2, d1
    bra.b   l_349ea
l_349e0:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_349e6:
    cmp.w   d3, d2
    bcs.b   l_349d6
l_349ea:
    move.w  d1, d0
    movem.l (a7)+, d2-d5/a2-a3
    rts

; ============================================================================
; func_0349F2 -- (TODO: name)
; 206 bytes | $0349F2-$034ABF
; ============================================================================
func_0349F2:
    movem.l d2-d5/a2, -(a7)
    move.l  $18(a7), d2
    move.l  $28(a7), d3
    move.l  $24(a7), d4
    move.l  $20(a7), d5
    move.w  d2, d0
    mulu.w  #$30, d0
    move.w  $1e(a7), d1
    mulu.w  #$c, d1
    add.w   d1, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d5, (a2)
    move.w  d4, $2(a2)
    move.w  d3, $4(a2)
    move.w  d5, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    moveq   #$0,d0
    move.b  (a1), d0
    moveq   #$0,d1
    move.b  $1(a1), d1
    sub.l   d1, d0
    bne.b   l_34a58
    move.w  #$1, $6(a2)
    bra.b   l_34a5e
l_34a58:
    move.w  #$3, $6(a2)
l_34a5e:
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    moveq   #$0,d0
    move.b  (a1), d0
    moveq   #$0,d1
    move.b  $1(a1), d1
    sub.l   d1, d0
    bne.b   l_34a8a
    move.w  #$1, $8(a2)
    bra.b   l_34a90
l_34a8a:
    move.w  #$3, $8(a2)
l_34a90:
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    tst.b   $1(a1)
    bne.b   l_34ab4
    move.w  #$1, $a(a2)
    bra.b   l_34aba
l_34ab4:
    move.w  #$3, $8(a2)
l_34aba:
    movem.l (a7)+, d2-d5/a2
    rts

; ============================================================================
; func_034AC0 -- (TODO: name)
; 302 bytes | $034AC0-$034BED
; ============================================================================
func_034AC0:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d4
    lea     -$4(a6), a3
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, -$2(a6)
    move.w  #$ff, d0
    move.w  d0, d7
    move.w  d0, (a3)
    move.l  #$5f5e0ff, d6
    move.l  d6, d5
    move.w  ($00FF0004).l, d2
    ext.l   d2
    addq.l  #$4, d2
    moveq   #$7,d0
    cmp.l   d2, d0
    ble.b   l_34b22
    move.w  ($00FF0004).l, d2
    ext.l   d2
    addq.l  #$4, d2
    bra.b   l_34b24
l_34b22:
    moveq   #$7,d2
l_34b24:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $6100,$DB36                                 ; bsr.w $032662
    addq.l  #$8, a7
    cmp.w   d2, d0
    bcc.w   l_34be4
    clr.w   d2
l_34b38:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_34b8e
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $6100,$DB52                                 ; bsr.w $0326B2
    addq.l  #$8, a7
    move.l  d0, d3
    tst.l   d3
    ble.b   l_34b74
    cmp.l   d5, d3
    bge.b   l_34b8e
    move.l  d3, d5
    move.w  d2, d7
    bra.b   l_34b8e
l_34b74:
    cmp.w   -$2(a6), d2
    bne.b   l_34b86
    move.l  d3, d0
    moveq   #$3,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.l  d0, d3
l_34b86:
    cmp.l   d6, d3
    bge.b   l_34b8e
    move.l  d3, d6
    move.w  d2, (a3)
l_34b8e:
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.b   l_34b38
    cmpi.w  #$7, d7
    bcc.b   l_34be4
    cmpi.w  #$7, (a3)
    bcc.b   l_34be4
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$003E                                 ; jsr $034BEE(pc)
    nop
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$28, d2
    bcc.b   l_34be4
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00F4                                 ; jsr $034CC4(pc)
    nop
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FADE                                 ; bsr.w $0346C0
l_34be4:
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts

; ============================================================================
; func_034BEE -- (TODO: name)
; 214 bytes | $034BEE-$034CC3
; ============================================================================
func_034BEE:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d2
    move.l  $24(a7), d6
    move.w  #$ff, d5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$20, d4
    bcc.w   l_34cbc
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$74F8                           ; jsr $0074F8
    addq.l  #$8, a7
    cmpi.w  #$2, d0
    ble.b   l_34cbc
    move.w  #$ffff, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$759E                           ; jsr $00759E
    addq.l  #$8, a7
    move.w  d0, d6
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   l_34cbc
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d6, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d6, d2
    bra.b   l_34ca6
l_34c88:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bgt.b   l_34cbc
    cmp.w   $8(a2), d3
    bls.b   l_34ca0
    move.w  $8(a2), d3
    move.w  d2, d5
l_34ca0:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_34ca6:
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_34c88
l_34cbc:
    move.w  d5, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts

RemoveCharRelation:                                                  ; $034CC4
    link    a6,#-$3c
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0008(a6),d2
    move.l  $000c(a6),d3
    movea.l #$00ff9a20,a4
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  $0004(a3),d1
    cmp.l   d1,d0
    blt.w   .l34f80
    moveq   #$0,d0
    move.b  $0004(a3),d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
    ble.w   .l34f80
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    lea     (a4,d0.l),a0
    adda.l  (sp)+,a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     -$001e(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     -$003c(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0003).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$a506                           ; jsr $01A506
    bge.b   .l34d8c
    addq.l  #$1,d0
.l34d8c:                                                ; $034D8C
    asr.l   #$1,d0
    move.l  d0,d5
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    move.w  d0,d4
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    move.w  d0,d7
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    lea     $0028(sp),sp
    move.w  d0,d6
    cmpi.b  #$20,$0001(a2)
    bcc.b   .l34de2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    lsl.w   #$2,d1
    movea.l #$00ffa6a0,a0
    eor.l   d0,(a0,d1.w)
    subq.b  #$01,$0002(a3)
    bra.b   .l34e22
.l34de2:                                                ; $034DE2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    lsl.w   #$2,d1
    movea.l #$0005ecbe,a0
    move.b  (a0,d1.w),d1
    andi.l  #$ff,d1
    sub.w   d1,d0
    moveq   #$1,d1
    lsl.w   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    mulu.w  #$e,d1
    movea.l d7,a0
    move.w  d4,d7
    add.w   d7,d7
    exg     d7,a0
    add.w   a0,d1
    movea.l #$00ffbd6c,a0
    eor.w   d0,(a0,d1.w)
    subq.b  #$01,$0003(a3)
.l34e22:                                                ; $034E22
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$3,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    move.b  $0003(a2),d1
    movea.l #$00ffba81,a0
    sub.b   d1,(a0,d0.w)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$3,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    move.b  $0003(a2),d1
    movea.l #$00ffba81,a0
    sub.b   d1,(a0,d0.w)
    add.l   d5,$0006(a3)
    subq.b  #$01,$0005(a3)
    move.w  d2,d0
    lsl.w   #$5,d0
    move.w  d7,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e9,a0
    add.b   d6,(a0,d0.w)
    cmpi.w  #$27,d3
    bcc.b   .l34eaa
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$28,d1
    sub.l   d0,d1
    move.l  d1,d0
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    subi.l  #$14,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    move.l  a2,d0
    moveq   #$14,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538
    lea     $0014(sp),sp
.l34eaa:                                                ; $034EAA
    pea     ($0014).w
    clr.l   -(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    lea     (a4,d0.l),a0
    lea     $030c(a0),a0
    move.l  a0,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    lea     $000c(sp),sp
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    movea.l d0,a0
    lea     $030c(a4),a1
    move.b  #$ff,(a1,a0.l)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    movea.l d0,a0
    lea     $030d(a4),a1
    move.b  #$ff,(a1,a0.l)
    cmpi.w  #$1,$0012(a6)
    bne.b   .l34f80
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    pea     -$003c(a6)
    pea     -$001e(a6)
    move.w  d2,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    pea     ($000448E4).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($0001).w
    clr.l   -(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$68ca                           ; jsr $0068CA
    lea     $002c(sp),sp
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    pea     ($001E).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
.l34f80:                                                ; $034F80
    movem.l -$0060(a6),d2-d7/a2-a4
    unlk    a6
    rts
    dc.w    $48E7,$3020,$242F; $034F8A
; === Translated block $034F90-$0357FE ===
; 11 functions, 2158 bytes

; ============================================================================
; func_034F90 -- (TODO: name)
; 208 bytes | $034F90-$03505F
; ============================================================================
func_034F90:
    dc.w    $0010,$3002                     ; ori.b #$2,(a0) - high byte $30 is compiler junk
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    bra.w   l_35050
l_34faa:
    cmpi.w  #$59, (a2)
    bcc.w   l_3504a
    cmpi.w  #$1, $6(a2)
    bne.b   l_34ffc
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0098                                 ; jsr $035060(pc)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_34fdc
    move.w  #$3, $6(a2)
    bra.b   l_34ffc
l_34fdc:
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0138                                 ; jsr $035122(pc)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_34ffc
    move.w  #$2, $6(a2)
l_34ffc:
    cmpi.w  #$1, $8(a2)
    bne.b   l_3504a
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$004C                                 ; jsr $035060(pc)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_35028
    move.w  #$3, $8(a2)
    bra.b   l_3504a
l_35028:
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00EA                                 ; jsr $035122(pc)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_3504a
    move.w  #$2, $8(a2)
l_3504a:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d3
l_35050:
    cmp.w   ($00FFA7DA).l, d3
    bcs.w   l_34faa
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; func_035060 -- (TODO: name)
; 194 bytes | $035060-$035121
; ============================================================================
func_035060:
    movem.l d2-d5/a2, -(a7)
    move.l  $18(a7), d3
    move.l  $1c(a7), d4
    clr.w   d5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    moveq   #$0,d0
    move.b  $4(a1), d0
    mulu.w  #$14, d0
    move.w  d3, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  $4(a1), d2
    bra.b   l_35104
l_350a6:
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d4, d0
    beq.b   l_350b8
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d4, d0
    bne.b   l_350fe
l_350b8:
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcc.b   l_350fe
    cmpi.b  #$2, $3(a2)
    bls.b   l_350fe
    subq.b  #$1, $3(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    subq.b  #$1, (a0,d0.w)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    subq.b  #$1, (a0,d0.w)
    moveq   #$1,d5
l_350fe:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_35104:
    moveq   #$0,d0
    move.b  $4(a1), d0
    moveq   #$0,d1
    move.b  $5(a1), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_350a6
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2
    rts

; ============================================================================
; func_035122 -- (TODO: name)
; 322 bytes | $035122-$035263
; ============================================================================
func_035122:
    link    a6,#$0
    movem.l d2-d7/a2, -(a7)
    move.l  $c(a6), d4
    move.l  $8(a6), d5
    clr.w   d6
    moveq   #$0,d0
    move.w  d5, d0
    lsl.l   #$5, d0
    move.l  d0, d7
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    clr.w   d2
l_3514c:
    tst.b   $1(a2)
    bne.b   l_35156
    moveq   #$1,d3
    bra.b   l_3516e
l_35156:
    cmpi.b  #$1, $1(a2)
    bne.b   l_3516e
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bne.b   l_3516e
    clr.w   d3
    bra.b   l_35178
l_3516e:
    addq.l  #$8, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_3514c
l_35178:
    cmpi.w  #$1, d3
    bne.w   l_35258
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$8458                           ; jsr $008458
    addq.l  #$8, a7
    move.w  d0, d3
    beq.w   l_35258
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9D92                           ; jsr $009D92
    cmpi.w  #$2, d0
    bge.b   l_351b6
    moveq   #$1,d2
    bra.b   l_351b8
l_351b6:
    clr.w   d2
l_351b8:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0FB4                                 ; jsr $03617A(pc)
    nop
    lea     $10(a7), a7
    move.w  d0, d2
    cmpi.w  #$4, d2
    bcc.w   l_35258
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d7, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d4, (a2)
    move.b  #$1, $1(a2)
    move.b  d3, $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00044912).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9E1C                           ; jsr $009E1C
    pea     ($001E).w
    dc.w    $4EB9,$0001,$E2F4                           ; jsr $01E2F4
    moveq   #$1,d6
l_35258:
    move.w  d6, d0
    movem.l -$1c(a6), d2-d7/a2
    unlk    a6
    rts

; ============================================================================
; func_035264 -- (TODO: name)
; 208 bytes | $035264-$035333
; ============================================================================
func_035264:
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $1c(a7), d4
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    movea.l  #$00FF8824,a3
    clr.w   d2
l_35284:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d3
    lsl.l   d0, d3
    move.l  (a4), d0
    and.l   d3, d0
    bne.b   l_352d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0094                                 ; jsr $035334(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_352d2
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d3
    sub.b   d3, $1(a3)
    sub.b   d3, (a2)
l_352d2:
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    bcs.b   l_35284
    movea.l  #$00FF8864,a3
    moveq   #$20,d2
l_352e4:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0042                                 ; jsr $035334(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_35324
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d3
    sub.b   d3, $1(a3)
    sub.b   d3, (a2)
l_35324:
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_352e4
    movem.l (a7)+, d2-d4/a2-a4
    rts

; ============================================================================
; func_035334 -- (TODO: name)
; 72 bytes | $035334-$03537B
; ============================================================================
func_035334:
    movem.l d2-d4, -(a7)
    move.l  $14(a7), d3
    clr.w   d1
    move.w  $12(a7), d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
    move.w  ($00FFA7DA).l, d4
    bra.b   l_35370
l_3535c:
    cmp.w   (a1), d3
    bne.b   l_35364
l_35360:
    moveq   #$1,d1
    bra.b   l_35374
l_35364:
    cmp.w   $2(a1), d3
    beq.b   l_35360
    moveq   #$C,d0
    adda.l  d0, a1
    addq.w  #$1, d2
l_35370:
    cmp.w   d4, d2
    bcs.b   l_3535c
l_35374:
    move.w  d1, d0
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; func_03537C -- (TODO: name)
; 68 bytes | $03537C-$0353BF
; ============================================================================
func_03537C:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d3
    clr.w   d1
    move.w  $e(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_3539a:
    cmpi.b  #$1, $1(a1)
    bne.b   l_353ae
    moveq   #$0,d0
    move.b  (a1), d0
    cmp.w   d3, d0
    bne.b   l_353ae
    moveq   #$1,d1
    bra.b   l_353b8
l_353ae:
    addq.l  #$8, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_3539a
l_353b8:
    move.w  d1, d0
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; func_0353C0 -- (TODO: name)
; 384 bytes | $0353C0-$03553F
; ============================================================================
func_0353C0:
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $28(a7), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.w  d0, d7
    movea.l  #$0005ECBC,a2
    clr.w   d4
l_353f6:
    cmp.w   d7, d4
    beq.w   l_3552e
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0D72                                 ; jsr $03617A(pc)
    nop
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$ff, d0
    beq.w   l_3553a
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$ff, d2
    bne.w   l_3552e
    moveq   #$0,d2
    move.b  (a2), d2
    bra.w   l_35518
l_3543e:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    beq.w   l_35516
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00D8                                 ; jsr $035540(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.w   l_35516
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d5
    move.b  $3(a3), d5
    mulu.w  #$f, d5
    addi.w  #$12c, d5
    move.w  d5, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9D92                           ; jsr $009D92
    addq.l  #$8, a7
    addq.w  #$1, d0
    move.l  d0, d5
    mulu.w  (a7)+, d5
    moveq   #$0,d0
    move.w  d5, d0
    cmp.l   $6(a4), d0
    bge.b   l_35516
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d6, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.b  d2, (a3)
    move.b  #$3, $1(a3)
    moveq   #$0,d0
    move.w  d5, d0
    sub.l   d0, $6(a4)
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$68CA                           ; jsr $0068CA
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6B78                           ; jsr $006B78
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$C43C                           ; jsr $01C43C
    lea     $1c(a7), a7
    bra.b   l_3552e
l_35516:
    addq.w  #$1, d2
l_35518:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.w   l_3543e
l_3552e:
    addq.l  #$4, a2
    addq.w  #$1, d4
    cmpi.w  #$7, d4
    bcs.w   l_353f6
l_3553a:
    movem.l (a7)+, d2-d7/a2-a4
    rts

; ============================================================================
; func_035540 -- (TODO: name)
; 68 bytes | $035540-$035583
; ============================================================================
func_035540:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d3
    clr.w   d1
    move.w  $e(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_3555e:
    cmpi.b  #$3, $1(a1)
    bne.b   l_35572
    moveq   #$0,d0
    move.b  (a1), d0
    cmp.w   d3, d0
    bne.b   l_35572
    moveq   #$1,d1
    bra.b   l_3557c
l_35572:
    addq.l  #$8, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_3555e
l_3557c:
    move.w  d1, d0
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; func_035584 -- (TODO: name)
; 100 bytes | $035584-$0355E7
; ============================================================================
func_035584:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d4
    move.w  d4, d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_355da
l_355a2:
    cmpi.w  #$59, (a2)
    bcc.b   l_355d4
    cmpi.w  #$1, $a(a2)
    bne.b   l_355d4
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0028                                 ; jsr $0355E8(pc)
    nop
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$1, d3
    bne.b   l_355d4
    move.w  #$2, $a(a2)
l_355d4:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_355da:
    cmp.w   ($00FFA7DA).l, d2
    bcs.b   l_355a2
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; func_0355E8 -- (TODO: name)
; 410 bytes | $0355E8-$035781
; ============================================================================
func_0355E8:
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $28(a7), d4
    move.l  $24(a7), d5
    clr.w   d7
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_35626
    addq.l  #$3, d0
l_35626:
    asr.l   #$2, d0
    addi.w  #$37, d0
    move.w  d0, d2
    cmpi.l  #$bb8, $6(a2)
    ble.w   l_3577a
    moveq   #$0,d0
    move.b  $6(a3), d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.w   l_3577a
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $7(a3), d1
    ext.l   d1
    cmp.l   d1, d0
    bge.w   l_3577a
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$8016                           ; jsr $008016
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$ffff, d0
    beq.w   l_3577a
    move.b  (a3), d0
    cmp.b   ($00FF09A0).l, d0
    bne.b   l_3568e
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_3568a
    addq.l  #$1, d0
l_3568a:
    asr.l   #$1, d0
    move.w  d0, d3
l_3568e:
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    cmp.l   $6(a2), d0
    bge.b   l_3569e
    moveq   #$3,d2
    bra.b   l_356c4
l_3569e:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    cmp.l   $6(a2), d0
    bge.b   l_356b2
    moveq   #$2,d2
    bra.b   l_356c4
l_356b2:
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0
    cmp.l   $6(a2), d0
    bge.b   l_356c2
    moveq   #$1,d2
    bra.b   l_356c4
l_356c2:
    clr.w   d2
l_356c4:
    tst.w   d2
    beq.w   l_3577a
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0002,$F548                           ; jsr $02F548
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$5, d6
    bcc.w   l_3577a
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  d2, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    sub.l   d0, $6(a2)
    move.w  d5, d0
    mulu.w  #$14, d0
    move.w  d6, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d4, (a2)
    add.b   d2, $1(a2)
    move.b  #$1, $2(a2)
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    movea.l  #$00FF1278,a0
    move.b  (a0,d4.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00044938).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($001E).w
    dc.w    $4EB9,$0001,$E2F4                           ; jsr $01E2F4
    lea     $20(a7), a7
    moveq   #$1,d7
l_3577a:
    move.w  d7, d0
    movem.l (a7)+, d2-d7/a2-a3
    rts

; ============================================================================
; func_035782 -- (TODO: name)
; 124 bytes | $035782-$0357FD
; ============================================================================
func_035782:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d3
    move.l  $18(a7), d4
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_357a0:
    moveq   #$0,d0
    move.b  $1(a2), d0
    tst.w   d0
    ble.b   l_357ee
    tst.w   d4
    bne.b   l_357bc
    moveq   #$0,d0
    move.b  $1(a2), d0
    andi.l  #$ffff, d0
    bra.b   l_357d6
l_357bc:
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmpi.w  #$a, d0
    ble.b   l_357ee
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    subi.l  #$a, d0
l_357d6:
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0018                                 ; jsr $0357FE(pc)
    nop
    lea     $c(a7), a7
l_357ee:
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    bcs.b   l_357a0
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; ApplyCharBonus -- (TODO: describe)
; Called: ?? times.
; 126 bytes | $0357FE-$03587B
; ============================================================================
ApplyCharBonus:                                                  ; $0357FE
    movem.l d2-d4/a2-a3,-(sp)
    move.l  $0020(sp),d2
    move.l  $0018(sp),d3
    move.l  $001c(sp),d4
    move.w  d3,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d3,d0
    lsl.w   #$5,d0
    move.w  d4,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    blt.b   .l35872
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$f4ee                           ; jsr $02F4EE
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d3
    add.l   d3,$0006(a3)
    sub.b   d2,(a2)
    sub.b   d2,$0001(a2)
    moveq   #$1,d2
    bra.b   .l35874
.l35872:                                                ; $035872
    clr.w   d2
.l35874:                                                ; $035874
    move.w  d2,d0
    movem.l (sp)+,d2-d4/a2-a3
    rts
    dc.w    $48E7,$2020                                      ; $03587C
; === Translated block $035880-$035CCC ===
; 5 functions, 1100 bytes

; ============================================================================
; func_035880 -- (TODO: name)
; 144 bytes | $035880-$03590F
; ============================================================================
func_035880:
    move.l  $c(a7), d2
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FEE2                                 ; bsr.w $035782
    addq.l  #$8, a7
    cmpi.b  #$63, $22(a2)
    bne.b   l_358c8
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F9B0                                 ; bsr.w $035264
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0104                                 ; jsr $0359C4(pc)
    nop
    lea     $c(a7), a7
l_358c8:
    cmpi.b  #$62, $22(a2)
    bne.b   l_358e2
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0DF4                                 ; jsr $0366D0(pc)
    nop
    addq.l  #$8, a7
l_358e2:
    cmpi.b  #$61, $22(a2)
    bne.b   l_3590a
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00CE                                 ; jsr $0359C4(pc)
    nop
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$000E                                 ; jsr $035910(pc)
    nop
    lea     $c(a7), a7
l_3590a:
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; func_035910 -- (TODO: name)
; 180 bytes | $035910-$0359C3
; ============================================================================
func_035910:
    movem.l d2/a2, -(a7)
    move.l  $c(a7), d2
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00044970).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($003C).w
    dc.w    $4EB9,$0001,$E2F4                           ; jsr $01E2F4
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    pea     ($0004494E).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $30(a7), a7
    pea     ($003C).w
    dc.w    $4EB9,$0001,$E2F4                           ; jsr $01E2F4
    addq.l  #$4, a7
    addi.l  #$186a0, $6(a2)
    cmpi.l  #$186a0, $6(a2)
    ble.b   l_359ae
    move.l  $6(a2), d0
    bra.b   l_359b4
l_359ae:
    move.l  #$186a0, d0
l_359b4:
    move.l  d0, $6(a2)
    move.b  #$64, $22(a2)
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; func_0359C4 -- (TODO: name)
; 154 bytes | $0359C4-$035A5D
; ============================================================================
func_0359C4:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $20(a7), d4
    move.l  $1c(a7), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
l_359e2:
    moveq   #$0,d0
    move.b  $4(a3), d0
    mulu.w  #$14, d0
    move.w  d5, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  $4(a3), d3
    moveq   #$0,d0
    move.b  $5(a3), d0
    add.w   d0, d3
    moveq   #$0,d2
    move.b  $4(a3), d2
    bra.b   l_35a50
l_35a16:
    tst.w   d4
    bne.b   l_35a3a
    move.b  $a(a2), d0
    btst    #$1, d0
    beq.b   l_35a4a
l_35a24:
    pea     ($0001).w
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F292                                 ; bsr.w $034CC4
    lea     $c(a7), a7
    bra.b   l_35a54
l_35a3a:
    cmpi.w  #$1, d4
    bne.b   l_35a4a
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcs.b   l_35a24
l_35a4a:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_35a50:
    cmp.w   d3, d2
    bcs.b   l_35a16
l_35a54:
    cmp.w   d3, d2
    bcs.b   l_359e2
    movem.l (a7)+, d2-d5/a2-a3
    rts

; ============================================================================
; func_035A5E -- (TODO: name)
; 178 bytes | $035A5E-$035B0F
; ============================================================================
func_035A5E:
    movem.l d2/a2-a4, -(a7)
    move.l  $14(a7), d2
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03F0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    cmpi.l  #$3e8, $6(a3)
    ble.b   l_35ade
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0002,$6270                           ; jsr $026270
    addq.l  #$4, a7
    add.l   $e(a3), d0
    cmp.l   $a(a3), d0
    bcc.b   l_35aca
    clr.b   $9(a2)
    clr.b   $a(a2)
    clr.b   $b(a2)
    bra.b   l_35b0a
l_35aca:
    move.b  #$1, $9(a2)
    move.b  #$1, $a(a2)
    move.b  #$1, $b(a2)
    bra.b   l_35b0a
l_35ade:
    cmpi.b  #$5a, (a4)
    bls.b   l_35af8
    move.b  #$3, $9(a2)
    move.b  #$3, $a(a2)
    move.b  #$3, $b(a2)
    bra.b   l_35b0a
l_35af8:
    move.b  #$2, $9(a2)
    move.b  #$2, $a(a2)
    move.b  #$2, $b(a2)
l_35b0a:
    movem.l (a7)+, d2/a2-a4
    rts

; ============================================================================
; func_035B10 -- (TODO: name)
; 444 bytes | $035B10-$035CCB
; ============================================================================
func_035B10:
    link    a6,#-$8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d5
    lea     -$2(a6), a5
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01A2                                 ; jsr $035CCC(pc)
    nop
    move.w  d0, -$6(a6)
    move.w  #$ff, d0
    move.w  d0, -$4(a6)
    move.w  d0, (a5)
    moveq   #$0,d7
    moveq   #$0,d6
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    lea     $c(a7), a7
    move.w  d0, d3
    cmpi.w  #$20, d0
    bcc.b   l_35b66
    move.w  d3, d5
    bra.w   l_35cc0
l_35b66:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  (a4), d3
    bra.w   l_35c9c
l_35b90:
    clr.w   d4
    movea.l  #$00FF0018,a3
    clr.w   d2
l_35b9a:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   l_35bba
    addq.w  #$1, d4
l_35bba:
    moveq   #$24,d0
    adda.l  d0, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_35b9a
    cmpi.w  #$1, d4
    bhi.w   l_35c98
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    addq.l  #$8, a7
    cmp.w   -$6(a6), d0
    bhi.w   l_35c98
    move.w  ($00FFBD4C).l, d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a2), d0
    ext.l   d0
    move.w  ($00FFBD4C).l, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    add.l   (a7)+, d0
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    moveq   #$0,d1
    move.b  $1(a2), d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, d2
    moveq   #$0,d0
    move.b  $3(a2), d0
    andi.l  #$ffff, d0
    moveq   #$5A,d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    addi.w  #$a, d0
    move.w  d0, d4
    moveq   #$0,d1
    move.w  d4, d1
    move.l  d2, d0
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, d2
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9D92                           ; jsr $009D92
    addq.l  #$8, a7
    cmpi.w  #$2, d0
    bge.b   l_35c8e
    cmp.l   d7, d2
    ble.b   l_35c98
    move.w  d3, (a5)
    move.l  d2, d7
    bra.b   l_35c98
l_35c8e:
    cmp.l   d6, d2
    ble.b   l_35c98
    move.w  d3, -$4(a6)
    move.l  d2, d6
l_35c98:
    addq.l  #$4, a2
    addq.w  #$1, d3
l_35c9c:
    moveq   #$0,d0
    move.b  (a4), d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.w   l_35b90
    cmpi.w  #$20, (a5)
    bcc.b   l_35cbc
    move.w  (a5), d5
    bra.b   l_35cc0
l_35cbc:
    move.w  -$4(a6), d5
l_35cc0:
    move.w  d5, d0
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; FindBestCharValue -- (TODO: describe)
; 122 bytes | $035CCC-$035D45
; ============================================================================
FindBestCharValue:                                                  ; $035CCC
    movem.l d2-d5/a2,-(sp)
    move.l  $0018(sp),d5
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l35ce0
    addq.l  #$3,d0
.l35ce0:                                                ; $035CE0
    asr.l   #$2,d0
    addi.w  #$37,d0
    move.w  d0,d4
    clr.w   d3
    movea.l #$00ffa6b8,a2
    clr.w   d2
.l35cf2:                                                ; $035CF2
    moveq   #$0,d0
    move.b  $0006(a2),d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d4,d1
    cmp.l   d1,d0
    bgt.b   .l35d32
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0007(a2),d1
    ext.l   d1
    cmp.l   d1,d0
    bge.b   .l35d32
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$8016                           ; jsr $008016
    addq.l  #$8,sp
    cmpi.w  #$ffff,d0
    beq.b   .l35d32
    cmp.w   $0002(a2),d3
    bcc.b   .l35d32
    move.w  $0002(a2),d3
.l35d32:                                                ; $035D32
    moveq   #$c,d0
    adda.l  d0,a2
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    bcs.b   .l35cf2
    move.w  d3,d0
    movem.l (sp)+,d2-d5/a2
    rts
; === Translated block $035D46-$0366D0 ===
; 10 functions, 2442 bytes

; ============================================================================
; func_035D46 -- (TODO: name)
; 778 bytes | $035D46-$03604F
; ============================================================================
func_035D46:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d6
    lea     -$4(a6), a5
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d5
    move.w  #$ff, d6
    cmpi.w  #$20, d5
    bcc.w   l_36044
    clr.l   (a5)
    moveq   #$0,d7
    moveq   #$0,d0
    move.b  (a3), d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  (a3), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  (a3), d4
    bra.w   l_35edc
l_35dba:
    cmpi.b  #$8, (a4)
    bcc.w   l_35ed6
    cmp.w   d4, d5
    beq.w   l_35ed6
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0314                                 ; jsr $0360F2(pc)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.w   l_35ed6
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$865E                           ; jsr $00865E
    move.l  d0, d3
    andi.l  #$ffff, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$02B4                                 ; jsr $0360C2(pc)
    nop
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    moveq   #$2,d0
    cmp.l   d1, d0
    bge.b   l_35e2c
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    bra.b   l_35e2e
l_35e2c:
    moveq   #$2,d1
l_35e2e:
    move.w  d1, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d3, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    tst.l   d0
    bge.b   l_35e42
    addq.l  #$3, d0
l_35e42:
    asr.l   #$2, d0
    move.l  d0, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01FC                                 ; jsr $036050(pc)
    nop
    lea     $14(a7), a7
    andi.l  #$ffff, d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d2
    cmpi.w  #$7, d2
    bcc.b   l_35e78
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_35e7a
l_35e78:
    moveq   #$7,d0
l_35e7a:
    move.w  d0, d2
    tst.w   $12(a6)
    bne.b   l_35e98
    moveq   #$0,d1
    move.w  d2, d1
    move.l  d3, d0
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, d3
    cmp.l   (a5), d3
    bls.b   l_35ed6
    move.l  d3, (a5)
    bra.b   l_35ed4
l_35e98:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$70DC                           ; jsr $0070DC
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E0C6                           ; jsr $03E0C6
    move.l  d3, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, d3
    cmp.l   d7, d3
    bls.b   l_35ed6
    move.l  d3, d7
l_35ed4:
    move.w  d4, d6
l_35ed6:
    addq.l  #$2, a4
    addq.l  #$2, a2
    addq.w  #$1, d4
l_35edc:
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bgt.w   l_35dba
    moveq   #$0,d0
    move.b  $2(a3), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  $2(a3), d4
    bra.w   l_3602c
l_35f10:
    move.b  (a2), d0
    cmp.b   $1(a2), d0
    bls.w   l_36028
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01C2                                 ; jsr $0360F2(pc)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.w   l_36028
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$865E                           ; jsr $00865E
    move.l  d0, d3
    andi.l  #$ffff, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0162                                 ; jsr $0360C2(pc)
    nop
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    moveq   #$2,d0
    cmp.l   d1, d0
    bge.b   l_35f7e
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    bra.b   l_35f80
l_35f7e:
    moveq   #$2,d1
l_35f80:
    move.w  d1, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d3, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    tst.l   d0
    bge.b   l_35f94
    addq.l  #$3, d0
l_35f94:
    asr.l   #$2, d0
    move.l  d0, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00AA                                 ; jsr $036050(pc)
    nop
    lea     $14(a7), a7
    andi.l  #$ffff, d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d2
    cmpi.w  #$7, d2
    bcc.b   l_35fca
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_35fcc
l_35fca:
    moveq   #$7,d0
l_35fcc:
    move.w  d0, d2
    tst.w   $12(a6)
    bne.b   l_35fea
    moveq   #$0,d1
    move.w  d2, d1
    move.l  d3, d0
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, d3
    cmp.l   (a5), d3
    bls.b   l_36028
    move.l  d3, (a5)
    bra.b   l_36026
l_35fea:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$70DC                           ; jsr $0070DC
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E0C6                           ; jsr $03E0C6
    move.l  d3, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, d3
    cmp.l   d7, d3
    bls.b   l_36028
    move.l  d3, d7
l_36026:
    move.w  d4, d6
l_36028:
    addq.l  #$2, a2
    addq.w  #$1, d4
l_3602c:
    moveq   #$0,d0
    move.b  $2(a3), d0
    moveq   #$0,d1
    move.b  $3(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bgt.w   l_35f10
l_36044:
    move.w  d6, d0
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_036050 -- (TODO: name)
; 114 bytes | $036050-$0360C1
; ============================================================================
func_036050:
    link    a6,#$0
    movem.l d2-d3, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    move.w  d0, d3
    cmpi.w  #$3200, d3
    bls.b   l_3607a
    moveq   #$1E,d2
    bra.b   l_360a8
l_3607a:
    cmpi.w  #$1900, d3
    bls.b   l_36084
    moveq   #$23,d2
    bra.b   l_360a8
l_36084:
    cmpi.w  #$c80, d3
    bls.b   l_3608e
    moveq   #$32,d2
    bra.b   l_360a8
l_3608e:
    cmpi.w  #$640, d3
    bls.b   l_36098
    moveq   #$64,d2
    bra.b   l_360a8
l_36098:
    cmpi.w  #$320, d3
    bls.b   l_360a4
    move.w  #$96, d2
    bra.b   l_360a8
l_360a4:
    move.w  #$c8, d2
l_360a8:
    cmpi.w  #$1e, d2
    ble.b   l_360b4
    move.w  d2, d0
    ext.l   d0
    bra.b   l_360b6
l_360b4:
    moveq   #$1E,d0
l_360b6:
    move.w  d0, d2
    movem.l -$8(a6), d2-d3
    unlk    a6
    rts

; ============================================================================
; func_0360C2 -- (TODO: name)
; 48 bytes | $0360C2-$0360F1
; ============================================================================
func_0360C2:
    move.l  d2, -(a7)
    clr.w   d1
    move.w  $a(a7), d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_360da:
    tst.b   $1(a1)
    beq.b   l_360e2
    addq.w  #$1, d1
l_360e2:
    addq.l  #$2, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_360da
    move.w  d1, d0
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_0360F2 -- (TODO: name)
; 136 bytes | $0360F2-$036179
; ============================================================================
func_0360F2:
    movem.l d2-d6/a2, -(a7)
    move.l  $1c(a7), d2
    move.l  $24(a7), d3
    move.l  $20(a7), d4
    moveq   #$1,d6
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$957C                           ; jsr $00957C
    lea     $c(a7), a7
    cmpi.w  #$ff, d0
    bne.b   l_36172
    move.w  d2, d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    move.w  ($00FFA7DA).l, d5
    bra.b   l_36164
l_36142:
    cmpi.w  #$59, (a2)
    bcc.b   l_3615e
    cmp.w   (a2), d4
    bne.b   l_36154
    cmp.w   $2(a2), d3
    bne.b   l_3615e
    bra.b   l_36168
l_36154:
    cmp.w   (a2), d3
    bne.b   l_3615e
    cmp.w   $2(a2), d4
    beq.b   l_36168
l_3615e:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_36164:
    cmp.w   d5, d2
    bcs.b   l_36142
l_36168:
    cmp.w   ($00FFA7DA).l, d2
    bne.b   l_36172
    clr.w   d6
l_36172:
    move.w  d6, d0
    movem.l (a7)+, d2-d6/a2
    rts

; ============================================================================
; func_03617A -- (TODO: name)
; 96 bytes | $03617A-$0361D9
; ============================================================================
func_03617A:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
    move.l  $10(a7), d3
    move.w  #$ff, d1
    tst.w   d3
    bne.b   l_3619a
    move.w  d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    bra.b   l_361a4
l_3619a:
    move.w  d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0350,a0
l_361a4:
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_361ac:
    tst.b   $1(a1)
    bne.b   l_361c0
    tst.w   d3
    bne.b   l_361ba
    move.w  d2, d1
    bra.b   l_361d2
l_361ba:
    moveq   #$3,d1
    sub.w   d2, d1
    bra.b   l_361d2
l_361c0:
    tst.w   d3
    bne.b   l_361c8
    addq.l  #$8, a1
    bra.b   l_361ca
l_361c8:
    subq.l  #$8, a1
l_361ca:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_361ac
l_361d2:
    move.w  d1, d0
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; func_0361DA -- (TODO: name)
; 22 bytes | $0361DA-$0361EF
; ============================================================================
func_0361DA:
    move.w  ($00FF0002).l, d0
    mulu.w  #$3c, d0
    move.w  ($00FF0006).l, d1
    sub.w   d0, d1
    move.w  d1, d0
    rts

; ============================================================================
; func_0361F0 -- (TODO: name)
; 288 bytes | $0361F0-$03630F
; ============================================================================
func_0361F0:
    movem.l d2-d6, -(a7)
    move.l  $18(a7), d2
    clr.w   d4
l_361fa:
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FF74                                 ; bsr.w $03617A
    addq.l  #$8, a7
    cmpi.w  #$ff, d0
    beq.w   l_3630a
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FFA7AC,a0
    move.w  (a0,d0.w), d3
    cmpi.w  #$7, d3
    bcc.w   l_36300
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$20, d0
    bcc.w   l_36300
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00BC                                 ; jsr $036310(pc)
    nop
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$59, d0
    bcc.b   l_362a4
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0198                                 ; jsr $03640A(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$ff, d0
    beq.b   l_362a4
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$02B8                                 ; jsr $03654E(pc)
    nop
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    beq.b   l_3630a
l_362a4:
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7728                           ; jsr $007728
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_36300
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$013C                                 ; jsr $03640A(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$ff, d0
    beq.b   l_36300
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$025C                                 ; jsr $03654E(pc)
    nop
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    beq.b   l_3630a
l_36300:
    addq.w  #$1, d4
    cmpi.w  #$8, d4
    bcs.w   l_361fa
l_3630a:
    movem.l (a7)+, d2-d6
    rts

; ============================================================================
; func_036310 -- (TODO: name)
; 250 bytes | $036310-$036409
; ============================================================================
func_036310:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d2
    move.l  $24(a7), d5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  #$ff, d6
    moveq   #$0,d4
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$20, d5
    bcc.w   l_36402
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$759E                           ; jsr $00759E
    addq.l  #$8, a7
    move.w  d0, d3
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.w   l_36402
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d2
    bra.b   l_363ec
l_36390:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bgt.b   l_36402
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.b   l_363e6
    moveq   #$0,d0
    move.b  $1(a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.b   l_363e6
    moveq   #$0,d0
    move.w  $e(a2), d0
    moveq   #$0,d1
    move.w  $6(a2), d1
    sub.l   d1, d0
    move.l  d0, d3
    cmp.l   d4, d0
    bge.b   l_363e6
    move.l  d3, d4
    moveq   #$0,d6
    move.b  $1(a2), d6
l_363e6:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_363ec:
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_36390
l_36402:
    move.w  d6, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts

; ============================================================================
; func_03640A -- (TODO: name)
; 324 bytes | $03640A-$03654D
; ============================================================================
func_03640A:
    link    a6,#-$8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d6
    move.l  $c(a6), d7
    lea     -$2(a6), a5
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.w  d0, -$8(a6)
    cmpi.w  #$20, d7
    bcc.b   l_36462
    move.w  d7, d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  #$6, -$6(a6)
    bra.b   l_36488
l_36462:
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  #$4, -$6(a6)
l_36488:
    move.w  #$ff, d0
    move.w  d0, -$4(a6)
    move.w  d0, (a5)
    move.l  #$3b9ac9ff, d5
    move.l  d5, d4
    clr.w   d2
    bra.w   l_36528
l_364a0:
    cmpi.b  #$f, (a2)
    beq.b   l_36522
    cmpi.b  #$ff, (a3)
    bne.b   l_36522
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$E08E                           ; jsr $00E08E
    lea     $c(a7), a7
    move.l  d0, d3
    move.w  d6, d0
    mulu.w  #$e, d0
    move.w  -$8(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$0005F936,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.b  $3(a4), d1
    cmp.l   d1, d0
    bne.b   l_36510
    cmp.l   d5, d3
    bcc.b   l_36522
    move.w  d2, (a5)
    move.l  d3, d5
    bra.b   l_36522
l_36510:
    cmpi.b  #$1, $3(a4)
    bne.b   l_36522
    cmp.l   d4, d3
    bcc.b   l_36522
    move.w  d2, -$4(a6)
    move.l  d3, d4
l_36522:
    addq.l  #$1, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
l_36528:
    cmp.w   -$6(a6), d2
    bcs.w   l_364a0
    cmpi.w  #$ff, (a5)
    beq.b   l_3653e
    cmpi.w  #$1, $12(a6)
    bne.b   l_36542
l_3653e:
    move.w  -$4(a6), (a5)
l_36542:
    move.w  (a5), d0
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03654E -- (TODO: name)
; 386 bytes | $03654E-$0366CF
; ============================================================================
func_03654E:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    move.l  $10(a6), d4
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d7
    cmpi.w  #$20, d2
    bcc.b   l_365a4
    move.w  d2, d0
    mulu.w  #$6, d0
    add.w   d4, d0
    movea.l  #$00FF1704,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d2, d0
    mulu.w  #$6, d0
    add.w   d4, d0
    movea.l  #$00FF0420,a0
    bra.b   l_365c6
l_365a4:
    move.w  d2, d0
    lsl.w   #$2, d0
    add.w   d4, d0
    movea.l  #$00FF15A0,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d2, d0
    lsl.w   #$2, d0
    add.w   d4, d0
    movea.l  #$00FF0460,a0
l_365c6:
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$f, d5
    beq.w   l_366c4
    cmpi.b  #$ff, (a2)
    bne.w   l_366c4
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$E08E                           ; jsr $00E08E
    lea     $c(a7), a7
    move.l  d0, d6
    cmp.l   $6(a3), d6
    bcc.w   l_366c4
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FB6C                                 ; bsr.w $03617A
    addq.l  #$8, a7
    move.w  d0, -$2(a6)
    cmpi.w  #$4, d0
    bcc.w   l_366c4
    sub.l   d6, $6(a3)
    move.b  d3, d0
    ori.b   #$80, d0
    move.b  d0, (a2)
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  -$2(a6), d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d2, (a2)
    move.b  #$5, $1(a2)
    move.b  d4, $2(a2)
    move.b  #$1, $3(a2)
    clr.w   $4(a2)
    clr.w   $6(a2)
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00044996).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9E1C                           ; jsr $009E1C
    pea     ($001E).w
    dc.w    $4EB9,$0001,$E2F4                           ; jsr $01E2F4
    moveq   #$1,d7
l_366c4:
    move.w  d7, d0
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts

CollectCharRevenue:                                                  ; $0366D0
    link    a6,#$0
    movem.l d2-d6/a2-a4,-(sp)
    move.l  $0008(a6),d5
    move.l  $000c(a6),d6
    move.w  d5,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    movea.l #$00ff1704,a2
    movea.l #$00ff0420,a3
    clr.w   d3
.l36700:                                                ; $036700
    clr.w   d4
.l36702:                                                ; $036702
    cmpi.b  #$0f,(a2)
    beq.w   .l367a6
    moveq   #$0,d0
    move.b  (a3),d0
    moveq   #$0,d1
    move.w  d5,d1
    cmp.l   d1,d0
    bne.w   .l367a6
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d2
    lsr.l   #$2,d0
    sub.l   d0,d2
    add.l   d2,$0006(a4)
    move.b  #$ff,(a3)
    cmpi.w  #$1,d6
    bne.b   .l367a6
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d5,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    pea     ($000449C8).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($001E).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
    lea     $0024(sp),sp
.l367a6:                                                ; $0367A6
    addq.l  #$1,a2
    addq.l  #$1,a3
    addq.w  #$1,d4
    cmpi.w  #$6,d4
    bcs.w   .l36702
    addq.w  #$1,d3
    cmpi.w  #$20,d3
    bcs.w   .l36700
    movea.l #$00ff1620,a2
    movea.l #$00ff04e0,a3
    moveq   #$20,d3
.l367cc:                                                ; $0367CC
    clr.w   d4
.l367ce:                                                ; $0367CE
    cmpi.b  #$0f,(a2)
    beq.w   .l36872
    moveq   #$0,d0
    move.b  (a3),d0
    moveq   #$0,d1
    move.w  d5,d1
    cmp.l   d1,d0
    bne.w   .l36872
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d2
    lsr.l   #$2,d0
    sub.l   d0,d2
    add.l   d2,$0006(a4)
    move.b  #$ff,(a3)
    cmpi.w  #$1,d6
    bne.b   .l36872
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d5,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    pea     ($000449B2).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($001E).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
    lea     $0024(sp),sp
.l36872:                                                ; $036872
    addq.l  #$1,a2
    addq.l  #$1,a3
    addq.w  #$1,d4
    cmpi.w  #$4,d4
    bcs.w   .l367ce
    addq.w  #$1,d3
    cmpi.w  #$59,d3
    bcs.w   .l367cc
    movem.l -$0020(a6),d2-d6/a2-a4
    unlk    a6
    rts
; === Translated block $036894-$036F12 ===
; 7 functions, 1662 bytes

; ============================================================================
; func_036894 -- (TODO: name)
; 142 bytes | $036894-$036921
; ============================================================================
func_036894:
    movem.l d2-d5, -(a7)
    move.l  $14(a7), d3
    clr.w   d2
l_3689e:
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F8D0                                 ; bsr.w $03617A
    addq.l  #$8, a7
    cmpi.w  #$ff, d0
    beq.b   l_3691c
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0066                                 ; jsr $036922(pc)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bcs.b   l_3691c
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FFA7AC,a0
    move.w  (a0,d0.w), d4
    cmpi.w  #$7, d4
    bcc.b   l_36914
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00D6                                 ; jsr $0369C0(pc)
    nop
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$ff, d0
    beq.b   l_36914
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0324                                 ; jsr $036C30(pc)
    nop
    lea     $c(a7), a7
l_36914:
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    bcs.b   l_3689e
l_3691c:
    movem.l (a7)+, d2-d5
    rts

; ============================================================================
; func_036922 -- (TODO: name)
; 158 bytes | $036922-$0369BF
; ============================================================================
func_036922:
    movem.l d2-d6/a2, -(a7)
    move.l  $1c(a7), d4
    clr.w   d2
    move.w  d4, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
l_3693e:
    tst.b   $1(a2)
    beq.b   l_369ac
    cmpi.b  #$1, $1(a2)
    bne.b   l_3698c
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$AFCA                           ; jsr $01AFCA
    moveq   #$0,d1
    move.b  $3(a2), d1
    add.w   d1, d0
    move.w  d0, d6
    moveq   #$0,d0
    move.b  (a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$769C                           ; jsr $00769C
    lea     $10(a7), a7
    move.w  d0, d5
    cmp.w   d5, d6
    bcs.b   l_369ae
    bra.b   l_369ac
l_3698c:
    cmpi.b  #$3, $1(a2)
    beq.b   l_369ac
    cmpi.b  #$5, $1(a2)
    beq.b   l_369ac
    cmpi.b  #$6, $1(a2)
    bne.b   l_369ae
    cmpi.b  #$1, $3(a2)
    bhi.b   l_369ae
l_369ac:
    addq.w  #$1, d2
l_369ae:
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_3693e
    move.w  d2, d0
    movem.l (a7)+, d2-d6/a2
    rts

; ============================================================================
; func_0369C0 -- (TODO: name)
; 624 bytes | $0369C0-$036C2F
; ============================================================================
func_0369C0:
    link    a6,#-$10
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    move.w  d0, d7
    pea     ($000C).w
    clr.l   -(a7)
    pea     -$10(a6)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    lea     $14(a7), a7
    cmpi.w  #$20, d7
    bcc.w   l_36be4
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$759E                           ; jsr $00759E
    addq.l  #$8, a7
    move.w  d0, d3
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.w   l_36be4
    move.w  d5, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d6
    bra.w   l_36bbc
l_36a52:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d7, d1
    cmp.l   d1, d0
    bgt.w   l_36be4
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.w   l_36bb6
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    addq.l  #$4, a7
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    mulu.w  #$a, d3
    moveq   #$0,d0
    move.w  $10(a2), d0
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3, d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d2
    cmpi.w  #$64, d2
    bcc.b   l_36ab6
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_36ab8
l_36ab6:
    moveq   #$64,d0
l_36ab8:
    move.w  d0, d2
    moveq   #$64,d0
    sub.w   d2, d0
    move.w  d0, d2
    moveq   #$0,d3
    move.b  $1(a2), d3
    cmpi.w  #$20, d3
    bcc.b   l_36af4
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$6,d4
    bra.b   l_36b16
l_36af4:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$4,d4
l_36b16:
    clr.w   d3
    bra.w   l_36bb0
l_36b1c:
    cmpi.b  #$f, (a3)
    beq.w   l_36baa
    moveq   #$0,d0
    move.b  (a4), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_36baa
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    tst.b   $3(a5)
    bne.b   l_36b64
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    andi.l  #$ffff, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    add.l   d0, -$10(a6)
    bra.b   l_36baa
l_36b64:
    cmpi.b  #$2, $3(a5)
    bne.b   l_36b88
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    andi.l  #$ffff, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    add.l   d0, -$8(a6)
    bra.b   l_36baa
l_36b88:
    cmpi.b  #$3, $3(a5)
    bne.b   l_36baa
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    andi.l  #$ffff, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    add.l   d0, -$c(a6)
l_36baa:
    addq.l  #$1, a3
    addq.l  #$1, a4
    addq.w  #$1, d3
l_36bb0:
    cmp.w   d4, d3
    bcs.w   l_36b1c
l_36bb6:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d6
l_36bbc:
    movea.l -$4(a6), a0
    move.b  $4(a0), d0
    andi.l  #$ff, d0
    movea.l -$4(a6), a0
    move.b  $5(a0), d1
    andi.l  #$ff, d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d6, d1
    cmp.l   d1, d0
    bgt.w   l_36a52
l_36be4:
    moveq   #$0,d3
    move.w  #$ff, d5
    clr.w   d2
l_36bec:
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$10(a6, d0.w), d0
    cmp.l   d3, d0
    bls.b   l_36c02
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$10(a6, d0.w), d3
    move.w  d2, d5
l_36c02:
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    bcs.b   l_36bec
    tst.w   d5
    bne.b   l_36c12
    clr.w   d5
    bra.b   l_36c24
l_36c12:
    cmpi.w  #$1, d5
    bne.b   l_36c1c
    moveq   #$1,d5
    bra.b   l_36c24
l_36c1c:
    cmpi.w  #$2, d5
    bne.b   l_36c24
    moveq   #$2,d5
l_36c24:
    move.w  d5, d0
    movem.l -$38(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_036C30 -- (TODO: name)
; 244 bytes | $036C30-$036D23
; ============================================================================
func_036C30:
    movem.l d2-d7/a2, -(a7)
    move.l  $20(a7), d2
    move.l  $28(a7), d4
    move.l  $24(a7), d5
    clr.w   d6
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00BC                                 ; jsr $036D24(pc)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.w   l_36d1c
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00EC                                 ; jsr $036D76(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d3
    beq.w   l_36d1c
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$40DC                           ; jsr $0140DC
    addq.l  #$4, a7
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d3
    cmp.l   $6(a2), d3
    bge.b   l_36d1c
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F4B6                                 ; bsr.w $03617A
    addq.l  #$8, a7
    move.w  d0, d7
    cmpi.w  #$4, d0
    bcc.b   l_36d1c
    sub.l   d3, $6(a2)
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d5, (a2)
    move.b  #$6, $1(a2)
    move.b  #$32, $2(a2)
    move.b  #$4, $3(a2)
    move.w  #$32, $4(a2)
    move.w  d4, $6(a2)
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9E1C                           ; jsr $009E1C
    addq.l  #$8, a7
    moveq   #$1,d6
l_36d1c:
    move.w  d6, d0
    movem.l (a7)+, d2-d7/a2
    rts

; ============================================================================
; func_036D24 -- (TODO: name)
; 82 bytes | $036D24-$036D75
; ============================================================================
func_036D24:
    movem.l d2-d5, -(a7)
    move.l  $1c(a7), d3
    move.l  $18(a7), d4
    clr.w   d5
    move.w  $16(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_36d46:
    cmpi.b  #$6, $1(a1)
    bne.b   l_36d64
    moveq   #$0,d0
    move.b  (a1), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bne.b   l_36d64
    cmp.w   $6(a1), d3
    bne.b   l_36d64
    moveq   #$1,d5
    bra.b   l_36d6e
l_36d64:
    addq.l  #$8, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_36d46
l_36d6e:
    move.w  d5, d0
    movem.l (a7)+, d2-d5
    rts

; ============================================================================
; func_036D76 -- (TODO: name)
; 356 bytes | $036D76-$036ED9
; ============================================================================
func_036D76:
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $30(a7), d3
    move.l  $28(a7), d5
    clr.w   d4
    move.w  $2e(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    tst.w   d3
    bne.b   l_36d9e
    clr.w   d7
    bra.b   l_36daa
l_36d9e:
    cmpi.w  #$1, d3
    bne.b   l_36da8
    moveq   #$3,d7
    bra.b   l_36daa
l_36da8:
    moveq   #$2,d7
l_36daa:
    moveq   #$0,d3
    move.b  (a1), d3
    moveq   #$0,d6
    move.w  d3, d6
    move.l  d6, d0
    add.l   d6, d6
    add.l   d0, d6
    add.l   d6, d6
    bra.b   l_36e28
l_36dbc:
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    tst.b   (a0,d0.w)
    beq.b   l_36e24
    movea.l  #$00FF1704,a0
    lea     (a0,d6.w), a2
    movea.l  #$00FF0420,a0
    lea     (a0,d6.w), a3
    clr.w   d2
l_36de8:
    cmpi.b  #$f, (a2)
    beq.b   l_36e18
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_36e18
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmp.w   d7, d0
    bne.b   l_36e18
    addq.w  #$1, d4
l_36e18:
    addq.l  #$1, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    bcs.b   l_36de8
l_36e24:
    addq.l  #$6, d6
    addq.w  #$1, d3
l_36e28:
    moveq   #$0,d0
    move.b  (a1), d0
    moveq   #$0,d1
    move.b  $1(a1), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_36dbc
    moveq   #$0,d3
    move.b  $2(a1), d3
    bra.b   l_36eba
l_36e44:
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    tst.b   (a0,d0.w)
    beq.b   l_36eb8
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
l_36e7c:
    cmpi.b  #$f, (a2)
    beq.b   l_36eac
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_36eac
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmp.w   d7, d0
    bne.b   l_36eac
    addq.w  #$1, d4
l_36eac:
    addq.l  #$1, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_36e7c
l_36eb8:
    addq.w  #$1, d3
l_36eba:
    moveq   #$0,d0
    move.b  $2(a1), d0
    moveq   #$0,d1
    move.b  $3(a1), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.w   l_36e44
    move.w  d4, d0
    movem.l (a7)+, d2-d7/a2-a4
    rts

; ============================================================================
; func_036EDA -- (TODO: name)
; 56 bytes | $036EDA-$036F11
; ============================================================================
func_036EDA:
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d4
    clr.w   d3
    clr.w   d2
l_36ee6:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_36f02
    addq.w  #$1, d3
l_36f02:
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.b   l_36ee6
    move.w  d3, d0
    movem.l (a7)+, d2-d4
    rts

RecruitCharacter:                                                  ; $036F12
    link    a6,#-$80
    movem.l d2-d4/a2-a5,-(sp)
    movea.l #$00ff9a1c,a4
    movea.l #$0001e0b8,a5
    clr.w   d4
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    movea.l #$00ffba6c,a2
    pea     ($0014).w
    clr.l   -(sp)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    move.w  (a4),d3
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
    pea     ($0001).w
    clr.l   -(sp)
    jsr     (a5)
    pea     ($0004).w
    pea     ($003B).w
    jsr     (a5)
    lea     $0020(sp),sp
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    moveq   #$0,d0
    move.b  $0004(a3),d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    add.l   d1,d0
    moveq   #$28,d1
    cmp.l   d0,d1
    ble.w   .l370f0
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    addq.l  #$8,sp
    move.b  d0,(a2)
    cmpi.b  #$ff,d0
    beq.w   .l370d2
    clr.l   -(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$080c                                 ; jsr $0377DA
    nop
    lea     $0010(sp),sp
    cmpi.w  #$1,d0
    bne.w   .l37110
.l36fde:                                                ; $036FDE
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($000485F6).l,-(sp)
    pea     -$0080(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     -$0080(a6)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0130                                 ; jsr $037162
    nop
    lea     $002c(sp),sp
    move.b  d0,$0001(a2)
    cmpi.b  #$ff,d0
    beq.w   .l37110
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0778                                 ; jsr $0377DA
    nop
    lea     $0010(sp),sp
    cmpi.w  #$1,d0
    bne.b   .l370c8
    move.l  a2,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$09c2                                 ; jsr $037A3C
    nop
    move.w  d0,d4
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9f4a                           ; jsr $009F4A
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0001).w
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    lea     $0024(sp),sp
.l370c8:                                                ; $0370C8
    move.w  (a4),d3
    tst.w   d4
    beq.w   .l36fde
    bra.b   .l37110
.l370d2:                                                ; $0370D2
    pea     ($0004).w
    pea     ($0037).w
    jsr     (a5)
    addq.l  #$8,sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    move.l  ($0004861E).l,-(sp)
    bra.b   .l37100
.l370f0:                                                ; $0370F0
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($00044E94).l
.l37100:                                                ; $037100
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    lea     $0014(sp),sp
.l37110:                                                ; $037110
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0004).w
    pea     ($0037).w
    jsr     (a5)
    pea     ($0001).w
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9f4a                           ; jsr $009F4A
    movem.l -$009c(a6),d2-d4/a2-a5
    unlk    a6
    rts
; === Translated block $037162-$0377C8 ===
; 1 functions, 1638 bytes

; ============================================================================
; func_037162 -- (TODO: name)
; 1638 bytes | $037162-$0377C7
; ============================================================================
func_037162:
    link    a6,#-$B8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d3
    move.l  $8(a6), d5
    movea.l  #$00000D64,a5
    move.w  #$1, -$b8(a6)
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  #$ff, d6
    move.w  #$ff, d4
    movea.l  #$00FFBD64,a2
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$88EA                           ; jsr $0088EA
    lea     $30(a7), a7
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_3720c
    moveq   #$1,d2
    bra.b   l_3720e
l_3720c:
    moveq   #$0,d2
l_3720e:
    clr.w   d7
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
l_3721c:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    tst.w   d2
    beq.b   l_37272
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_37272
    pea     ($0003).w
l_37268:
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   l_3721c
l_37272:
    clr.w   d2
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    andi.w  #$bf, d0
    move.w  d0, d7
    tst.w   -$b8(a6)
    beq.w   l_37480
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7B1E                           ; jsr $007B1E
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$ff, d0
    beq.w   l_37428
    cmp.w   d4, d6
    beq.w   l_3747c
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$88EA                           ; jsr $0088EA
    pea     ($0039).w
    pea     ($0013).w
    pea     ($0001).w
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$88EA                           ; jsr $0088EA
    pea     ($0017).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $30(a7), a7
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$ffff, d6
    beq.b   l_37388
    tst.w   d6
    beq.b   l_37388
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($001C).w
    pea     ($0017).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($00044F76).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0017).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $2c(a7), a7
    pea     ($0003).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$A506                           ; jsr $01A506
    lea     $c(a7), a7
    move.l  d0, -(a7)
    pea     ($00044F6C).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    addq.l  #$8, a7
    bra.w   l_37424
l_37388:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($001C).w
    pea     ($0017).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    cmp.w   d3, d4
    bne.b   l_373e8
    pea     ($0003).w
    pea     ($001C).w
    pea     ($0017).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    movea.l (a0,d0.w), a3
    move.l  a3, -(a7)
    move.l  a3, -(a7)
    pea     ($00044F46).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    lea     $1c(a7), a7
    bra.b   l_3740e
l_373e8:
    pea     ($0003).w
    pea     ($001C).w
    pea     ($0017).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    pea     ($00044F12).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    lea     $14(a7), a7
l_3740e:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $10(a7), a7
l_37424:
    move.w  d4, d6
    bra.b   l_3747c
l_37428:
    cmpi.w  #$ff, d6
    beq.b   l_3747c
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0004).w
    pea     ($0037).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    lea     $24(a7), a7
    move.w  #$ff, d6
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$88EA                           ; jsr $0088EA
    lea     $14(a7), a7
l_3747c:
    clr.w   -$b8(a6)
l_37480:
    move.w  d7, d0
    andi.w  #$20, d0
    beq.w   l_3769c
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    cmpi.w  #$ff, d4
    beq.w   l_37694
    pea     ($0001).w
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9CEC                           ; jsr $009CEC
    lea     $c(a7), a7
    cmp.w   d3, d4
    beq.w   l_375f0
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$81D2                           ; jsr $0081D2
    lea     $c(a7), a7
    tst.l   d0
    bne.w   l_375d8
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$2926                                 ; jsr $039E52(pc)
    nop
    lea     $c(a7), a7
    tst.w   d0
    beq.w   l_375c2
    pea     ($0003).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$A506                           ; jsr $01A506
    lea     $c(a7), a7
    cmp.l   $6(a4), d0
    bgt.b   l_37576
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$B324                           ; jsr $01B324
    lea     $c(a7), a7
    bra.w   l_377bc
l_37576:
    dc.w    $4EBA,$0250                                 ; jsr $0377C8(pc)
    nop
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    move.l  ($00048642).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000485F6).l, -(a7)
    pea     -$b6(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    bra.b   l_37622
l_375c2:
    dc.w    $4EBA,$0204                                 ; jsr $0377C8(pc)
    nop
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00044EDC).l
    bra.b   l_37626
l_375d8:
    dc.w    $4EBA,$01EE                                 ; jsr $0377C8(pc)
    nop
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  ($00048636).l, -(a7)
    bra.b   l_37626
l_375f0:
    dc.w    $4EBA,$01D6                                 ; jsr $0377C8(pc)
    nop
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($0004861A).l, -(a7)
    pea     -$b6(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
l_37622:
    pea     -$b6(a6)
l_37626:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $30(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
l_37676:
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$88EA                           ; jsr $0088EA
    lea     $14(a7), a7
l_37694:
    pea     ($0002).w
    bra.w   l_37268
l_3769c:
    move.w  d7, d0
    andi.w  #$10, d0
    beq.b   l_376b8
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  #$ff, d4
    bra.w   l_377bc
l_376b8:
    move.w  d7, d0
    andi.w  #$80, d0
    beq.w   l_37796
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$8A4A                           ; jsr $008A4A
    lea     $24(a7), a7
    move.w  d0, -$2(a6)
    cmpi.w  #$ff, -$2(a6)
    beq.b   l_37720
    move.w  -$2(a6), d0
    cmp.w   $e(a6), d0
    beq.b   l_37720
    move.w  -$2(a6), $e(a6)
l_37720:
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    pea     ($0004DFB8).l
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    lea     $14(a7), a7
    bra.w   l_37676
l_37796:
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7A74                           ; jsr $007A74
    addq.l  #$8, a7
    move.w  #$1, ($00FF13FC).l
    move.w  #$1, -$b8(a6)
    pea     ($0001).w
    bra.w   l_37268
l_377bc:
    move.w  d4, d0
    movem.l -$e0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; ClearCharSprites -- (TODO: describe)
; Called: ?? times.
; 18 bytes | $0377C8-$0377D9
; ============================================================================
ClearCharSprites:                                                  ; $0377C8
    pea     ($0004).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    addq.l  #$8,sp
    rts

; === Translated block $0377DA-$038544 ===
; 3 functions, 3434 bytes

; ============================================================================
; func_0377DA -- (TODO: name)
; 610 bytes | $0377DA-$037A3B
; ============================================================================
func_0377DA:
    link    a6,#-$50
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $10(a6), d3
    move.l  $8(a6), d4
    move.l  $14(a6), d5
    lea     -$50(a6), a3
    movea.l  #$00007912,a4
    movea.l  #$00048616,a5
    movea.l  #$00FF09D8,a0
    move.b  (a0,d3.w), d0
    andi.b  #$3, d0
    beq.b   l_37836
    dc.w    $6100,$FFB4                                 ; bsr.w $0377C8
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $34(a5), -(a7)
l_37824:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    moveq   #$0,d0
    bra.w   l_37a32
l_37836:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    cmp.w   d3, d0
    bne.b   l_37884
    cmpi.w  #$1, d5
    bne.b   l_37884
    dc.w    $6100,$FF72                                 ; bsr.w $0377C8
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  $4(a5), -(a7)
l_3786a:
    move.l  a3, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
l_37876:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    bra.b   l_37824
l_37884:
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   (a2)
    beq.w   l_37948
    move.b  (a2), d0
    cmp.b   $1(a2), d0
    bhi.w   l_37994
    dc.w    $6100,$FF1C                                 ; bsr.w $0377C8
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  $10(a5), -(a7)
    move.l  a3, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    move.w  d4, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    clr.w   d5
    bra.b   l_37910
l_378f6:
    tst.b   $1(a2)
    beq.b   l_3790c
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_3790c
    moveq   #$1,d5
    bra.b   l_37916
l_3790c:
    addq.l  #$8, a2
    addq.w  #$1, d2
l_37910:
    cmpi.w  #$4, d2
    blt.b   l_378f6
l_37916:
    cmpi.w  #$1, d5
    bne.b   l_37932
    dc.w    $6100,$FEAA                                 ; bsr.w $0377C8
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $18(a5), -(a7)
    bra.w   l_37824
l_37932:
    dc.w    $6100,$FE94                                 ; bsr.w $0377C8
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $1c(a5), -(a7)
    bra.w   l_37824
l_37948:
    dc.w    $6100,$FE7E                                 ; bsr.w $0377C8
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  $c(a5), -(a7)
    move.l  a3, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  $14(a5), -(a7)
    bra.w   l_3786a
l_37994:
    cmpi.w  #$1, d5
    bne.w   l_37a30
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.w  d0, d5
    cmp.w   d2, d0
    beq.w   l_37a30
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    bne.b   l_379ea
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9DC4                           ; jsr $009DC4
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    beq.b   l_37a30
l_379ea:
    cmp.w   d3, d2
    beq.b   l_37a30
    dc.w    $6100,$FDD8                                 ; bsr.w $0377C8
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$2, d5
    bne.b   l_37a0e
    pea     ($00044F86).l
    bra.b   l_37a1c
l_37a0e:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
l_37a1c:
    move.l  $38(a5), -(a7)
    move.l  a3, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $10(a7), a7
    bra.w   l_37876
l_37a30:
    moveq   #$1,d0
l_37a32:
    movem.l -$70(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_037A3C -- (TODO: name)
; 1474 bytes | $037A3C-$037FFD
; ============================================================================
func_037A3C:
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $2c(a7), d3
    movea.l $30(a7), a2
    movea.l  #$00000D64,a4
    movea.l  #$00FF1804,a5
    clr.w   d5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    pea     ($0004DCE8).l
    move.l  a5, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($001A).w
    pea     ($0328).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    lea     $1c(a7), a7
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    clr.w   d2
l_37aa4:
    tst.w   d2
    bne.b   l_37ad4
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0540                                 ; jsr $037FFE(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    bne.w   l_37fee
    bra.w   l_37ff6
l_37ad4:
    cmpi.w  #$1, d2
    beq.b   l_37ae2
    cmpi.w  #$5, d2
    bne.w   l_37d30
l_37ae2:
    cmpi.w  #$1, d2
    bne.w   l_37c50
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7158                           ; jsr $007158
    tst.w   d0
    beq.b   l_37b48
    move.l  ($000A1B50).l, -(a7)
    bra.b   l_37b4e
l_37b48:
    move.l  ($000A1B4C).l, -(a7)
l_37b4e:
    move.l  a5, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $2c(a7), a7
    pea     ($0010).w
    pea     ($0001).w
    move.l  a5, -(a7)
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007651E).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    lea     $18(a7), a7
    pea     ($00072AC0).l
    pea     ($000D).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0007651E).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.l  ($000A1AE4).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $30(a7), a7
    pea     ($0020).w
    pea     ($0694).w
    move.l  a5, -(a7)
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    pea     ($00070F38).l
    pea     ($0004).w
    pea     ($0004).w
    pea     ($0005).w
    pea     ($0010).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $28(a7), a7
    pea     ($00070F58).l
    pea     ($0004).w
    pea     ($0004).w
    pea     ($0009).w
    pea     ($0010).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0005).w
    pea     ($0002).w
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    addq.l  #$4, a7
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$2960                                 ; jsr $03A5A8(pc)
    nop
    lea     $18(a7), a7
l_37c50:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    pea     ($0004).w
    pea     ($0005).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    pea     ($00044FA0).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0004).w
    pea     ($0015).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    pea     ($00044F96).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    lea     $c(a7), a7
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$085A                                 ; jsr $03857E(pc)
    nop
l_37d28:
    addq.l  #$8, a7
    move.w  d0, d2
    bra.w   l_37fee
l_37d30:
    cmpi.w  #$2, d2
    bne.b   l_37d46
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1154                                 ; jsr $038E94(pc)
    nop
    bra.b   l_37d28
l_37d46:
    cmpi.w  #$3, d2
    bne.b   l_37d5c
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1932                                 ; jsr $039688(pc)
    nop
    bra.b   l_37d28
l_37d5c:
    cmpi.w  #$4, d2
    bne.w   l_37fee
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000F).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($0004860E).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    lea     $30(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_37fe6
    clr.w   $e(a2)
    clr.w   $6(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d5
    moveq   #$0,d4
    move.b  (a2), d4
    moveq   #$0,d6
    move.b  $1(a2), d6
    cmp.w   d5, d2
    beq.b   l_37e46
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    moveq   #$1,d0
    lsl.b   d5, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    sub.l   d1, d0
    move.l  d0, d4
    add.w   d2, d0
    move.l  (a7)+, d1
    movea.l  #$00FFA7BC,a0
    or.b    d1, (a0,d0.w)
    moveq   #$1,d0
    lsl.b   d2, d0
    move.w  d4, d1
    add.w   d5, d1
    movea.l  #$00FFA7BC,a0
    or.b    d0, (a0,d1.w)
    addq.b  #$1, $4(a3)
    bra.w   l_37efa
l_37e46:
    cmpi.w  #$20, d4
    bge.b   l_37e66
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    bra.b   l_37e9e
l_37e66:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d4, d1
    sub.w   d0, d1
    move.w  d1, d4
    moveq   #$1,d0
    lsl.w   d4, d0
    move.w  d3, d1
    mulu.w  #$e, d1
    move.w  d2, d7
    add.w   d7, d7
    add.w   d7, d1
    movea.l  #$00FFBD6C,a0
    or.w    d0, (a0,d1.w)
    addq.b  #$1, $3(a3)
l_37e9e:
    cmpi.w  #$20, d6
    bge.b   l_37ec0
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    bra.b   l_37ef6
l_37ec0:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d6, d4
    sub.w   d0, d4
    moveq   #$1,d0
    lsl.w   d4, d0
    move.w  d3, d1
    mulu.w  #$e, d1
    move.w  d5, d7
    add.w   d7, d7
    add.w   d7, d1
    movea.l  #$00FFBD6C,a0
    or.w    d0, (a0,d1.w)
    addq.b  #$1, $3(a3)
l_37ef6:
    addq.b  #$1, $5(a3)
l_37efa:
    clr.b   $2(a3)
    clr.w   d2
l_37f00:
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    beq.b   l_37f1e
    addq.b  #$1, $2(a3)
l_37f1e:
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    blt.b   l_37f00
    pea     ($0003).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$A506                           ; jsr $01A506
    sub.l   d0, $6(a3)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E9,a0
    adda.l  d0, a0
    movea.l a0, a3
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
    sub.b   d0, (a3)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a2), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a2), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
    move.b  #$4, $a(a2)
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$82E4                           ; jsr $0082E4
    lea     $24(a7), a7
    moveq   #$1,d5
    cmpi.w  #$1, ($00FF000A).l
    bne.b   l_37ff6
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1EDC                                 ; jsr $039EAA(pc)
    nop
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9F4A                           ; jsr $009F4A
    addq.l  #$8, a7
    bra.b   l_37ff6
l_37fe6:
    clr.w   d2
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
l_37fee:
    cmpi.w  #$ff, d2
    bne.w   l_37aa4
l_37ff6:
    move.w  d5, d0
    movem.l (a7)+, d2-d7/a2-a5
    rts

; ============================================================================
; func_037FFE -- (TODO: name)
; 1350 bytes | $037FFE-$038543
; ============================================================================
func_037FFE:
    link    a6,#-$28
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l $c(a6), a3
    movea.l  #$00000D64,a4
    movea.l  #$00FF13FC,a5
    move.w  #$2, -$2(a6)
    clr.l   -(a7)
    pea     ($0005).w
    pea     ($0020).w
    pea     ($000D).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
    clr.w   d2
l_3806c:
    tst.b   (a2)
    beq.b   l_380a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$818A                           ; jsr $00818A
    lea     $c(a7), a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   l_380a2
    move.w  d4, d0
    add.w   d0, d0
    move.w  d2, -$22(a6, d0.w)
    addq.w  #$1, d4
l_380a2:
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   l_3806c
    tst.w   d4
    ble.b   l_380bc
    move.w  d4, d0
    addi.w  #$ffff, d0
    move.w  d0, -$26(a6)
    bra.b   l_380e4
l_380bc:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  ($0004863A).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    lea     $14(a7), a7
    move.w  #$ff, d0
    bra.w   l_3853a
l_380e4:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000485FE).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0440                                 ; jsr $038544(pc)
    nop
    lea     $18(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_38120
    move.l  ($00048612).l, -(a7)
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    addq.l  #$4, a7
l_38120:
    pea     ($0003).w
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$AFF0                           ; jsr $01AFF0
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044FB2).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000C).w
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$58FC                           ; jsr $0058FC
    pea     ($0001).w
    pea     ($0013).w
    pea     ($0001).w
    dc.w    $4EB9,$0000,$58FC                           ; jsr $0058FC
    pea     ($0001).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0002).w
    dc.w    $4EB9,$0000,$595E                           ; jsr $00595E
    pea     ($0001).w
    pea     ($000D).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $30(a7), a7
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    pea     ($00044FAE).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($0001).w
    pea     ($0014).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044FAA).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    tst.w   -$26(a6)
    bne.b   l_3822a
    move.w  #$1, -$28(a6)
    bra.b   l_3822e
l_3822a:
    clr.w   -$28(a6)
l_3822e:
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   l_38242
    moveq   #$1,d7
    bra.b   l_38244
l_38242:
    moveq   #$0,d7
l_38244:
    clr.w   -$24(a6)
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    moveq   #$1,d6
    clr.w   d2
    clr.w   d4
    clr.w   d3
    bra.w   l_38532
l_3825c:
    addq.w  #$1, d3
    cmpi.w  #$1, d3
    bne.b   l_382cc
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0040).w
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0040).w
    pea     ($00F0).w
    pea     ($003A).w
    pea     ($0773).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    lea     $1c(a7), a7
l_382be:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   l_382ec
l_382cc:
    cmpi.w  #$f, d3
    bne.b   l_382e4
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    addq.l  #$8, a7
    bra.b   l_382be
l_382e4:
    cmpi.w  #$1e, d3
    bne.b   l_382ec
    clr.w   d3
l_382ec:
    cmpi.w  #$1, d6
    bne.b   l_38320
    pea     ($0002).w
    pea     ($0003).w
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    add.w   d0, d0
    move.w  -$22(a6, d0.w), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$B0CE                           ; jsr $01B0CE
    lea     $14(a7), a7
    clr.w   d6
l_38320:
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d4, d1
    add.w   d1, d1
    move.w  -$22(a6, d1.w), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    tst.b   (a0,d0.w)
    bne.b   l_38354
    pea     ($0001).w
    pea     ($000A).w
    pea     ($001D).w
    clr.l   -(a7)
    dc.w    $4EBA,$1B5C                                 ; jsr $039EA8(pc)
    nop
    lea     $10(a7), a7
l_38354:
    tst.w   d7
    beq.b   l_38368
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_38526
l_38368:
    clr.w   d7
    move.w  -$24(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    andi.w  #$bc, d0
    move.w  d0, -$24(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_383b0
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_38448
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_38456
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_3846c
    cmpi.w  #$80, d0
    beq.w   l_38482
    bra.w   l_38514
l_383b0:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d4, d1
    add.w   d1, d1
    move.w  -$22(a6, d1.w), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    tst.b   (a0,d0.w)
    beq.b   l_38402
    move.w  d4, d0
    add.w   d0, d0
    move.w  -$22(a6, d0.w), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    dc.w    $4EB9,$0000,$7390                           ; jsr $007390
    addq.l  #$8, a7
    moveq   #$1,d2
l_383ec:
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    addq.l  #$8, a7
    move.w  d2, d0
    bra.w   l_3853a
l_38402:
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    move.l  ($00048646).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    pea     ($001E).w
    dc.w    $4EB9,$0001,$E2F4                           ; jsr $01E2F4
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000485FE).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    lea     $2c(a7), a7
    clr.w   d6
    bra.w   l_3851c
l_38448:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  #$ff, d2
    bra.b   l_383ec
l_38456:
    move.w  #$1, (a5)
    moveq   #$1,d6
    subq.w  #$1, d4
    tst.w   d4
    bge.w   l_3851c
    move.w  -$26(a6), d4
    bra.w   l_3851c
l_3846c:
    move.w  #$1, (a5)
    moveq   #$1,d6
    addq.w  #$1, d4
    cmp.w   -$26(a6), d4
    ble.w   l_3851c
    clr.w   d4
    bra.w   l_3851c
l_38482:
    clr.w   (a5)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00B8                                 ; jsr $038544(pc)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_3851c
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$A2CE                           ; jsr $01A2CE
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000485FE).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    move.l  ($00048612).l, -(a7)
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $28(a7), a7
    moveq   #$1,d6
    bra.b   l_3851c
l_38514:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
l_3851c:
    cmpi.w  #$1, -$28(a6)
    bne.b   l_38526
    clr.w   d6
l_38526:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
l_38532:
    cmpi.w  #$ff, d2
    bne.w   l_3825c
l_3853a:
    movem.l -$50(a6), d2-d7/a2-a5
    unlk    a6
    rts


; ============================================================================
; CheckMatchSlots -- (TODO: describe)
; Called: ?? times.
; 58 bytes | $038544-$03857D
; ============================================================================
CheckMatchSlots:                                                  ; $038544
    movem.l d2-d3,-(sp)
    move.l  $000c(sp),d3
    moveq   #$1,d1
    clr.w   d2
.l38550:                                                ; $038550
    cmp.w   d3,d2
    beq.b   .l38566
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$00ff8804,a0
    cmpi.w  #$ff,(a0,d0.w)
    bne.b   .l3856e
.l38566:                                                ; $038566
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l38550
.l3856e:                                                ; $03856E
    cmpi.w  #$4,d2
    blt.b   .l38576
    clr.w   d1
.l38576:                                                ; $038576
    move.w  d1,d0
    movem.l (sp)+,d2-d3
    rts
; === Translated block $03857E-$03A5A8 ===
; 8 functions, 8234 bytes

; ============================================================================
; func_03857E -- (TODO: name)
; 2326 bytes | $03857E-$038E93
; ============================================================================
func_03857E:
    link    a6,#-$38
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    movea.l  #$00000D64,a4
    movea.l  #$0003AB2C,a5
    pea     ($077E).w
    pea     ($0002).w
    pea     ($0007).w
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    lea     $20(a7), a7
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  $a(a6), d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E8,a0
    adda.l  d0, a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.w  d0, -$a(a6)
    cmpi.w  #$9, -$a(a6)
    bge.b   l_385f2
    move.w  -$a(a6), d0
    ext.l   d0
    bra.b   l_385f4
l_385f2:
    moveq   #$9,d0
l_385f4:
    move.w  d0, -$a(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048602).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$FF28                                 ; bsr.w $038544
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_38634
    move.l  ($00048612).l, -(a7)
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    addq.l  #$4, a7
l_38634:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    pea     ($0002).w
    pea     ($0002).w
    jsr     (a5)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044FDE).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($0002).w
    pea     ($000C).w
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$58FC                           ; jsr $0058FC
    lea     $2c(a7), a7
    pea     ($0002).w
    pea     ($0013).w
    pea     ($0001).w
    dc.w    $4EB9,$0000,$58FC                           ; jsr $0058FC
    pea     ($0002).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0002).w
    dc.w    $4EB9,$0000,$595E                           ; jsr $00595E
    pea     ($0002).w
    pea     ($000D).w
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    pea     ($00044FDA).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $2c(a7), a7
    pea     ($0002).w
    pea     ($0014).w
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044FD6).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7412                           ; jsr $007412
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d4
    cmpi.w  #$7, d4
    bge.b   l_3872c
    move.w  d4, d3
    ext.l   d3
    bra.b   l_3872e
l_3872c:
    moveq   #$7,d3
l_3872e:
    pea     ($033E).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $30(a7), a7
    move.w  d4, d3
    addi.w  #$fff9, d3
    tst.w   d3
    ble.b   l_3877c
    pea     ($033E).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_3877c:
    clr.w   d2
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FD2).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    moveq   #$1,d2
    moveq   #$1,d5
    moveq   #$E,d7
    clr.w   d6
l_387a2:
    move.w  d6, d0
    addi.w  #$2d7f, d0
    move.w  d6, d1
    add.w   d1, d1
    move.w  d0, -$32(a6, d1.w)
    addq.w  #$1, d6
    cmpi.w  #$14, d6
    blt.b   l_387a2
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076A3E).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.l  ($000A1B04).l, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($0059).w
    pea     ($0011).w
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    lea     $30(a7), a7
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    move.w  #$1, -$36(a6)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($00044FCE).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $2c(a7), a7
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a4)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FCA).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$ACBA                           ; jsr $01ACBA
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    lea     $2c(a7), a7
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FC6).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    addq.l  #$8, a7
    move.w  -$a(a6), d0
    ext.l   d0
    subq.l  #$1, d0
    bgt.b   l_388fa
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$36(a6)
l_388fa:
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_3890c
    moveq   #$1,d6
    bra.b   l_3890e
l_3890c:
    moveq   #$0,d6
l_3890e:
    clr.w   -$34(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$0,d0
    move.w  d0, -$38(a6)
    andi.l  #$ffff, d0
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$c, d0
    move.l  d0, -$4(a6)
    move.l  #$33e, -$8(a6)
l_38942:
    addq.w  #$1, -$38(a6)
    cmpi.w  #$1, -$38(a6)
    bne.b   l_389c4
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.l  -$4(a6), -(a7)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0039).w
    pea     ($0772).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.l  -$4(a6), -(a7)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$48, d0
    move.l  d0, -(a7)
    pea     ($003A).w
    pea     ($0773).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    lea     $1c(a7), a7
l_389b6:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   l_389ea
l_389c4:
    cmpi.w  #$f, -$38(a6)
    bne.b   l_389de
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    addq.l  #$8, a7
    bra.b   l_389b6
l_389de:
    cmpi.w  #$1e, -$38(a6)
    bne.b   l_389ea
    clr.w   -$38(a6)
l_389ea:
    tst.w   d6
    beq.b   l_389fe
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_38942
l_389fe:
    clr.w   d6
    move.w  -$34(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    andi.w  #$bc, d0
    move.w  d0, -$34(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_38a46
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_38aba
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_38b00
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_38c82
    cmpi.w  #$80, d0
    beq.w   l_38dd2
    bra.w   l_38e6e
l_38a46:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$73A6                           ; jsr $0073A6
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($000A).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($000A).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    lea     $24(a7), a7
    moveq   #$2,d0
    bra.w   l_38e8a
l_38aba:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.l  #$8000, -(a7)
    pea     ($000E).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    dc.w    $4EB9,$0003,$A9AC                           ; jsr $03A9AC
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    lea     $24(a7), a7
    moveq   #$0,d0
    bra.w   l_38e8a
l_38b00:
    move.w  #$1, ($00FF13FC).l
    subq.w  #$1, d2
    move.w  -$a(a6), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    ble.b   l_38b54
    cmpi.w  #$1, -$a(a6)
    ble.b   l_38b54
    tst.w   -$36(a6)
    bne.b   l_38b54
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  #$1, -$36(a6)
l_38b54:
    tst.w   d2
    ble.b   l_38b94
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FC2).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addi.l  #$d, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$ACBA                           ; jsr $01ACBA
    lea     $1c(a7), a7
l_38b94:
    cmpi.w  #$1, d2
    ble.b   l_38ba0
    move.w  d2, d0
    ext.l   d0
    bra.b   l_38ba2
l_38ba0:
    moveq   #$1,d0
l_38ba2:
    move.w  d0, d2
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FBE).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7412                           ; jsr $007412
    lea     $14(a7), a7
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$14,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d4
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    ble.b   l_38c04
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    bra.b   l_38c06
l_38c04:
    moveq   #$0,d3
l_38c06:
    cmpi.w  #$7, d3
    bge.b   l_38c3a
    pea     ($077E).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($000C).w
    move.w  d3, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_38c3a:
    cmpi.w  #$7, d4
    bge.b   l_38c46
    move.w  d4, d3
    ext.l   d3
    bra.b   l_38c48
l_38c46:
    moveq   #$7,d3
l_38c48:
    cmpi.w  #$7, d3
    bge.w   l_38e7a
    pea     ($077E).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($000B).w
    move.w  d3, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
l_38c72:
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    bra.w   l_38e7a
l_38c82:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$1, d2
    cmp.w   -$a(a6), d2
    bgt.b   l_38cda
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FBA).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$ACBA                           ; jsr $01ACBA
    lea     $1c(a7), a7
l_38cda:
    cmp.w   -$a(a6), d2
    bge.b   l_38ce4
    move.w  d2, d0
    bra.b   l_38ce8
l_38ce4:
    move.w  -$a(a6), d0
l_38ce8:
    ext.l   d0
    move.w  d0, d2
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FB6).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    lea     $10(a7), a7
    move.w  -$a(a6), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    bgt.b   l_38d4e
    cmpi.w  #$1, -$36(a6)
    bne.b   l_38d4e
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$36(a6)
l_38d4e:
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7412                           ; jsr $007412
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$14,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d4
    cmpi.w  #$7, d4
    bge.b   l_38d78
    move.w  d4, d3
    ext.l   d3
    bra.b   l_38d7a
l_38d78:
    moveq   #$7,d3
l_38d7a:
    move.l  -$8(a6), -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $20(a7), a7
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    moveq   #$7,d0
    cmp.l   d3, d0
    ble.b   l_38db0
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    bra.b   l_38db2
l_38db0:
    moveq   #$7,d3
l_38db2:
    tst.w   d3
    ble.w   l_38e7a
    move.l  -$8(a6), -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    bra.w   l_38c72
l_38dd2:
    clr.w   ($00FF13FC).l
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$F762                                 ; bsr.w $038544
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_38e7a
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$A2CE                           ; jsr $01A2CE
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048602).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    move.l  ($00048612).l, -(a7)
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $28(a7), a7
    bra.b   l_38e7a
l_38e6e:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
l_38e7a:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.w   l_38942
l_38e8a:
    movem.l -$60(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_038E94 -- (TODO: name)
; 2036 bytes | $038E94-$039687
; ============================================================================
func_038E94:
    link    a6,#-$7C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a4
    movea.l  #$00000D64,a5
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048606).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$F67A                                 ; bsr.w $038544
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_38ee2
    move.l  ($00048612).l, -(a7)
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    addq.l  #$4, a7
l_38ee2:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    cmpi.b  #$e, $b(a4)
    bcc.b   l_38f04
    moveq   #$0,d5
    move.b  $b(a4), d5
    bra.b   l_38f06
l_38f04:
    moveq   #$E,d5
l_38f06:
    moveq   #$0,d0
    move.b  $3(a4), d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_38f1c
    moveq   #$0,d0
    move.b  $3(a4), d0
    bra.b   l_38f20
l_38f1c:
    move.w  d5, d0
    ext.l   d0
l_38f20:
    move.b  d0, $3(a4)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d4
    andi.l  #$ff, d4
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d4
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d2
    cmp.w   d2, d4
    bge.b   l_38fac
    move.w  d4, d0
    bra.b   l_38fae
l_38fac:
    move.w  d2, d0
l_38fae:
    ext.l   d0
    move.w  d0, d4
    cmp.w   d4, d5
    bge.b   l_38fba
    move.w  d5, d0
    bra.b   l_38fbc
l_38fba:
    move.w  d4, d0
l_38fbc:
    ext.l   d0
    move.w  d0, d5
    moveq   #$1,d4
    cmpi.w  #$7, d4
    bge.b   l_38fce
    move.w  d4, d0
    ext.l   d0
    bra.b   l_38fd0
l_38fce:
    moveq   #$7,d0
l_38fd0:
    move.w  d0, -$6(a6)
    pea     ($033D).w
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $2c(a7), a7
    move.w  d4, d0
    addi.w  #$fff9, d0
    move.w  d0, -$6(a6)
    tst.w   -$6(a6)
    ble.b   l_3902c
    pea     ($033D).w
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
l_3902c:
    clr.w   d2
    move.w  d2, d0
    add.w   d0, d0
    lea     -$78(a6, d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    add.w   d0, d0
    lea     -$40(a6, d0.w), a0
    movea.l a0, a2
    bra.b   l_39060
l_39044:
    cmp.w   d4, d2
    bge.b   l_39052
    move.w  #$8541, (a2)
    move.w  #$8542, (a3)
    bra.b   l_3905a
l_39052:
    move.w  #$8000, (a2)
    move.w  #$8543, (a3)
l_3905a:
    addq.l  #$2, a2
    addq.l  #$2, a3
    addq.w  #$1, d2
l_39060:
    cmp.w   d5, d2
    blt.b   l_39044
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$40(a6, d0.w)
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$78(a6, d0.w)
    moveq   #$1,d7
    moveq   #$E,d6
    pea     ($0004).w
    pea     ($0015).w
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addi.l  #$12, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $28(a7), a7
    move.w  d6, d0
    addq.w  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    addi.w  #$12, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0003).w
    dc.w    $4EB9,$0000,$595E                           ; jsr $00595E
    pea     ($000B).w
    pea     ($001D).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    pea     ($000B).w
    pea     ($001D).w
    pea     ($0002).w
    pea     ($0003).w
    dc.w    $4EB9,$0000,$595E                           ; jsr $00595E
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$7a(a6)
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$7c(a6)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    lea     $2c(a7), a7
    tst.w   d0
    beq.b   l_39158
    moveq   #$1,d0
    bra.b   l_3915a
l_39158:
    moveq   #$0,d0
l_3915a:
    move.w  d0, -$2(a6)
    clr.w   -$4(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d2
    clr.w   d3
    bra.w   l_39676
l_39176:
    addq.w  #$1, d3
    cmpi.w  #$1, d3
    bne.b   l_391e6
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($007C).w
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($007C).w
    pea     ($00A0).w
    pea     ($003A).w
    pea     ($0773).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    lea     $1c(a7), a7
l_391d8:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   l_39206
l_391e6:
    cmpi.w  #$f, d3
    bne.b   l_391fe
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    addq.l  #$8, a7
    bra.b   l_391d8
l_391fe:
    cmpi.w  #$1e, d3
    bne.b   l_39206
    clr.w   d3
l_39206:
    pea     ($000B).w
    pea     ($001B).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FEE).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($0004).w
    pea     ($0005).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  -$7a(a6), d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FEA).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0004).w
    pea     ($0015).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  -$7c(a6), d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FE6).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    lea     $30(a7), a7
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FE2).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     -$40(a6)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    lea     $2c(a7), a7
    pea     -$78(a6)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    lea     $1c(a7), a7
    tst.w   -$2(a6)
    beq.b   l_39310
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_3966a
l_39310:
    clr.w   -$2(a6)
    move.w  -$4(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    andi.w  #$bc, d0
    move.w  d0, -$4(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_3935a
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_393cc
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_3941e
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_39538
    cmpi.w  #$80, d0
    beq.w   l_395c6
    bra.w   l_3965e
l_3935a:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.b  d4, $3(a4)
    moveq   #$3,d2
l_3936c:
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($0015).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($0015).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    pea     ($0018).w
    jsr     (a5)
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    lea     $28(a7), a7
    move.w  d2, d0
    bra.w   l_3967e
l_393cc:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$5,d2
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000A).w
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000A).w
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    bra.w   l_3936c
l_3941e:
    move.w  #$1, ($00FF13FC).l
    subq.w  #$1, d4
    cmpi.w  #$1, d4
    ble.b   l_39434
    move.w  d4, d0
    ext.l   d0
    bra.b   l_39436
l_39434:
    moveq   #$1,d0
l_39436:
    move.w  d0, d4
    cmpi.w  #$1, d5
    ble.b   l_39452
    move.w  d4, d0
    add.w   d0, d0
    move.w  #$8000, -$40(a6, d0.w)
    move.w  d4, d0
    add.w   d0, d0
    move.w  #$8543, -$78(a6, d0.w)
l_39452:
    cmpi.w  #$7, d4
    bne.b   l_3947c
    pea     ($033E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    subq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
l_3947c:
    cmpi.w  #$7, d4
    ble.b   l_394c2
    move.w  d4, d0
    addi.w  #$fff9, d0
    move.w  d0, -$6(a6)
    pea     ($033E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.w  -$6(a6), d1
    ext.l   d1
    sub.l   d1, d0
    subq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($000C).w
    move.w  -$6(a6), d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
l_394c2:
    cmpi.w  #$7, d4
    bge.b   l_394ce
    move.w  d4, d0
    ext.l   d0
    bra.b   l_394d0
l_394ce:
    moveq   #$7,d0
l_394d0:
    move.w  d0, -$6(a6)
    cmpi.w  #$7, -$6(a6)
    bge.w   l_3966a
    cmpi.w  #$7, d5
    bge.b   l_394ea
    move.w  d5, d0
    ext.l   d0
    bra.b   l_394ec
l_394ea:
    moveq   #$7,d0
l_394ec:
    move.w  d0, -$8(a6)
    ext.l   d0
    move.w  -$6(a6), d1
    ext.l   d1
    sub.l   d1, d0
    ble.w   l_3966a
    pea     ($033E).w
    pea     ($0001).w
    move.w  -$8(a6), d0
    ext.l   d0
    move.w  -$6(a6), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000B).w
    move.w  -$6(a6), d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
l_39528:
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    bra.w   l_3966a
l_39538:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$1, d4
    cmp.w   d5, d4
    bge.b   l_3954a
    move.w  d4, d0
    bra.b   l_3954c
l_3954a:
    move.w  d5, d0
l_3954c:
    ext.l   d0
    move.w  d0, d4
    add.w   d0, d0
    move.w  #$8541, -$42(a6, d0.w)
    move.w  d4, d0
    add.w   d0, d0
    move.w  #$8542, -$7a(a6, d0.w)
    cmpi.w  #$7, d4
    bge.b   l_3956e
    move.w  d4, d0
    ext.l   d0
    bra.b   l_39570
l_3956e:
    moveq   #$7,d0
l_39570:
    move.w  d0, -$6(a6)
    pea     ($033D).w
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.w  d4, d0
    addi.w  #$fff9, d0
    move.w  d0, -$6(a6)
    tst.w   -$6(a6)
    ble.w   l_3966a
    pea     ($033D).w
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    bra.w   l_39528
l_395c6:
    clr.w   ($00FF13FC).l
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$EF6E                                 ; bsr.w $038544
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_3966a
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$A2CE                           ; jsr $01A2CE
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048606).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    move.l  ($00048612).l, -(a7)
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $28(a7), a7
    bra.b   l_3966a
l_3965e:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
l_3966a:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
l_39676:
    cmpi.w  #$ff, d2
    bne.w   l_39176
l_3967e:
    movem.l -$a4(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_039688 -- (TODO: name)
; 1878 bytes | $039688-$039DDD
; ============================================================================
func_039688:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    movea.l  #$00000D64,a3
    lea     -$8(a6), a4
    lea     -$4(a6), a5
    move.w  #$33a, d7
    clr.w   d6
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004860A).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$EE78                                 ; bsr.w $038544
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_396e4
    move.l  ($00048612).l, -(a7)
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    addq.l  #$4, a7
l_396e4:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$70DC                           ; jsr $0070DC
    move.w  d0, (a5)
    pea     ($0064).w
    pea     ($0096).w
    move.w  -$4(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E11C                           ; jsr $01E11C
    lea     $24(a7), a7
    move.w  d0, -$6(a6)
    clr.w   $4(a2)
    moveq   #$32,d2
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    move.w  #$1, -$c(a6)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    lea     $24(a7), a7
    tst.w   d0
    beq.b   l_39774
    moveq   #$1,d0
    bra.b   l_39776
l_39774:
    moveq   #$0,d0
l_39776:
    move.w  d0, -$2(a6)
    clr.w   -$a(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  (a5), (a4)
    clr.w   d5
l_3978e:
    addq.w  #$1, d5
    cmpi.w  #$1, d5
    bne.b   l_397fe
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    pea     ($0010).w
    pea     ($0039).w
    pea     ($0772).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    pea     ($0068).w
    pea     ($003A).w
    pea     ($0773).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    lea     $1c(a7), a7
l_397f0:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.b   l_3981e
l_397fe:
    cmpi.w  #$f, d5
    bne.b   l_39816
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    addq.l  #$8, a7
    bra.b   l_397f0
l_39816:
    cmpi.w  #$1e, d5
    bne.b   l_3981e
    clr.w   d5
l_3981e:
    tst.w   d2
    ble.b   l_39828
    move.w  d2, d0
    ext.l   d0
    bra.b   l_3982a
l_39828:
    moveq   #$0,d0
l_3982a:
    move.w  d0, d2
    cmpi.w  #$64, d2
    bge.b   l_39838
    move.w  d2, d0
    ext.l   d0
    bra.b   l_3983a
l_39838:
    moveq   #$64,d0
l_3983a:
    move.w  d0, d2
    pea     ($000F).w
    pea     ($000F).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    addq.l  #$8, a7
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    beq.w   l_398ea
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    bge.b   l_398b0
    pea     ($000F).w
    pea     ($000F).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d2, d0
    ext.l   d0
    neg.l   d0
    addi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0004502C).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $10(a7), a7
    cmpi.w  #$1, -$c(a6)
    bne.w   l_3991c
    pea     ($0004501E).l
l_398a2:
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    addq.l  #$4, a7
    clr.w   -$c(a6)
    bra.b   l_3991c
l_398b0:
    pea     ($000F).w
    pea     ($000F).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0004501A).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $10(a7), a7
    cmpi.w  #$1, -$c(a6)
    bne.b   l_3991c
    pea     ($0004500C).l
    bra.b   l_398a2
l_398ea:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0007).w
    pea     ($000F).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($00044FFE).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $20(a7), a7
    move.w  (a4), (a5)
    move.w  #$1, -$c(a6)
l_3991c:
    pea     ($0009).w
    pea     ($0019).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FF8).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($000A).w
    pea     ($0019).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d2, d0
    addi.w  #$ffce, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FF2).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    lea     $20(a7), a7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d3
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    moveq   #$1,d1
    cmp.l   d0, d1
    ble.b   l_39992
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    bra.b   l_39994
l_39992:
    moveq   #$1,d0
l_39994:
    move.w  d0, d4
    tst.w   d3
    ble.b   l_399f2
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000A).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
l_399f2:
    tst.w   d4
    beq.b   l_39a5a
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000A).w
    move.w  d3, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0010).w
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
l_39a5a:
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.w  d4, d0
    ext.l   d0
    sub.l   d0, d1
    ble.w   l_39af4
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.w  d4, d0
    ext.l   d0
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($000A).w
    move.w  d3, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.w  d4, d0
    ext.l   d0
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0010).w
    move.w  d3, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
l_39af4:
    tst.w   -$2(a6)
    beq.b   l_39b18
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_39b18
l_39b08:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   l_3978e
l_39b18:
    clr.w   -$2(a6)
    move.w  -$a(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    andi.w  #$bc, d0
    move.w  d0, -$a(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_39b62
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_39bcc
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_39c52
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_39ca4
    cmpi.w  #$80, d0
    beq.w   l_39cda
    bra.w   l_39dc4
l_39b62:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  -$8(a6), $4(a2)
    pea     ($0018).w
    jsr     (a3)
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    lea     $24(a7), a7
    moveq   #$4,d0
    bra.w   l_39dd4
l_39bcc:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    pea     ($0328).w
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0009).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0018).w
    jsr     (a3)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    lea     $24(a7), a7
    moveq   #$2,d0
    bra.w   l_39dd4
l_39c52:
    move.w  #$1, ($00FF13FC).l
    subq.w  #$5, d2
    move.w  (a5), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    add.w   (a5), d0
    move.w  d0, (a4)
    move.w  (a5), d0
    ext.l   d0
    bge.b   l_39c84
    addq.l  #$1, d0
l_39c84:
    asr.l   #$1, d0
    move.w  (a4), d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_39c94
l_39c8e:
    move.w  (a4), d0
l_39c90:
    ext.l   d0
    bra.b   l_39c9e
l_39c94:
    move.w  (a5), d0
    ext.l   d0
    bge.b   l_39c9c
    addq.l  #$1, d0
l_39c9c:
    asr.l   #$1, d0
l_39c9e:
    move.w  d0, (a4)
    bra.w   l_39b08
l_39ca4:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$5, d2
    move.w  (a5), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    add.w   (a5), d0
    move.w  d0, (a4)
    cmp.w   -$6(a6), d0
    blt.b   l_39c8e
    move.w  -$6(a6), d0
    bra.b   l_39c90
l_39cda:
    clr.w   ($00FF13FC).l
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$E85A                                 ; bsr.w $038544
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_39b08
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$A2CE                           ; jsr $01A2CE
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000F).w
    pea     ($000F).w
    pea     ($000F).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004860A).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    lea     $30(a7), a7
    move.l  ($00048612).l, -(a7)
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0001).w
    pea     ($0003).w
    dc.w    $4EB9,$0001,$D62C                           ; jsr $01D62C
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $28(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
    bra.w   l_39b08
l_39dc4:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    bra.w   l_39b08
l_39dd4:
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_039DDE -- (TODO: name)
; 116 bytes | $039DDE-$039E51
; ============================================================================
func_039DDE:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $18(a7), d2
    move.l  $1c(a7), d3
    move.l  $20(a7), d4
    move.w  d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6F42                           ; jsr $006F42
    addq.l  #$8, a7
    move.w  d0, d3
    clr.w   d4
    clr.w   d2
l_39e18:
    tst.b   $1(a3)
    beq.b   l_39e42
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    blt.b   l_39e42
    moveq   #$1,d4
    bra.b   l_39e4a
l_39e42:
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   l_39e18
l_39e4a:
    move.w  d4, d0
    movem.l (a7)+, d2-d4/a2-a3
    rts

; ============================================================================
; func_039E52 -- (TODO: name)
; 86 bytes | $039E52-$039EA7
; ============================================================================
func_039E52:
    movem.l d2-d5, -(a7)
    move.l  $1c(a7), d2
    move.l  $18(a7), d3
    move.l  $14(a7), d5
    moveq   #$1,d4
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d3
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$8, a7
    move.w  d0, d2
    cmp.w   d2, d3
    beq.b   l_39ea0
    moveq   #$1,d0
    lsl.b   d2, d0
    move.w  d5, d1
    mulu.w  #$7, d1
    add.w   d3, d1
    movea.l  #$00FFA7BC,a0
    and.b   (a0,d1.w), d0
    beq.b   l_39ea0
    clr.w   d4
l_39ea0:
    move.w  d4, d0
    movem.l (a7)+, d2-d5
    rts

; ============================================================================
; func_039EA8 -- (TODO: name)
; 2 bytes | $039EA8-$039EA9
; ============================================================================
func_039EA8:
    rts

; ============================================================================
; func_039EAA -- (TODO: name)
; 1668 bytes | $039EAA-$03A52D
; ============================================================================
func_039EAA:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2
    movea.l  #$00FF1804,a2
    movea.l  #$00000D64,a3
    movea.l  #$00005092,a4
    movea.l  #$0001D8AA,a5
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    move.l  #$9010, -(a7)
    clr.l   -(a7)
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$5518                           ; jsr $005518
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $2c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0006157C).l
    jsr     (a4)
    lea     $28(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0006157E).l
    jsr     (a4)
    pea     ($0006159C).l
    pea     ($0013).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($00061A5C).l
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $30(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($001C).w
    pea     ($015A).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00061BC2).l
    jsr     (a4)
    lea     $20(a7), a7
    pea     ($00061BE2).l
    pea     ($000B).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($00061EA2).l
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($0052).w
    pea     ($0001).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    pea     ($0006088E).l
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $1c(a7), a7
    pea     ($0006010E).l
    pea     ($001E).w
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($00EE).w
    pea     ($0176).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    lea     $30(a7), a7
    pea     ($000620CC).l
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0006210C).l
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($000621BC).l
    move.l  a2, d0
    addi.l  #$7d0, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $2c(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($0020).w
    pea     ($0053).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    pea     ($00062212).l
    move.l  a2, d0
    addi.l  #$fa0, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    move.l  a2, d0
    addi.l  #$fa0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0300).w
    dc.w    $4EB9,$0001,$D7BE                           ; jsr $01D7BE
    lea     $2c(a7), a7
    move.l  a2, d0
    addi.l  #$1160, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0310).w
    dc.w    $4EB9,$0001,$D7BE                           ; jsr $01D7BE
    move.l  a2, d0
    addi.l  #$1320, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0320).w
    dc.w    $4EB9,$0001,$D7BE                           ; jsr $01D7BE
    move.l  a2, d0
    addi.l  #$14e0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0330).w
    dc.w    $4EB9,$0001,$D7BE                           ; jsr $01D7BE
    lea     $30(a7), a7
    move.l  a2, d0
    addi.l  #$16a0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0340).w
    dc.w    $4EB9,$0001,$D7BE                           ; jsr $01D7BE
    pea     ($00062426).l
    move.l  a2, d0
    addi.l  #$fa0, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    move.l  a2, d0
    addi.l  #$fa0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0008).w
    pea     ($0321).w
    dc.w    $4EB9,$0001,$D7BE                           ; jsr $01D7BE
    lea     $28(a7), a7
    move.l  a2, d0
    addi.l  #$10a0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0008).w
    pea     ($0331).w
    dc.w    $4EB9,$0001,$D7BE                           ; jsr $01D7BE
    move.l  a2, d0
    addi.l  #$11a0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0008).w
    pea     ($0341).w
    dc.w    $4EB9,$0001,$D7BE                           ; jsr $01D7BE
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00062762).l
    jsr     (a4)
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0031).w
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00076520,a0
    pea     (a0, d0.w)
    jsr     (a4)
    pea     ($0001).w
    pea     ($0033).w
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00076520,a0
    pea     (a0, d0.w)
    jsr     (a4)
    lea     $18(a7), a7
    clr.w   d2
    clr.w   d4
l_3a21e:
    clr.w   d3
l_3a220:
    pea     ($6000).w
    pea     ($0001).w
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$78, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$58, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$4, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    addi.l  #$300, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    addq.w  #$1, d2
    addq.w  #$1, d3
    cmpi.w  #$7, d3
    blt.b   l_3a220
    addq.w  #$1, d4
    cmpi.w  #$5, d4
    blt.b   l_3a21e
    moveq   #$1,d4
    move.w  d4, d7
    clr.w   d3
    clr.w   d2
    move.w  d7, d5
    ext.l   d5
    move.l  d5, d0
    add.l   d5, d5
    add.l   d0, d5
    lsl.l   #$7, d5
    addi.l  #$7d0, d5
    move.w  d7, d6
    ext.l   d6
    lsl.l   #$8, d6
    addi.l  #$9d0, d6
    bra.w   l_3a4be
l_3a2b4:
    clr.l   -(a7)
    pea     ($0003).w
    dc.w    $4EB9,$0001,$D62C                           ; jsr $01D62C
    addq.l  #$8, a7
    cmpi.w  #$10, d0
    beq.w   l_3a4c6
    tst.w   d2
    bne.b   l_3a2dc
    clr.l   -(a7)
    pea     ($000D).w
    dc.w    $4EB9,$0001,$D3AC                           ; jsr $01D3AC
    addq.l  #$8, a7
l_3a2dc:
    cmpi.w  #$28, d2
    bge.b   l_3a2e8
    subq.w  #$2, d3
    bra.w   l_3a42c
l_3a2e8:
    subq.w  #$2, d4
    subq.w  #$3, d3
    cmpi.w  #$41, d2
    bge.w   l_3a3a0
    move.w  d2, d0
    ext.l   d0
    moveq   #$5,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    moveq   #$4,d1
    cmp.l   d0, d1
    bne.w   l_3a3a0
    cmpi.w  #$37, d2
    bge.b   l_3a356
    move.l  d5, d0
    add.l   d0, d0
    pea     (a2, d0.l)
    pea     ($0008).w
    pea     ($0321).w
    jsr     (a5)
    move.l  d5, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    lea     $100(a0), a0
    move.l  a0, -(a7)
    pea     ($0008).w
    pea     ($0331).w
    jsr     (a5)
    move.l  d5, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    lea     $200(a0), a0
    move.l  a0, -(a7)
    pea     ($0008).w
    pea     ($0341).w
    jsr     (a5)
    lea     $24(a7), a7
    bra.b   l_3a392
l_3a356:
    move.l  d6, d0
    add.l   d0, d0
    pea     (a2, d0.l)
    pea     ($0008).w
    pea     ($0321).w
    jsr     (a5)
    move.l  d6, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    lea     $100(a0), a0
    move.l  a0, -(a7)
    pea     ($0008).w
    pea     ($0331).w
    jsr     (a5)
    pea     ($0004).w
    pea     ($001C).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    lea     $20(a7), a7
l_3a392:
    addi.l  #$100, d6
    addi.l  #$180, d5
    addq.w  #$1, d7
l_3a3a0:
    cmpi.w  #$2d, d2
    bne.b   l_3a3b4
    pea     ($000A).w
    dc.w    $4EB9,$0001,$D444                           ; jsr $01D444
    addq.l  #$4, a7
    bra.b   l_3a42c
l_3a3b4:
    cmpi.w  #$41, d2
    bne.b   l_3a412
    pea     ($00062212).l
    move.l  a2, d0
    addi.l  #$fa0, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    move.l  a2, d0
    addi.l  #$1320, d0
    move.l  d0, -(a7)
    pea     ($000E).w
    pea     ($0320).w
    jsr     (a5)
    move.l  a2, d0
    addi.l  #$14e0, d0
    move.l  d0, -(a7)
    pea     ($000E).w
    pea     ($0330).w
    jsr     (a5)
    lea     $20(a7), a7
    move.l  a2, d0
    addi.l  #$16a0, d0
    move.l  d0, -(a7)
    pea     ($000E).w
    pea     ($0340).w
    jsr     (a5)
    bra.b   l_3a428
l_3a412:
    cmpi.w  #$4c, d2
    bne.b   l_3a42c
    pea     ($0010).w
    pea     ($0010).w
    pea     ($000600EE).l
    jsr     (a4)
l_3a428:
    lea     $c(a7), a7
l_3a42c:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D8F4                           ; jsr $01D8F4
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    dc.w    $4EB9,$0001,$D8F4                           ; jsr $01D8F4
    lea     $18(a7), a7
    cmpi.w  #$1, d2
    bne.b   l_3a462
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
l_3a462:
    cmpi.w  #$4c, d2
    bge.b   l_3a4bc
    move.w  d2, d0
    andi.l  #$1, d0
    bne.b   l_3a47a
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    bra.b   l_3a488
l_3a47a:
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, d0
    addi.l  #$7d0, d0
    move.l  d0, -(a7)
l_3a488:
    pea     ($0020).w
    pea     ($0053).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    pea     ($0002).w
    pea     ($001A).w
    move.w  d2, d0
    ext.l   d0
    moveq   #$2,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    lsl.w   #$2, d0
    movea.l  #$000600E4,a0
    pea     (a0, d0.w)
    jsr     (a4)
    lea     $20(a7), a7
l_3a4bc:
    addq.w  #$1, d2
l_3a4be:
    cmpi.w  #$88, d2
    blt.w   l_3a2b4
l_3a4c6:
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    pea     ($0018).w
    jsr     (a3)
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D8F4                           ; jsr $01D8F4
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    dc.w    $4EB9,$0001,$D8F4                           ; jsr $01D8F4
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    jsr     (a4)
    move.l  #$9000, -(a7)
    clr.l   -(a7)
    jsr     (a3)
    lea     $30(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$5518                           ; jsr $005518
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    dc.w    $4EB9,$0001,$DE92                           ; jsr $01DE92
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03A52E -- (TODO: name)
; 122 bytes | $03A52E-$03A5A7
; ============================================================================
func_03A52E:
    link    a6,#$0
    movem.l d2-d5/a2-a3, -(a7)
    move.w  $a(a6), d0
    lsl.w   #$3, d0
    movea.l  #$00048868,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  (a0), d3
    move.w  $2(a2), d4
    move.w  $4(a2), d2
    move.w  $6(a2), d5
    move.w  d5, d0
    mulu.w  #$c, d0
    add.w   d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FFAA64,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    movea.l  #$00FFA7E4,a3
    clr.w   d2
    bra.b   l_3a59a
l_3a576:
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$5, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    move.l  a3, -(a7)
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    lea     $c(a7), a7
    lea     $180(a2), a2
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$5, d0
    adda.l  d0, a3
    addq.w  #$1, d2
l_3a59a:
    cmp.w   d4, d2
    bcs.b   l_3a576
    movem.l -$18(a6), d2-d5/a2-a3
    unlk    a6
    rts

; ============================================================================
; ShowCharPortrait -- (TODO: describe)
; Called: 8 times.
; 504 bytes | $03A5A8-$03A79F
; ============================================================================
ShowCharPortrait:                                                  ; $03A5A8
    link    a6,#-$4
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $001c(a6),d2
    move.l  $0010(a6),d4
    move.l  $000c(a6),d5
    move.l  $0008(a6),d6
    movea.l #$0d64,a3
    movea.l #$0007bad6,a4
    movea.l #$3fec,a5
    move.w  #$0222,-$0002(a6)
    pea     ($0001).w
    pea     ($000F).w
    cmpi.w  #$4,d2
    bne.b   .l3a5ec
    pea     -$0002(a6)
    bra.b   .l3a5fa
.l3a5ec:                                                ; $03A5EC
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$00076520,a0
    pea     (a0,d0.w)
.l3a5fa:                                                ; $03A5FA
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    movea.l #$00ff1278,a0
    move.b  (a0,d6.w),d0
    andi.l  #$ff,d0
    moveq   #$35,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    mulu.w  #$a,d0
    movea.l #$00048656,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  (a2)+,d2
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a4,a0.l),-(sp)
    pea     ($00FFAA64).l
    jsr     (a5)
    lea     $0014(sp),sp
    moveq   #$1,d3
.l3a646:                                                ; $03A646
    move.w  (a2)+,d2
    cmpi.w  #$ff,d2
    beq.b   .l3a6aa
    cmpi.w  #$2,d3
    beq.b   .l3a660
    cmpi.w  #$3,d3
    beq.b   .l3a660
    cmpi.w  #$31,d2
    bne.b   .l3a686
.l3a660:                                                ; $03A660
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a4,a0.l),-(sp)
    pea     ($00FFA7E4).l
    jsr     (a5)
    move.w  d2,d0
    addi.w  #$ffeb,d0
    move.l  d0,-(sp)
    dc.w    $6100,$feb0                                 ; bsr.w $03A52E
    lea     $000c(sp),sp
    addq.w  #$1,d2
.l3a686:                                                ; $03A686
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a4,a0.l),-(sp)
    pea     ($00FFA7E4).l
    jsr     (a5)
    move.w  d2,d0
    addi.w  #$ffeb,d0
    move.l  d0,-(sp)
    dc.w    $6100,$fe8a                                 ; bsr.w $03A52E
    lea     $000c(sp),sp
.l3a6aa:                                                ; $03A6AA
    addq.w  #$1,d3
    cmpi.w  #$5,d3
    bcs.b   .l3a646
    pea     ($0054).w
    pea     ($0640).w
    pea     ($00FFAA64).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    pea     ($064C).w
    pea     ($0008).w
    pea     ($000E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $0028(sp),sp
    pea     ($00070000).l
    pea     ($0007).w
    pea     ($000C).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  $0016(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $001c(sp),sp
    tst.w   $001a(a6)
    beq.b   .l3a796
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0009).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $002c(sp),sp
    move.w  d4,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    movea.l #$00ff1278,a0
    move.b  (a0,d6.w),d0
    andi.l  #$ff,d0
    lsl.w   #$2,d0
    movea.l #$0005ecfc,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($00045030).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
.l3a796:                                                ; $03A796
    movem.l -$0028(a6),d2-d6/a2-a5
    unlk    a6
    rts
; ============================================================================
; LoadGameGraphics -- (TODO: describe)
; 310 bytes | $03A7A0-$03A8D5
; ============================================================================
LoadGameGraphics:                                                  ; $03A7A0
    movem.l d2/a2-a5,-(sp)
    movea.l #$00ff1804,a2
    movea.l #$0d64,a3
    movea.l #$45e6,a4
    movea.l #$3fec,a5
    pea     ($0001).w
    pea     ($0404).w
    pea     ($00048958).l
    jsr     (a4)
    lea     $000c(sp),sp
    clr.w   d2
.l3a7d2:                                                ; $03A7D2
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l #$000780bc,a0
    move.l  (a0,d0.l),-(sp)
    move.l  a2,-(sp)
    jsr     (a5)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2,d0
    addi.l  #$0405,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    jsr     (a4)
    lea     $0014(sp),sp
    addq.w  #$1,d2
    cmpi.w  #$5a,d2
    bcs.b   .l3a7d2
    clr.w   d2
.l3a808:                                                ; $03A808
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l #$00078224,a0
    move.l  (a0,d0.l),-(sp)
    move.l  a2,-(sp)
    jsr     (a5)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d2,d0
    add.l   d0,d0
    addi.l  #$045f,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    jsr     (a4)
    lea     $0014(sp),sp
    addq.w  #$1,d2
    cmpi.w  #$64,d2
    bcs.b   .l3a808
    clr.l   -(sp)
    move.l  #$a4e0,-(sp)
    pea     ($0004897C).l
    pea     ($0080).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    clr.l   -(sp)
    move.l  #$a5e0,-(sp)
    pea     ($00048C7C).l
    pea     ($0020).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    lea     $0030(sp),sp
    clr.l   -(sp)
    move.l  #$a620,-(sp)
    pea     ($00048A7C).l
    pea     ($0100).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    clr.l   -(sp)
    move.l  #$a820,-(sp)
    pea     ($00048CBC).l
    pea     ($0030).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    lea     $0030(sp),sp
    move.l  ($000A1B48).l,-(sp)
    move.l  a2,-(sp)
    jsr     (a5)
    pea     ($0006).w
    pea     ($0544).w
    move.l  a2,-(sp)
    jsr     (a4)
    lea     $0014(sp),sp
    movem.l (sp)+,d2/a2-a5
    rts
; ============================================================================
; ResetGameState -- (TODO: describe)
; 108 bytes | $03A8D6-$03A941
; ============================================================================
ResetGameState:                                                  ; $03A8D6
    clr.w   ($00FF1800).l
    clr.w   ($00FF128A).l
    clr.w   ($00FFBDA6).l
    clr.w   ($00FF1290).l
    move.w  #$1f,($00FF1000).l
    move.w  #$1,($00FF99DE).l
    clr.w   ($00FFBD4A).l
    move.w  #$1,($00FFA77A).l
    clr.w   ($00FFBDA4).l
    clr.w   ($00FFBD68).l
    clr.w   ($00FFB9E4).l
    moveq   #$20,d0
    move.w  d0,($00FFBD48).l
    move.w  d0,($00FFBDA8).l
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  #$1,($00FF128C).l
    rts
; ---------------------------------------------------------------------------
; SetTextWindow - Define text rendering window bounds
; Params: left (SP+4), top (SP+8), width (SP+12), height (SP+16)
; Sets win_left, win_top, win_right, win_bottom and calls cursor helpers
; 124 calls | 106 bytes | $03A942-$03A9AB
; ---------------------------------------------------------------------------
SetTextWindow:
    movem.l d2-d5,-(sp)                                    ; $03A942
    move.l  $14(sp),d2                                     ; $03A946 | left
    move.l  $1C(sp),d3                                     ; $03A94A | width
    move.l  $18(sp),d4                                     ; $03A94E | top
    move.l  $20(sp),d5                                     ; $03A952 | height
    move.w  d2,($FFBD68).l                                 ; $03A956 | win_left
    move.w  d2,($FF1290).l                                 ; $03A95C | win_left_dup
    move.w  d4,($FFB9E4).l                                 ; $03A962 | win_top
    moveq   #0,d0                                          ; $03A968
    move.w  d2,d0                                          ; $03A96A
    moveq   #0,d1                                          ; $03A96C
    move.w  d3,d1                                          ; $03A96E
    add.l   d1,d0                                          ; $03A970 | left + width
    subq.l  #1,d0                                          ; $03A972 | right = left+width-1
    move.l  d0,d3                                          ; $03A974
    move.w  d0,($FFBDA8).l                                 ; $03A976 | win_right
    move.w  d3,($FF1000).l                                 ; $03A97C | win_right_dup
    move.w  d4,d0                                          ; $03A982
    add.w   d5,d0                                          ; $03A984 | top + height
    addi.w  #$FFFF,d0                                      ; $03A986 | bottom = top+height-1
    move.w  d0,($FFBD48).l                                 ; $03A98A | win_bottom
    move.w  d2,d0                                          ; $03A990
    move.l  d0,-(sp)                                       ; $03A992
    dc.w    $4EBA,$0168                                    ; $03A994 | jsr SetCursorX(pc)
    nop                                                    ; $03A998
    move.w  d4,d0                                          ; $03A99A
    move.l  d0,-(sp)                                       ; $03A99C
    dc.w    $4EBA,$0154                                    ; $03A99E | jsr SetCursorY(pc)
    nop                                                    ; $03A9A2
    addq.l  #8,sp                                          ; $03A9A4 | clean 2 pushed params
    movem.l (sp)+,d2-d5                                    ; $03A9A6
    rts                                                    ; $03A9AA
; ============================================================================
; ClearTileArea -- (TODO: describe)
; Called: ?? times.
; 36 bytes | $03A9AC-$03A9CF
; ============================================================================
ClearTileArea:                                                  ; $03A9AC
    move.l  #$8000,-(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    rts
; === Translated block $03A9D0-$03AAF4 ===
; 5 functions, 292 bytes

; ============================================================================
; func_03A9D0 -- (TODO: name)
; 50 bytes | $03A9D0-$03AA01
; ============================================================================
func_03A9D0:
    move.l  d2, -(a7)
    movea.l $8(a7), a1
    clr.w   d2
    bra.b   l_3a9e6
l_3a9da:
    move.w  d2, d0
    mulu.w  #$a, d0
    add.w   d1, d0
    move.w  d0, d2
    addq.l  #$1, (a1)
l_3a9e6:
    movea.l (a1), a0
    move.b  (a0), d0
    andi.l  #$ff, d0
    addi.w  #$ffd0, d0
    move.w  d0, d1
    cmpi.w  #$a, d0
    bcs.b   l_3a9da
    move.w  d2, d0
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_03AA02 -- (TODO: name)
; 86 bytes | $03AA02-$03AA57
; ============================================================================
func_03AA02:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    movea.l $10(a7), a2
    moveq   #$A,d0
    cmp.l   d2, d0
    bls.b   l_3aa24
    move.b  d2, d0
    addi.b  #$30, d0
    movea.l (a2), a0
    addq.l  #$1, (a2)
    move.b  d0, (a0)
    moveq   #$1,d0
    bra.b   l_3aa52
l_3aa24:
    move.l  d2, d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E0C6                           ; jsr $03E0C6
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $6100,$FFCE                                 ; bsr.w $03AA02
    move.w  d0, d3
    move.l  d2, d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E12A                           ; jsr $03E12A
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $6100,$FFBA                                 ; bsr.w $03AA02
    lea     $10(a7), a7
    move.w  d3, d0
    addq.w  #$1, d0
l_3aa52:
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; func_03AA58 -- (TODO: name)
; 88 bytes | $03AA58-$03AAAF
; ============================================================================
func_03AA58:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    movea.l $10(a7), a2
    moveq   #$10,d0
    cmp.l   d2, d0
    bls.b   l_3aa88
    moveq   #$A,d0
    cmp.l   d2, d0
    bls.b   l_3aa78
    move.b  d2, d0
    addi.b  #$30, d0
    bra.b   l_3aa7e
l_3aa78:
    move.b  d2, d0
    addi.b  #$37, d0
l_3aa7e:
    movea.l (a2), a0
    addq.l  #$1, (a2)
    move.b  d0, (a0)
    moveq   #$1,d0
    bra.b   l_3aaaa
l_3aa88:
    move.l  d2, d0
    lsr.l   #$4, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $6100,$FFC6                                 ; bsr.w $03AA58
    move.w  d0, d3
    moveq   #$F,d0
    and.l   d2, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $6100,$FFB8                                 ; bsr.w $03AA58
    lea     $10(a7), a7
    move.w  d3, d0
    addq.w  #$1, d0
l_3aaaa:
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; func_03AAB0 -- (TODO: name)
; 54 bytes | $03AAB0-$03AAE5
; ============================================================================
func_03AAB0:
    move.l  d2, -(a7)
    move.l  $c(a7), d2
    move.l  $8(a7), d1
    cmpi.w  #$20, d1
    bls.b   l_3aac4
    moveq   #$20,d0
    bra.b   l_3aac8
l_3aac4:
    moveq   #$0,d0
    move.w  d1, d0
l_3aac8:
    move.w  d0, ($00FF1290).l
    cmpi.w  #$20, d2
    bls.b   l_3aad8
    moveq   #$20,d0
    bra.b   l_3aadc
l_3aad8:
    moveq   #$0,d0
    move.w  d2, d0
l_3aadc:
    move.w  d0, ($00FF1000).l
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_03AAE6 -- (TODO: name)
; 14 bytes | $03AAE6-$03AAF3
; ============================================================================
func_03AAE6:
    pea     ($0020).w
    clr.l   -(a7)
    dc.w    $6100,$FFC2                                 ; bsr.w $03AAB0
    addq.l  #$8, a7
    rts

; ============================================================================
; SetCursorY -- (TODO: describe)
; Called: ?? times.
; 10 bytes | $03AAF4-$03AAFD
; ============================================================================
SetCursorY:                                                  ; $03AAF4
    move.w  $0006(sp),($00FFBDA6).l
    rts
; ============================================================================
; SetCursorX -- (TODO: describe)
; Called: ?? times.
; 10 bytes | $03AAFE-$03AB07
; ============================================================================
SetCursorX:                                                  ; $03AAFE
    move.w  $0006(sp),($00FF128A).l
    rts
; === Translated block $03AB08-$03AB2C ===
; 1 functions, 36 bytes

; ============================================================================
; func_03AB08 -- (TODO: name)
; 36 bytes | $03AB08-$03AB2B
; ============================================================================
func_03AB08:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d2
    move.l  $c(a7), d3
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FFE4                                 ; bsr.w $03AAFE
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FFD2                                 ; bsr.w $03AAF4
    addq.l  #$8, a7
    movem.l (a7)+, d2-d3
    rts

; ---------------------------------------------------------------------------
; SetTextCursor - Set text cursor position
; Params: x (SP+4), y (SP+8)
; 174 calls | 36 bytes | $03AB2C-$03AB4F
; ---------------------------------------------------------------------------
SetTextCursor:
    movem.l d2-d3,-(sp)                                    ; $03AB2C
    move.l  $10(sp),d2                                     ; $03AB30 | y
    move.l  $0C(sp),d3                                     ; $03AB34 | x
    move.w  d3,d0                                          ; $03AB38
    move.l  d0,-(sp)                                       ; $03AB3A
    dc.w    $6100,$FFC0                                    ; $03AB3C | bsr.w SetCursorX
    move.w  d2,d0                                          ; $03AB40
    move.l  d0,-(sp)                                       ; $03AB42
    dc.w    $6100,$FFAE                                    ; $03AB44 | bsr.w SetCursorY
    addq.l  #8,sp                                          ; $03AB48 | clean 2 pushed params
    movem.l (sp)+,d2-d3                                    ; $03AB4A
    rts                                                    ; $03AB4E
; === Translated block $03AB50-$03ACDC ===
; 4 functions, 396 bytes

; ============================================================================
; func_03AB50 -- (TODO: name)
; 86 bytes | $03AB50-$03ABA5
; ============================================================================
func_03AB50:
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

; ============================================================================
; func_03ABA6 -- (TODO: name)
; 172 bytes | $03ABA6-$03AC51
; ============================================================================
func_03ABA6:
    link    a6,#$0
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $20(a6), d2
    move.l  $1c(a6), d3
    movea.l $18(a6), a2
    movea.l $8(a6), a3
    movea.l $14(a6), a4
    movea.l $c(a6), a5
    tst.w   (a2)
    beq.b   l_3ac12
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    move.l  (a5), -(a7)
    move.l  a3, d0
    moveq   #$42,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E16C                           ; jsr $01E16C
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  ($00FFA77A).l, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  ($00FFBDA6).l, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a4), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($001B).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
l_3ac12:
    tst.w   d2
    beq.b   l_3ac32
    move.w  ($00FF1290).l, d0
    move.w  d0, ($00FF128A).l
    move.w  d0, (a4)
    move.w  ($00FF99DE).l, d0
    add.w   d0, ($00FFBDA6).l
    bra.b   l_3ac38
l_3ac32:
    move.w  ($00FF128A).l, (a4)
l_3ac38:
    move.l  a3, (a5)
    move.l  a3, d0
    moveq   #$42,d1
    add.l   d1, d0
    movea.l $10(a6), a0
    move.l  d0, (a0)
    clr.w   (a2)
    movem.l -$18(a6), d2-d3/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03AC52 -- (TODO: name)
; 96 bytes | $03AC52-$03ACB1
; ============================================================================
func_03AC52:
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

; ============================================================================
; func_03ACB2 -- (TODO: name)
; 42 bytes | $03ACB2-$03ACDB
; ============================================================================
func_03ACB2:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d1
    clr.w   d2
    bra.b   l_3acc8
l_3acbe:
    cmp.b   d1, d3
    bne.b   l_3acc6
    moveq   #$1,d0
    bra.b   l_3acd6
l_3acc6:
    addq.w  #$1, d2
l_3acc8:
    movea.l  #$00048978,a0
    move.b  (a0,d2.w), d3
    bne.b   l_3acbe
    moveq   #$0,d0
l_3acd6:
    movem.l (a7)+, d2-d3
    rts

RenderTextBlock:                                                  ; $03ACDC
    link    a6,#-$94
    movem.l d2-d7/a2-a5,-(sp)
    movea.l $0008(a6),a2
    movea.l #$00ff128a,a3
    lea     -$0084(a6),a4
    lea     -$008c(a6),a5
    move.l  a4,-$0088(a6)
    move.l  a4,d0
    moveq   #$42,d1
    add.l   d1,d0
    move.l  d0,(a5)
    moveq   #$0,d0
    move.w  (a3),d0
    moveq   #$20,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,(a3)
    moveq   #$0,d0
    move.w  ($00FFBDA6).l,d0
    moveq   #$20,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,($00FFBDA6).l
    clr.w   -$0090(a6)
    move.w  (a3),-$008e(a6)
    clr.w   d5
    clr.w   d4
    clr.w   d7
    clr.w   d6
    bra.w   .l3afc6
.l3ad3a:                                                ; $03AD3A
    move.b  $0001(a2),-$0091(a6)
    move.w  (a3),d0
    cmp.w   ($00FF1000).l,d0
    bcs.b   .l3ad50
    cmpi.b  #$1b,d3
    bne.b   .l3ad72
.l3ad50:                                                ; $03AD50
    move.l  a2,-(sp)
    dc.w    $6100,$fefe                                 ; bsr.w $03AC52
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  (a3),d1
    add.l   d1,d0
    subq.l  #$1,d0
    moveq   #$0,d1
    move.w  ($00FF1000).l,d1
    cmp.l   d1,d0
    blt.b   .l3ad9e
.l3ad72:                                                ; $03AD72
    pea     ($0001).w
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    dc.w    $6100,$fe18                                 ; bsr.w $03ABA6
    lea     $001c(sp),sp
    moveq   #$1,d4
    cmpi.b  #$20,d3
    beq.w   .l3afc4
.l3ad9e:                                                ; $03AD9E
    cmpi.b  #$0a,d3
    bne.b   .l3add0
    tst.w   d4
    bne.b   .l3adca
    pea     ($0001).w
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    dc.w    $6100,$fde2                                 ; bsr.w $03ABA6
    lea     $001c(sp),sp
.l3adca:                                                ; $03ADCA
    clr.w   d4
    bra.w   .l3afc4
.l3add0:                                                ; $03ADD0
    tst.w   d7
    beq.b   .l3ae18
    clr.l   -(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    dc.w    $6100,$fdb8                                 ; bsr.w $03ABA6
    pea     ($0001).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
    lea     $0020(sp),sp
    move.w  d0,d2
    tst.w   d2
    beq.b   .l3ae0a
    cmp.w   d2,d6
    beq.b   .l3ae0a
    clr.w   d7
.l3ae0a:                                                ; $03AE0A
    tst.w   d2
    beq.b   .l3ae14
    moveq   #$0,d0
    move.w  d6,d0
    bra.b   .l3ae16
.l3ae14:                                                ; $03AE14
    moveq   #$0,d0
.l3ae16:                                                ; $03AE16
    move.w  d0,d6
.l3ae18:                                                ; $03AE18
    tst.w   ($00FF128C).l
    beq.b   .l3ae26
    move.w  #$8404,d2
    bra.b   .l3ae2a
.l3ae26:                                                ; $03AE26
    move.w  #$0404,d2
.l3ae2a:                                                ; $03AE2A
    cmpi.b  #$20,d3
    bne.b   .l3ae68
    tst.w   ($00FF128C).l
    beq.b   .l3ae4e
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    move.w  #$8000,(a0)
.l3ae44:                                                ; $03AE44
    movea.l (a5),a0
    addq.l  #$2,(a5)
    move.w  #$8000,(a0)
    bra.b   .l3ae5e
.l3ae4e:                                                ; $03AE4E
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    clr.w   (a0)
.l3ae58:                                                ; $03AE58
    movea.l (a5),a0
    addq.l  #$2,(a5)
    clr.w   (a0)
.l3ae5e:                                                ; $03AE5E
    addq.w  #$1,(a3)
    addq.w  #$1,-$0090(a6)
    bra.w   .l3adca
.l3ae68:                                                ; $03AE68
    cmpi.b  #$21,d3
    bcs.b   .l3aec4
    cmpi.b  #$7e,d3
    bhi.b   .l3aec4
    tst.w   ($00FF1800).l
    beq.b   .l3ae88
    moveq   #$0,d4
    move.b  d3,d4
    add.w   d4,d4
    addi.w  #$19,d4
    bra.b   .l3ae90
.l3ae88:                                                ; $03AE88
    moveq   #$0,d4
    move.b  d3,d4
    addi.w  #$ffe0,d4
.l3ae90:                                                ; $03AE90
    add.w   d4,d2
    tst.w   ($00FF1800).l
    beq.b   .l3aeb0
    move.l  d2,d0
    addq.w  #$1,d2
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    move.w  d0,(a0)
    movea.l (a5),a0
    addq.l  #$2,(a5)
    move.w  d2,(a0)
    bra.b   .l3ae5e
.l3aeb0:                                                ; $03AEB0
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    move.w  d2,(a0)
    tst.w   ($00FF128C).l
    beq.b   .l3ae58
    bra.b   .l3ae44
.l3aec4:                                                ; $03AEC4
    cmpi.b  #$1b,d3
    bne.w   .l3afc4
    tst.w   -$0090(a6)
    beq.b   .l3af02
    move.b  -$0091(a6),d0
    move.l  d0,-(sp)
    dc.w    $6100,$fdd8                                 ; bsr.w $03ACB2
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l3af02
    clr.l   -(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    dc.w    $6100,$fcaa                                 ; bsr.w $03ABA6
    lea     $001c(sp),sp
.l3af02:                                                ; $03AF02
    addq.l  #$1,a2
    moveq   #$0,d0
    move.b  -$0091(a6),d0
    moveq   #$3d,d1
    cmp.b   d1,d0
    beq.b   .l3af3a
    moveq   #$52,d1
    cmp.b   d1,d0
    beq.b   .l3af5c
    moveq   #$45,d1
    cmp.b   d1,d0
    beq.b   .l3af6e
    moveq   #$47,d1
    cmp.b   d1,d0
    beq.b   .l3af80
    moveq   #$57,d1
    cmp.b   d1,d0
    beq.b   .l3af90
    moveq   #$4d,d1
    cmp.b   d1,d0
    beq.b   .l3afa2
    moveq   #$50,d1
    cmp.b   d1,d0
    beq.w   .l3afb0
    bra.w   .l3afc4
.l3af3a:                                                ; $03AF3A
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    addi.w  #$ffe0,d0
    move.w  d0,($00FFBDA6).l
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    addi.w  #$ffe0,d0
    move.w  d0,(a3)
    move.w  d0,-$008e(a6)
    bra.b   .l3afc4
.l3af5c:                                                ; $03AF5C
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    addi.w  #$ffe0,d0
    move.w  d0,($00FF1290).l
    bra.b   .l3afc4
.l3af6e:                                                ; $03AF6E
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    addi.w  #$ffe0,d0
    move.w  d0,($00FF1000).l
    bra.b   .l3afc4
.l3af80:                                                ; $03AF80
    moveq   #$1,d7
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    move.w  d0,d6
    bra.b   .l3afc4
.l3af90:                                                ; $03AF90
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    bra.b   .l3afc4
.l3afa2:                                                ; $03AFA2
    tst.w   d5
    bne.b   .l3afaa
    moveq   #$1,d0
    bra.b   .l3afac
.l3afaa:                                                ; $03AFAA
    moveq   #$0,d0
.l3afac:                                                ; $03AFAC
    move.w  d0,d5
    bra.b   .l3afc4
.l3afb0:                                                ; $03AFB0
    addq.l  #$1,a2
    cmpi.b  #$31,(a2)
    bne.b   .l3afbc
    moveq   #$1,d0
    bra.b   .l3afbe
.l3afbc:                                                ; $03AFBC
    moveq   #$0,d0
.l3afbe:                                                ; $03AFBE
    move.w  d0,($00FF128C).l
.l3afc4:                                                ; $03AFC4
    addq.l  #$1,a2
.l3afc6:                                                ; $03AFC6
    move.b  (a2),d3
    bne.w   .l3ad3a
    clr.l   -(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    dc.w    $6100,$fbc0                                 ; bsr.w $03ABA6
    movem.l -$00bc(a6),d2-d7/a2-a5
    unlk    a6
    rts
; === Translated block $03AFF2-$03B22C ===
; 2 functions, 570 bytes

; ============================================================================
; func_03AFF2 -- (TODO: name)
; 538 bytes | $03AFF2-$03B20B
; ============================================================================
func_03AFF2:
    link    a6,#-$EC
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a3
    lea     -$e6(a6), a4
    lea     -$e2(a6), a5
    lea     -$c8(a6), a2
    move.l  $8(a6), (a5)
    bra.w   l_3b1ea
l_3b012:
    cmpi.b  #$25, d2
    bne.w   l_3b1e8
    lea     -$de(a6), a0
    move.l  a0, (a4)
    moveq   #$6,d5
    clr.w   d7
    clr.w   d6
    clr.w   -$e8(a6)
    clr.w   -$ea(a6)
    movea.l (a5), a0
    move.b  (a0), d2
    cmpi.b  #$2d, d2
    bne.b   l_3b040
    moveq   #$1,d6
    addq.l  #$1, (a5)
    movea.l (a5), a0
    move.b  (a0), d2
l_3b040:
    cmpi.b  #$24, d2
    bne.b   l_3b064
    move.w  #$1, -$e8(a6)
    addq.l  #$1, (a5)
    movea.l (a5), a0
    move.b  (a0), d2
    cmpi.b  #$24, d2
    bne.b   l_3b064
    move.w  #$1, -$ea(a6)
    addq.l  #$1, (a5)
    movea.l (a5), a0
    move.b  (a0), d2
l_3b064:
    cmpi.b  #$30, d2
    bne.b   l_3b06e
    moveq   #$30,d0
    bra.b   l_3b070
l_3b06e:
    moveq   #$20,d0
l_3b070:
    move.b  d0, -$eb(a6)
    cmpi.b  #$30, d2
    bcs.b   l_3b094
    cmpi.b  #$39, d2
    bhi.b   l_3b094
    pea     -$e2(a6)
    dc.w    $6100,$F94A                                 ; bsr.w $03A9D0
    addq.l  #$4, a7
    move.l  d0, d3
    andi.l  #$ffff, d3
    bra.b   l_3b096
l_3b094:
    moveq   #$0,d3
l_3b096:
    movea.l (a5), a0
    addq.l  #$1, (a5)
    move.b  (a0), d0
    move.b  d0, d2
    cmpi.b  #$2e, d0
    bne.b   l_3b0b8
    pea     -$e2(a6)
    dc.w    $6100,$F926                                 ; bsr.w $03A9D0
    addq.l  #$4, a7
    move.w  d0, d5
    moveq   #$1,d7
    movea.l (a5), a0
    addq.l  #$1, (a5)
    move.b  (a0), d2
l_3b0b8:
    moveq   #$0,d0
    move.b  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E14A                           ; jsr $01E14A
    moveq   #$4C,d1
    cmp.l   d0, d1
    bne.b   l_3b0d0
    movea.l (a5), a0
    addq.l  #$1, (a5)
    move.b  (a0), d2
l_3b0d0:
    clr.b   d4
    moveq   #$0,d0
    move.b  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E14A                           ; jsr $01E14A
    addq.l  #$8, a7
    andi.l  #$ff, d0
    moveq   #$44,d1
    cmp.b   d1, d0
    beq.b   l_3b114
    moveq   #$55,d1
    cmp.b   d1, d0
    beq.b   l_3b124
    moveq   #$58,d1
    cmp.b   d1, d0
    beq.b   l_3b13a
    moveq   #$53,d1
    cmp.b   d1, d0
    beq.b   l_3b146
    moveq   #$43,d1
    cmp.b   d1, d0
    beq.b   l_3b15a
    moveq   #$57,d1
    cmp.b   d1, d0
    beq.b   l_3b166
    tst.b   d0
    beq.w   l_3b202
    bra.w   l_3b1e8
l_3b114:
    tst.l   (a3)
    bge.b   l_3b124
    neg.l   (a3)
    movea.l (a4), a0
    addq.l  #$1, (a4)
    move.b  #$2d, (a0)
    subq.w  #$1, d3
l_3b124:
    move.l  (a3), -(a7)
    pea     -$e6(a6)
    dc.w    $6100,$F8D6                                 ; bsr.w $03AA02
l_3b12e:
    addq.l  #$8, a7
    sub.w   d0, d3
    addq.l  #$4, a3
l_3b134:
    ori.b   #$1, d4
    bra.b   l_3b16c
l_3b13a:
    move.l  (a3), -(a7)
    pea     -$e6(a6)
    dc.w    $6100,$F916                                 ; bsr.w $03AA58
    bra.b   l_3b12e
l_3b146:
    move.l  (a3), (a4)
    move.l  (a4), -(a7)
    dc.w    $6100,$FA04                                 ; bsr.w $03AB50
    addq.l  #$4, a7
    sub.w   d0, d3
    addq.l  #$4, a3
    ori.b   #$2, d4
    bra.b   l_3b16c
l_3b15a:
    subq.w  #$1, d3
    move.l  (a3)+, d0
    movea.l (a4), a0
    addq.l  #$1, (a4)
    move.b  d0, (a0)
    bra.b   l_3b134
l_3b166:
    add.w   d5, d5
    add.w   d3, d3
    bra.b   l_3b124
l_3b16c:
    btst    #$0, d4
    beq.b   l_3b182
    movea.l (a4), a0
    clr.b   (a0)
    lea     -$de(a6), a0
    move.l  a0, (a4)
    clr.w   d7
    ori.b   #$2, d4
l_3b182:
    btst    #$1, d4
    beq.b   l_3b1ea
    move.w  d3, d2
    bra.b   l_3b190
l_3b18c:
    move.b  -$eb(a6), (a2)+
l_3b190:
    move.l  d3, d0
    subq.w  #$1, d3
    tst.w   d0
    ble.b   l_3b19c
    tst.w   d6
    beq.b   l_3b18c
l_3b19c:
    tst.w   -$e8(a6)
    beq.b   l_3b1b8
    move.b  #$24, (a2)+
    bra.b   l_3b1b8
l_3b1a8:
    tst.w   d7
    beq.b   l_3b1b0
    tst.w   d5
    ble.b   l_3b1b6
l_3b1b0:
    movea.l (a4), a0
    move.b  (a0), (a2)+
    subq.w  #$1, d5
l_3b1b6:
    addq.l  #$1, (a4)
l_3b1b8:
    movea.l (a4), a0
    tst.b   (a0)
    bne.b   l_3b1a8
    tst.w   -$e8(a6)
    beq.b   l_3b1da
    cmpi.w  #$1, -$ea(a6)
    beq.b   l_3b1da
    move.b  #$30, (a2)+
    move.b  #$4b, (a2)+
    bra.b   l_3b1da
l_3b1d6:
    move.b  -$eb(a6), (a2)+
l_3b1da:
    move.l  d2, d0
    subq.w  #$1, d2
    tst.w   d0
    ble.b   l_3b1ea
    tst.w   d6
    bne.b   l_3b1d6
    bra.b   l_3b1ea
l_3b1e8:
    move.b  d2, (a2)+
l_3b1ea:
    movea.l (a5), a0
    addq.l  #$1, (a5)
    move.b  (a0), d2
    bne.w   l_3b012
    clr.b   (a2)
    lea     -$c8(a6), a0
    movea.l $10(a6), a1
l_3b1fe:
    move.b  (a0)+, (a1)+
    bne.b   l_3b1fe
l_3b202:
    movem.l -$114(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03B20C -- (TODO: name)
; 32 bytes | $03B20C-$03B22B
; ============================================================================
func_03B20C:
    link    a6,#-$98
    pea     -$96(a6)
    move.l  $c(a6), -(a7)
    move.l  $8(a6), -(a7)
    dc.w    $6100,$FDD4                                 ; bsr.w $03AFF2
    pea     -$96(a6)
    dc.w    $6100,$FAB6                                 ; bsr.w $03ACDC
    unlk    a6
    rts

; ---------------------------------------------------------------------------
; sprintf - Format string to buffer (C-style varargs)
; Params via LINK: dest (8,A6), format ($C,A6), varargs ($10,A6+)
; 171 calls | 26 bytes | $03B22C-$03B245
; ---------------------------------------------------------------------------
sprintf:
    link    a6,#0                                          ; $03B22C
    lea     $10(a6),a0                                     ; $03B230 | varargs ptr
    move.l  $08(a6),-(sp)                                  ; $03B234 | push dest
    move.l  a0,-(sp)                                       ; $03B238 | push varargs
    move.l  $0C(a6),-(sp)                                  ; $03B23A | push format
    dc.w    $6100,$FDB2                                    ; $03B23E | bsr.w vsprintf
    unlk    a6                                             ; $03B242
    rts                                                    ; $03B244
; ---------------------------------------------------------------------------
; PrintfNarrow - Format and display string (1-tile narrow font)
; Params: format (8,A6), varargs ($C,A6+)
; 65 calls | 42 bytes | $03B246-$03B26F
; ---------------------------------------------------------------------------
PrintfNarrow:
    link    a6,#0                                          ; $03B246
    lea     $0C(a6),a0                                     ; $03B24A | varargs ptr
    clr.w   ($FF1800).l                                    ; $03B24E | font_mode = 0 (narrow)
    moveq   #1,d0                                          ; $03B254
    move.w  d0,($FFA77A).l                                 ; $03B256 | cursor_advance = 1
    move.w  d0,($FF99DE).l                                 ; $03B25C | char_width = 1
    move.l  a0,-(sp)                                       ; $03B262 | push varargs
    move.l  $08(a6),-(sp)                                  ; $03B264 | push format
    dc.w    $6100,$FFA2                                    ; $03B268 | bsr.w printf_internal
    unlk    a6                                             ; $03B26C
    rts                                                    ; $03B26E
; ---------------------------------------------------------------------------
; PrintfWide - Format and display string (2-tile wide font)
; Params: format (8,A6), varargs ($C,A6+)
; 97 calls | 44 bytes | $03B270-$03B29B
; ---------------------------------------------------------------------------
PrintfWide:
    link    a6,#0                                          ; $03B270
    lea     $0C(a6),a0                                     ; $03B274 | varargs ptr
    move.w  #1,($FF1800).l                                 ; $03B278 | font_mode = 1 (wide)
    moveq   #2,d0                                          ; $03B280
    move.w  d0,($FFA77A).l                                 ; $03B282 | cursor_advance = 2
    move.w  d0,($FF99DE).l                                 ; $03B288 | char_width = 2
    move.l  a0,-(sp)                                       ; $03B28E | push varargs
    move.l  $08(a6),-(sp)                                  ; $03B290 | push format
    dc.w    $6100,$FF76                                    ; $03B294 | bsr.w printf_internal
    unlk    a6                                             ; $03B298
    rts                                                    ; $03B29A
; === Translated block $03B29C-$03CB36 ===
; 19 functions, 6298 bytes

; ============================================================================
; func_03B29C -- (TODO: name)
; 164 bytes | $03B29C-$03B33F
; ============================================================================
func_03B29C:
    link    a6,#-$4
    movem.l d2-d3/a2, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    lea     -$4(a6), a2
    move.w  d2, d0
    move.w  d0, ($00FFA782).l
    move.w  d0, ($00FFA786).l
    move.w  d2, d0
    andi.w  #$3ff, d0
    move.w  d0, -$4(a6)
    move.w  d2, d0
    andi.w  #$3ff, d0
    add.w   ($00FFA780).l, d0
    move.w  d0, $2(a2)
    pea     ($0002).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $18(a7), a7
    move.w  d3, d0
    move.w  d0, ($00FFA784).l
    move.w  d0, ($00FFA788).l
    move.w  d3, d0
    neg.w   d0
    andi.w  #$3ff, d0
    move.w  d0, $2(a2)
    move.w  d0, -$4(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  ($00FFA78A).l, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    movem.l -$10(a6), d2-d3/a2
    unlk    a6
    rts

; ============================================================================
; func_03B340 -- (TODO: name)
; 42 bytes | $03B340-$03B369
; ============================================================================
func_03B340:
    pea     ($000D).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    move.l  ($000AF190).l, -(a7)
    pea     ($4000).w
    dc.w    $4EB9,$0000,$4342                           ; jsr $004342
    pea     ($000C).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $10(a7), a7
    rts

; ============================================================================
; func_03B36A -- (TODO: name)
; 36 bytes | $03B36A-$03B38D
; ============================================================================
func_03B36A:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
l_3b370:
    tst.w   d2
    beq.b   l_3b388
    subq.w  #$1, d2
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
    bra.b   l_3b370
l_3b388:
    moveq   #$0,d0
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_03B38E -- (TODO: name)
; 76 bytes | $03B38E-$03B3D9
; ============================================================================
func_03B38E:
    movem.l d2-d5/a2, -(a7)
    move.l  $24(a7), d3
    move.l  $20(a7), d4
    move.l  $1c(a7), d5
    movea.l $18(a7), a2
    moveq   #$7,d2
l_3b3a4:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$4BC6                           ; jsr $004BC6
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FFAC                                 ; bsr.w $03B36A
    lea     $14(a7), a7
    tst.w   d0
    beq.b   l_3b3cc
    moveq   #$1,d0
    bra.b   l_3b3d4
l_3b3cc:
    subq.w  #$1, d2
    tst.w   d2
    bge.b   l_3b3a4
    moveq   #$0,d0
l_3b3d4:
    movem.l (a7)+, d2-d5/a2
    rts

; ============================================================================
; func_03B3DA -- (TODO: name)
; 78 bytes | $03B3DA-$03B427
; ============================================================================
func_03B3DA:
    movem.l d2-d5/a2, -(a7)
    move.l  $24(a7), d3
    move.l  $20(a7), d4
    move.l  $1c(a7), d5
    movea.l $18(a7), a2
    clr.w   d2
l_3b3f0:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$4BC6                           ; jsr $004BC6
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FF60                                 ; bsr.w $03B36A
    lea     $14(a7), a7
    tst.w   d0
    beq.b   l_3b418
    moveq   #$1,d0
    bra.b   l_3b422
l_3b418:
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    blt.b   l_3b3f0
    moveq   #$0,d0
l_3b422:
    movem.l (a7)+, d2-d5/a2
    rts

; ============================================================================
; GameSetup1 -- (TODO: name)
; 1222 bytes | $03B428-$03B8ED
; ============================================================================
GameSetup1:
    link    a6,#$0
    movem.l d2/a2-a5, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$00076CFE,a3
    movea.l  #$00004B6C,a4
    movea.l a3, a5
    moveq   #$34,d0
    adda.l  d0, a5
    tst.w   $a(a6)
    beq.w   l_3b74c
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($000472CE).l
    jsr     (a4)
    dc.w    $4EB9,$0000,$53BA                           ; jsr $0053BA
    pea     ($000D).w
    jsr     (a2)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$FE2C                                 ; bsr.w $03B29C
    lea     $18(a7), a7
    dc.w    $6100,$FEC8                                 ; bsr.w $03B340
    moveq   #$0,d0
    move.w  ($000737F8).l, d0
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($000C).w
    jsr     (a2)
    pea     ($0002).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  ($00076CFE).l, -(a7)
    dc.w    $4EB9,$0000,$4D04                           ; jsr $004D04
    lea     $30(a7), a7
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    moveq   #$1,d2
l_3b4ea:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00048D18,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0005).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a2)
    lea     $30(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    bcs.b   l_3b4ea
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    moveq   #$6,d2
l_3b55e:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$9, d2
    bcs.b   l_3b55e
    moveq   #$9,d2
l_3b58a:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    subq.w  #$1, d2
    cmpi.w  #$5, d2
    bhi.b   l_3b58a
    moveq   #$4,d2
l_3b5b6:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    subq.w  #$1, d2
    tst.w   d2
    bne.b   l_3b5b6
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    moveq   #$A,d2
l_3b60c:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$e, d2
    bcs.b   l_3b60c
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr     (a4)
    pea     ($0007386A).l
    pea     ($0002).w
    pea     ($000E).w
    pea     ($0011).w
    pea     ($0009).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0078).w
    pea     ($000E).w
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    dc.w    $4EB9,$0000,$4CB6                           ; jsr $004CB6
    dc.w    $4EB9,$0000,$53BA                           ; jsr $0053BA
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr     (a4)
    lea     $1c(a7), a7
    pea     ($000737FA).l
    pea     ($0002).w
    pea     ($001C).w
    pea     ($000F).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0078).w
    dc.w    $6100,$FCB4                                 ; bsr.w $03B36A
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    dc.w    $6100,$FCC8                                 ; bsr.w $03B38E
    lea     $30(a7), a7
    dc.w    $4EB9,$0000,$53BA                           ; jsr $0053BA
    pea     ($000738A2).l
    pea     ($0003).w
    pea     ($0008).w
    pea     ($000B).w
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($000738D2).l
    pea     ($0003).w
    pea     ($0014).w
    pea     ($000E).w
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    dc.w    $6100,$FCBA                                 ; bsr.w $03B3DA
    pea     ($00B4).w
    dc.w    $6100,$FC42                                 ; bsr.w $03B36A
    lea     $30(a7), a7
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    dc.w    $6100,$FC52                                 ; bsr.w $03B38E
    lea     $10(a7), a7
    dc.w    $4EB9,$0000,$53BA                           ; jsr $0053BA
    bra.w   l_3b8e4
l_3b74c:
    clr.l   -(a7)
    pea     ($0015).w
    jsr     (a2)
    addq.l  #$8, a7
    dc.w    $4EB9,$0001,$D310                           ; jsr $01D310
    tst.l   d0
    beq.b   l_3b76a
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D340                           ; jsr $01D340
    addq.l  #$4, a7
l_3b76a:
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$FB2C                                 ; bsr.w $03B29C
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($000472CE).l
    jsr     (a4)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    lea     $20(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    pea     ($000D).w
    jsr     (a2)
    lea     $20(a7), a7
    dc.w    $6100,$FB6A                                 ; bsr.w $03B340
    moveq   #$0,d0
    move.w  ($000737F8).l, d0
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($000C).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    dc.w    $6100,$FBAC                                 ; bsr.w $03B3DA
    lea     $30(a7), a7
    pea     ($0014).w
    dc.w    $6100,$FB30                                 ; bsr.w $03B36A
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($001E).w
    dc.w    $6100,$FB0A                                 ; bsr.w $03B36A
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr     (a4)
    lea     $30(a7), a7
    pea     ($0034).w
    dc.w    $6100,$FAF4                                 ; bsr.w $03B36A
    pea     ($0007394A).l
    pea     ($0003).w
    pea     ($0016).w
    pea     ($0011).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $20(a7), a7
    clr.w   d2
l_3b89c:
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.l   d0
    bne.b   l_3b8bc
    pea     ($0001).w
    dc.w    $6100,$FABA                                 ; bsr.w $03B36A
    addq.l  #$4, a7
    addq.w  #$1, d2
    cmpi.w  #$1f4, d2
    bcs.b   l_3b89c
l_3b8bc:
    dc.w    $4EB9,$0001,$D310                           ; jsr $01D310
    tst.l   d0
    bne.b   l_3b8bc
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    dc.w    $6100,$FABA                                 ; bsr.w $03B38E
    dc.w    $4EB9,$0000,$53BA                           ; jsr $0053BA
    pea     ($001E).w
    jsr     (a2)
l_3b8e2:
    bra.b   l_3b8e2
l_3b8e4:
    movem.l -$14(a6), d2/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03B8EE -- (TODO: name)
; 82 bytes | $03B8EE-$03B93F
; ============================================================================
func_03B8EE:
    movem.l d2-d4, -(a7)
    move.l  $14(a7), d2
    move.l  $1c(a7), d3
    move.w  d2, d0
    or.w    d3, d0
    bne.b   l_3b904
    moveq   #$0,d0
    bra.b   l_3b93a
l_3b904:
    moveq   #$0,d0
    move.w  $1a(a7), d0
    moveq   #$0,d1
    move.w  d3, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $16(a7), d0
    moveq   #$0,d1
    move.w  d2, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    add.l   (a7)+, d0
    moveq   #$0,d1
    move.w  d2, d1
    moveq   #$0,d4
    move.w  d3, d4
    add.l   d4, d1
    dc.w    $4EB9,$0003,$E0C6                           ; jsr $03E0C6
    move.w  d0, d2
l_3b93a:
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; func_03B940 -- (TODO: name)
; 84 bytes | $03B940-$03B993
; ============================================================================
func_03B940:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    bra.b   l_3b984
l_3b954:
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    move.w  d0, d3
    andi.w  #$80, d0
    beq.b   l_3b972
    move.w  #$1, ($00FFA78E).l
    moveq   #$1,d0
    bra.b   l_3b98e
l_3b972:
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
    subq.w  #$1, d2
l_3b984:
    tst.w   d2
    bne.b   l_3b954
    move.w  ($00FFA78E).l, d0
l_3b98e:
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; func_03B994 -- (TODO: name)
; 64 bytes | $03B994-$03B9D3
; ============================================================================
func_03B994:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    bra.b   l_3b9c6
l_3b99c:
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    andi.w  #$80, d0
    beq.b   l_3b9b2
    move.w  #$1, ($00FFA78E).l
l_3b9b2:
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $c(a7), a7
    subq.w  #$1, d2
l_3b9c6:
    tst.w   d2
    bne.b   l_3b99c
    move.w  ($00FFA78E).l, d0
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_03B9D4 -- (TODO: name)
; 360 bytes | $03B9D4-$03BB3B
; ============================================================================
func_03B9D4:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a4
    lea     -$6(a6), a5
    moveq   #$0,d0
    move.w  $16(a6), d0
    add.l   d0, d0
    move.l  d0, -(a7)
    pea     -$86(a6)
    move.l  $8(a6), -(a7)
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    lea     $c(a7), a7
    clr.w   -$4(a6)
l_3ba04:
    moveq   #$7,d0
    sub.w   -$4(a6), d0
    move.w  d0, -$2(a6)
    clr.w   d5
    move.w  d5, d0
    add.w   d0, d0
    lea     -$86(a6), a0
    lea     (a0,d0.w), a1
    movea.l a1, a2
    moveq   #$0,d0
    move.w  d5, d0
    add.l   d0, d0
    lea     (a4,d0.l), a0
    movea.l a0, a3
    bra.w   l_3baec
l_3ba2e:
    move.w  (a3), d0
    andi.l  #$e00, d0
    moveq   #$9,d1
    asr.l   d1, d0
    move.w  d0, (a5)
    move.w  (a3), d7
    andi.l  #$e0, d7
    asr.l   #$5, d7
    move.w  (a3), d6
    andi.l  #$e, d6
    asr.l   #$1, d6
    move.w  (a2), d4
    andi.l  #$e00, d4
    moveq   #$9,d0
    asr.l   d0, d4
    move.w  (a2), d3
    andi.l  #$e0, d3
    asr.l   #$5, d3
    move.w  (a2), d2
    andi.l  #$e, d2
    asr.l   #$1, d2
    cmp.w   (a5), d4
    bls.b   l_3ba78
    subq.w  #$1, d4
    bra.b   l_3ba92
l_3ba78:
    cmp.w   (a5), d4
    bcc.b   l_3ba92
    move.w  -$2(a6), d0
    cmp.w   (a5), d0
    bcc.b   l_3ba8c
    moveq   #$0,d0
    move.w  d4, d0
    addq.l  #$1, d0
    bra.b   l_3ba90
l_3ba8c:
    moveq   #$0,d0
    move.w  d4, d0
l_3ba90:
    move.w  d0, d4
l_3ba92:
    cmp.w   d7, d3
    bls.b   l_3ba9a
    subq.w  #$1, d3
    bra.b   l_3bab2
l_3ba9a:
    cmp.w   d7, d3
    bcc.b   l_3bab2
    cmp.w   -$2(a6), d7
    bls.b   l_3baac
    moveq   #$0,d0
    move.w  d3, d0
    addq.l  #$1, d0
    bra.b   l_3bab0
l_3baac:
    moveq   #$0,d0
    move.w  d3, d0
l_3bab0:
    move.w  d0, d3
l_3bab2:
    cmp.w   d6, d2
    bls.b   l_3baba
    subq.w  #$1, d2
    bra.b   l_3bad2
l_3baba:
    cmp.w   d6, d2
    bcc.b   l_3bad2
    cmp.w   -$2(a6), d6
    bls.b   l_3bacc
    moveq   #$0,d0
    move.w  d2, d0
    addq.l  #$1, d0
    bra.b   l_3bad0
l_3bacc:
    moveq   #$0,d0
    move.w  d2, d0
l_3bad0:
    move.w  d0, d2
l_3bad2:
    move.w  d4, d0
    moveq   #$9,d1
    lsl.w   d1, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.w   d1, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    move.w  d0, (a2)
    addq.l  #$2, a3
    addq.l  #$2, a2
    addq.w  #$1, d5
l_3baec:
    cmp.w   $16(a6), d5
    bcs.w   l_3ba2e
    moveq   #$0,d0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    pea     -$86(a6)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    lea     $c(a7), a7
    tst.w   $1a(a6)
    beq.b   l_3bb24
    move.w  $1a(a6), d0
    move.l  d0, -(a7)
    dc.w    $6100,$FE74                                 ; bsr.w $03B994
    addq.l  #$4, a7
l_3bb24:
    addq.w  #$1, -$4(a6)
    cmpi.w  #$8, -$4(a6)
    bcs.w   l_3ba04
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03BB3C -- (TODO: name)
; 250 bytes | $03BB3C-$03BC35
; ============================================================================
func_03BB3C:
    link    a6,#-$4
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $10(a6), d3
    lea     -$4(a6), a2
    movea.l  #$00FFA786,a3
    movea.l  #$00FFA788,a4
    movea.l  #$00FFA782,a5
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  ($00FFA77E).l, d1
    lsl.l   #$3, d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  ($00FFA77C).l, d1
    lsl.l   #$3, d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    move.w  d0, d3
    moveq   #$0,d0
    move.w  $a(a6), d0
    beq.b   l_3bb9e
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   l_3bba4
    bra.b   l_3bbae
l_3bb9e:
    move.w  d2, (a4)
    move.w  d3, (a3)
    bra.b   l_3bbbe
l_3bba4:
    move.w  d2, ($00FFA784).l
    move.w  d3, (a5)
    bra.b   l_3bbbe
l_3bbae:
    move.w  d2, d0
    move.w  d0, ($00FFA784).l
    move.w  d0, (a4)
    move.w  d3, d0
    move.w  d0, (a5)
    move.w  d0, (a3)
l_3bbbe:
    move.w  (a3), -$4(a6)
    move.w  ($00FFA780).l, d0
    add.w   (a5), d0
    move.w  d0, $2(a2)
    pea     ($0002).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $18(a7), a7
    moveq   #$0,d0
    move.w  ($00FFA77E).l, d0
    lsl.l   #$3, d0
    move.l  d0, d2
    sub.w   (a4), d0
    move.w  d0, -$4(a6)
    move.w  d2, d0
    sub.w   ($00FFA784).l, d0
    move.w  d0, $2(a2)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  ($00FFA78A).l, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    movem.l -$1c(a6), d2-d3/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03BC36 -- (TODO: name)
; 232 bytes | $03BC36-$03BD1D
; ============================================================================
func_03BC36:
    move.l  d2, -(a7)
    dc.w    $4EB9,$0003,$A7A0                           ; jsr $03A7A0
    dc.w    $4EB9,$0003,$A8D6                           ; jsr $03A8D6
    dc.w    $4EB9,$0000,$5060                           ; jsr $005060
    move.w  #$1, ($00FFA7DC).l
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    pea     ($001A).w
    pea     ($001D).w
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    clr.w   ($00FF1800).l
    moveq   #$1,d0
    move.w  d0, ($00FFA77A).l
    move.w  d0, ($00FF99DE).l
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $24(a7), a7
    clr.w   d2
l_3bca2:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00048DB0,a0
    move.l  (a0,d0.w), -(a7)
    dc.w    $4EB9,$0003,$ACDC                           ; jsr $03ACDC
    addq.l  #$4, a7
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$6,d1
    cmp.w   d1, d0
    beq.b   l_3bcce
    moveq   #$D,d1
    cmp.w   d1, d0
    beq.b   l_3bcce
    moveq   #$13,d1
    cmp.w   d1, d0
    bne.b   l_3bd12
l_3bcce:
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($00F0).w
    dc.w    $6100,$FCBA                                 ; bsr.w $03B994
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    move.l  #$8000, -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $28(a7), a7
l_3bd12:
    addq.w  #$1, d2
    cmpi.w  #$14, d2
    bcs.b   l_3bca2
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_03BD1E -- (TODO: name)
; 52 bytes | $03BD1E-$03BD51
; ============================================================================
func_03BD1E:
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    pea     ($0003).w
    pea     ($0002).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$634A                           ; jsr $00634A
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$ffff, -(a7)
    dc.w    $6100,$FDF8                                 ; bsr.w $03BB3C
    lea     $20(a7), a7
    dc.w    $4EB9,$0000,$53BA                           ; jsr $0053BA
    rts

; ============================================================================
; func_03BD52 -- (TODO: name)
; 1064 bytes | $03BD52-$03C179
; ============================================================================
func_03BD52:
    link    a6,#-$80
    movem.l d2-d4/a2-a5, -(a7)
    movea.l  #$00000D64,a3
    lea     -$80(a6), a4
    movea.l  #$0003BD1E,a5
    pea     ($0010).w
    clr.l   -(a7)
    move.l  ($00077016).l, -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    pea     ($0010).w
    pea     ($0010).w
    move.l  ($0007702E).l, -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    pea     ($0010).w
    pea     ($0020).w
    move.l  ($00077046).l, -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076EF6).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    lea     $30(a7), a7
    move.l  ($000B7530).l, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($037F).w
    pea     ($0001).w
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    move.l  ($000B7534).l, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($003C).w
    pea     ($03C0).w
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    move.l  ($000B7538).l, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $30(a7), a7
    pea     ($0078).w
    pea     ($0400).w
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    pea     ($000739CE).l
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $28(a7), a7
    pea     ($000740CE).l
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D3AC                           ; jsr $01D3AC
    lea     $24(a7), a7
    pea     ($0003).w
    pea     ($0002).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    dc.w    $4EB9,$0000,$634A                           ; jsr $00634A
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($0040).w
    dc.w    $6100,$FAA4                                 ; bsr.w $03B940
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_3beac
l_3bea6:
    jsr     (a5)
    bra.w   l_3c170
l_3beac:
    clr.w   d2
l_3beae:
    pea     ($0068).w
    pea     ($0068).w
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$000747CE,a0
    pea     (a0, d0.w)
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a3)
    lea     $18(a7), a7
    clr.w   d3
l_3bed6:
    pea     ($0010).w
    pea     ($0020).w
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$2,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    lsl.l   #$2, d0
    movea.l  #$00077046,a0
    move.l  (a0,d0.l), -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    pea     ($0020).w
    dc.w    $6100,$FA3E                                 ; bsr.w $03B940
    lea     $10(a7), a7
    tst.w   d0
    bne.b   l_3bea6
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_3bed6
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   l_3beae
    clr.w   d2
l_3bf1e:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$8,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    tst.l   d0
    bne.b   l_3bf5e
    pea     ($0010).w
    pea     ($0020).w
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_3bf3e
    addq.l  #$7, d0
l_3bf3e:
    asr.l   #$3, d0
    moveq   #$2,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    lsl.l   #$2, d0
    movea.l  #$00077046,a0
    move.l  (a0,d0.l), -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    lea     $c(a7), a7
l_3bf5e:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$68,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0068).w
    pea     ($0007480E).l
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a3)
    pea     ($0004).w
    dc.w    $6100,$F9BC                                 ; bsr.w $03B940
    lea     $1c(a7), a7
    tst.w   d0
    bne.w   l_3bea6
    addq.w  #$1, d2
    cmpi.w  #$68, d2
    bcs.b   l_3bf1e
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $c(a7), a7
    clr.w   d2
    movea.l a4, a2
    moveq   #$40,d0
    adda.l  d0, a2
l_3bfb0:
    pea     ($0020).w
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$00077016,a0
    move.l  (a0,d0.l), -(a7)
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    pea     ($0020).w
    move.l  a4, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$0007702E,a0
    move.l  (a0,d0.l), -(a7)
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    pea     ($0020).w
    move.l  a2, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$0007701A,a0
    move.l  (a0,d0.l), -(a7)
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    pea     ($0020).w
    move.l  a4, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$00077032,a0
    move.l  (a0,d0.l), -(a7)
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    lea     $30(a7), a7
    pea     ($0006).w
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    move.l  a4, -(a7)
    dc.w    $6100,$F994                                 ; bsr.w $03B9D4
    pea     ($0020).w
    dc.w    $6100,$F8F8                                 ; bsr.w $03B940
    lea     $18(a7), a7
    tst.w   d0
    bne.w   l_3bea6
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.w   l_3bfb0
    pea     ($0040).w
    dc.w    $6100,$F8DC                                 ; bsr.w $03B940
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_3bea6
    clr.w   d2
l_3c070:
    move.w  d2, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  #$10f, d0
    sub.w   d2, d0
    move.l  d0, -(a7)
    pea     ($0130).w
    dc.w    $6100,$F86A                                 ; bsr.w $03B8EE
    move.w  d0, d3
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  #$10f, d0
    sub.w   d2, d0
    move.l  d0, -(a7)
    move.w  #$10f, d0
    sub.w   d2, d0
    move.l  d0, -(a7)
    pea     ($0110).w
    dc.w    $6100,$F84C                                 ; bsr.w $03B8EE
    lea     $20(a7), a7
    move.w  d0, d4
    ext.l   d0
    subi.l  #$30, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    subi.l  #$30, d0
    move.l  d0, -(a7)
    pea     ($0007481E).l
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a3)
    pea     ($0001).w
    dc.w    $6100,$F868                                 ; bsr.w $03B940
    lea     $1c(a7), a7
    tst.w   d0
    bne.w   l_3bea6
    addq.w  #$1, d2
    cmpi.w  #$110, d2
    bcs.b   l_3c070
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    pea     ($0080).w
    move.l  a4, -(a7)
    pea     ($00FF14BC).l
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    pea     ($0006).w
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00048D30).l
    move.l  a4, -(a7)
    dc.w    $6100,$F8B6                                 ; bsr.w $03B9D4
    lea     $2c(a7), a7
    pea     ($0003).w
    pea     ($0002).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$634A                           ; jsr $00634A
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$ffff, -(a7)
    dc.w    $6100,$F9F8                                 ; bsr.w $03BB3C
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
l_3c170:
    movem.l -$9c(a6), d2-d4/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03C17A -- (TODO: name)
; 62 bytes | $03C17A-$03C1B7
; ============================================================================
func_03C17A:
    clr.l   -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0023).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$ffff, -(a7)
    dc.w    $6100,$F992                                 ; bsr.w $03BB3C
    lea     $28(a7), a7
    dc.w    $4EB9,$0000,$53BA                           ; jsr $0053BA
    rts

; ============================================================================
; func_03C1B8 -- (TODO: name)
; 1252 bytes | $03C1B8-$03C69B
; ============================================================================
func_03C1B8:
    link    a6,#-$80
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$00000D64,a2
    lea     -$80(a6), a3
    movea.l  #$00FF1804,a4
    movea.l  #$000045B2,a5
    move.l  ($000B753C).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($00BF).w
    pea     ($0001).w
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    move.l  ($000B7540).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $1c(a7), a7
    clr.w   d2
l_3c208:
    moveq   #$0,d3
    move.w  d2, d3
    addi.l  #$80, d3
    cmpi.l  #$2e0, d3
    bge.b   l_3c222
    move.l  #$80, d3
    bra.b   l_3c22e
l_3c222:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  #$2e0, d3
    sub.l   d0, d3
l_3c22e:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$c0, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$5, d0
    pea     (a4, d0.l)
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addi.w  #$80, d2
    cmpi.w  #$2e0, d2
    bcs.b   l_3c208
    move.l  ($000B7544).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    addq.l  #$8, a7
    clr.w   d2
l_3c27a:
    moveq   #$0,d3
    move.w  d2, d3
    addi.l  #$80, d3
    cmpi.l  #$200, d3
    bge.b   l_3c294
    move.l  #$80, d3
    bra.b   l_3c2a0
l_3c294:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  #$200, d3
    sub.l   d0, d3
l_3c2a0:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$400, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$5, d0
    pea     (a4, d0.l)
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addi.w  #$80, d2
    cmpi.w  #$200, d2
    bcs.b   l_3c27a
    pea     ($0007486E).l
    pea     ($000A).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    pea     ($00074AEE).l
    pea     ($0012).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    pea     ($0080).w
    pea     ($0080).w
    pea     ($0007586E).l
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    pea     ($0100).w
    pea     ($0080).w
    pea     ($0007596E).l
    pea     ($0020).w
    pea     ($0020).w
    pea     ($000F).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0020).w
    move.l  a3, -(a7)
    pea     ($00076F16).l
    jsr     (a5)
    lea     $2c(a7), a7
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076F36).l
    jsr     (a5)
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$40,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076F96).l
    jsr     (a5)
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076F76).l
    jsr     (a5)
    lea     $24(a7), a7
    pea     ($0006).w
    pea     ($0040).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($00048D30).l
    dc.w    $6100,$F5F0                                 ; bsr.w $03B9D4
    pea     ($0020).w
    move.l  a3, -(a7)
    pea     ($00076F36).l
    jsr     (a5)
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076F56).l
    jsr     (a5)
    lea     $2c(a7), a7
    move.l  a3, -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0001).w
    pea     ($0023).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.w   d2
l_3c42e:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  #$80, d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0080).w
    pea     ($0007586E).l
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a2)
    pea     ($0002).w
    dc.w    $6100,$F4E8                                 ; bsr.w $03B940
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   l_3c46a
l_3c462:
    dc.w    $6100,$FD16                                 ; bsr.w $03C17A
    bra.w   l_3c692
l_3c46a:
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$100, d0
    move.l  d0, -(a7)
    pea     ($0080).w
    pea     ($0007596E).l
    pea     ($0020).w
    pea     ($0020).w
    pea     ($000F).w
    jsr     (a2)
    pea     ($0002).w
    dc.w    $6100,$F4AC                                 ; bsr.w $03B940
    lea     $1c(a7), a7
    tst.w   d0
    bne.b   l_3c462
    addq.w  #$1, d2
    cmpi.w  #$80, d2
    bcs.b   l_3c42e
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $28(a7), a7
    pea     ($0100).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$F662                                 ; bsr.w $03BB3C
    move.l  ($000B7548).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($0120).w
    pea     ($0400).w
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    lea     $20(a7), a7
    pea     ($00075A6E).l
    pea     ($0010).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$D444                           ; jsr $01D444
    lea     $20(a7), a7
    clr.w   d2
    move.w  #$80, d3
    bra.b   l_3c5aa
l_3c52e:
    move.w  d3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$F604                                 ; bsr.w $03BB3C
    lea     $c(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    cmpi.w  #$150, d0
    beq.b   l_3c550
    cmpi.w  #$1a8, d0
    beq.b   l_3c558
    bra.b   l_3c57a
l_3c550:
    pea     ($000753EE).l
    bra.b   l_3c55e
l_3c558:
    pea     ($00074F6E).l
l_3c55e:
    pea     ($0012).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
l_3c57a:
    pea     ($0002).w
    dc.w    $6100,$F3C0                                 ; bsr.w $03B940
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_3c594
l_3c588:
    pea     ($0018).w
    jsr     (a2)
    addq.l  #$4, a7
    bra.w   l_3c462
l_3c594:
    tst.w   d3
    beq.b   l_3c5a0
    moveq   #$0,d0
    move.w  d3, d0
    subq.l  #$1, d0
    bra.b   l_3c5a6
l_3c5a0:
    move.l  #$200, d0
l_3c5a6:
    move.w  d0, d3
    addq.w  #$1, d2
l_3c5aa:
    cmpi.w  #$180, d2
    bcs.w   l_3c52e
    pea     ($0018).w
    jsr     (a2)
    pea     ($0013).w
    dc.w    $4EB9,$0001,$D444                           ; jsr $01D444
    move.l  #$8000, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $24(a7), a7
    move.w  #$100, d3
l_3c5e4:
    move.w  d3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$F54E                                 ; bsr.w $03BB3C
    lea     $c(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    cmpi.w  #$1b8, d0
    beq.b   l_3c60c
    cmpi.w  #$160, d0
    beq.b   l_3c614
    cmpi.w  #$108, d0
    beq.b   l_3c61c
    bra.b   l_3c63e
l_3c60c:
    pea     ($00075F2E).l
    bra.b   l_3c622
l_3c614:
    pea     ($00075ECE).l
    bra.b   l_3c622
l_3c61c:
    pea     ($00075E6E).l
l_3c622:
    pea     ($0004).w
    pea     ($000C).w
    pea     ($000C).w
    pea     ($0009).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
l_3c63e:
    pea     ($0001).w
    dc.w    $6100,$F2FC                                 ; bsr.w $03B940
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_3c588
    addq.w  #$1, d3
    cmpi.w  #$200, d3
    bcs.b   l_3c5e4
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$F4DE                                 ; bsr.w $03BB3C
    pea     ($0018).w
    jsr     (a2)
    pea     ($0040).w
    dc.w    $6100,$F2D4                                 ; bsr.w $03B940
    lea     $14(a7), a7
    tst.w   d0
    bne.w   l_3c462
    move.l  #$8000, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
l_3c692:
    movem.l -$98(a6), d2-d3/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03C69C -- (TODO: name)
; 678 bytes | $03C69C-$03C941
; ============================================================================
func_03C69C:
    link    a6,#-$C0
    movem.l d2-d3/a2-a5, -(a7)
    lea     -$c0(a6), a2
    movea.l  #$000045B2,a3
    movea.l  #$00000D64,a4
    movea.l  #$0003B994,a5
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00076FB6).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.l  ($000B754C).l, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($01A0).w
    pea     ($0400).w
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0023).w
    jsr     (a4)
    pea     ($0020).w
    move.l  a2, -(a7)
    pea     ($00076F16).l
    jsr     (a3)
    lea     $28(a7), a7
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076F36).l
    jsr     (a3)
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$40,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076FB6).l
    jsr     (a3)
    pea     ($0040).w
    move.l  a2, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00048D30).l
    jsr     (a3)
    pea     ($0020).w
    move.l  a2, d0
    addi.l  #$a0, d0
    move.l  d0, -(a7)
    pea     ($00076FD6).l
    jsr     (a3)
    lea     $30(a7), a7
    pea     ($0003).w
    pea     ($0030).w
    clr.l   -(a7)
    move.l  a2, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $6100,$F244                                 ; bsr.w $03B9D4
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $30(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4EB9,$0000,$5518                           ; jsr $005518
    clr.l   -(a7)
    pea     ($0100).w
    clr.l   -(a7)
    dc.w    $6100,$F358                                 ; bsr.w $03BB3C
    lea     $30(a7), a7
    pea     ($000760A6).l
    pea     ($0008).w
    pea     ($001A).w
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($0001).w
    jsr     (a5)
    lea     $20(a7), a7
    pea     ($00076246).l
    pea     ($0006).w
    pea     ($001A).w
    pea     ($0009).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0001).w
    jsr     (a5)
    lea     $20(a7), a7
    pea     ($00075F8E).l
    pea     ($0004).w
    pea     ($001B).w
    pea     ($000F).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($0020).w
    move.l  a2, -(a7)
    pea     ($0007651E).l
    jsr     (a3)
    lea     $28(a7), a7
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0007651E).l
    jsr     (a3)
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$40,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076FF6).l
    jsr     (a3)
    pea     ($0003).w
    pea     ($0030).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    move.l  a2, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F128                                 ; bsr.w $03B9D4
    pea     ($0020).w
    jsr     (a5)
    lea     $30(a7), a7
    moveq   #$10,d2
l_3c8ba:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    tst.l   d0
    beq.b   l_3c8d6
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_3c8d2
    addq.l  #$1, d0
l_3c8d2:
    asr.l   #$1, d0
    bra.b   l_3c8ea
l_3c8d6:
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_3c8de
    addq.l  #$1, d0
l_3c8de:
    asr.l   #$1, d0
    move.l  #$200, d1
    sub.l   d0, d1
    move.l  d1, d0
l_3c8ea:
    move.w  d0, d3
    clr.l   -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    dc.w    $6100,$F246                                 ; bsr.w $03BB3C
    pea     ($0001).w
    jsr     (a5)
    lea     $10(a7), a7
    subq.w  #$1, d2
    tst.w   d2
    bne.b   l_3c8ba
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$F22C                                 ; bsr.w $03BB3C
    pea     ($0080).w
    jsr     (a5)
    pea     ($00076066).l
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0014).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    movem.l -$d8(a6), d2-d3/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03C942 -- (TODO: name)
; 268 bytes | $03C942-$03CA4D
; ============================================================================
func_03C942:
    movem.l a2-a3, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$0003B994,a3
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00076FF6).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.l  ($000B754C).l, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($01A0).w
    pea     ($0400).w
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    lea     $2c(a7), a7
    pea     ($000760A6).l
    pea     ($0008).w
    pea     ($001A).w
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    jsr     (a3)
    lea     $20(a7), a7
    pea     ($00076246).l
    pea     ($0006).w
    pea     ($001A).w
    pea     ($0009).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    jsr     (a3)
    lea     $20(a7), a7
    pea     ($00075F8E).l
    pea     ($0004).w
    pea     ($001B).w
    pea     ($000F).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($0080).w
    jsr     (a3)
    lea     $20(a7), a7
    pea     ($00076066).l
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0014).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    movem.l (a7)+, a2-a3
    rts

; ============================================================================
; GameSetup2 -- (TODO: name)
; 232 bytes | $03CA4E-$03CB35
; ============================================================================
GameSetup2:
    movem.l d2/a2-a4, -(a7)
    movea.l  #$00FFA78E,a2
    movea.l  #$0001E1EC,a3
    movea.l  #$000053BA,a4
    clr.w   (a2)
    moveq   #$1,d2
l_3ca68:
    pea     ($0001).w
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$5518                           ; jsr $005518
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$ffff, -(a7)
    dc.w    $6100,$F0BC                                 ; bsr.w $03BB3C
    lea     $14(a7), a7
    jsr     (a4)
    dc.w    $6100,$F1AC                                 ; bsr.w $03BC36
    tst.w   (a2)
    beq.b   l_3ca9e
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D3AC                           ; jsr $01D3AC
    addq.l  #$8, a7
    bra.b   l_3cab0
l_3ca9e:
    dc.w    $6100,$F2B2                                 ; bsr.w $03BD52
    tst.w   (a2)
    bne.b   l_3cab0
    dc.w    $6100,$F710                                 ; bsr.w $03C1B8
    clr.w   d2
    tst.w   d2
    bne.b   l_3ca68
l_3cab0:
    tst.w   (a2)
    bne.b   l_3caba
    dc.w    $6100,$FBE6                                 ; bsr.w $03C69C
    bra.b   l_3cabe
l_3caba:
    dc.w    $6100,$FE86                                 ; bsr.w $03C942
l_3cabe:
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$4, a7
    andi.w  #$80, d0
    bne.b   l_3cabe
    bra.b   l_3cb02
l_3cacc:
    dc.w    $4EB9,$0001,$D310                           ; jsr $01D310
    tst.w   d0
    bne.b   l_3caf2
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D340                           ; jsr $01D340
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    jsr     (a4)
    pea     ($001E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
l_3caf2:
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
l_3cb02:
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$4, a7
    move.w  d0, d2
    andi.w  #$80, d0
    beq.b   l_3cacc
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D340                           ; jsr $01D340
    jsr     (a4)
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$5518                           ; jsr $005518
    lea     $c(a7), a7
    movem.l (a7)+, d2/a2-a4
    rts

; ============================================================================
; ShowPlayerScreen -- (TODO: describe)
; Called: ?? times.
; 182 bytes | $03CB36-$03CBEB
; ============================================================================
ShowPlayerScreen:                                                  ; $03CB36
    movem.l d2/a2-a3,-(sp)
    move.l  $0010(sp),d2
    movea.l #$0001d3ac,a3
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    move.w  #$1,($00FF000C).l
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d340                           ; jsr $01D340
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d37a                           ; jsr $01D37A
    addq.l  #$8,sp
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    cmpi.w  #$4,d2
    blt.b   .l3cb98
    clr.l   -(sp)
    pea     ($0014).w
    jsr     (a3)
    addq.l  #$8,sp
    dc.w    $4eba,$133c                                 ; jsr $03DECE
    nop
    bra.b   .l3cbdc
.l3cb98:                                                ; $03CB98
    cmpi.b  #$01,(a2)
    bne.b   .l3cbc6
    dc.w    $4eba,$004c                                 ; jsr $03CBEC
    nop
    clr.l   -(sp)
    pea     ($0015).w
    jsr     (a3)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$01fa                                 ; jsr $03CDAC
    nop
    lea     $000c(sp),sp
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0894                                 ; jsr $03D454
    nop
    bra.b   .l3cbda
.l3cbc6:                                                ; $03CBC6
    clr.l   -(sp)
    pea     ($0013).w
    jsr     (a3)
    addq.l  #$8,sp
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$100e                                 ; jsr $03DBE4
    nop
.l3cbda:                                                ; $03CBDA
    addq.l  #$4,sp
.l3cbdc:                                                ; $03CBDC
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$b428                           ; jsr $03B428
    addq.l  #$4,sp
    movem.l (sp)+,d2/a2-a3
    rts
; === Translated block $03CBEC-$03E05A ===
; 12 functions, 5230 bytes

; ============================================================================
; func_03CBEC -- (TODO: name)
; 448 bytes | $03CBEC-$03CDAB
; ============================================================================
func_03CBEC:
    movem.l a2-a4, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$00FF1804,a3
    movea.l  #$00003FEC,a4
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    pea     ($0010).w
    pea     ($0013).w
    jsr     (a2)
    move.l  #$9010, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    pea     ($0001).w
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$5518                           ; jsr $005518
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$0492                                 ; jsr $03D0C0(pc)
    nop
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    pea     ($000543E2).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    move.l  a3, -(a7)
    pea     ($12F0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($00054F82).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($2600).w
    move.l  a3, -(a7)
    pea     ($1470).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($00050006).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($4EE0).w
    move.l  a3, -(a7)
    pea     ($13E0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($0030).w
    pea     ($0010).w
    pea     ($00053482).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    lea     $24(a7), a7
    pea     ($000534E2).l
    pea     ($001E).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($00053C62).l
    pea     ($001E).w
    pea     ($0020).w
    pea     ($001E).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($00064140).l
    pea     ($000E).w
    pea     ($0020).w
    pea     ($002E).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($76A0).w
    pea     ($00055C54).l
    pea     ($06C0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    lea     $18(a7), a7
    movem.l (a7)+, a2-a4
    rts

; ============================================================================
; func_03CDAC -- (TODO: name)
; 292 bytes | $03CDAC-$03CECF
; ============================================================================
func_03CDAC:
    link    a6,#-$4
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $8(a6), d3
    movea.l  #$00000D64,a2
    movea.l  #$0003CED0,a3
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    move.w  #$100, d3
    move.w  #$b0, d2
    bra.b   l_3ce10
l_3cde0:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0005FD36).l
    pea     ($0009).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    subq.w  #$2, d3
    subq.w  #$1, d2
l_3ce10:
    move.w  d3, d0
    ext.l   d0
    moveq   #-$60,d1
    cmp.l   d0, d1
    ble.b   l_3cde0
    pea     ($0009).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0058).w
    pea     ($00F0).w
    pea     ($003C).w
    jsr     (a3)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $28(a7), a7
    pea     ($0060).w
    pea     ($00F0).w
    pea     ($00BC).w
    jsr     (a3)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0040).w
    pea     ($00F0).w
    pea     ($007C).w
    jsr     (a3)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    move.l  #$8b00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    lea     $30(a7), a7
    move.l  #$8c00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    addq.l  #$8, a7
    clr.w   d2
l_3ce98:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$021E                                 ; jsr $03D0C0(pc)
    nop
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $10(a7), a7
    addq.w  #$2, d2
    cmpi.w  #$f0, d2
    ble.b   l_3ce98
    pea     ($00C8).w
    pea     ($000E).w
    jsr     (a2)
    movem.l -$14(a6), d2-d3/a2-a3
    unlk    a6
    rts

; ============================================================================
; func_03CED0 -- (TODO: name)
; 496 bytes | $03CED0-$03D0BF
; ============================================================================
func_03CED0:
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $28(a7), d2
    move.l  $24(a7), d3
    move.l  $20(a7), d4
    movea.l  #$00000D64,a2
    movea.l  #$00FF1804,a3
    movea.l  #$00052162,a4
    movea.l  #$00003FEC,a5
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00052142).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.l  a4, -(a7)
    move.l  a3, -(a7)
    jsr     (a5)
    move.l  a4, d0
    moveq   #$68,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.l  a3, d0
    addi.l  #$360, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.l  a4, d0
    addi.l  #$aa, d0
    move.l  d0, -(a7)
    move.l  a3, d0
    addi.l  #$6c0, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.l  a4, d0
    addi.l  #$f6, d0
    move.l  d0, -(a7)
    move.l  a3, d0
    addi.l  #$a20, d0
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($0014).w
    dc.w    $4EB9,$0001,$D444                           ; jsr $01D444
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($76A0).w
    move.l  a3, -(a7)
    pea     ($01B0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($0018).w
    jsr     (a2)
    pea     ($0015).w
    dc.w    $4EB9,$0001,$D444                           ; jsr $01D444
    lea     $20(a7), a7
    bra.b   l_3cfba
l_3cf8c:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0005FD7E).l
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a2)
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    subq.w  #$6, d3
l_3cfba:
    cmp.w   d2, d3
    bge.b   l_3cf8c
    moveq   #$1,d2
l_3cfc0:
    clr.l   -(a7)
    pea     ($76A0).w
    move.w  d2, d0
    ext.l   d0
    move.l  #$1b0, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    add.l   d0, d0
    pea     (a3, d0.l)
    pea     ($01B0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_3cfc0
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    subi.w  #$14, d4
    subi.w  #$18, d3
    pea     ($0018).w
    jsr     (a2)
    pea     ($0016).w
    dc.w    $4EB9,$0001,$D444                           ; jsr $01D444
    clr.l   -(a7)
    pea     ($76A0).w
    pea     ($00052282).l
    pea     ($0240).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    lea     $2c(a7), a7
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0005FDB6).l
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a2)
    lea     $18(a7), a7
    moveq   #$1,d2
l_3d066:
    clr.l   -(a7)
    pea     ($76A0).w
    move.w  d2, d0
    mulu.w  #$480, d0
    movea.l  #$00052282,a0
    pea     (a0, d0.w)
    pea     ($0240).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_3d066
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    movem.l (a7)+, d2-d4/a2-a5
    rts

; ============================================================================
; func_03D0C0 -- (TODO: name)
; 126 bytes | $03D0C0-$03D13D
; ============================================================================
func_03D0C0:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    move.l  $10(a7), d3
    movea.l  #$00FF5804,a2
    move.w  d3, d0
    or.w    d2, d0
    bne.b   l_3d0ec
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    lea     $c(a7), a7
    bra.b   l_3d0f4
l_3d0ec:
    move.w  d3, $4(a2)
    move.w  d2, $6(a2)
l_3d0f4:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    clr.l   -(a7)
    move.l  a2, d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    clr.l   -(a7)
    move.l  #$fc00, -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $18(a7), a7
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; func_03D13E -- (TODO: name)
; 124 bytes | $03D13E-$03D1B9
; ============================================================================
func_03D13E:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    move.l  $10(a7), d3
    movea.l  #$00FF5804,a2
    move.w  d3, d0
    or.w    d2, d0
    bne.b   l_3d16a
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    lea     $c(a7), a7
    bra.b   l_3d170
l_3d16a:
    move.w  d3, (a2)
    move.w  d2, $2(a2)
l_3d170:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    clr.l   -(a7)
    move.l  a2, d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    clr.l   -(a7)
    move.l  #$fc00, -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $18(a7), a7
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; func_03D1BA -- (TODO: name)
; 190 bytes | $03D1BA-$03D277
; ============================================================================
func_03D1BA:
    link    a6,#-$20
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    lea     -$20(a6), a2
    movea.l  #$00000D64,a3
    tst.w   d3
    ble.w   l_3d26e
    tst.w   d2
    ble.w   l_3d26e
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    pea     ($0010).w
    pea     ($0030).w
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    pea     ($0020).w
    pea     ($2222).w
    move.l  a2, -(a7)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($18C0).w
    move.l  a2, -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    lea     $18(a7), a7
    move.l  #$e0c6, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    move.l  #$e0c6, -(a7)
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0018).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
l_3d26e:
    movem.l -$30(a6), d2-d3/a2-a3
    unlk    a6
    rts

; ============================================================================
; func_03D278 -- (TODO: name)
; 476 bytes | $03D278-$03D453
; ============================================================================
func_03D278:
    movem.l a2-a4, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$00FF1804,a3
    movea.l  #$00003FEC,a4
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    move.l  #$9000, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$5518                           ; jsr $005518
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$FE12                                 ; bsr.w $03D0C0
    pea     ($000635D0).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    move.l  a3, -(a7)
    pea     ($0590).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($00063CF4).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0B40).w
    move.l  a3, -(a7)
    pea     ($00D0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($00063E36).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0CE0).w
    move.l  a3, -(a7)
    pea     ($0340).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    pea     ($00063350).l
    pea     ($000A).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($000638F4).l
    pea     ($0010).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($00063D36).l
    pea     ($0004).w
    pea     ($0020).w
    pea     ($0018).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($4040).w
    pea     ($00059794).l
    pea     ($19D0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($1360).w
    pea     ($0005CBB4).l
    pea     ($06C0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    clr.l   -(a7)
    pea     ($20E0).w
    pea     ($0005D934).l
    pea     ($0480).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($29E0).w
    pea     ($00051522).l
    pea     ($0210).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    clr.l   -(a7)
    pea     ($2E00).w
    pea     ($0006541E).l
    pea     ($0210).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00063330).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    lea     $c(a7), a7
    movem.l (a7)+, a2-a4
    rts

; ============================================================================
; func_03D454 -- (TODO: name)
; 1216 bytes | $03D454-$03D913
; ============================================================================
func_03D454:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00000D64,a4
    movea.l  #$00005092,a5
    dc.w    $6100,$FE0E                                 ; bsr.w $03D278
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00056A94).l
    jsr     (a5)
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($0200).w
    pea     ($00FF1074).l
    clr.l   -(a7)
    pea     ($0005FE24).l
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    lea     $20(a7), a7
    moveq   #-$3C,d6
    move.w  #$ffd8, -$2(a6)
    clr.w   d3
    clr.w   d4
    bra.b   l_3d4f2
l_3d4ae:
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00FF1234).l
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a4)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FC66                                 ; bsr.w $03D13E
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)
    lea     $28(a7), a7
    addq.w  #$1, d3
    addq.w  #$2, d4
    addq.w  #$1, d6
    addq.w  #$1, -$2(a6)
l_3d4f2:
    cmpi.w  #$4c, d6
    blt.b   l_3d4ae
    moveq   #$12,d5
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDD8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDFC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_3d51a:
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDD6,a0
    move.w  (a0,d0.w), d2
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FC0C                                 ; bsr.w $03D13E
    addq.l  #$8, a7
    move.w  d5, d0
    andi.l  #$1, d0
    bne.b   l_3d596
    pea     ($0010).w
    pea     ($0030).w
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$000569D4,a0
    pea     (a0, d0.w)
    jsr     (a5)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    pea     ($000A).w
    bra.b   l_3d5ea
l_3d596:
    pea     ($0010).w
    pea     ($0020).w
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$000569D4,a0
    pea     (a0, d0.w)
    jsr     (a5)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    pea     ($000F).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    clr.l   -(a7)
l_3d5ea:
    pea     ($0010).w
    jsr     (a4)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)
    lea     $14(a7), a7
    subq.l  #$2, a2
    subq.l  #$2, a3
    addq.w  #$1, d3
    addq.w  #$3, d4
    subq.w  #$1, d5
    cmpi.w  #$b, d5
    bge.w   l_3d51a
    clr.w   d2
l_3d612:
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FB22                                 ; bsr.w $03D13E
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d2
    addq.w  #$1, d3
    addq.w  #$3, d4
    cmpi.w  #$30, d2
    blt.b   l_3d612
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0005CB74).l
    jsr     (a5)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0005CB34).l
    jsr     (a5)
    lea     $18(a7), a7
    moveq   #-$50,d2
    moveq   #-$78,d7
    bra.b   l_3d6cc
l_3d660:
    pea     ($0020).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000600B4).l
    pea     ($0003).w
    pea     ($0012).w
    pea     ($000F).w
    jsr     (a4)
    lea     $18(a7), a7
    cmpi.w  #$160, d7
    bge.b   l_3d6aa
    pea     ($00A0).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00060024).l
    pea     ($000C).w
    pea     ($0015).w
    pea     ($000F).w
    jsr     (a4)
    lea     $18(a7), a7
l_3d6aa:
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FA8A                                 ; bsr.w $03D13E
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d2
    addq.w  #$2, d7
    addq.w  #$1, d3
    addq.w  #$3, d4
l_3d6cc:
    cmpi.w  #$114, d2
    blt.b   l_3d660
    pea     ($000F).w
    pea     ($0012).w
    pea     ($0010).w
    jsr     (a4)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0005CB94).l
    jsr     (a5)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0005CB54).l
    jsr     (a5)
    lea     $24(a7), a7
    move.w  #$ff4c, d2
    moveq   #-$3C,d7
    bra.b   l_3d776
l_3d70a:
    pea     ($0020).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00060084).l
    pea     ($0006).w
    pea     ($0015).w
    pea     ($000F).w
    jsr     (a4)
    lea     $18(a7), a7
    cmpi.w  #$160, d7
    bge.b   l_3d754
    pea     ($00A0).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000600CC).l
    pea     ($0003).w
    pea     ($0012).w
    pea     ($000F).w
    jsr     (a4)
    lea     $18(a7), a7
l_3d754:
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F9E0                                 ; bsr.w $03D13E
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d2
    addq.w  #$2, d7
    addq.w  #$1, d3
    addq.w  #$3, d4
l_3d776:
    cmpi.w  #$15e, d2
    blt.b   l_3d70a
    pea     ($0009).w
    pea     ($0012).w
    pea     ($0010).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00056A54).l
    jsr     (a5)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00056A54).l
    jsr     (a5)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($1360).w
    pea     ($00056AB4).l
    pea     ($1970).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a4)
    lea     $18(a7), a7
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDD8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDFC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    bra.w   l_3d8de
l_3d7f0:
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDD6,a0
    move.w  (a0,d0.w), d2
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F936                                 ; bsr.w $03D13E
    addq.l  #$8, a7
    move.w  d5, d0
    andi.l  #$1, d0
    bne.b   l_3d86c
    pea     ($0010).w
    pea     ($0030).w
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$000569D4,a0
    pea     (a0, d0.w)
    jsr     (a5)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    pea     ($000A).w
    bra.b   l_3d8c0
l_3d86c:
    pea     ($0010).w
    pea     ($0020).w
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$000569D4,a0
    pea     (a0, d0.w)
    jsr     (a5)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    pea     ($000F).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    clr.l   -(a7)
l_3d8c0:
    pea     ($0010).w
    jsr     (a4)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)
    lea     $14(a7), a7
    subq.l  #$2, a2
    subq.l  #$2, a3
    addq.w  #$1, d3
    addq.w  #$3, d4
    subq.w  #$1, d5
l_3d8de:
    tst.w   d5
    bge.w   l_3d7f0
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a4)
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0068                                 ; jsr $03D964(pc)
    nop
    pea     ($00C8).w
    pea     ($000E).w
    jsr     (a4)
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03D914 -- (TODO: name)
; 80 bytes | $03D914-$03D963
; ============================================================================
func_03D914:
    movem.l d2/a2, -(a7)
    movea.l  #$00FF159C,a2
    clr.w   d2
l_3d920:
    move.w  #$eee, (a2)+
    addq.w  #$1, d2
    cmpi.w  #$40, d2
    blt.b   l_3d920
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00FF159C).l
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    pea     ($0050).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $24(a7), a7
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; func_03D964 -- (TODO: name)
; 640 bytes | $03D964-$03DBE3
; ============================================================================
func_03D964:
    link    a6,#-$84
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d6
    movea.l  #$00000D64,a3
    movea.l  #$00005092,a4
    movea.l  #$00FF1804,a5
    clr.w   -$82(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$F734                                 ; bsr.w $03D0C0
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    jsr     (a4)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$82(a6)
    jsr     (a4)
    pea     ($0012).w
    pea     ($0020).w
    dc.w    $6100,$F802                                 ; bsr.w $03D1BA
    lea     $28(a7), a7
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00062782).l
    jsr     (a4)
    pea     ($000627A2).l
    pea     ($000C).w
    pea     ($0010).w
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($00062922).l
    move.l  a5, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($0240).w
    move.l  a5, -(a7)
    pea     ($0B40).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    clr.l   -(a7)
    pea     (-$AF).w
    dc.w    $6100,$F6A2                                 ; bsr.w $03D0C0
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a3)
    lea     $28(a7), a7
    move.w  #$ff51, d4
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $10(a7), a7
    clr.w   d3
    moveq   #$2,d5
    bra.w   l_3db2c
l_3da56:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    addq.l  #$8, a7
    cmpi.w  #$10, d3
    bne.b   l_3da88
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
l_3da88:
    tst.w   d3
    bne.b   l_3daba
    lea     -$80(a6), a2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_3da9c
    addq.l  #$3, d0
l_3da9c:
    asr.l   #$2, d0
    addi.l  #$7a3, d0
    move.l  d0, -(a7)
    move.l  ($0006583E).l, -(a7)
l_3daac:
    move.l  a2, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
    bra.b   l_3dae8
l_3daba:
    cmpi.w  #$4, d3
    bne.b   l_3dada
    lea     -$80(a6), a2
    move.w  d6, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  ($0006584E).l, -(a7)
    bra.b   l_3daac
l_3dada:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0006583E,a0
    movea.l (a0,d0.w), a2
l_3dae8:
    move.l  a2, -(a7)
    pea     ($00046840).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($003C).w
    pea     ($000E).w
    jsr     (a3)
    lea     $10(a7), a7
    clr.w   d2
l_3db06:
    clr.l   -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F5B2                                 ; bsr.w $03D0C0
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a3)
    lea     $10(a7), a7
    addq.w  #$1, d2
    addq.w  #$1, d4
    cmpi.w  #$10, d2
    blt.b   l_3db06
    addq.w  #$1, d3
    addq.w  #$2, d5
l_3db2c:
    cmpi.w  #$11, d3
    blt.w   l_3da56
    pea     ($0032).w
    pea     ($000E).w
    jsr     (a3)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$F574                                 ; bsr.w $03D0C0
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00063310).l
    jsr     (a4)
    pea     ($0017).w
    dc.w    $4EB9,$0001,$D444                           ; jsr $01D444
    lea     $2c(a7), a7
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076A7E).l
    jsr     (a4)
    move.l  ($000A1B64).l, -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($0025).w
    pea     ($0110).w
    move.l  a5, -(a7)
    dc.w    $4EB9,$0000,$45E6                           ; jsr $0045E6
    lea     $28(a7), a7
    pea     ($00073318).l
    pea     ($0003).w
    pea     ($0010).w
    pea     ($0014).w
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0064).w
    pea     ($000E).w
    jsr     (a3)
    movem.l -$a8(a6), d2-d6/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03DBE4 -- (TODO: name)
; 746 bytes | $03DBE4-$03DECD
; ============================================================================
func_03DBE4:
    link    a6,#-$88
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d6
    movea.l  #$00000D64,a4
    movea.l  #$0003B22C,a5
    clr.w   -$88(a6)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$88(a6)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $6100,$F49E                                 ; bsr.w $03D0C0
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    pea     ($0012).w
    pea     ($0020).w
    dc.w    $6100,$F586                                 ; bsr.w $03D1BA
    pea     ($00064660).l
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($00FF1804).l
    pea     ($0AC0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($000644C0).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    lea     $24(a7), a7
    pea     ($000644E0).l
    pea     ($000C).w
    pea     ($0010).w
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   d3
    clr.w   d2
    bra.b   l_3dcbc
l_3dca8:
    cmp.w   d6, d3
    beq.b   l_3dcba
    move.w  d2, d0
    add.w   d0, d0
    lea     -$86(a6), a0
    move.w  d3, (a0,d0.w)
    addq.w  #$1, d2
l_3dcba:
    addq.w  #$1, d3
l_3dcbc:
    cmpi.w  #$4, d3
    blt.b   l_3dca8
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    clr.l   -(a7)
    pea     (-$AF).w
    dc.w    $6100,$F3DC                                 ; bsr.w $03D0C0
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a4)
    lea     $2c(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $10(a7), a7
    move.w  #$ff51, d4
    clr.w   d2
    moveq   #$2,d5
    move.w  d6, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    bra.w   l_3deaa
l_3dd2c:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    addq.l  #$8, a7
    cmpi.w  #$10, d2
    bne.b   l_3dd5e
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_3dd5e:
    tst.w   d2
    bne.b   l_3dd8e
    lea     -$80(a6), a2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_3dd72
    addq.l  #$3, d0
l_3dd72:
    asr.l   #$2, d0
    addi.l  #$7a3, d0
    move.l  d0, -(a7)
    move.l  ($0006588E).l, -(a7)
l_3dd82:
    move.l  a2, -(a7)
    jsr     (a5)
    lea     $c(a7), a7
    bra.w   l_3de66
l_3dd8e:
    cmpi.w  #$1, d2
    bne.b   l_3dda2
    lea     -$80(a6), a2
    move.l  a3, -(a7)
    move.l  ($00065892).l, -(a7)
    bra.b   l_3dd82
l_3dda2:
    cmpi.w  #$4, d2
    bne.b   l_3ddd8
    lea     -$80(a6), a2
    move.w  ($00FF0004).l, d0
    ext.l   d0
    addq.l  #$4, d0
    moveq   #$7,d1
    cmp.l   d0, d1
    ble.b   l_3ddca
    move.w  ($00FF0004).l, d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    bra.b   l_3ddd0
l_3ddca:
    move.l  #$7, -(a7)
l_3ddd0:
    move.l  ($0006589E).l, -(a7)
    bra.b   l_3dd82
l_3ddd8:
    cmpi.w  #$6, d2
    bne.b   l_3ddfa
    lea     -$80(a6), a2
    move.w  -$86(a6), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  ($000658A6).l, -(a7)
    bra.b   l_3dd82
l_3ddfa:
    cmpi.w  #$7, d2
    bne.b   l_3de1e
    lea     -$80(a6), a2
    move.w  -$84(a6), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  ($000658AA).l, -(a7)
    bra.w   l_3dd82
l_3de1e:
    cmpi.w  #$8, d2
    bne.b   l_3de42
    lea     -$80(a6), a2
    move.w  -$82(a6), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  ($000658AE).l, -(a7)
    bra.w   l_3dd82
l_3de42:
    cmpi.w  #$a, d2
    bne.b   l_3de58
    lea     -$80(a6), a2
    move.l  a3, -(a7)
    move.l  ($000658B6).l, -(a7)
    bra.w   l_3dd82
l_3de58:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0006588E,a0
    movea.l (a0,d0.w), a2
l_3de66:
    move.l  a2, -(a7)
    pea     ($00046844).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($0050).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    clr.w   d3
l_3de84:
    clr.l   -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F234                                 ; bsr.w $03D0C0
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d3
    addq.w  #$1, d4
    cmpi.w  #$10, d3
    blt.b   l_3de84
    addq.w  #$1, d2
    addq.w  #$2, d5
l_3deaa:
    cmpi.w  #$11, d2
    blt.w   l_3dd2c
    pea     ($00C8).w
    pea     ($000E).w
    jsr     (a4)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    movem.l -$ac(a6), d2-d6/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_03DECE -- (TODO: name)
; 396 bytes | $03DECE-$03E059
; ============================================================================
func_03DECE:
    link    a6,#-$4
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00000D64,a3
    movea.l  #$00064DEE,a4
    movea.l  #$0003D0C0,a5
    clr.w   -$2(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr     (a5)
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$2(a6)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    pea     ($0012).w
    pea     ($0020).w
    dc.w    $6100,$F2A8                                 ; bsr.w $03D1BA
    move.l  a4, d0
    addi.l  #$1a0, d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($00FF1804).l
    pea     ($0860).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0010).w
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    lea     $24(a7), a7
    move.l  a4, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($000C).w
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    clr.l   -(a7)
    pea     (-$AF).w
    jsr     (a5)
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a3)
    lea     $2c(a7), a7
    move.w  #$ff51, d3
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $10(a7), a7
    clr.w   d4
    moveq   #$2,d5
    bra.b   l_3e038
l_3dfd8:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$000658D2,a0
    movea.l (a0,d0.w), a2
    move.l  a2, -(a7)
    pea     ($00046848).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    pea     ($0050).w
    pea     ($000E).w
    jsr     (a3)
    lea     $18(a7), a7
    clr.w   d2
l_3e014:
    clr.l   -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a3)
    lea     $10(a7), a7
    addq.w  #$1, d2
    addq.w  #$1, d3
    cmpi.w  #$10, d2
    blt.b   l_3e014
    addq.w  #$1, d4
    addq.w  #$2, d5
l_3e038:
    cmpi.w  #$d, d4
    blt.b   l_3dfd8
    pea     ($00C8).w
    pea     ($000E).w
    jsr     (a3)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    movem.l -$24(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ===========================================================================
; Multiply32_FromPtr -- Alternate entry: load multiplier from (A0)
; ===========================================================================
Multiply32_FromPtr:                                         ; $03E05A
    move.l  (a0),d1
; ===========================================================================
; Multiply32 -- 32x32 -> 32 unsigned multiply
;   In:  D0.l = multiplicand, D1.l = multiplier
;   Out: D0.l = low 32 bits of product
;   Uses: D2 (saved/restored)
;   204 calls
; ===========================================================================
Multiply32:                                                 ; $03E05C
    movem.l d0/d2,-(sp)               ; save D0 and D2
    move.l  d0,d2                      ; D2 = multiplicand copy
    mulu.w  d1,d0                      ; D0 = low * low (16x16->32)
    clr.w   d2
    swap    d2                         ; D2 = multiplicand high word
    beq.s   .crossB                    ; skip if high word zero
    mulu.w  d1,d2                      ; D2 = mcand_high * mplier_low
    swap    d2
    clr.w   d2                         ; cross product << 16
    add.l   d2,d0                      ; accumulate
.crossB:                                                    ; $03E072
    move.l  (sp)+,d2                   ; recover saved D0 into D2
    clr.w   d1
    swap    d1                         ; D1 = multiplier high word
    beq.s   .mulDone                   ; skip if high word zero
    mulu.w  d1,d2                      ; D2 = saved_D0_low * mplier_high
    swap    d2
    clr.w   d2                         ; cross product << 16
    add.l   d2,d0                      ; accumulate
.mulDone:                                                   ; $03E082
    move.l  (sp)+,d2                   ; restore original D2
    rts
; ===========================================================================
; SignedDiv_FromPtr -- Alternate entry: load from (A0), swap
; ===========================================================================
SignedDiv_FromPtr:                                          ; $03E086
    move.l  (a0),d1
    exg     d0,d1                      ; D0 = (A0), D1 = caller's D0
; ===========================================================================
; SignedDiv -- Signed 32/32 -> 32 division
;   In:  D0.l = dividend, D1.l = divisor
;   Out: D0.l = quotient (signed)
;   169 calls
; ===========================================================================
SignedDiv:                                                  ; $03E08A
    cmpi.l  #$00007FFF,d1
    bgt.s   .slowDiv                   ; divisor > +32767
    cmpi.l  #$FFFF8000,d1
    blt.s   .slowDiv                   ; divisor < -32768
    divs.w  d1,d0                      ; fast: DIVS.W (32/16)
    bvs.s   .slowDiv                   ; overflow
    ext.l   d0                         ; sign-extend quotient
    rts
.slowDiv:                                                   ; $03E0A2
    move.l  d2,-(sp)                   ; save D2
    clr.b   d2                         ; sign tracker
    tst.l   d0
    bge.s   .divChk1                   ; dividend positive
    neg.l   d0                         ; make positive
    not.b   d2                         ; toggle sign
.divChk1:                                                   ; $03E0AE
    tst.l   d1
    bge.s   .divCall                   ; divisor positive
    neg.l   d1                         ; make positive
    not.b   d2                         ; toggle sign
.divCall:                                                   ; $03E0B6
    bsr.s   UnsignedDivide             ; unsigned D0/D1
    tst.b   d2
    beq.s   .divDone                   ; signs matched
    neg.l   d0                         ; negate quotient
.divDone:                                                   ; $03E0BE
    move.l  (sp)+,d2                   ; restore D2
    rts
; ===========================================================================
; UnsignedDiv_FromPtr -- Alternate entry: load from (A0), swap
; ===========================================================================
UnsignedDiv_FromPtr:                                        ; $03E0C2
    move.l  (a0),d1
    exg     d0,d1                      ; D0 = (A0), D1 = caller's D0
; ===========================================================================
; UnsignedDivide -- Unsigned 32/32 divide
;   In:  D0.l = dividend, D1.l = divisor
;   Out: D0.l = quotient, D1.l = remainder
; ===========================================================================
UnsignedDivide:                                             ; $03E0C6
    cmpi.l  #$00010000,d1
    bcc.s   UDiv_Full32                ; divisor >= 65536, bit-by-bit
    divu.w  d1,d0                      ; fast: DIVU.W (32/16)
    bvs.s   UDiv_Overflow              ; quotient overflow, two-step
    moveq   #0,d1
    move.w  d0,d1                      ; D1 = quotient (low word)
    clr.w   d0
    swap    d0                         ; D0 = remainder (high word)
    exg     d0,d1                      ; D0 = quotient, D1 = remainder
    rts
; ---------------------------------------------------------------------------
; UDiv_Overflow -- Two-step 32/16 (quotient > 16 bits)
; ---------------------------------------------------------------------------
UDiv_Overflow:                                              ; $03E0DE
    move.l  d2,-(sp)                   ; save D2
    move.l  d1,d2                      ; D2 = divisor
    move.l  d0,d1                      ; D1 = original dividend
    clr.w   d0
    swap    d0                         ; D0 = dividend high word
    divu.w  d2,d0                      ; high / divisor -> rem1:quot_hi
    swap    d0                         ; D0 = quot_hi:rem1
    swap    d1
    move.w  d0,d1                      ; D1.low = rem1
    swap    d1                         ; D1 = rem1:dividend_low
    divu.w  d2,d1                      ; rem1:low / divisor -> rem2:quot_lo
    move.w  d1,d0                      ; D0 = quot_hi:quot_lo
    clr.w   d1
    swap    d1                         ; D1 = remainder
    move.l  (sp)+,d2                   ; restore D2
    rts
; ---------------------------------------------------------------------------
; UDiv_Full32 -- Bit-by-bit 32/32 shift-subtract (16 iterations)
;   Quotient fits in 16 bits since divisor >= $10000
; ---------------------------------------------------------------------------
UDiv_Full32:                                                ; $03E0FE
    movem.l d2-d3,-(sp)               ; save D2-D3
    move.l  d1,d3                      ; D3 = divisor
    move.l  d0,d1                      ; D1 = dividend
    swap    d0
    clr.w   d0                         ; D0 = dividend_low:0 (quotient accum)
    clr.w   d1
    swap    d1                         ; D1 = 0:dividend_high (remainder seed)
    moveq   #15,d2                     ; 16 iterations
.shiftLoop:                                                 ; $03E110
    add.l   d0,d0                      ; shift quotient left
    addx.l  d1,d1                      ; shift remainder left with carry
    cmp.l   d3,d1
    bcs.s   .noSub                     ; remainder < divisor
    sub.l   d3,d1                      ; remainder -= divisor
    addq.b  #1,d0                      ; set quotient bit
.noSub:                                                     ; $03E11C
    dbra    d2,.shiftLoop
    movem.l (sp)+,d2-d3               ; restore D2-D3
    rts
; ===========================================================================
; UnsignedMod_FromPtr -- Alternate entry: load from (A0), swap
; ===========================================================================
UnsignedMod_FromPtr:                                        ; $03E126
    move.l  (a0),d1
    exg     d0,d1                      ; D0 = (A0), D1 = caller's D0
; ===========================================================================
; UnsignedMod -- Unsigned 32/32 modulo
;   In:  D0.l = dividend, D1.l = divisor
;   Out: D0.l = remainder
; ===========================================================================
UnsignedMod:                                                ; $03E12A
    cmpi.l  #$00010000,d1
    bcc.s   .slowMod                   ; divisor >= 65536
    divu.w  d1,d0                      ; fast: DIVU.W
    bvs.s   .slowMod                   ; overflow
    clr.w   d0
    swap    d0                         ; D0 = remainder
    rts
.slowMod:                                                   ; $03E13C
    bsr.s   UnsignedDivide             ; full divide, D1 = remainder
    move.l  d1,d0                      ; D0 = remainder
    rts
; ===========================================================================
; SignedMod_FromPtr -- Alternate entry: load from (A0), swap
; ===========================================================================
SignedMod_FromPtr:                                          ; $03E142
    move.l  (a0),d1
    exg     d0,d1                      ; D0 = (A0), D1 = caller's D0
; ===========================================================================
; SignedMod -- Signed 32/32 modulo
;   In:  D0.l = dividend, D1.l = divisor
;   Out: D0.l = remainder (sign follows dividend)
;   88 calls
; ===========================================================================
SignedMod:                                                  ; $03E146
    cmpi.l  #$00007FFF,d1
    bgt.s   .slowMod                   ; divisor out of 16-bit range
    cmpi.l  #$FFFF8000,d1
    blt.s   .slowMod                   ; divisor out of 16-bit range
    divs.w  d1,d0                      ; fast: DIVS.W
    bvs.s   .slowMod                   ; overflow
    swap    d0                         ; remainder in low word
    ext.l   d0                         ; sign-extend remainder
    rts
.slowMod:                                                   ; $03E160
    move.l  d2,-(sp)                   ; save D2
    clr.l   d2                         ; sign tracker
    tst.l   d1
    bge.s   .modChk                    ; divisor positive
    neg.l   d1                         ; make positive
.modChk:                                                    ; $03E16A
    tst.l   d0
    bge.s   .modCall                   ; dividend positive
    neg.l   d0                         ; make positive
    addq.b  #1,d2                      ; mark: dividend was negative
.modCall:                                                   ; $03E172
    dc.w    $6100,$FF52                ; bsr.w UnsignedDivide (vasm BSR.W +2 bug)
    move.l  d1,d0                      ; D0 = remainder
    tst.b   d2
    beq.s   .modDone                   ; dividend was positive
    neg.l   d0                         ; negate remainder
.modDone:                                                   ; $03E17E
    move.l  (sp)+,d2                   ; restore D2
    rts
; ---------------------------------------------------------------------------
    dc.w    $1B47,$2573,$00FF,$2524,$366C,$6400,$2533        ; $03E182 (string data)
    dc.w    $6400,$2533,$6400,$2533,$6400,$2533,$6400,$2534; $03E190
    dc.w    $6400,$2535,$6400,$2573,$00FF,$00FF         ; $03E1A0
; ============================================================================
; GameStrings -- Game text string pool (679 strings, ASCII null-terminated)
; printf-style formatting (%s, %d, %$lu). $03E1AC-$041FFF (~15.4 KB)
; ============================================================================
GameStrings:                                            ; $03E1AC
    dc.w    $506C,$6561                                 ; $03E1AC
    dc.w    $7365,$2063,$686F,$6F73,$6520,$616E,$6F74,$6865; $03E1B0
    dc.w    $7220,$6369,$7479,$2E20,$2573,$2069,$7320,$616C; $03E1C0
    dc.w    $7265,$6164,$7920,$7468,$6520,$686F,$6D65,$2062; $03E1D0
    dc.w    $6173,$6520,$6F66,$2061,$6E6F,$7468,$6572,$2063; $03E1E0
    dc.w    $6F6D,$7061,$6E79,$2E00,$5765,$2772,$6520,$7265; $03E1F0
    dc.w    $6164,$7920,$746F,$2062,$6567,$696E,$2E20,$4973; $03E200
    dc.w    $2065,$7665,$7279,$7468,$696E,$6720,$696E,$206F; $03E210
    dc.w    $7264,$6572,$3F00,$4368,$616E,$6765,$2063,$6F6D; $03E220
    dc.w    $7061,$6E79,$206E,$616D,$653F,$00FF,$4973,$2025; $03E230
    dc.w    $7320,$4F4B,$3F00,$2573,$2069,$7320,$746F,$6F20; $03E240
    dc.w    $736D,$616C,$6C20,$746F,$2062,$6520,$7468,$6520; $03E250
    dc.w    $686F,$6D65,$2062,$6173,$6520,$666F,$7220,$6120; $03E260
    dc.w    $636F,$6D70,$616E,$7920,$6173,$2067,$7265,$6174; $03E270
    dc.w    $2061,$7320,$6F75,$7273,$2100,$4368,$6F6F,$7365; $03E280
    dc.w    $2061,$2025,$7320,$666F,$7220,$706C,$6179,$6572; $03E290
    dc.w    $2025,$6427,$7320,$686F,$6D65,$2062,$6173,$652E; $03E2A0
    dc.w    $00FF,$4368,$6F6F,$7365,$2073,$6B69,$6C6C,$206C; $03E2B0
    dc.w    $6576,$656C,$2E00,$00FF,$4368,$6F6F,$7365,$2061; $03E2C0
    dc.w    $2073,$6365,$6E61,$7269,$6F2E,$00FF,$2832,$3030; $03E2D0
    dc.w    $3020,$2D20,$3230,$3230,$2900,$2831,$3938,$3520; $03E2E0
    dc.w    $2D20,$3230,$3035,$2900,$2831,$3937,$3020,$2D20; $03E2F0
    dc.w    $3139,$3930,$2900,$2831,$3935,$3520,$2D20,$3139; $03E300
    dc.w    $3735,$2900,$5375,$7065,$7273,$6F6E,$6963,$2054; $03E310
    dc.w    $7261,$7665,$6C00,$4169,$726C,$696E,$6573,$2043; $03E320
    dc.w    $6F76,$6572,$2074,$6865,$2047,$6C6F,$6265,$00FF; $03E330
    dc.w    $4169,$7220,$5472,$6176,$656C,$2054,$616B,$6573; $03E340
    dc.w    $204F,$6666,$00FF,$5468,$6520,$4461,$776E,$206F; $03E350
    dc.w    $6620,$7468,$6520,$4A65,$7420,$4167,$6500,$5468; $03E360
    dc.w    $6520,$6167,$6520,$6F66,$2063,$6F6E,$7665,$6E74; $03E370
    dc.w    $696F,$6E61,$6C20,$6A65,$7420,$6169,$7220,$7472; $03E380
    dc.w    $6176,$656C,$2068,$6173,$2070,$6173,$7365,$642E; $03E390
    dc.w    $2020,$4E6F,$7720,$7468,$6520,$6F6E,$6C79,$2077; $03E3A0
    dc.w    $6179,$2074,$6F20,$666C,$7920,$6973,$2053,$7570; $03E3B0
    dc.w    $6572,$736F,$6E69,$6321,$00FF,$496E,$6372,$6561; $03E3C0
    dc.w    $7365,$6420,$666C,$7969,$6E67,$2072,$616E,$6765; $03E3D0
    dc.w    $206D,$6561,$6E74,$2074,$6861,$7420,$6D6F,$7374; $03E3E0
    dc.w    $2063,$6974,$6965,$7320,$636F,$756C,$6420,$6265; $03E3F0
    dc.w    $2073,$6572,$7665,$6420,$6279,$206E,$6F6E,$2D73; $03E400
    dc.w    $746F,$7020,$666C,$6967,$6874,$732E,$00FF,$5468; $03E410
    dc.w    $6520,$6E75,$6D62,$6572,$206F,$6620,$666C,$7969; $03E420
    dc.w    $6E67,$2070,$6173,$7365,$6E67,$6572,$7320,$7374; $03E430
    dc.w    $6561,$6469,$6C79,$2063,$6C69,$6D62,$6564,$2061; $03E440
    dc.w    $6E64,$2070,$6C61,$6E65,$7320,$6265,$6361,$6D65; $03E450
    dc.w    $206C,$6172,$6765,$7220,$616E,$6420,$6661,$7374; $03E460
    dc.w    $6572,$2E00,$5175,$6965,$742C,$2063,$6F6D,$666F; $03E470
    dc.w    $7274,$6162,$6C65,$206A,$6574,$2061,$6972,$6372; $03E480
    dc.w    $6166,$7420,$7765,$7265,$2071,$7569,$636B,$2074; $03E490
    dc.w    $6F20,$7265,$706C,$6163,$6520,$7072,$6F70,$2065; $03E4A0
    dc.w    $6E67,$696E,$6520,$706C,$616E,$6573,$2E00,$4237; $03E4B0
    dc.w    $3737,$204D,$4431,$3120,$4133,$3430,$2020,$2E20; $03E4C0
    dc.w    $2E20,$2E20,$00FF,$4D44,$3131,$2042,$3734,$3720; $03E4D0
    dc.w    $4237,$3637,$2041,$3334,$3000,$4237,$3437,$2044; $03E4E0
    dc.w    $4331,$3020,$4C31,$3031,$3120,$4133,$3030,$00FF; $03E4F0
    dc.w    $4237,$3037,$2044,$4338,$2043,$4152,$4156,$454C; $03E500
    dc.w    $4C45,$2042,$3732,$3720,$4237,$3337,$2044,$4339; $03E510
    dc.w    $00FF,$2532,$643A,$2025,$7300,$7468,$6973,$2073; $03E520
    dc.w    $6365,$6E61,$7269,$6F00,$4D61,$6A6F,$7220,$4E65; $03E530
    dc.w    $7720,$4169,$7263,$7261,$6674,$204D,$6F64,$656C; $03E540
    dc.w    $733A,$0A25,$7300,$2573,$00FF,$2573,$00FF,$2573; $03E550
    dc.w    $0A00,$5363,$656E,$6172,$696F,$2025,$3264,$0A00; $03E560
    dc.w    $2532,$643A,$2025,$7300,$486F,$7720,$6D61,$6E79; $03E570
    dc.w    $2070,$656F,$706C,$6520,$7769,$6C6C,$2070,$6C61; $03E580
    dc.w    $793F,$00FF,$5375,$7065,$7273,$6F6E,$6963,$00FF; $03E590
    dc.w    $4A75,$6D62,$6F20,$4A65,$7400,$5475,$7262,$6F00; $03E5A0
    dc.w    $5072,$6F70,$00FF,$476C,$6964,$6572,$00FF,$4C65; $03E5B0
    dc.w    $7665,$6C20,$2564,$00FF,$2573,$00FF,$6369,$7479; $03E5C0
    dc.w    $00FF,$7265,$6769,$6F6E,$00FF,$4C76,$2025,$6400; $03E5D0
    dc.w    $2532,$6400,$5363,$656E,$00FF,$2573,$00FF,$2573; $03E5E0
    dc.w    $00FF,$2573,$00FF,$4375,$7374,$6F6D,$697A,$6520; $03E5F0
    dc.w    $6561,$6368,$2063,$6F6D,$7061,$6E79,$2773,$206E; $03E600
    dc.w    $616D,$653F,$00FF,$6E61,$6D65,$00FF,$636F,$6C6F; $03E610
    dc.w    $7200,$4578,$6974,$00FF,$4368,$616E,$6765,$2077; $03E620
    dc.w    $6869,$6368,$2063,$6F6D,$7061,$6E79,$2773,$2025; $03E630
    dc.w    $733F,$00FF,$5468,$6973,$2063,$6974,$7920,$6973; $03E640
    dc.w    $2069,$6E20,$7468,$6520,$6D69,$6473,$7420,$6F66; $03E650
    dc.w    $2061,$2077,$6172,$2E20,$596F,$7520,$6361,$6E6E; $03E660
    dc.w    $6F74,$2070,$7572,$7375,$6520,$6120,$6275,$7369; $03E670
    dc.w    $6E65,$7373,$2076,$656E,$7475,$7265,$2074,$6865; $03E680
    dc.w    $7265,$2E00,$5765,$2064,$6F20,$6E6F,$7420,$6861; $03E690
    dc.w    $7665,$2061,$6E79,$2062,$7573,$696E,$6573,$7320; $03E6A0
    dc.w    $7665,$6E74,$7572,$6573,$2069,$6E20,$7468,$6973; $03E6B0
    dc.w    $2072,$6567,$696F,$6E2E,$00FF,$5768,$6963,$6820; $03E6C0
    dc.w    $6275,$7369,$6E65,$7373,$2076,$656E,$7475,$7265; $03E6D0
    dc.w    $2077,$696C,$6C20,$796F,$7520,$7365,$6C6C,$3F00; $03E6E0
    dc.w    $5765,$2061,$6C72,$6561,$6479,$206F,$776E,$2074; $03E6F0
    dc.w    $6869,$7320,$2573,$2E00,$4920,$7769,$6C6C,$2062; $03E700
    dc.w    $6567,$696E,$206E,$6567,$6F74,$6961,$7469,$6F6E; $03E710
    dc.w    $7320,$7769,$7468,$2074,$6865,$2063,$6974,$7920; $03E720
    dc.w    $746F,$2070,$7572,$6368,$6173,$6520,$7468,$6520; $03E730
    dc.w    $6275,$7369,$6E65,$7373,$2E00,$596F,$7520,$6D75; $03E740
    dc.w    $7374,$206E,$6567,$6F74,$6961,$7465,$2077,$6974; $03E750
    dc.w    $6820,$7468,$6520,$6369,$7479,$2074,$6F20,$7075; $03E760
    dc.w    $7263,$6861,$7365,$2074,$6869,$7320,$2573,$2E20; $03E770
    dc.w    $4974,$2077,$696C,$6C20,$7461,$6B65,$2033,$206D; $03E780
    dc.w    $6F6E,$7468,$732E,$2049,$7320,$7468,$6973,$204F; $03E790
    dc.w    $4B3F,$00FF,$536F,$7272,$792C,$2077,$6520,$646F; $03E7A0
    dc.w    $6E27,$7420,$6861,$7665,$2065,$6E6F,$7567,$6820; $03E7B0
    dc.w    $6D6F,$6E65,$792E,$00FF,$5468,$6973,$2025,$7320; $03E7C0
    dc.w    $6973,$2061,$6C72,$6561,$6479,$206F,$776E,$6564; $03E7D0
    dc.w    $2062,$7920,$2573,$2E00,$5768,$6963,$6820,$6275; $03E7E0
    dc.w    $7369,$6E65,$7373,$2076,$656E,$7475,$7265,$2077; $03E7F0
    dc.w    $696C,$6C20,$796F,$7520,$7075,$7263,$6861,$7365; $03E800
    dc.w    $3F00,$4F6E,$6C79,$2062,$7573,$696E,$6573,$7320; $03E810
    dc.w    $7665,$6E74,$7572,$6573,$2069,$6E20,$636F,$6E6E; $03E820
    dc.w    $6563,$7469,$6E67,$2063,$6974,$6965,$7320,$6361; $03E830
    dc.w    $6E20,$6265,$2070,$7572,$6368,$6173,$6564,$2E00; $03E840
    dc.w    $496E,$2077,$6869,$6368,$2063,$6974,$7920,$7368; $03E850
    dc.w    $616C,$6C20,$7765,$2062,$6964,$2066,$6F72,$2061; $03E860
    dc.w    $2062,$7573,$696E,$6573,$7320,$7665,$6E74,$7572; $03E870
    dc.w    $653F,$00FF,$5768,$6174,$2072,$6567,$696F,$6E20; $03E880
    dc.w    $646F,$2079,$6F75,$2077,$616E,$7420,$6265,$2074; $03E890
    dc.w    $6F20,$6D6F,$7665,$2069,$6E74,$6F3F,$00FF,$5768; $03E8A0
    dc.w    $6174,$2063,$616E,$2049,$2064,$6F20,$666F,$7220; $03E8B0
    dc.w    $796F,$753F,$00FF,$2524,$386C,$6400,$2573,$00FF; $03E8C0
    dc.w    $2524,$366C,$7500,$2573,$00FF,$2573,$00FF,$5661; $03E8D0
    dc.w    $6C75,$6500,$4275,$7369,$6E65,$7373,$00FF,$4369; $03E8E0
    dc.w    $7479,$00FF,$5661,$6C75,$6520,$2524,$3130,$6C75; $03E8F0
    dc.w    $00FF,$436F,$7374,$2025,$2431,$316C,$7500,$5072; $03E900
    dc.w    $6F66,$6974,$2025,$2439,$6400,$4578,$7065,$6E73; $03E910
    dc.w    $6573,$2025,$2437,$6C75,$00FF,$5361,$6C65,$7320; $03E920
    dc.w    $2025,$2439,$6C75,$00FF,$2573,$00FF,$2573,$00FF; $03E930
    dc.w    $5468,$6973,$2071,$7561,$7274,$6572,$2074,$6865; $03E940
    dc.w    $2025,$7320,$6861,$7320,$6265,$656E,$2075,$6E70; $03E950
    dc.w    $726F,$6669,$7461,$626C,$652E,$2044,$6F20,$796F; $03E960
    dc.w    $7520,$7761,$6E74,$2074,$6F20,$7365,$6C6C,$3F00; $03E970
    dc.w    $5468,$6973,$2071,$7561,$7274,$6572,$2062,$7573; $03E980
    dc.w    $696E,$6573,$7320,$6861,$7320,$6265,$656E,$2067; $03E990
    dc.w    $6F6F,$6420,$666F,$7220,$7468,$6520,$2573,$2E20; $03E9A0
    dc.w    $446F,$2079,$6F75,$2072,$6561,$6C6C,$7920,$7761; $03E9B0
    dc.w    $6E74,$2074,$6F20,$7365,$6C6C,$3F00,$4966,$2079; $03E9C0
    dc.w    $6F75,$2073,$656C,$6C20,$6974,$206E,$6F77,$2079; $03E9D0
    dc.w    $6F75,$7220,$6164,$2063,$616D,$7061,$6967,$6E20; $03E9E0
    dc.w    $7769,$6C6C,$2062,$6520,$7761,$7374,$6564,$2E20; $03E9F0
    dc.w    $5365,$6C6C,$2061,$6E79,$7761,$793F,$00FF,$2533; $03EA00
    dc.w    $7300,$2534,$6400,$2531,$6400,$6C76,$00FF,$2531; $03EA10
    dc.w    $6400,$7363,$00FF,$252D,$3973,$00FF,$2533,$7300; $03EA20
    dc.w    $252D,$3773,$00FF,$4E6F,$2053,$6176,$6564,$2047; $03EA30
    dc.w    $616D,$6500,$2533,$7300,$2534,$6400,$2531,$6400; $03EA40
    dc.w    $6C76,$00FF,$2531,$6400,$7363,$00FF,$252D,$3973; $03EA50
    dc.w    $00FF,$2533,$7300,$252D,$3773,$00FF,$4E6F,$2053; $03EA60
    dc.w    $6176,$6564,$2047,$616D,$6500,$596F,$7520,$616C; $03EA70
    dc.w    $7265,$6164,$7920,$6861,$7665,$2061,$2072,$6567; $03EA80
    dc.w    $696F,$6E61,$6C20,$6875,$6220,$696E,$2025,$732E; $03EA90
    dc.w    $00FF,$4927,$6C6C,$2067,$6574,$2072,$6967,$6874; $03EAA0
    dc.w    $206F,$6E20,$6974,$2E00,$536F,$7272,$792C,$2077; $03EAB0
    dc.w    $6520,$6361,$6E27,$7420,$6F70,$656E,$2061,$2072; $03EAC0
    dc.w    $6567,$696F,$6E61,$6C20,$6875,$6220,$6265,$6361; $03EAD0
    dc.w    $7573,$6520,$6F66,$2074,$6865,$2077,$6172,$2E00; $03EAE0
    dc.w    $5368,$616C,$6C20,$7765,$206F,$7065,$6E20,$6120; $03EAF0
    dc.w    $7265,$6769,$6F6E,$616C,$2068,$7562,$2069,$6E20; $03EB00
    dc.w    $2573,$3F00,$536F,$7272,$792C,$2077,$6520,$646F; $03EB10
    dc.w    $6E27,$7420,$6861,$7665,$2065,$6E6F,$7567,$6820; $03EB20
    dc.w    $6D6F,$6E65,$7920,$746F,$206F,$7065,$6E20,$6120; $03EB30
    dc.w    $7265,$6769,$6F6E,$616C,$2068,$7562,$2E00,$6120; $03EB40
    dc.w    $666C,$6967,$6874,$2067,$6F69,$6E67,$2074,$6F20; $03EB50
    dc.w    $2573,$2E00,$496E,$2074,$6869,$7320,$7265,$6769; $03EB60
    dc.w    $6F6E,$2077,$6520,$6861,$7665,$2000,$2524,$3564; $03EB70
    dc.w    $00FF,$436F,$6E73,$7472,$7563,$7469,$6F6E,$2043; $03EB80
    dc.w    $6F73,$7473,$00FF,$2524,$3564,$00FF,$4D61,$696E; $03EB90
    dc.w    $7465,$6E61,$6E63,$6520,$4578,$7065,$6E73,$6500; $03EBA0
    dc.w    $2573,$00FF,$4875,$6220,$5365,$742D,$7570,$00FF; $03EBB0
    dc.w    $5765,$2063,$616E,$2774,$206F,$7065,$6E20,$6120; $03EBC0
    dc.w    $7265,$6769,$6F6E,$616C,$2068,$7562,$2069,$6E20; $03EBD0
    dc.w    $2573,$2E20,$5765,$2064,$6F6E,$2774,$2068,$6176; $03EBE0
    dc.w    $6520,$616E,$7920,$666C,$6967,$6874,$7320,$676F; $03EBF0
    dc.w    $696E,$6720,$7468,$6572,$6520,$7965,$742E,$00FF; $03EC00
    dc.w    $4F75,$7220,$686F,$6D65,$2062,$6173,$6520,$6973; $03EC10
    dc.w    $2068,$6572,$6520,$696E,$2025,$732E,$2057,$6520; $03EC20
    dc.w    $646F,$6E27,$7420,$6E65,$6564,$2061,$2072,$6567; $03EC30
    dc.w    $696F,$6E61,$6C20,$6875,$622E,$00FF,$496E,$2025; $03EC40
    dc.w    $732C,$2070,$7265,$7061,$7261,$7469,$6F6E,$7320; $03EC50
    dc.w    $666F,$7220,$6120,$7265,$6769,$6F6E,$616C,$2068; $03EC60
    dc.w    $7562,$2061,$7265,$2061,$6C72,$6561,$6479,$2075; $03EC70
    dc.w    $6E64,$6572,$7761,$7920,$696E,$2025,$732E,$00FF; $03EC80
    dc.w    $4172,$6520,$796F,$7520,$7375,$7265,$2079,$6F75; $03EC90
    dc.w    $2077,$616E,$7420,$746F,$2063,$6C6F,$7365,$2074; $03ECA0
    dc.w    $6865,$2072,$6567,$696F,$6E61,$6C20,$6875,$6220; $03ECB0
    dc.w    $696E,$2025,$733F,$00FF,$5765,$2064,$6F20,$6E6F; $03ECC0
    dc.w    $7420,$6861,$7665,$2061,$2072,$6567,$696F,$6E61; $03ECD0
    dc.w    $6C20,$6875,$6220,$696E,$2025,$732E,$00FF,$4164; $03ECE0
    dc.w    $2043,$616D,$7061,$6967,$6E00,$4275,$7369,$6E65; $03ECF0
    dc.w    $7373,$2050,$7572,$6368,$6173,$6500,$00FF,$4875; $03ED00
    dc.w    $6220,$5365,$7475,$7000,$00FF,$4169,$7270,$6F72; $03ED10
    dc.w    $7420,$536C,$6F74,$7300,$776F,$726B,$696E,$6720; $03ED20
    dc.w    $6F6E,$2061,$6E20,$6164,$7665,$7274,$6973,$696E; $03ED30
    dc.w    $6720,$6361,$6D70,$6169,$676E,$2E00,$6E65,$676F; $03ED40
    dc.w    $7469,$6174,$696E,$6720,$666F,$7220,$6120,$6275; $03ED50
    dc.w    $7369,$6E65,$7373,$2076,$656E,$7475,$7265,$2E00; $03ED60
    dc.w    $00FF,$6F76,$6572,$7365,$6569,$6E67,$2063,$6F6E; $03ED70
    dc.w    $7374,$7275,$6374,$696F,$6E20,$6F66,$2061,$2072; $03ED80
    dc.w    $6567,$696F,$6E61,$6C20,$6875,$622E,$0000,$6D61; $03ED90
    dc.w    $6B69,$6E67,$2061,$2062,$6964,$2066,$6F72,$2073; $03EDA0
    dc.w    $6F6D,$6520,$6169,$7270,$6F72,$7420,$736C,$6F74; $03EDB0
    dc.w    $732E,$00FF,$5361,$6E74,$6961,$676F,$00FF,$4275; $03EDC0
    dc.w    $656E,$6F73,$2041,$6972,$6573,$00FF,$4C69,$6D61; $03EDD0
    dc.w    $00FF,$4B69,$6E67,$7374,$6F6E,$00FF,$5269,$6F20; $03EDE0
    dc.w    $6465,$204A,$616E,$6569,$726F,$00FF,$486F,$6E6F; $03EDF0
    dc.w    $6C75,$6C75,$00FF,$546F,$726F,$6E74,$6F00,$4D69; $03EE00
    dc.w    $616D,$6900,$486F,$7573,$746F,$6E00,$5068,$696C; $03EE10
    dc.w    $612D,$2064,$656C,$7068,$6961,$00FF,$5068,$6F65; $03EE20
    dc.w    $6E69,$7800,$4465,$6E76,$6572,$00FF,$5365,$6174; $03EE30
    dc.w    $746C,$6500,$5361,$6E20,$4672,$616E,$2063,$6973; $03EE40
    dc.w    $636F,$00FF,$5061,$7065,$6574,$6500,$4E6F,$756D; $03EE50
    dc.w    $6561,$00FF,$4E61,$6469,$00FF,$4164,$656C,$6169; $03EE60
    dc.w    $6465,$00FF,$4D65,$6C2D,$2062,$6F75,$726E,$6500; $03EE70
    dc.w    $4272,$6973,$6261,$6E65,$00FF,$4B68,$6162,$2D20; $03EE80
    dc.w    $6172,$6F76,$736B,$00FF,$5361,$6970,$616E,$00FF; $03EE90
    dc.w    $4775,$616D,$00FF,$4365,$6275,$00FF,$4B75,$616C; $03EEA0
    dc.w    $6120,$4C75,$6D70,$7572,$00FF,$5461,$6970,$6569; $03EEB0
    dc.w    $00FF,$5368,$616E,$6768,$6169,$00FF,$4675,$6B75; $03EEC0
    dc.w    $6F6B,$6100,$5361,$7070,$6F72,$6F00,$4F73,$616B; $03EED0
    dc.w    $6100,$5461,$7368,$6B65,$6E74,$00FF,$426F,$6D62; $03EEE0
    dc.w    $6179,$00FF,$4361,$6C63,$7574,$7461,$00FF,$4B61; $03EEF0
    dc.w    $7261,$6368,$6900,$4973,$6C61,$6D61,$2D20,$6261; $03EF00
    dc.w    $6400,$5472,$6970,$6F6C,$6900,$4164,$6469,$7320; $03EF10
    dc.w    $4162,$6162,$6100,$4E61,$6972,$6F62,$6900,$4C61; $03EF20
    dc.w    $676F,$7300,$416C,$6769,$6572,$7300,$4D69,$6E73; $03EF30
    dc.w    $6B00,$4B69,$6576,$00FF,$526F,$7374,$6F76,$00FF; $03EF40
    dc.w    $5669,$656E,$6E61,$00FF,$4F73,$6C6F,$00FF,$5374; $03EF50
    dc.w    $6F63,$6B2D,$2068,$6F6C,$6D00,$4865,$6C73,$696E; $03EF60
    dc.w    $6B69,$00FF,$4261,$7263,$652D,$206C,$6F6E,$6100; $03EF70
    dc.w    $4D61,$6472,$6964,$00FF,$5A75,$7269,$6368,$00FF; $03EF80
    dc.w    $4174,$6865,$6E73,$00FF,$436F,$7065,$6E2D,$2068; $03EF90
    dc.w    $6167,$656E,$00FF,$4D69,$6C61,$6E00,$4272,$7573; $03EFA0
    dc.w    $7365,$6C73,$00FF,$4D75,$6E69,$6368,$00FF,$4E69; $03EFB0
    dc.w    $6365,$00FF,$4D61,$6E2D,$2063,$6865,$7374,$6572; $03EFC0
    dc.w    $00FF,$4861,$7661,$6E61,$00FF,$5361,$6F20,$5061; $03EFD0
    dc.w    $756C,$6F00,$4D65,$7869,$636F,$2043,$6974,$7900; $03EFE0
    dc.w    $5661,$6E2D,$2063,$6F75,$7665,$7200,$4174,$6C61; $03EFF0
    dc.w    $6E74,$6100,$4461,$6C6C,$6173,$00FF,$4C6F,$7320; $03F000
    dc.w    $416E,$6765,$6C65,$7300,$4368,$6963,$6167,$6F00; $03F010
    dc.w    $4E65,$7720,$596F,$726B,$00FF,$5761,$7368,$696E; $03F020
    dc.w    $672D,$2074,$6F6E,$00FF,$4175,$636B,$6C61,$6E64; $03F030
    dc.w    $00FF,$5065,$7274,$6800,$5379,$646E,$6579,$00FF; $03F040
    dc.w    $4D61,$6E69,$6C61,$00FF,$4261,$6E67,$6B6F,$6B00; $03F050
    dc.w    $5369,$6E67,$2D20,$6170,$6F72,$6500,$486F,$6E67; $03F060
    dc.w    $204B,$6F6E,$6700,$5365,$6F75,$6C00,$4265,$696A; $03F070
    dc.w    $696E,$6700,$546F,$6B79,$6F00,$4E65,$7720,$4465; $03F080
    dc.w    $6C68,$6900,$4261,$6768,$6461,$6400,$5465,$6872; $03F090
    dc.w    $616E,$00FF,$5475,$6E69,$7300,$4361,$6972,$6F00; $03F0A0
    dc.w    $4D6F,$7363,$6F77,$00FF,$4265,$726C,$696E,$00FF; $03F0B0
    dc.w    $526F,$6D65,$00FF,$416D,$7374,$6572,$2D20,$6461; $03F0C0
    dc.w    $6D00,$4672,$616E,$6B2D,$2066,$7572,$7400,$5061; $03F0D0
    dc.w    $7269,$7300,$4C6F,$6E64,$6F6E,$00FF,$6F76,$6572; $03F0E0
    dc.w    $206F,$6E65,$2079,$6561,$7200,$2532,$6420,$6D6F; $03F0F0
    dc.w    $6E74,$6873,$00FF,$2573,$00FF,$4D69,$6464,$6C65; $03F100
    dc.w    $2045,$6173,$7400,$5345,$2041,$7369,$6100,$536F; $03F110
    dc.w    $7272,$792C,$2049,$276D,$2062,$7573,$7920,$2573; $03F120
    dc.w    $00FF,$5768,$6F20,$7769,$6C6C,$2079,$6F75,$2073; $03F130
    dc.w    $656E,$6420,$746F,$2000,$636F,$6E64,$7563,$7420; $03F140
    dc.w    $616E,$2061,$6420,$6361,$6D70,$6169,$676E,$3F00; $03F150
    dc.w    $6368,$6563,$6B20,$6F75,$7420,$6275,$7369,$6E65; $03F160
    dc.w    $7373,$2070,$6F73,$7369,$6269,$6C69,$7469,$6573; $03F170
    dc.w    $3F00,$6E65,$676F,$7469,$6174,$6520,$666F,$7220; $03F180
    dc.w    $6120,$7265,$6769,$6F6E,$616C,$2068,$7562,$3F00; $03F190
    dc.w    $6269,$6420,$666F,$7220,$736C,$6F74,$733F,$00FF; $03F1A0
    dc.w    $2000,$2524,$396C,$6400,$4172,$6520,$796F,$7520; $03F1B0
    dc.w    $7375,$7265,$2079,$6F75,$2077,$616E,$7420,$746F; $03F1C0
    dc.w    $2063,$6C6F,$7365,$3F00,$2573,$2077,$696C,$6C20; $03F1D0
    dc.w    $6265,$2063,$6C6F,$7365,$642E,$00FF,$2573,$2061; $03F1E0
    dc.w    $6E64,$2025,$7300,$2564,$2072,$6F75,$7465,$7300; $03F1F0
    dc.w    $2564,$2072,$6567,$696F,$6E61,$6C20,$6875,$6273; $03F200
    dc.w    $00FF,$5468,$6520,$726F,$7574,$6520,$7761,$7320; $03F210
    dc.w    $636C,$6F73,$6564,$2E00,$2573,$00FF,$2573,$00FF; $03F220
    dc.w    $3120,$726F,$7574,$6500,$3120,$7265,$6769,$6F6E; $03F230
    dc.w    $616C,$2068,$7562,$00FF,$2573,$00FF,$2573,$00FF; $03F240
    dc.w    $3120,$726F,$7574,$6500,$3120,$7265,$6769,$6F6E; $03F250
    dc.w    $616C,$2068,$7562,$00FF,$416C,$6C20,$666C,$6967; $03F260
    dc.w    $6874,$7320,$6C69,$7374,$6564,$2061,$626F,$7665; $03F270
    dc.w    $2077,$696C,$6C20,$6265,$2063,$6C6F,$7365,$642E; $03F280
    dc.w    $00FF,$5765,$2063,$616E,$2774,$2061,$6666,$6F72; $03F290
    dc.w    $6420,$746F,$2072,$756E,$2074,$6861,$7420,$6361; $03F2A0
    dc.w    $6D70,$6169,$676E,$2072,$6967,$6874,$206E,$6F77; $03F2B0
    dc.w    $2E00,$5765,$2772,$6520,$696E,$2074,$6865,$206D; $03F2C0
    dc.w    $6964,$646C,$6520,$6F66,$2061,$2077,$6172,$2120; $03F2D0
    dc.w    $5765,$2063,$616E,$2774,$2063,$6F6E,$6475,$6374; $03F2E0
    dc.w    $2061,$2063,$616D,$7061,$6967,$6E20,$6E6F,$7721; $03F2F0
    dc.w    $00FF,$4927,$6C6C,$2067,$6574,$2072,$6967,$6874; $03F300
    dc.w    $206F,$6E20,$6974,$2E00,$486F,$7720,$6D75,$6368; $03F310
    dc.w    $2077,$696C,$6C20,$796F,$7520,$7370,$656E,$6420; $03F320
    dc.w    $6F6E,$2074,$6865,$2063,$616D,$7061,$6967,$6E3F; $03F330
    dc.w    $00FF,$5468,$6572,$6520,$6172,$6520,$6E6F,$2062; $03F340
    dc.w    $7573,$696E,$6573,$7365,$7320,$696E,$206F,$7572; $03F350
    dc.w    $2025,$7320,$6E65,$7477,$6F72,$6B20,$746F,$2070; $03F360
    dc.w    $726F,$6D6F,$7465,$2E00,$5768,$6174,$206B,$696E; $03F370
    dc.w    $6420,$6F66,$2063,$616D,$7061,$6967,$6E20,$776F; $03F380
    dc.w    $756C,$6420,$796F,$7520,$6C69,$6B65,$2074,$6F20; $03F390
    dc.w    $7275,$6E3F,$00FF,$5765,$2064,$6F6E,$2774,$206F; $03F3A0
    dc.w    $776E,$2061,$6E79,$2025,$7320,$6275,$7369,$6E65; $03F3B0
    dc.w    $7373,$6573,$2120,$486F,$7720,$6361,$6E20,$7765; $03F3C0
    dc.w    $2072,$756E,$2061,$2063,$616D,$7061,$6967,$6E3F; $03F3D0
    dc.w    $00FF,$4172,$6520,$796F,$7520,$7375,$7265,$2079; $03F3E0
    dc.w    $6F75,$2077,$616E,$7420,$746F,$2072,$756E,$2074; $03F3F0
    dc.w    $6869,$7320,$2573,$2063,$616D,$7061,$6967,$6E3F; $03F400
    dc.w    $00FF,$4C65,$6973,$7572,$652F,$5370,$6F72,$7473; $03F410
    dc.w    $00FF,$5472,$6176,$656C,$204E,$6574,$776F,$726B; $03F420
    dc.w    $00FF,$4375,$6C74,$7572,$6520,$616E,$6420,$4172; $03F430
    dc.w    $7473,$00FF,$5269,$6768,$7420,$6E6F,$7720,$7765; $03F440
    dc.w    $2772,$6520,$7275,$6E6E,$696E,$6720,$6120,$2573; $03F450
    dc.w    $2063,$616D,$7061,$6967,$6E2E,$00FF,$5765,$2063; $03F460
    dc.w    $616E,$2774,$2072,$756E,$2061,$6E20,$6164,$2063; $03F470
    dc.w    $616D,$7061,$6967,$6E20,$696E,$2025,$732E,$2057; $03F480
    dc.w    $6520,$646F,$6E27,$7420,$6861,$7665,$2061,$6E79; $03F490
    dc.w    $2072,$6F75,$7465,$7320,$696E,$2074,$6861,$7420; $03F4A0
    dc.w    $7265,$6769,$6F6E,$2E00,$5665,$7279,$2068,$6967; $03F4B0
    dc.w    $6800,$4869,$6768,$00FF,$4176,$6572,$6167,$6500; $03F4C0
    dc.w    $536C,$696D,$00FF,$5665,$7279,$2073,$6C69,$6D00; $03F4D0
    dc.w    $5765,$2077,$696C,$6C20,$7072,$6F6D,$6F74,$6520; $03F4E0
    dc.w    $6563,$6F6E,$6F6D,$6963,$616C,$2074,$6F75,$7273; $03F4F0
    dc.w    $2061,$7420,$6F75,$7220,$7370,$6F72,$7473,$2061; $03F500
    dc.w    $6E64,$2061,$6D75,$7365,$6D65,$6E74,$2066,$6163; $03F510
    dc.w    $696C,$6974,$6965,$732E,$00FF,$5765,$2077,$696C; $03F520
    dc.w    $6C20,$6869,$6768,$6C69,$6768,$7420,$7468,$6520; $03F530
    dc.w    $636F,$6E76,$656E,$6965,$6E63,$6520,$6F66,$206F; $03F540
    dc.w    $7572,$2074,$7261,$7665,$6C20,$7365,$7276,$6963; $03F550
    dc.w    $6573,$2061,$6E64,$206F,$6666,$6572,$2075,$7067; $03F560
    dc.w    $7261,$6465,$6420,$6361,$7465,$7269,$6E67,$2E00; $03F570
    dc.w    $5765,$2077,$696C,$6C20,$7370,$6F6E,$736F,$7220; $03F580
    dc.w    $6375,$6C74,$7572,$616C,$2065,$7665,$6E74,$7320; $03F590
    dc.w    $6174,$206F,$7572,$2066,$6163,$696C,$6974,$6965; $03F5A0
    dc.w    $732E,$00FF,$4E6F,$7420,$506F,$7373,$6962,$6C65; $03F5B0
    dc.w    $00FF,$4F6E,$676F,$696E,$6700,$5365,$7474,$696E; $03F5C0
    dc.w    $6720,$7570,$00FF,$2524,$3564,$00FF,$4578,$7065; $03F5D0
    dc.w    $6E73,$652F,$5374,$6174,$7573,$00FF,$5479,$7065; $03F5E0
    dc.w    $00FF,$2524,$356C,$6400,$4368,$616E,$6365,$2066; $03F5F0
    dc.w    $6F72,$2053,$7563,$6365,$7373,$3A00,$5072,$6F6D; $03F600
    dc.w    $6F74,$696F,$6E20,$4578,$7065,$6E73,$6500,$2524; $03F610
    dc.w    $356C,$6400,$5374,$616E,$6461,$7264,$2045,$7870; $03F620
    dc.w    $656E,$7365,$00FF,$4368,$616E,$6365,$2066,$6F72; $03F630
    dc.w    $2053,$7563,$6365,$7373,$3A00,$5072,$6F6D,$6F74; $03F640
    dc.w    $696F,$6E20,$4578,$7065,$6E73,$6500,$2524,$356C; $03F650
    dc.w    $6400,$5374,$616E,$6461,$7264,$2045,$7870,$656E; $03F660
    dc.w    $7365,$00FF,$7825,$6400,$4973,$2074,$6869,$7320; $03F670
    dc.w    $636F,$7272,$6563,$743F,$00FF,$5768,$6174,$2066; $03F680
    dc.w    $6172,$6520,$7769,$6C6C,$2079,$6F75,$2073,$6574; $03F690
    dc.w    $3F00,$486F,$7720,$6D61,$6E79,$2066,$6C69,$6768; $03F6A0
    dc.w    $7473,$2070,$6572,$2077,$6565,$6B3F,$00FF,$486F; $03F6B0
    dc.w    $7720,$6D61,$6E79,$2070,$6C61,$6E65,$7320,$7769; $03F6C0
    dc.w    $6C6C,$2066,$6C79,$206F,$6E20,$7468,$6520,$726F; $03F6D0
    dc.w    $7574,$653F,$00FF,$5768,$6963,$6820,$6169,$7263; $03F6E0
    dc.w    $7261,$6674,$2077,$696C,$6C20,$796F,$7520,$7573; $03F6F0
    dc.w    $6520,$6F6E,$2074,$6865,$2072,$6F75,$7465,$3F00; $03F700
    dc.w    $4F4B,$3F00,$5365,$6C65,$6374,$2064,$6573,$7469; $03F710
    dc.w    $6E61,$7469,$6F6E,$2E00,$5365,$6C65,$6374,$2072; $03F720
    dc.w    $6567,$696F,$6E20,$666F,$7220,$6465,$7374,$696E; $03F730
    dc.w    $6174,$696F,$6E2E,$0000,$4973,$2069,$7420,$4F4B; $03F740
    dc.w    $2074,$6F20,$6368,$616E,$6765,$2074,$6869,$7320; $03F750
    dc.w    $666C,$6967,$6874,$2061,$7320,$7368,$6F77,$6E3F; $03F760
    dc.w    $00FF,$5765,$2064,$6F6E,$2774,$2068,$6176,$6520; $03F770
    dc.w    $616E,$7920,$726F,$7574,$6573,$2066,$6C79,$696E; $03F780
    dc.w    $6720,$696E,$746F,$2074,$6869,$7320,$7265,$6769; $03F790
    dc.w    $6F6E,$2E00,$2534,$6400,$2532,$6400,$2532,$6400; $03F7A0
    dc.w    $2573,$0D00,$5075,$7368,$2053,$5441,$5254,$2074; $03F7B0
    dc.w    $6F20,$7669,$6577,$2074,$6865,$2063,$6F6D,$7065; $03F7C0
    dc.w    $7469,$7469,$6F6E,$2E00,$5075,$7368,$2053,$5441; $03F7D0
    dc.w    $5254,$2074,$6F20,$7669,$6577,$2074,$6865,$2063; $03F7E0
    dc.w    $6F6D,$7065,$7469,$7469,$6F6E,$2E00,$4974,$2077; $03F7F0
    dc.w    $6F75,$6C64,$2062,$6520,$6469,$6666,$6963,$756C; $03F800
    dc.w    $7420,$746F,$2063,$6861,$6E67,$6520,$6120,$726F; $03F810
    dc.w    $7574,$6520,$7468,$6174,$2064,$6F65,$736E,$2774; $03F820
    dc.w    $2065,$7869,$7374,$2E00,$2A25,$6400,$2532,$6400; $03F830
    dc.w    $2532,$6400,$2A25,$6400,$2533,$6400,$2533,$6400; $03F840
    dc.w    $2A25,$6400,$2532,$6400,$2532,$6400,$2533,$6400; $03F850
    dc.w    $2533,$6400,$2532,$6400,$2532,$6400,$2533,$6400; $03F860
    dc.w    $2533,$6400,$2534,$6425,$2500,$2524,$2434,$6400; $03F870
    dc.w    $2534,$6425,$2500,$2524,$2434,$6400,$6176,$6572; $03F880
    dc.w    $6167,$6520,$6661,$7265,$2020,$00FF,$2532,$6425; $03F890
    dc.w    $2520,$6162,$6F76,$6520,$6176,$672E,$00FF,$2532; $03F8A0
    dc.w    $6425,$2520,$6265,$6C6F,$7720,$6176,$672E,$00FF; $03F8B0
    dc.w    $0000,$00FF,$5346,$5800,$4247,$4D00,$456E,$6420; $03F8C0
    dc.w    $4761,$6D65,$00FF,$4D65,$7373,$6167,$6500,$536F; $03F8D0
    dc.w    $756E,$6400,$416E,$696D,$6174,$696F,$6E00,$5361; $03F8E0
    dc.w    $7665,$00FF,$4247,$4D00,$5346,$5800,$4F6E,$2000; $03F8F0
    dc.w    $4F66,$6600,$5374,$6572,$656F,$00FF,$4D6F,$6E6F; $03F900
    dc.w    $00FF,$536C,$6F77,$00FF,$4D65,$6469,$756D,$00FF; $03F910
    dc.w    $4661,$7374,$00FF,$5365,$6520,$686F,$7720,$6974; $03F920
    dc.w    $2065,$6E64,$7320,$7570,$3F00,$456E,$6420,$6761; $03F930
    dc.w    $6D65,$3F00,$2573,$00FF,$2573,$00FF,$2573,$0A00; $03F940
    dc.w    $5361,$7665,$2063,$6F6D,$706C,$6574,$6564,$2E00; $03F950
    dc.w    $4D65,$7373,$6167,$6573,$2061,$7265,$2063,$7572; $03F960
    dc.w    $7265,$6E74,$6C79,$2062,$6569,$6E67,$2064,$6973; $03F970
    dc.w    $706C,$6179,$6564,$2061,$7420,$2573,$2073,$7065; $03F980
    dc.w    $6564,$2E20,$5768,$6174,$2073,$7065,$6564,$2077; $03F990
    dc.w    $6F75,$6C64,$2079,$6F75,$206C,$696B,$653F,$00FF; $03F9A0
    dc.w    $2573,$00FF,$446F,$6E27,$7420,$796F,$7520,$7468; $03F9B0
    dc.w    $696E,$6B20,$7765,$2073,$686F,$756C,$6420,$7465; $03F9C0
    dc.w    $726D,$696E,$6174,$6520,$7365,$7276,$6963,$6520; $03F9D0
    dc.w    $6F6E,$2074,$6869,$7320,$726F,$7574,$653F,$00FF; $03F9E0
    dc.w    $4920,$7468,$696E,$6B20,$7765,$2073,$686F,$756C; $03F9F0
    dc.w    $6420,$7465,$6D70,$6F72,$6172,$696C,$7920,$7375; $03FA00
    dc.w    $7370,$656E,$6420,$6F70,$6572,$6174,$696F,$6E73; $03FA10
    dc.w    $206F,$6E20,$7468,$6973,$2072,$6F75,$7465,$2E00; $03FA20
    dc.w    $5468,$6520,$726F,$7574,$6520,$6265,$7477,$6565; $03FA30
    dc.w    $6E20,$2573,$2061,$6E64,$2025,$7320,$6973,$206E; $03FA40
    dc.w    $6F74,$2070,$726F,$6669,$7461,$626C,$652E,$00FF; $03FA50
    dc.w    $5468,$6520,$726F,$7574,$6520,$6265,$7477,$6565; $03FA60
    dc.w    $6E20,$2573,$2061,$6E64,$2025,$7320,$6973,$2072; $03FA70
    dc.w    $756E,$6E69,$6E67,$2025,$246C,$7520,$696E,$2074; $03FA80
    dc.w    $6865,$2062,$6C61,$636B,$2E00,$5468,$6520,$726F; $03FA90
    dc.w    $7574,$6520,$6265,$7477,$6565,$6E20,$2573,$2061; $03FAA0
    dc.w    $6E64,$2025,$7320,$6973,$2072,$756E,$6E69,$6E67; $03FAB0
    dc.w    $2025,$246C,$7520,$696E,$2074,$6865,$2072,$6564; $03FAC0
    dc.w    $2E00,$5269,$7369,$6E67,$206F,$696C,$2070,$7269; $03FAD0
    dc.w    $6365,$7320,$6172,$6520,$6861,$7669,$6E67,$2061; $03FAE0
    dc.w    $2073,$6576,$6572,$6520,$696D,$7061,$6374,$206F; $03FAF0
    dc.w    $6E20,$6F75,$7220,$6578,$7065,$6E73,$6573,$2E00; $03FB00
    dc.w    $5468,$6572,$6520,$2573,$2025,$6420,$2573,$2077; $03FB10
    dc.w    $6865,$7265,$2077,$6520,$646F,$206E,$6F74,$2068; $03FB20
    dc.w    $6176,$6520,$6120,$6875,$622E,$00FF,$4279,$206F; $03FB30
    dc.w    $7065,$6E69,$6E67,$2068,$7562,$7320,$696E,$2061; $03FB40
    dc.w    $6C6C,$2072,$6567,$696F,$6E73,$2077,$6520,$6361; $03FB50
    dc.w    $6E20,$6578,$7061,$6E64,$206F,$7572,$206E,$6574; $03FB60
    dc.w    $776F,$726B,$2074,$6F20,$636F,$7665,$7220,$7468; $03FB70
    dc.w    $6520,$7768,$6F6C,$6520,$776F,$726C,$642E,$00FF; $03FB80
    dc.w    $4C65,$7427,$7320,$7465,$726D,$696E,$6174,$6520; $03FB90
    dc.w    $756E,$6E65,$6365,$7373,$6172,$7920,$726F,$7574; $03FBA0
    dc.w    $6573,$2061,$6E64,$206F,$7065,$6E20,$6E65,$7720; $03FBB0
    dc.w    $6F6E,$6573,$2069,$6E20,$7265,$6769,$6F6E,$7320; $03FBC0
    dc.w    $7768,$6572,$6520,$7765,$2772,$6520,$7765,$616B; $03FBD0
    dc.w    $2E00,$416E,$2061,$6972,$6C69,$6E65,$2069,$7320; $03FBE0
    dc.w    $6F6E,$6C79,$2061,$6C6C,$6F77,$6564,$2074,$6F20; $03FBF0
    dc.w    $6F70,$6572,$6174,$6520,$3430,$2072,$6F75,$7465; $03FC00
    dc.w    $732E,$00FF,$4966,$2079,$6F75,$2064,$6F6E,$2774; $03FC10
    dc.w    $2074,$6572,$6D69,$6E61,$7465,$2073,$6F6D,$6520; $03FC20
    dc.w    $726F,$7574,$6573,$2079,$6F75,$2063,$616E,$2774; $03FC30
    dc.w    $206F,$7065,$6E20,$6E65,$7720,$6F6E,$6573,$2E00; $03FC40
    dc.w    $4927,$6D20,$7375,$7265,$2077,$6520,$6861,$7665; $03FC50
    dc.w    $2061,$2066,$6577,$2072,$6F75,$7465,$7320,$7468; $03FC60
    dc.w    $6174,$2063,$6F75,$6C64,$2062,$6520,$636C,$6F73; $03FC70
    dc.w    $6564,$2061,$6E64,$2072,$6570,$6C61,$6365,$6420; $03FC80
    dc.w    $6279,$2073,$6F6D,$6574,$6869,$6E67,$206D,$6F72; $03FC90
    dc.w    $6520,$7072,$6F66,$6974,$6162,$6C65,$2E00,$4F75; $03FCA0
    dc.w    $7220,$636F,$6D70,$616E,$7927,$7320,$726F,$7574; $03FCB0
    dc.w    $6573,$2061,$6C72,$6561,$6479,$2063,$6F76,$6572; $03FCC0
    dc.w    $2065,$7665,$7279,$2072,$6567,$696F,$6E20,$6F6E; $03FCD0
    dc.w    $2074,$6865,$2067,$6C6F,$6265,$2E00,$2573,$2055; $03FCE0
    dc.w    $7365,$2074,$6865,$2063,$6F6E,$7472,$6F6C,$2070; $03FCF0
    dc.w    $6164,$2074,$6F20,$7365,$6C65,$6374,$2061,$2072; $03FD00
    dc.w    $6F75,$7465,$2E00,$5768,$6963,$6820,$726F,$7574; $03FD10
    dc.w    $6520,$7368,$6F75,$6C64,$2077,$6520,$6469,$7363; $03FD20
    dc.w    $7573,$733F,$0A0A,$436F,$6E74,$726F,$6C20,$5061; $03FD30
    dc.w    $643A,$0A20,$4C2F,$5220,$746F,$2063,$6861,$6E67; $03FD40
    dc.w    $6520,$7265,$6769,$6F6E,$0A20,$552F,$4420,$746F; $03FD50
    dc.w    $2063,$6861,$6E67,$6520,$726F,$7574,$6500,$4D65; $03FD60
    dc.w    $6574,$696E,$6720,$6973,$2061,$646A,$6F75,$726E; $03FD70
    dc.w    $6564,$2E00,$5368,$616C,$6C20,$7765,$2061,$646A; $03FD80
    dc.w    $6F75,$726E,$2061,$6E64,$206D,$6565,$7420,$6167; $03FD90
    dc.w    $6169,$6E20,$6C61,$7465,$723F,$00FF,$506C,$6561; $03FDA0
    dc.w    $7365,$2063,$686F,$6F73,$6520,$6120,$746F,$7069; $03FDB0
    dc.w    $6320,$666F,$7220,$6469,$7363,$7573,$7369,$6F6E; $03FDC0
    dc.w    $2E00,$4920,$6361,$6C6C,$2074,$6869,$7320,$6D65; $03FDD0
    dc.w    $6574,$696E,$6720,$746F,$206F,$7264,$6572,$2E00; $03FDE0
    dc.w    $5368,$616C,$6C20,$4920,$636F,$6E64,$7563,$7420; $03FDF0
    dc.w    $7468,$6520,$6D65,$6574,$696E,$673F,$00FF,$2573; $03FE00
    dc.w    $206C,$6574,$2773,$2064,$6973,$6375,$7373,$2025; $03FE10
    dc.w    $732E,$00FF,$4E65,$7874,$2C00,$536F,$2C00,$4669; $03FE20
    dc.w    $7273,$742C,$00FF,$6275,$7369,$6E65,$7373,$2076; $03FE30
    dc.w    $656E,$7475,$7265,$7300,$6F75,$7220,$706C,$616E; $03FE40
    dc.w    $6520,$686F,$6C64,$696E,$6773,$00FF,$6164,$6A75; $03FE50
    dc.w    $7374,$696E,$6720,$6578,$6973,$7469,$6E67,$2072; $03FE60
    dc.w    $6F75,$7465,$7300,$6F70,$656E,$696E,$6720,$6E65; $03FE70
    dc.w    $7720,$726F,$7574,$6573,$00FF,$6169,$7263,$7261; $03FE80
    dc.w    $6674,$00FF,$4920,$6B6E,$6F77,$2077,$6520,$6E65; $03FE90
    dc.w    $6564,$206E,$6577,$2072,$6F75,$7465,$732C,$2062; $03FEA0
    dc.w    $7574,$2049,$2064,$6F6E,$2774,$2072,$6561,$6C6C; $03FEB0
    dc.w    $7920,$6861,$7665,$2061,$6E79,$2067,$6F6F,$6420; $03FEC0
    dc.w    $6964,$6561,$732E,$00FF,$596F,$7527,$6C6C,$2077; $03FED0
    dc.w    $616E,$7420,$746F,$2065,$7374,$6162,$6C69,$7368; $03FEE0
    dc.w    $2073,$6572,$7669,$6365,$2062,$6574,$7765,$656E; $03FEF0
    dc.w    $2025,$7320,$616E,$6420,$2573,$2C20,$6F66,$2063; $03FF00
    dc.w    $6F75,$7273,$652E,$2048,$6F77,$2061,$626F,$7574; $03FF10
    dc.w    $2025,$733F,$00FF,$4C65,$7427,$7320,$616C,$736F; $03FF20
    dc.w    $206F,$7065,$6E20,$6120,$726F,$7574,$6520,$2573; $03FF30
    dc.w    $2E00,$4F72,$2025,$7320,$776F,$756C,$6420,$6265; $03FF40
    dc.w    $2067,$6F6F,$642E,$00FF,$486F,$7720,$6162,$6F75; $03FF50
    dc.w    $7420,$6120,$726F,$7574,$6520,$2573,$3F00,$5765; $03FF60
    dc.w    $2063,$6F75,$6C64,$206C,$6F77,$6572,$2066,$6172; $03FF70
    dc.w    $6573,$2061,$6E64,$2067,$6976,$6520,$7072,$696F; $03FF80
    dc.w    $7269,$7479,$2074,$6F20,$766F,$6C75,$6D65,$206F; $03FF90
    dc.w    $7665,$7220,$7065,$722D,$7365,$6174,$2070,$726F; $03FFA0
    dc.w    $6669,$7420,$6D61,$7267,$696E,$732E,$00FF,$5265; $03FFB0
    dc.w    $6C61,$7469,$6F6E,$7320,$6265,$7477,$6565,$6E20; $03FFC0
    dc.w    $2573,$2061,$6E64,$2025,$7320,$6172,$6520,$7374; $03FFD0
    dc.w    $7261,$696E,$6564,$2E00,$5765,$2073,$686F,$756C; $03FFE0
    dc.w    $6420,$6275,$7920,$6275,$7369,$6E65,$7373,$6573; $03FFF0

