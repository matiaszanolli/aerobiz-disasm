; ============================================================================
; CalcCharAdvantage -- Compute character advantage score from player ranking, city traffic stats, entity bitfield, and stat descriptors
; Called: ?? times.
; 518 bytes | $008458-$00865D
; ============================================================================
CalcCharAdvantage:                                                  ; $008458
    link    a6,#-$4
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $000c(a6),d6
    move.l  $0008(a6),d7
    lea     -$0002(a6),a5
    move.w  d7,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    move.w  d6,d0
    add.w   d0,d0
    movea.l #$00ff8824,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d6,d0
    lsl.w   #$3,d0
    move.w  d7,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffba80,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  (a2),d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    sub.w   d1,d0
    move.w  d0,(a5)
    moveq   #$4,d3
    cmpi.w  #$20,d6
    bge.b   .l84e8
    move.w  d7,d0
    lsl.w   #$4,d0
    movea.l #$00ff0230,a0
    move.w  (a0,d0.w),d4
    clr.w   d2
.l84ca:                                                 ; $0084CA
    move.w  d2,d0
    lsl.w   #$4,d0
    movea.l #$00ff0230,a0
    move.w  (a0,d0.w),d0
    cmp.w   d4,d0
    bcc.b   .l84de
    subq.w  #$1,d3
.l84de:                                                 ; $0084DE
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.b   .l84ca
    bra.b   .l8530
.l84e8:                                                 ; $0084E8
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,d5
    move.w  d7,d0
    lsl.w   #$4,d0
    move.w  d5,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ff0232,a0
    move.w  (a0,d0.w),d4
    clr.w   d2
.l850e:                                                 ; $00850E
    move.w  d2,d0
    lsl.w   #$4,d0
    move.w  d5,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ff0232,a0
    move.w  (a0,d0.w),d0
    cmp.w   d4,d0
    bcc.b   .l8528
    subq.w  #$1,d3
.l8528:                                                 ; $008528
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.b   .l850e
.l8530:                                                 ; $008530
    moveq   #$0,d0
    move.b  $0001(a4),d0
    move.w  d6,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l8542
    moveq   #$e,d2
    bra.b   .l854e
.l8542:                                                 ; $008542
    move.w  d3,d0
    mulu.w  #$3,d0
    moveq   #$e,d2
    sub.w   d0,d2
    addq.w  #$3,d2
.l854e:                                                 ; $00854E
    moveq   #$0,d0
    move.w  (a5),d0
    add.l   d0,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    ble.b   .l856a
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l8578
.l856a:                                                 ; $00856A
    moveq   #$0,d0
    move.w  (a5),d0
    add.l   d0,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
.l8578:                                                 ; $008578
    move.w  d0,d2
    cmpi.w  #$1,d2
    bls.b   .l8586
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l8588
.l8586:                                                 ; $008586
    moveq   #$1,d0
.l8588:                                                 ; $008588
    move.w  d0,d2
    cmpi.w  #$20,d6
    bge.b   .l85f0
    moveq   #$0,d0
    move.b  $0001(a4),d0
    cmp.w   d6,d0
    bne.b   .l85b4
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
.l85aa:                                                 ; $0085AA
    bge.b   .l85ae
    addq.l  #$3,d0
.l85ae:                                                 ; $0085AE
    asr.l   #$2,d0
.l85b0:                                                 ; $0085B0
    move.w  d0,d6
    bra.b   .l85f2
.l85b4:                                                 ; $0085B4
    move.w  d6,d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d7,d1
    lsl.w   #$2,d1
    movea.l #$00ff08ec,a0
    and.l   (a0,d1.w),d0
    beq.b   .l85e2
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    tst.l   d0
    bge.b   .l85de
    addq.l  #$1,d0
.l85de:                                                 ; $0085DE
    asr.l   #$1,d0
    bra.b   .l85b0
.l85e2:                                                 ; $0085E2
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    tst.l   d0
    bra.b   .l85aa
.l85f0:                                                 ; $0085F0
    moveq   #$e,d6
.l85f2:                                                 ; $0085F2
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$0,d1
    move.b  (a3),d1
    cmp.l   d1,d0
    ble.b   .l8650
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$0,d1
    move.b  (a3),d1
    andi.l  #$ffff,d1
    sub.l   d1,d0
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    ble.b   .l861c
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l862c
.l861c:                                                 ; $00861C
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$0,d1
    move.b  (a3),d1
    andi.l  #$ffff,d1
    sub.l   d1,d0
.l862c:                                                 ; $00862C
    move.w  d0,d2
    cmpi.w  #$e,d2
    bcc.b   .l863a
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l863c
.l863a:                                                 ; $00863A
    moveq   #$e,d0
.l863c:                                                 ; $00863C
    move.w  d0,d2
    cmp.w   (a5),d2
    bcc.b   .l8648
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l864c
.l8648:                                                 ; $008648
    moveq   #$0,d0
    move.w  (a5),d0
.l864c:                                                 ; $00864C
    move.w  d0,d2
    bra.b   .l8652
.l8650:                                                 ; $008650
    clr.w   d2
.l8652:                                                 ; $008652
    move.w  d2,d0
    movem.l -$002c(a6),d2-d7/a2-a5
    unlk    a6
    rts
