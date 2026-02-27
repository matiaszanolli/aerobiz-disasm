; ============================================================================
; GetPlayerCharCount -- Returns count of char slots occupied by the given player (via BitFieldSearch)
; 56 bytes | $036EDA-$036F11
; ============================================================================
GetPlayerCharCount:
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
    jsr BitFieldSearch
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
