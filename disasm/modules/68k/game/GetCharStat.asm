; ============================================================================
; GetCharStat -- Look up character attribute from stat table
; Called: 14 times.
; 50 bytes | $009D92-$009DC3
; ============================================================================
GetCharStat:                                                  ; $009D92
    move.w  $000a(sp),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$0,d1
    move.b  (a1),d1
    move.w  $0006(sp),d0
    mulu.w  #$39,d0
    add.w   d1,d0
    movea.l #$00ff05c4,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    rts
