; ============================================================================
; ShowCharCompare -- Display character comparison panel: compute output and value, show stats, portrait, delta, and return win/lose flag
; Called: ?? times.
; 504 bytes | $00E6B2-$00E8A9
; ============================================================================
ShowCharCompare:                                                  ; $00E6B2
    link    a6,#-$8
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0008(a6),d2
    move.l  $000c(a6),d3
    move.l  $0014(a6),d4
    movea.l #$0003ab2c,a2
    movea.l #$0003b246,a3
    lea     -$0008(a6),a4
    lea     -$0004(a6),a5
    clr.w   d5
    move.w  ($00FF0006).l,d6
    ext.l   d6
    subq.l  #$1,d6
    ble.b   .le6f4
    move.w  ($00FF0006).l,d6
    ext.l   d6
    subq.l  #$1,d6
    bra.b   .le6f6
.le6f4:                                                 ; $00E6F4
    moveq   #$0,d6
.le6f6:                                                 ; $00E6F6
    pea     -$0008(a6)
    pea     -$0004(a6)
    move.w  $0012(a6),d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$969a                           ; jsr $00969A
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    bsr.w CalcCharValue
    lea     $0024(sp),sp
    move.l  d0,d2
    move.l  #$8000,-(sp)
    pea     ($0011).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0028(sp),sp
    pea     ($0010).w
    pea     ($001E).w
    pea     ($0002).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    pea     ($0010).w
    pea     ($001F).w
    pea     ($0002).w
    pea     ($0001).w
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0020(sp),sp
    pea     ($0001).w
    pea     ($06A0).w
    pea     ($0037).w
    pea     ($0018).w
    pea     ($0010).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$883a                           ; jsr $00883A
    pea     ($0003).w
    pea     ($0005).w
    jsr     (a2)
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003E93C).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($0006).w
    pea     ($0002).w
    jsr     (a2)
    lea     $0030(sp),sp
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003E938).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($0640).w
    pea     ($000A).w
    pea     ($0003).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0278                                 ; jsr $00EA86
    nop
    pea     ($0008).w
    pea     ($000B).w
    jsr     (a2)
    move.l  (a5),-(sp)
    pea     ($0003E92A).l
    jsr     (a3)
    pea     ($000A).w
    pea     ($000B).w
    jsr     (a2)
    lea     $0030(sp),sp
    move.l  (a4),-(sp)
    pea     ($0003E91A).l
    jsr     (a3)
    pea     ($000C).w
    pea     ($000B).w
    jsr     (a2)
    move.w  $0002(a5),d0
    sub.w   $0002(a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003E90E).l
    jsr     (a3)
    pea     ($000E).w
    pea     ($000B).w
    jsr     (a2)
    move.l  d2,-(sp)
    pea     ($0003E902).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($000B).w
    jsr     (a2)
    lea     $0030(sp),sp
    move.l  d2,d0
    bge.b   .le884
    addq.l  #$3,d0
.le884:                                                 ; $00E884
    asr.l   #$2,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0003E8F4).l
    jsr     (a3)
    move.l  (a5),d0
    cmp.l   (a4),d0
    ble.b   .le89e
    moveq   #$1,d5
.le89e:                                                 ; $00E89E
    move.w  d5,d0
    movem.l -$002c(a6),d2-d6/a2-a5
    unlk    a6
    rts

; === Translated block $00E8AA-$00EB28 ===
; 2 functions, 638 bytes
