; ============================================================================
; RangeMatch -- Check if two char codes map to the same range category
; Called: 10 times. Args (stack, no link): $14(SP)=code1 (w), $18(SP)=code2 (w)
; Returns: D0.W = 1 (same range), 0 (different range), $FF (out of range)
; Uses A2 = RangeLookup ($0000D648)
; ============================================================================
RangeMatch:                                              ; $007158
    movem.l d2-d4/a2,-(sp)
    move.l  $0014(sp),d2                                 ; D2 = code1
    move.l  $0018(sp),d3                                 ; D3 = code2
    movea.l #$0000D648,a2                                ; A2 = RangeLookup
    cmp.w   d3,d2                                        ; D2 <= D3?
    ble.s   .sorted
    move.w  d2,d4                                        ; swap D2, D3 to ensure D2 <= D3
    move.w  d3,d2
    move.w  d4,d3
.sorted:                                                 ; $007174
    cmp.w   d3,d2                                        ; D2 == D3?
    beq.s   .return_ff                                   ; equal → not comparable
    cmpi.w  #$0020,d2
    bge.s   .check_high                                  ; D2 >= 32 → check upper range
    cmpi.w  #$0020,d3
    bge.s   .check_high                                  ; D3 >= 32 → check upper range
    ; both codes < 32: compare via RangeLookup
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a2)                                         ; RangeLookup(D2)
    move.w  d0,d4                                        ; D4 = RangeLookup(D2)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a2)                                         ; RangeLookup(D3)
    addq.l  #8,sp
    move.w  d0,d3                                        ; D3 = RangeLookup(D3)
    cmp.w   d3,d4                                        ; same range?
    bne.s   .return_zero
.return_one:                                             ; $00719E
    moveq   #1,d2
    bra.s   .return_d2
.return_zero:                                            ; $0071A2
    clr.w   d2
    bra.s   .return_d2
.check_high:                                             ; $0071A6
    cmpi.w  #$0059,d2
    bge.s   .return_ff
    cmpi.w  #$0059,d3
    bge.s   .return_ff
    ; 32 <= code < 89: compare via RangeLookup
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a2)                                         ; RangeLookup(D2)
    move.w  d0,d4
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a2)                                         ; RangeLookup(D3)
    addq.l  #8,sp
    move.w  d0,d3
    cmp.w   d3,d4
    bne.s   .return_ff
    cmpi.w  #$0020,d2
    blt.s   .return_one                                  ; D2 < 32 → return 1
.return_ff:                                              ; $0071D2
    move.w  #$00FF,d2
.return_d2:                                              ; $0071D6
    move.w  d2,d0
    movem.l (sp)+,d2-d4/a2
    rts
