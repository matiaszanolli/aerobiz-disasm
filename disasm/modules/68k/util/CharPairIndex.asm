; ============================================================================
; CharPairIndex -- Compute triangular index for a pair of character codes
; Called: 1 time (from CharCodeCompare low path).
; Args (stack, no link): $14(SP)=limit (l), $18(SP)=code1 (l), $1C(SP)=code2 (l)
; Returns: D0.W = triangular/pair index, or $FFFF if out of range
; ============================================================================
CharPairIndex:                                               ; $0071DE
    movem.l d2-d5,-(sp)
    move.l  $0014(sp),d2                                 ; D2 = limit ($0020)
    move.l  $0018(sp),d4                                 ; D4 = code1 (arg2)
    move.l  $001C(sp),d5                                 ; D5 = code2 (arg3)
    clr.w   d3                                           ; D3 = 0 (result accumulator)
    cmp.w   d4,d2                                        ; limit vs code1
    ble.s   .fail                                        ; if limit <= code1, fail
    cmp.w   d5,d2                                        ; limit vs code2
    ble.s   .fail                                        ; if limit <= code2, fail
    cmp.w   d5,d4                                        ; code1 vs code2
    bne.s   .compare                                     ; if code1 != code2, compare
.fail:                                                   ; $0071FC
    move.w  #$FFFF,d3
    bra.s   .return
.compare:                                                ; $007202
    cmp.w   d5,d4                                        ; re-check code1 vs code2
    bge.s   .sorted                                      ; if code1 >= code2 (signed), sorted
    move.w  d4,d2                                        ; swap step 1: D2 = code1 (min)
    move.w  d5,d4                                        ; swap step 2: D4 = code2 (max)
    move.w  d2,d5                                        ; swap step 3: D5 = code1 (min saved)
.sorted:                                                 ; $00720A
    clr.w   d2                                           ; D2 = 0 (loop counter)
    bra.s   .check                                       ; enter loop at check
.loop:                                                   ; $007210
    add.w   d2,d3                                        ; D3 += D2
    addq.w  #1,d2                                        ; D2++
.check:                                                  ; $007214
    moveq   #0,d0
    move.w  d2,d0                                        ; D0 = counter
    move.w  d4,d1                                        ; D1 = loop bound (D4)
    ext.l   d1
    cmp.l   d1,d0
    blt.s   .loop                                        ; if D0 < D4, continue
    add.w   d5,d3                                        ; D3 += loop start offset
.return:                                                 ; $007222
    move.w  d3,d0                                        ; D0 = result
    movem.l (sp)+,d2-d5
    rts

; === Translated block $00722A-$007390 ===
; 1 functions, 358 bytes
