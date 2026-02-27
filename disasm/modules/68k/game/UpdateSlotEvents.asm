; ============================================================================
; UpdateSlotEvents -- Iterates 32 route/event slots; for each active slot calls UpdateEventState, and for idle slots where the random threshold is met calls ApplyEventEffect
; Called: ?? times.
; 134 bytes | $017CE6-$017D6B
; ============================================================================
UpdateSlotEvents:                                                  ; $017CE6
    movem.l d2-d3/a2-a3,-(sp)
    movea.l #$00ff0728,a3
    movea.l #$00ff8824,a2
    clr.w   d2
.l17cf8:                                                ; $017CF8
    tst.b   $0001(a3)
    beq.b   .l17d0c
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0066                                 ; jsr $017D6C
    nop
    addq.l  #$4,sp
.l17d0c:                                                ; $017D0C
    tst.b   $0001(a3)
    bne.b   .l17d5a
    cmpi.b  #$ff,(a2)
    bcc.b   .l17d5a
    moveq   #$0,d0
    move.b  (a3),d0
    lsl.l   #$2,d0
    moveq   #$41,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.b  (a2),d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$0,d1
    move.b  (a2),d1
    ext.l   d1
    moveq   #$0,d3
    move.b  $0001(a2),d3
    ext.l   d3
    sub.l   d3,d1
    cmp.l   d1,d0
    blt.b   .l17d5a
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00ee                                 ; jsr $017E42
    nop
    addq.l  #$4,sp
.l17d5a:                                                ; $017D5A
    addq.l  #$2,a3
    addq.l  #$2,a2
    addq.w  #$1,d2
    cmpi.w  #$20,d2
    bcs.b   .l17cf8
    movem.l (sp)+,d2-d3/a2-a3
    rts
    dc.w    $4E56,$0000                                      ; $017D6C
; === Translated block $017D70-$01801C ===
; 4 functions, 684 bytes
