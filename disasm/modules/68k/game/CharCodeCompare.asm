; ============================================================================
; CharCodeCompare -- Compare two character codes, compute compatibility index
; Called: 22 times. Args (stack, no link): $18(SP)=code1 (l), $1C(SP)=code2 (l)
; Returns: D0.W = compatibility index, $FFFF if incompatible, 0 if equal
; Uses tables at $5E356, $5ECBC, $5E546/$5E5BE/$5E5C8/$5E5D8/$5E61E/$5E630/$5E670
; ============================================================================
CharCodeCompare:                                             ; $006F42
    movem.l d2-d5/a2,-(sp)
    move.l  $0018(sp),d2                                 ; D2 = code1
    move.l  $001C(sp),d3                                 ; D3 = code2
    ; Sort so D2 <= D3
    cmp.w   d3,d2
    bls.s   .sorted
    move.w  d2,d4
    move.w  d3,d2
    move.w  d4,d3
.sorted:                                                 ; $006F58
    cmp.w   d3,d2
    bne.s   .not_equal
    clr.w   d2                                           ; equal → return 0
    bra.w   .exit
.not_equal:                                              ; $006F62
    cmpi.w  #$0020,d2
    bcc.s   .check_high                                  ; D2 >= 32 → high path
    cmpi.w  #$0020,d3
    bcc.s   .check_high                                  ; D3 >= 32 → high path
    ; Both < 32: call CharPairIndex(code2, code1, #$20)
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($0020).w
    jsr (CharPairIndex,PC)
    nop
    lea     $000C(sp),sp                                 ; clean 3 args
    move.w  d0,d2                                        ; D2 = pair index result
    movea.l #$0005E356,a0                                ; A0 = char range score table
    move.b  (a0,d2.w),d0                                 ; D0 = table[D2]
.exit_mask:                                              ; $006F94
    andi.l  #$000000FF,d0                                ; zero-extend
    move.w  d0,d2                                        ; D2 = score byte
    bra.w   .exit
.check_high:                                             ; $006FA0
    cmpi.w  #$0059,d2
    bcc.w   .fail                                        ; D2 >= 89 → fail
    cmpi.w  #$0059,d3
    bcc.w   .fail                                        ; D3 >= 89 → fail
    ; [32..88]: RangeLookup both codes, compare categories
    moveq   #0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    jsr RangeLookup
    move.w  d0,d4                                        ; D4 = category(D2)
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    jsr RangeLookup
    addq.l  #8,sp                                        ; clean 2 args
    move.w  d0,d5                                        ; D5 = category(D3)
    cmp.w   d5,d4
    bne.w   .fail                                        ; different categories → fail
    cmpi.w  #$0020,d2
    bcc.w   .fail                                        ; mixed-class → fail
    ; Same category, D2 < 32: look up range entry at $5ECBC[D4*4]
    move.w  d4,d0
    lsl.w   #2,d0                                        ; D0 = D4 * 4
    movea.l #$0005ECBC,a0                                ; A0 = range entries
    lea     (a0,d0.w),a0                                 ; A0 = &RangeEntry[D4]
    movea.l a0,a2                                        ; A2 = save entry pointer
    move.b  (a0),d0                                      ; D0 = entry base byte [+0]
    andi.l  #$000000FF,d0
    move.w  d2,d1
    sub.w   d0,d1                                        ; D1 = code1 - base
    move.w  d1,d2                                        ; D2 = adjusted code1
    moveq   #0,d0
    move.b  $0002(a2),d0                                 ; D0 = entry byte [+2]
    move.w  d3,d1
    sub.w   d0,d1                                        ; D1 = code2 - base
    move.w  d1,d3                                        ; D3 = adjusted code2
    ; Dispatch via 7-entry jump table (category D4, 0-6)
    moveq   #0,d0
    move.w  d4,d0
    moveq   #6,d1
    cmp.l   d1,d0
    bhi.w   .fail                                        ; category > 6 → fail
    add.l   d0,d0                                        ; D0 *= 2 (word index)
    dc.w    $303B,$0806                                  ; move.w ($06,pc,d0.w),d0
    dc.w    $4EFB,$0002                                  ; jmp ($02,pc,d0.w)
.jtab:
    dc.w    .case0-.jtab
    dc.w    .case1-.jtab
    dc.w    .case2-.jtab
    dc.w    .case3-.jtab
    dc.w    .case4-.jtab
    dc.w    .case5-.jtab
    dc.w    .case6-.jtab
.case0:                                                  ; $00702A
    move.w  d2,d0
    dc.w    $C0FC,$0011                                  ; and.w #$0011,d0
    add.w   d3,d0
    movea.l #$0005E546,a0
.shared_lookup:                                          ; $007038 (shared by all cases)
    move.b  (a0,d0.w),d0                                 ; look up score in category table
    bra.w   .exit_mask                                   ; → mask + assign + exit
.case1:                                                  ; $007040
    move.w  d2,d0
    dc.w    $C0FC,$0005                                  ; and.w #$0005,d0
    add.w   d3,d0
    movea.l #$0005E5BE,a0
    bra.s   .shared_lookup
.case2:                                                  ; $007050
    move.w  d2,d0
    dc.w    $C0FC,$0005                                  ; and.w #$0005,d0
    add.w   d3,d0
    movea.l #$0005E5C8,a0
    bra.s   .shared_lookup
.case3:                                                  ; $007060
    move.w  d2,d0
    dc.w    $C0FC,$000A                                  ; and.w #$000A,d0
    add.w   d3,d0
    movea.l #$0005E5D8,a0
    bra.s   .shared_lookup
.case4:                                                  ; $007070
    move.w  d2,d0
    dc.w    $C0FC,$0006                                  ; and.w #$0006,d0
    add.w   d3,d0
    movea.l #$0005E61E,a0
    bra.s   .shared_lookup
.case5:                                                  ; $007080
    move.w  d2,d0
    dc.w    $C0FC,$0009                                  ; and.w #$0009,d0
    add.w   d3,d0
    movea.l #$0005E630,a0
    bra.s   .shared_lookup
.case6:                                                  ; $007090
    move.w  d2,d0
    dc.w    $C0FC,$0005                                  ; and.w #$0005,d0
    add.w   d3,d0
    movea.l #$0005E670,a0
    bra.s   .shared_lookup
.fail:                                                   ; $0070A0
    move.w  #$FFFF,d2
.exit:                                                   ; $0070A4
    cmpi.w  #$FFFF,d2
    beq.s   .final                                       ; fail → skip scaling, return $FFFF
    move.w  d2,d0
    dc.w    $C0FC,$0064                                  ; and.w #$0064,d0 (mask to 0-100)
    move.w  d0,d2
    moveq   #0,d0
    move.w  d2,d0                                        ; zero-extend D2
    bge.s   .no_round                                    ; non-negative → no adjustment
    moveq   #$0F,d1
    add.l   d1,d0                                        ; round toward zero
.no_round:                                               ; $0070BC
    asr.l   #4,d0                                        ; D0 /= 16 (arithmetic)
    move.l  d0,d1
    lsl.l   #2,d0                                        ; D0 *= 4
    add.l   d1,d0                                        ; D0 = D0*4 + D0 = D0*5
    add.l   d0,d0                                        ; D0 *= 2 = D0*10
    moveq   #$0A,d1
    jsr SignedDiv
    dc.w    $C0FC,$000A                                  ; and.w #$000A,d0
    move.w  d0,d2                                        ; D2 = scaled result
.final:                                                  ; $0070D4
    move.w  d2,d0                                        ; D0 = return value
    movem.l (sp)+,d2-d5/a2
    rts
