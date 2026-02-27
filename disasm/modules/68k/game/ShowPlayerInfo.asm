; ============================================================================
; ShowPlayerInfo -- Display player info screen with formatted data
; Called: 12 times.
; 274 bytes | $01C43C-$01C54D
; ============================================================================
ShowPlayerInfo:                                                  ; $01C43C
    movem.l d2/a2,-(sp)
    move.l  $000c(sp),d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    pea     ($0001).w
    pea     ($000F).w
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$00076520,a0
    pea     (a0,d0.w)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0004975E).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($0008).w
    pea     ($0328).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0028(sp),sp
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0016).w
    pea     ($0019).w
    pea     ($0009).w
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    pea     ($00049706).l
    pea     ($0002).w
    pea     ($0016).w
    pea     ($0019).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $002c(sp),sp
    pea     ($0019).w
    pea     ($000A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d2,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    pea     ($00041158).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($0019).w
    pea     ($0013).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.l  $0006(a2),-(sp)
    pea     ($00041152).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0020(sp),sp
    movem.l (sp)+,d2/a2
    rts
; === Translated block $01C54E-$01D310 ===
; 6 functions, 3522 bytes
