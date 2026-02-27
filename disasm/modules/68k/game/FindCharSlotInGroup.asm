; ============================================================================
; FindCharSlotInGroup -- Finds the slot index of a character (by city index) within a player's 5-slot route record; if not found in active entries, falls back to the first active slot; returns the slot index
; Called: ?? times.
; 94 bytes | $02F548-$02F5A5
; ============================================================================
FindCharSlotInGroup:                                                  ; $02F548
    movem.l d2-d3/a2,-(sp)
    move.l  $0014(sp),d3
    move.w  $0012(sp),d0
    mulu.w  #$14,d0
    movea.l #$00ff02e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    movea.l a0,a2
    clr.w   d2
.l2f568:                                                ; $02F568
    tst.b   $0001(a2)
    beq.b   .l2f57a
    moveq   #$0,d0
    move.b  (a2),d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
    beq.b   .l2f584
.l2f57a:                                                ; $02F57A
    addq.l  #$4,a2
    addq.w  #$1,d2
    cmpi.w  #$5,d2
    bcs.b   .l2f568
.l2f584:                                                ; $02F584
    cmpi.w  #$5,d2
    bne.b   .l2f59e
    movea.l a1,a2
    clr.w   d2
.l2f58e:                                                ; $02F58E
    tst.b   $0001(a2)
    beq.b   .l2f59e
    addq.l  #$4,a2
    addq.w  #$1,d2
    cmpi.w  #$5,d2
    bcs.b   .l2f58e
.l2f59e:                                                ; $02F59E
    move.w  d2,d0
    movem.l (sp)+,d2-d3/a2
    rts
; === Translated block $02F5A6-$02F712 ===
; 1 functions, 364 bytes
