; ============================================================================
; BuildRouteLoop -- Drives the interactive route-building phase for the current player: loops calling the route-selection function until the player passes, then invokes revenue and char-advantage calculations to finalise the new route.
; Called: ?? times.
; 220 bytes | $027F18-$027FF3
; ============================================================================
BuildRouteLoop:                                                  ; $027F18
    movem.l d2-d4/a2,-(sp)
    moveq   #$0,d4
    move.b  ($00FF0016).l,d4
    move.w  ($00FF9A1C).l,d3
.l27f2a:                                                ; $027F2A
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$12ee                           ; jsr $0112EE
    lea     $0014(sp),sp
    move.w  d0,d2
    cmpi.w  #$4,d2
    bge.b   .l27f8e
    move.w  d4,d0
    lsl.w   #$5,d0
    move.w  d2,d1
    lsl.w   #$3,d1
    add.w   d1,d0
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    tst.b   $0001(a2)
    bne.b   .l27faa
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0070                                 ; jsr $027FF4
    nop
    lea     $000c(sp),sp
    bra.b   .l27fa8
.l27f8e:                                                ; $027F8E
    cmpi.w  #$4,d2
    bne.b   .l27faa
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$05d4                                 ; jsr $028576
    nop
    addq.l  #$8,sp
.l27fa8:                                                ; $027FA8
    move.w  d0,d3
.l27faa:                                                ; $027FAA
    cmpi.w  #$ff,d2
    bne.w   .l27f2a
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    lea     $0018(sp),sp
    movem.l (sp)+,d2-d4/a2
    rts
; === Translated block $027FF4-$028B46 ===
; 5 functions, 2898 bytes
