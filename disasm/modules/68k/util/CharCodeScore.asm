; ============================================================================
; CharCodeScore -- Compute percentage match score for two character codes
; Called: 12 times. Args (stack, no link): $C(SP)=code1 (w), $10(SP)=code2 (w)
; Returns: D0.W = percentage score, or $FFFF if no match
; ============================================================================
CharCodeScore:                                               ; $0070DC
    movem.l d2-d3,-(sp)
    move.l  $000C(sp),d2                                 ; D2 = code1
    move.l  $0010(sp),d3                                 ; D3 = code2
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                                     ; push D3 sign-extended
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                                     ; push D2 sign-extended
    bsr.w CharCodeCompare
    addq.l  #8,sp                                        ; clean 2 args
    move.w  d0,d2                                        ; D2 = compare result
    tst.w   d2                                           ; result == 0?
    beq.s   .no_match
    cmpi.w  #$FFFF,d2
    bne.s   .has_result
.no_match:                                               ; $007106
    move.w  #$FFFF,d2
    bra.s   .scale
.has_result:                                             ; $00710C
    moveq   #0,d0
    move.w  d2,d0
    asr.l   #2,d0
    addi.l  #$78,d0
    moveq   #$0A,d1
    jsr SignedDiv
    dc.w    $C0FC,$000A                                  ; and.w #$000A,d0
    move.w  d0,d2
.scale:                                                  ; $007126
    move.w  ($00FF0002).l,d0
    ext.l   d0
    moveq   #3,d1
    sub.l   d0,d1
    move.l  d1,d0
    add.l   d0,d0
    add.l   d1,d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #0,d1
    move.w  d2,d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0,d2                                        ; D2 = final result
    movem.l (sp)+,d2-d3
    rts
