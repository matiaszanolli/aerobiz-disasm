; ============================================================================
; ProcessRouteAction -- Show route management screen, prompt player for action type, execute buy/assign/cancel, update route records
; Called: ?? times.
; 376 bytes | $00F5AA-$00F721
; ============================================================================
ProcessRouteAction:                                                  ; $00F5AA
    link    a6,#-$54
    movem.l d2-d5,-(sp)
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  ($00FF9A1C).l,d3
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0004).w
    pea     ($003B).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    clr.l   -(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $002c(sp),sp
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0566                                 ; jsr $00FB74
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.w   .lf6e6
.lf61e:                                                 ; $00F61E
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$12ee                           ; jsr $0112EE
    addq.l  #$8,sp
    move.w  d0,d4
    cmpi.w  #$4,d4
    bge.w   .lf6be
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    addq.l  #$8,sp
    move.w  d0,d5
    cmpi.w  #$ff,d0
    bne.b   .lf67a
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00f4                                 ; jsr $00F75E
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.b   .lf6de
    bra.b   .lf6e6
.lf67a:                                                 ; $00F67A
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA7A).l
    pea     -$0054(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     -$0054(a6)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$183a                           ; jsr $01183A
    lea     $0024(sp),sp
    bra.b   .lf6e6
.lf6be:                                                 ; $00F6BE
    cmpi.w  #$4,d4
    bne.b   .lf6de
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$05da                                 ; jsr $00FCAC
    nop
    addq.l  #$8,sp
    cmpi.w  #$1,d0
    beq.b   .lf6e6
.lf6de:                                                 ; $00F6DE
    cmpi.w  #$ff,d4
    bne.w   .lf61e
.lf6e6:                                                 ; $00F6E6
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    movem.l -$0064(a6),d2-d5
    unlk    a6
    rts
; === Translated block $00F722-$00FDC4 ===
; 4 functions, 1698 bytes
