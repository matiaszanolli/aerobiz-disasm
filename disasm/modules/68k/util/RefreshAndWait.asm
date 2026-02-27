; ============================================================================
; RefreshAndWait -- Issues two GameCommand calls (cmd 0x0E/1 and cmd 0x14) then returns 1 in D0 if bit 0 of the combined result byte is set, 0 otherwise; used to refresh the display and test a ready condition.
; 48 bytes | $01D310-$01D33F
; ============================================================================
RefreshAndWait:                                                  ; $01D310
    move.l  d2,-(sp)
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0014).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $000c(sp),sp
    move.b  d0,d2
    btst    #$00,d2
    beq.b   .l1d33a
    moveq   #$1,d0
    bra.b   .l1d33c
.l1d33a:                                                ; $01D33A
    moveq   #$0,d0
.l1d33c:                                                ; $01D33C
    move.l  (sp)+,d2
    rts
