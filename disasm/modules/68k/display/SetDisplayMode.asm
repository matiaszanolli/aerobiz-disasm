; ============================================================================
; SetDisplayMode -- Sets the low byte of the display-state word at $FF1274 to the given mode value; if mode is 0, first issues a GameCommand($13, $10) clear call and resets the stored selection at $FFBD52 to 0xFFFF.
; Called: 7 times.
; 58 bytes | $01D340-$01D379
; ============================================================================
SetDisplayMode:                                                  ; $01D340
    move.l  d2,-(sp)
    move.l  $0008(sp),d2
    tst.w   d2
    bne.b   .l1d362
    pea     ($0010).w
    pea     ($0013).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    move.w  #$ffff,($00FFBD52).l
.l1d362:                                                ; $01D362
    move.w  ($00FF1274).l,d0
    andi.w  #$ff00,d0
    or.w    d2,d0
    move.w  d0,($00FF1274).l
    moveq   #$0,d0
    move.l  (sp)+,d2
    rts
; ---------------------------------------------------------------------------
SetDisplayPage:                                                  ; $01D37A
    move.l  d2,-(sp)
    move.l  $0008(sp),d2
    tst.w   d2
    bne.b   .l1d390
    pea     ($0018).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$4,sp
.l1d390:                                                ; $01D390
    move.w  d2,d0
    lsl.w   #$8,d0
    move.w  ($00FF1274).l,d1
    andi.w  #$ff,d1
    or.l    d1,d0
    move.w  d0,($00FF1274).l
    moveq   #$0,d0
    move.l  (sp)+,d2
    rts
