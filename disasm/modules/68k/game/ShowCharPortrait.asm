; ============================================================================
; ShowCharPortrait -- Renders a character portrait sprite to screen: loads portrait tiles from the char index, calls LoadGraphicLine for each row, then draws portrait and name panel at the given screen coords
; Called: 8 times.
; 504 bytes | $03A5A8-$03A79F
; ============================================================================
ShowCharPortrait:                                                  ; $03A5A8
    link    a6,#-$4
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $001c(a6),d2
    move.l  $0010(a6),d4
    move.l  $000c(a6),d5
    move.l  $0008(a6),d6
    movea.l #$0d64,a3
    movea.l #$0007bad6,a4
    movea.l #$3fec,a5
    move.w  #$0222,-$0002(a6)
    pea     ($0001).w
    pea     ($000F).w
    cmpi.w  #$4,d2
    bne.b   .l3a5ec
    pea     -$0002(a6)
    bra.b   .l3a5fa
.l3a5ec:                                                ; $03A5EC
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$00076520,a0
    pea     (a0,d0.w)
.l3a5fa:                                                ; $03A5FA
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    movea.l #$00ff1278,a0
    move.b  (a0,d6.w),d0
    andi.l  #$ff,d0
    moveq   #$35,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    mulu.w  #$a,d0
    movea.l #$00048656,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  (a2)+,d2
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a4,a0.l),-(sp)
    pea     ($00FFAA64).l
    jsr     (a5)
    lea     $0014(sp),sp
    moveq   #$1,d3
.l3a646:                                                ; $03A646
    move.w  (a2)+,d2
    cmpi.w  #$ff,d2
    beq.b   .l3a6aa
    cmpi.w  #$2,d3
    beq.b   .l3a660
    cmpi.w  #$3,d3
    beq.b   .l3a660
    cmpi.w  #$31,d2
    bne.b   .l3a686
.l3a660:                                                ; $03A660
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a4,a0.l),-(sp)
    pea     ($00FFA7E4).l
    jsr     (a5)
    move.w  d2,d0
    addi.w  #$ffeb,d0
    move.l  d0,-(sp)
    bsr.w LoadGraphicLine
    lea     $000c(sp),sp
    addq.w  #$1,d2
.l3a686:                                                ; $03A686
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a4,a0.l),-(sp)
    pea     ($00FFA7E4).l
    jsr     (a5)
    move.w  d2,d0
    addi.w  #$ffeb,d0
    move.l  d0,-(sp)
    bsr.w LoadGraphicLine
    lea     $000c(sp),sp
.l3a6aa:                                                ; $03A6AA
    addq.w  #$1,d3
    cmpi.w  #$5,d3
    bcs.b   .l3a646
    pea     ($0054).w
    pea     ($0640).w
    pea     ($00FFAA64).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    pea     ($064C).w
    pea     ($0008).w
    pea     ($000E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $0028(sp),sp
    pea     ($00070000).l
    pea     ($0007).w
    pea     ($000C).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  $0016(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $001c(sp),sp
    tst.w   $001a(a6)
    beq.b   .l3a796
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0009).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $002c(sp),sp
    move.w  d4,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    movea.l #$00ff1278,a0
    move.b  (a0,d6.w),d0
    andi.l  #$ff,d0
    lsl.w   #$2,d0
    movea.l #$0005ecfc,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($00045030).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
.l3a796:                                                ; $03A796
    movem.l -$0028(a6),d2-d6/a2-a5
    unlk    a6
    rts
