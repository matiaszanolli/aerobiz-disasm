; ============================================================================
; RandRange -- Random integer in [min, max] (64 calls)
; Uses classic C LCG: state = state * 1103515245 + 12345
; Args (stack): $18(sp)=min (word), $1C(sp)=max (word)
;   (offsets shifted by 20 bytes of saved registers)
; RNG state at $FFA7E0 (longword + word accumulator)
; ============================================================================
RandRange:                                                       ; $01D6A4
    movem.l d2-d5/a2,-(sp)                                      ; save working registers
    move.l  $18(sp),d3                                           ; D3 = min
    move.l  $1C(sp),d4                                           ; D4 = max
    movea.l #$00FFA7E0,a2                                        ; A2 = RNG state pointer
    move.w  $2(a2),d2                                            ; D2 = accumulator word
    pea     ($0003).w                                            ; GameCommand #3
    jsr GameCommand
    addq.l  #4,sp                                                ; clean arg
    add.w   d0,d2                                                ; accumulate return value
    move.l  (a2),d0                                              ; D0 = RNG state
    move.l  #$41C64E6D,d1                                        ; D1 = LCG multiplier (1103515245)
    jsr Multiply32
    addi.l  #$00003039,d0                                        ; D0 += 12345 (LCG increment)
    move.l  d0,(a2)                                              ; store new RNG state
    moveq   #0,d0                                                ; zero-extend
    move.w  d2,d0                                                ; D0 = accumulator (unsigned)
    move.w  d4,d1                                                ; D1 = max
    ext.l   d1                                                   ; sign-extend to long
    move.w  d3,d5                                                ; D5 = min
    ext.l   d5                                                   ; sign-extend to long
    sub.l   d5,d1                                                ; D1 = max - min
    addq.l  #1,d1                                                ; D1 = range (max - min + 1)
    jsr SignedMod
    add.w   d3,d0                                                ; D0 = (random % range) + min
    movem.l (sp)+,d2-d5/a2                                       ; restore registers
    rts
