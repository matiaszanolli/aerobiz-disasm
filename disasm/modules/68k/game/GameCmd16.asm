; ============================================================================
; GameCmd16 -- Call GameCommand #16 with two args (77 calls)
; Args (stack): 4(sp)=arg1 (word), 8(sp)=arg2 (word)
; ============================================================================
GameCmd16:                                                       ; $01E0B8
    move.l  d2,-(sp)                                             ; save D2
    move.l  $C(sp),d2                                            ; D2 = arg2 (shifted +4)
    move.l  $8(sp),d1                                            ; D1 = arg1
    move.w  d2,d0                                                ; D0 = arg2
    ext.l   d0                                                   ; sign-extend
    move.l  d0,-(sp)                                             ; push arg2
    move.w  d1,d0                                                ; D0 = arg1
    ext.l   d0                                                   ; sign-extend
    move.l  d0,-(sp)                                             ; push arg1
    pea     ($0010).w                                            ; GameCommand #16
    jsr GameCommand
    lea     $C(sp),sp                                            ; clean 12 bytes (3 args)
    move.l  (sp)+,d2                                             ; restore D2
    rts
