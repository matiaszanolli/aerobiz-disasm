; ============================================================================
; IterateCollection -- Wait-for-press utility: if the system is active, first flushes any held button (looping ReadInput until zero), then waits for a new press; if inactive, calls PollInputChange with 60-frame timeout and returns the first input value in D0.
; 92 bytes | $01E234-$01E28F
; ============================================================================
IterateCollection:
    move.l  d2, -(a7)
    tst.w   ($00FF0A34).l
    bne.b   l_1e250
    bra.b   l_1e27c
l_1e240:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_1e250:
    clr.l   -(a7)
    bsr.w ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_1e240
    bra.b   l_1e26e
l_1e25e:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_1e26e:
    clr.l   -(a7)
    bsr.w ReadInput
    addq.l  #$4, a7
    move.w  d0, d2
    beq.b   l_1e25e
    bra.b   l_1e28a
l_1e27c:
    pea     ($003C).w
    jsr (PollInputChange,PC)
    nop
    addq.l  #$4, a7
    move.w  d0, d2
l_1e28a:
    move.w  d2, d0
    move.l  (a7)+, d2
    rts

; === ProcessInputLoop ($01E290, 100B) ===
ProcessInputLoop:                                                     ; $01E290
    MOVEM.L D2-D3,-(SP)
    MOVE.L  $C(SP),D2                                                 ; arg1 (iteration count)
    MOVE.L  $10(SP),D3                                                ; arg2 (target input)
    CMPI.W  #1,($00FF13FC).L                                         ; check mode flag
    BNE.S   .pil_after                                                ; if != 1, skip loop
    TST.W   ($00FFA7D8).L                                            ; check init flag
    BEQ.S   .pil_countdown                                            ; if == 0, start countdown
    BRA.S   .pil_after                                                ; else skip
.pil_loop:                                                            ; $01E2B0
    CLR.L   -(SP)
    bsr.w ReadInput
    ADDQ.L  #4,SP
    CMP.W   D3,D0                                                     ; compare with target
    BNE.S   .pil_after                                                ; if match, continue; else exit
    PEA     ($0001).W
    PEA     ($000E).W                                                 ; command 14
    jsr GameCommand
    ADDQ.L  #8,SP
.pil_countdown:                                                       ; $01E2CC
    MOVE.L  D2,D0
    SUBQ.W  #1,D2                                                     ; decrement counter
    TST.W   D0                                                        ; test pre-decrement value
    BNE.S   .pil_loop                                                 ; continue while != 0
.pil_after:                                                           ; $01E2D4
    CMPI.W  #1,($00FF13FC).L
    BNE.S   .pil_epilogue
    MOVE.W  #1,($00FFA7D8).L                                         ; set init flag
.pil_epilogue:                                                        ; $01E2E6
    CLR.L   -(SP)
    bsr.w ReadInput
    ADDQ.L  #4,SP
    MOVEM.L (SP)+,D2-D3
    RTS
; === PollInputChange ($01E2F4, 82B) ===
PollInputChange:                                                      ; $01E2F4
    MOVEM.L D2-D4,-(SP)
    MOVE.L  $10(SP),D3                                                ; arg (loop count)
    CLR.L   -(SP)
    bsr.w ReadInput
    ADDQ.L  #4,SP
    MOVE.W  D0,D4                                                     ; D4 = initial input
    BRA.S   .pic_check
.pic_loop:                                                            ; $01E308
    CLR.L   -(SP)
    bsr.w ReadInput
    ADDQ.L  #4,SP
    MOVE.W  D0,D2                                                     ; D2 = new input
    TST.W   D2
    BEQ.S   .pic_nochange                                             ; if 0, skip
    CMP.W   D2,D4
    BEQ.S   .pic_nochange                                             ; if same as last, skip
    MOVE.W  D2,D0                                                     ; found different input
    BRA.S   .pic_exit
.pic_nochange:                                                        ; $01E31E
    MOVE.W  ($00FF0008).L,D0                                         ; frame counter
    EXT.L   D0                                                        ; sign-extend
    ADDQ.L  #1,D0                                                     ; frame + 1
    MOVE.L  D0,-(SP)
    PEA     ($000E).W                                                 ; command 14
    jsr GameCommand
    ADDQ.L  #8,SP
    MOVE.W  D2,D4                                                     ; update last input
    SUBQ.W  #1,D3                                                     ; loop counter--
.pic_check:                                                           ; $01E33A
    TST.W   D3
    BNE.S   .pic_loop                                                 ; continue while != 0
    MOVE.W  D4,D0                                                     ; return last value
.pic_exit:                                                            ; $01E340
    MOVEM.L (SP)+,D2-D4
    RTS
