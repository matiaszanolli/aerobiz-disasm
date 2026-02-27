; ============================================================================
; CalcCharScore -- Calculates a character's score value: derives years-until-retirement from the current year and the character's age field, multiplies by the salary modifier, clamps to 100, and returns the result
; Called: ?? times.
; 90 bytes | $02F4EE-$02F547
; ============================================================================
CalcCharScore:                                                  ; $02F4EE
    movem.l d2/a2,-(sp)
    move.w  $000e(sp),d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l2f512
    addq.l  #$3,d0
.l2f512:                                                ; $02F512
    asr.l   #$2,d0
    addi.w  #$37,d0
    move.w  d0,d2
    ext.l   d0
    moveq   #$3c,d1
    sub.l   d0,d1
    moveq   #$0,d0
    move.b  $0006(a2),d0
    ext.l   d0
    add.l   d0,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.w  $0004(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    movem.l (sp)+,d2/a2
    rts
