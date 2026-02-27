; ============================================================================
; ReadInput -- Read joypad input via GameCommand #10 (95 calls)
; Arg (stack): $10(sp)=mode (0=high|low, 2=high only, other=low only)
; Input mask at $FFA790 filters which buttons are reported.
; Returns: D0.W = masked input value (byte)
; ============================================================================
ReadInput:                                                       ; $01E1EC
    movem.l d2-d3/a2,-(sp)                                      ; save working registers
    move.l  $10(sp),d3                                           ; D3 = mode arg (shifted +12)
    movea.l #$00FFA790,a2                                        ; A2 = input mask pointer
    clr.l   -(sp)                                                ; push 0 (sub-arg)
    pea     ($000A).w                                            ; GameCommand #10 (read input)
    jsr GameCommand
    addq.l  #8,sp                                                ; clean 2 args
    move.l  d0,d2                                                ; D2 = raw input (longword)
    tst.l   d3                                                   ; check mode
    beq.s   .modeOr                                              ; mode 0 -> OR both halves
    moveq   #2,d0                                                ; compare value
    cmp.l   d3,d0                                                ; mode == 2?
    bne.s   .modeLow                                             ; no -> use low word
; -- Mode 2: extract high word only (new presses) --
.modeHigh:                                                       ; $01E214
    move.l  d2,d0                                                ; D0 = raw input
    moveq   #$10,d1                                              ; D1 = 16
    lsr.l   d1,d0                                                ; D0 = high word (>> 16)
    bra.s   .mask                                                ; apply mask
; -- Mode other: use low word only (held buttons) --
.modeLow:                                                        ; $01E21C
    move.w  d2,d0                                                ; D0 = low word
    bra.s   .mask                                                ; apply mask
; -- Mode 0: OR high and low words (any activity) --
.modeOr:                                                         ; $01E220
    move.l  d2,d0                                                ; D0 = raw input
    moveq   #$10,d1                                              ; D1 = 16
    lsr.l   d1,d0                                                ; D0 = high word (>> 16)
    or.w    d2,d0                                                ; D0 |= low word
.mask:                                                           ; $01E228
    and.w   (a2),d0                                              ; mask with allowed buttons
    andi.w  #$00FF,d0                                            ; keep low byte only
    movem.l (sp)+,d2-d3/a2                                       ; restore registers
    rts
; ---
; === Translated block $01E234-$01E290 ===
; 1 functions, 92 bytes
