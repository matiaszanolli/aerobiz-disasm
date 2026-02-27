; ============================================================================
; CountMatchingChars -- Count roster entries for player D3 matching char code D4 via BitFieldSearch
; Called: ?? times.
; 166 bytes | $0074F8-$00759D
; ============================================================================
CountMatchingChars:                                                  ; $0074F8
    movem.l d2-d5/a2-a3,-(sp)
    move.l  $001c(sp),d3
    move.l  $0020(sp),d4
    clr.w   d2
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w BitFieldSearch
    lea     $000c(sp),sp
    move.w  d0,d5
    cmpi.w  #$ff,d5
    bne.b   .l7534
    clr.w   d2
    bra.b   .l7596
.l7534:                                                 ; $007534
    move.w  d3,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0004(a3),d0
    mulu.w  #$14,d0
    move.w  d3,d1
    mulu.w  #$0320,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d3
    bra.b   .l758c
.l7568:                                                 ; $007568
    moveq   #$0,d0
    move.b  (a2),d0
    cmp.w   d4,d0
    bne.b   .l7574
.l7570:                                                 ; $007570
    addq.w  #$1,d2
    bra.b   .l7586
.l7574:                                                 ; $007574
    moveq   #$0,d0
    move.b  $0001(a2),d0
    cmp.w   d4,d0
    beq.b   .l7570
    moveq   #$0,d0
    move.b  (a2),d0
    cmp.w   d5,d0
    bhi.b   .l7596
.l7586:                                                 ; $007586
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d3
.l758c:                                                 ; $00758C
    moveq   #$0,d0
    move.b  $0005(a3),d0
    cmp.w   d3,d0
    bhi.b   .l7568
.l7596:                                                 ; $007596
    move.w  d2,d0
    movem.l (sp)+,d2-d5/a2-a3
    rts
