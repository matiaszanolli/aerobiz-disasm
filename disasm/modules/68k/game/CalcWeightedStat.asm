; ============================================================================
; CalcWeightedStat -- Look up stat via GetCharStat, apply weighted multiplier from table, scale and clamp result
; Called: 8 times.
; 180 bytes | $008016-$0080C9
; ============================================================================
CalcWeightedStat:                                                  ; $008016
    movem.l d2-d4/a2,-(sp)
    move.l  $0018(sp),d3
    move.l  $0014(sp),d4
    moveq   #$64,d2
    move.w  d3,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  (a2),d0
    movea.l #$0005f07c,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$1d3c                                 ; jsr $009D92
    nop
    addq.l  #$8,sp
    move.w  d0,d3
    cmpi.w  #$3,d3
    bne.b   .l806a
    move.w  #$ffff,d4
    bra.b   .l80c2
.l806a:                                                 ; $00806A
    tst.w   d3
    bne.b   .l8072
    moveq   #$5a,d2
    bra.b   .l8084
.l8072:                                                 ; $008072
    cmpi.w  #$1,d3
    bne.b   .l807c
    moveq   #$64,d2
    bra.b   .l8084
.l807c:                                                 ; $00807C
    cmpi.w  #$2,d3
    bne.b   .l8084
    moveq   #$6e,d2
.l8084:                                                 ; $008084
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0032                                 ; jsr $0080CA
    nop
    addq.l  #$8,sp
    cmpi.w  #$1,d0
    bne.b   .l80a8
    subi.w  #$a,d2
.l80a8:                                                 ; $0080A8
    moveq   #$0,d0
    move.w  $0004(a2),d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d4
.l80c2:                                                 ; $0080C2
    move.w  d4,d0
    movem.l (sp)+,d2-d4/a2
    rts
    dc.w    $48E7,$3C30,$2A2F                                ; $0080CA
; === Translated block $0080D0-$00814A ===
; 1 functions, 122 bytes
