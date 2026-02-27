; ============================================================================
; FindOpenSlot -- Search player's domestic and international char slots for one whose value is below player cash, return 1 if found
; Called: ?? times.
; 278 bytes | $00FDC4-$00FED9
; ============================================================================
FindOpenSlot:                                                  ; $00FDC4
    link    a6,#-$4
    movem.l d2-d7/a2-a3,-(sp)
    move.l  $000c(a6),d6
    movea.l $0008(a6),a3
    move.w  d6,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  (a3),d0
    move.w  d0,-$0002(a6)
    moveq   #$0,d7
    move.b  $0001(a3),d7
    clr.w   d5
.lfdf6:                                                 ; $00FDF6
    tst.w   d5
    bne.b   .lfe00
    move.w  -$0002(a6),d4
    bra.b   .lfe02
.lfe00:                                                 ; $00FE00
    move.w  d7,d4
.lfe02:                                                 ; $00FE02
    ext.l   d4
    cmpi.w  #$20,d4
    blt.b   .lfe68
    clr.w   d2
.lfe0c:                                                 ; $00FE0C
    move.w  d4,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff0460,a0
    cmpi.b  #$ff,(a0,d0.w)
    bne.b   .lfe5e
    move.w  d4,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff15a0,a0
    move.b  (a0,d0.w),d3
    andi.l  #$ff,d3
    cmpi.w  #$f,d3
    beq.b   .lfe5e
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d3
    cmp.l   $0006(a2),d3
    bgt.b   .lfe5e
.lfe5a:                                                 ; $00FE5A
    moveq   #$1,d0
    bra.b   .lfed0
.lfe5e:                                                 ; $00FE5E
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .lfe0c
    bra.b   .lfec4
.lfe68:                                                 ; $00FE68
    clr.w   d2
.lfe6a:                                                 ; $00FE6A
    move.w  d4,d0
    mulu.w  #$6,d0
    add.w   d2,d0
    movea.l #$00ff0420,a0
    cmpi.b  #$ff,(a0,d0.w)
    bne.b   .lfebc
    move.w  d4,d0
    mulu.w  #$6,d0
    add.w   d2,d0
    movea.l #$00ff1704,a0
    move.b  (a0,d0.w),d3
    andi.l  #$ff,d3
    cmpi.w  #$f,d3
    beq.b   .lfebc
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d3
    cmp.l   $0006(a2),d3
    ble.b   .lfe5a
.lfebc:                                                 ; $00FEBC
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .lfe6a
.lfec4:                                                 ; $00FEC4
    addq.w  #$1,d5
    cmpi.w  #$2,d5
    blt.w   .lfdf6
    moveq   #$0,d0
.lfed0:                                                 ; $00FED0
    movem.l -$0024(a6),d2-d7/a2-a3
    unlk    a6
    rts
