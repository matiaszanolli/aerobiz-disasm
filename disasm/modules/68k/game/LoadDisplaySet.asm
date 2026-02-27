; ============================================================================
; LoadDisplaySet -- Load triple-pointer display resource set from table
; Called: 16 times.
; 220 bytes | $01D444-$01D51F
; ============================================================================
LoadDisplaySet:                                                  ; $01D444
    movem.l d2-d3/a2-a5,-(sp)
    move.l  $001c(sp),d3
    movea.l #$0d64,a5
    move.w  ($00FF1274).l,d0
    andi.l  #$0100,d0
    cmpi.l  #$0100,d0
    bne.w   .l1d518
    tst.w   d3
    blt.w   .l1d518
    cmpi.w  #$17,d3
    bgt.w   .l1d518
    move.w  d3,d0
    mulu.w  #$6,d0
    movea.l #$00047cec,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  (a0),d0
    move.w  d0,d2
    cmpi.w  #$ff,d0
    bne.b   .l1d498
    moveq   #$0,d0
    movea.l d0,a4
    bra.b   .l1d4a8
.l1d498:                                                ; $01D498
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$000fc0ca,a0
    movea.l (a0,d0.l),a4
.l1d4a8:                                                ; $01D4A8
    move.w  $0002(a2),d0
    move.w  d0,d2
    cmpi.w  #$ff,d0
    bne.b   .l1d4ba
    moveq   #$0,d0
    movea.l d0,a3
    bra.b   .l1d4ca
.l1d4ba:                                                ; $01D4BA
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$000fc0ca,a0
    movea.l (a0,d0.l),a3
.l1d4ca:                                                ; $01D4CA
    move.w  $0004(a2),d0
    move.w  d0,d2
    cmpi.w  #$ff,d0
    bne.b   .l1d4dc
    moveq   #$0,d0
    movea.l d0,a2
    bra.b   .l1d4ec
.l1d4dc:                                                ; $01D4DC
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$000fc052,a0
    movea.l (a0,d0.l),a2
.l1d4ec:                                                ; $01D4EC
    pea     ($0018).w
    jsr     (a5)
    move.l  a2,-(sp)
    move.l  a3,-(sp)
    move.l  a4,-(sp)
    pea     ($0016).w
    jsr     (a5)
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$000fc13e,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($0017).w
    jsr     (a5)
    lea     $001c(sp),sp
.l1d518:                                                ; $01D518
    moveq   #$0,d0
    movem.l (sp)+,d2-d3/a2-a5
    rts
