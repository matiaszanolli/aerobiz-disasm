; ============================================================================
; CalcQuarterBonus -- Computes a quarter-scaled bonus percentage for a relation slot revenue value; multiplies by 20, divides by turn-modulo-3, clamps to 100, and returns percentage.
; Called: ?? times.
; 60 bytes | $0140DC-$014117
; ============================================================================
CalcQuarterBonus:                                                  ; $0140DC
    move.l  d2,-(sp)
    move.w  $000a(sp),d2
    ext.l   d2
    move.l  d2,d0
    lsl.l   #$2,d2
    add.l   d0,d2
    lsl.l   #$2,d2
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$1e,d0
    move.l  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    move.l  (sp)+,d2
    rts
; === Translated block $014118-$014202 ===
; 1 functions, 234 bytes
