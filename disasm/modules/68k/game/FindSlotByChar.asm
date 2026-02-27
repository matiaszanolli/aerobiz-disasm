; ============================================================================
; FindSlotByChar -- Search low ($FF0420) or high ($FF0460) char code table for given code; return 1 if found
; Called: ?? times.
; 92 bytes | $007728-$007783
; ============================================================================
FindSlotByChar:                                                  ; $007728
    movem.l d2-d4,-(sp)
    move.l  $0014(sp),d2
    move.l  $0010(sp),d4
    cmpi.w  #$20,d2
    bcc.b   .l7750
    move.w  d2,d0
    mulu.w  #$6,d0
    movea.l #$00ff0420,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$6,d3
    bra.b   .l7762
.l7750:                                                 ; $007750
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff0460,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$4,d3
.l7762:                                                 ; $007762
    clr.w   d1
    clr.w   d2
    bra.b   .l7778
.l7768:                                                 ; $007768
    moveq   #$0,d0
    move.b  (a1),d0
    cmp.w   d4,d0
    bne.b   .l7774
    moveq   #$1,d1
    bra.b   .l777c
.l7774:                                                 ; $007774
    addq.l  #$1,a1
    addq.w  #$1,d2
.l7778:                                                 ; $007778
    cmp.w   d3,d2
    bcs.b   .l7768
.l777c:                                                 ; $00777C
    move.w  d1,d0
    movem.l (sp)+,d2-d4
    rts
