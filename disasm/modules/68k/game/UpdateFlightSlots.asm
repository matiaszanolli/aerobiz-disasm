; ============================================================================
; UpdateFlightSlots -- For the given display mode and player, counts active relation/route bits and fills in up to two free flight slot entries at $FF153C with flight path parameters
; ============================================================================
UpdateFlightSlots:                                                  ; $01A672
    movem.l d2-d6/a2-a3,-(sp)
    move.l  $0024(sp),d4
    move.l  $0020(sp),d5
    movea.l #$00ff153c,a3
    tst.w   ($00FF000A).l
    beq.w   .l1a78c
    cmpi.w  #$1,d4
    bne.w   .l1a75a
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d4
    clr.w   d3
    bra.b   .l1a720
.l1a6ac:                                                ; $01A6AC
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$00ffa6a0,a0
    move.l  (a0,d0.w),d2
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005ecdc,a0
    and.l   (a0,d0.w),d2
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d2,d1
    lsr.l   d0,d1
    move.l  d1,d2
    bra.b   .l1a6e2
.l1a6d4:                                                ; $01A6D4
    btst    #$00,d2
    beq.b   .l1a6dc
    addq.w  #$1,d3
.l1a6dc:                                                ; $01A6DC
    move.l  d2,d0
    lsr.l   #$1,d0
    move.l  d0,d2
.l1a6e2:                                                ; $01A6E2
    tst.l   d2
    beq.b   .l1a6ec
    cmpi.w  #$6,d3
    blt.b   .l1a6d4
.l1a6ec:                                                ; $01A6EC
    move.w  d4,d0
    mulu.w  #$e,d0
    move.w  d5,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffbd6c,a0
    move.w  (a0,d0.w),d2
    bra.b   .l1a714
.l1a704:                                                ; $01A704
    move.w  d2,d0
    andi.w  #$1,d0
    beq.b   .l1a70e
    addq.w  #$1,d3
.l1a70e:                                                ; $01A70E
    move.w  d2,d0
    lsr.w   #$1,d0
    move.w  d0,d2
.l1a714:                                                ; $01A714
    tst.w   d2
    beq.b   .l1a71e
    cmpi.w  #$8,d3
    blt.b   .l1a704
.l1a71e:                                                ; $01A71E
    addq.w  #$1,d4
.l1a720:                                                ; $01A720
    cmpi.w  #$4,d4
    bge.b   .l1a72e
    cmpi.w  #$6,d3
    blt.w   .l1a6ac
.l1a72e:                                                ; $01A72E
    move.w  d3,d0
    asr.w   #$1,d0
    move.w  d0,d3
    cmpi.w  #$4,d3
    bge.b   .l1a75a
    move.w  d3,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$3,d0
    add.l   d1,d0
    add.l   d0,d0
    move.l  d0,d6
    movea.l d0,a0
    move.b  #$ff,$1(a3,a0.l)
    movea.l a3,a0
    adda.l  d6,a0
    move.b  #$ff,$0002(a0)
.l1a75a:                                                ; $01A75A
    movea.l a3,a2
    clr.w   d4
.l1a75e:                                                ; $01A75E
    cmpi.b  #$ff,$0001(a2)
    beq.b   .l1a78c
    move.w  $000c(a2),d0
    cmp.w   $000e(a2),d0
    bcs.b   .l1a780
    move.l  a2,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0018                                 ; jsr $01A792
    nop
    addq.l  #$8,sp
.l1a780:                                                ; $01A780
    moveq   #$12,d0
    adda.l  d0,a2
    addq.w  #$1,d4
    cmpi.w  #$4,d4
    blt.b   .l1a75e
.l1a78c:                                                ; $01A78C
    movem.l (sp)+,d2-d6/a2-a3
    rts
; ---------------------------------------------------------------------------
; === Translated block $01A790-$01ABAE ===
; 2 functions, 1054 bytes
