; ============================================================================
; ApplyCharBonus -- Applies accumulated skill bonus to player wealth and clears skill counters; returns 1 on success
; Called: ?? times.
; 126 bytes | $0357FE-$03587B
; ============================================================================
ApplyCharBonus:                                                  ; $0357FE
    movem.l d2-d4/a2-a3,-(sp)
    move.l  $0020(sp),d2
    move.l  $0018(sp),d3
    move.l  $001c(sp),d4
    move.w  d3,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d3,d0
    lsl.w   #$5,d0
    move.w  d4,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    blt.b   .l35872
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$f4ee                           ; jsr $02F4EE
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d3
    add.l   d3,$0006(a3)
    sub.b   d2,(a2)
    sub.b   d2,$0001(a2)
    moveq   #$1,d2
    bra.b   .l35874
.l35872:                                                ; $035872
    clr.w   d2
.l35874:                                                ; $035874
    move.w  d2,d0
    movem.l (sp)+,d2-d4/a2-a3
    rts
    dc.w    $48E7,$2020                                      ; $03587C
; === Translated block $035880-$035CCC ===
; 5 functions, 1100 bytes
