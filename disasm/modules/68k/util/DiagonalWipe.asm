; ============================================================================
; DiagonalWipe -- Performs a tiled diagonal wipe transition by expanding a strip of tiles outward from a start position using random step sizes until the full screen span is covered
; Called: ?? times.
; 510 bytes | $01ACBA-$01AEB7
; ============================================================================
DiagonalWipe:                                                  ; $01ACBA
    movem.l d2-d7/a2-a3,-(sp)
    move.l  $0028(sp),d4
    move.l  $0024(sp),d5
    move.l  $002c(sp),d7
    movea.l #$0d64,a2
    movea.l #$0001e044,a3
    move.w  #$0750,d6
    clr.w   d2
    clr.w   d3
    cmpi.w  #$1,d7
    bne.w   .l1adb8
    lsl.w   #$3,d5
    addi.w  #$3c,d5
    lsl.w   #$3,d4
    addi.w  #$a,d4
    pea     ($0004).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
    addq.l  #$4,sp
    bra.b   .l1ad46
.l1ad00:                                                ; $01AD00
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$2,d0
    add.w   d0,d2
.l1ad46:                                                ; $01AD46
    cmpi.w  #$14,d2
    blt.b   .l1ad00
    bra.b   .l1adae
.l1ad4e:                                                ; $01AD4E
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d2
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d3
    addq.w  #$1,d2
    addq.w  #$1,d3
.l1adae:                                                ; $01ADAE
    cmpi.w  #$22,d3
    blt.b   .l1ad4e
    bra.w   .l1ae9a
.l1adb8:                                                ; $01ADB8
    move.w  d5,d0
    lsl.w   #$3,d0
    move.w  d0,d5
    move.w  d4,d0
    lsl.w   #$3,d0
    move.w  d0,d4
    pea     ($0005).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
    addq.l  #$4,sp
    bra.b   .l1ae3c
.l1add2:                                                ; $01ADD2
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.w  d2,d0
    ext.l   d0
    moveq   #$36,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d2
    move.w  d2,d0
    ext.l   d0
    moveq   #$36,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d3
.l1ae3c:                                                ; $01AE3C
    cmpi.w  #$22,d3
    blt.b   .l1add2
    bra.b   .l1ae94
.l1ae44:                                                ; $01AE44
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d2
    addq.w  #$1,d2
.l1ae94:                                                ; $01AE94
    cmpi.w  #$36,d2
    blt.b   .l1ae44
.l1ae9a:                                                ; $01AE9A
    pea     ($0018).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000F).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    lea     $000c(sp),sp
    movem.l (sp)+,d2-d7/a2-a3
    rts
ShowPlayerCompare:                                                  ; $01AEB8
    link    a6,#$0
    movem.l d2-d7/a2,-(sp)
    move.l  $001c(a6),d5
    move.l  $0010(a6),d6
    move.l  $0008(a6),d7
    movea.l #$0d64,a2
    cmp.w   d6,d7
    bne.b   .l1aee2
    move.w  #$0770,d4
    move.w  #$0771,d3
    bra.w   .l1af88
.l1aee2:                                                ; $01AEE2
    move.w  #$0772,d4
    move.w  #$0773,d3
    bra.w   .l1af88
.l1aeee:                                                ; $01AEEE
    cmpi.w  #$1,d2
    bne.b   .l1af6c
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0039).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  $0016(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($003A).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    clr.w   d2
    bra.b   .l1af8a
.l1af6c:                                                ; $01AF6C
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0010(sp),sp
.l1af88:                                                ; $01AF88
    moveq   #$1,d2
.l1af8a:                                                ; $01AF8A
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
    addq.l  #$4,sp
    move.w  d0,d5
    ext.l   d0
    moveq   #$0,d1
    move.w  $001a(a6),d1
    and.l   d1,d0
    beq.w   .l1aeee
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    move.w  d5,d0
    movem.l -$001c(a6),d2-d7/a2
    unlk    a6
    rts
; ---------------------------------------------------------------------------
GetModeRowOffset:                                                  ; $01AFCA
    move.l  $0008(sp),d1
    tst.w   d1
    bne.b   .l1afd6
    moveq   #$2a,d1
    bra.b   .l1afec
.l1afd6:                                                ; $01AFD6
    cmpi.w  #$1,d1
    bne.b   .l1afe0
    moveq   #$26,d1
    bra.b   .l1afec
.l1afe0:                                                ; $01AFE0
    cmpi.w  #$2,d1
    bne.b   .l1afea
    moveq   #$22,d1
    bra.b   .l1afec
.l1afea:                                                ; $01AFEA
    moveq   #$19,d1
.l1afec:                                                ; $01AFEC
    move.w  d1,d0
    rts
