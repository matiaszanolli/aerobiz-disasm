; ============================================================================
; SetTextCursorXY -- Sets text cursor to (X, Y) by calling SetCursorX then SetCursorY with the two parameters
; 36 bytes | $03AB08-$03AB2B
; ============================================================================
SetTextCursorXY:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d2
    move.l  $c(a7), d3
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w SetCursorX
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w SetCursorY
    addq.l  #$8, a7
    movem.l (a7)+, d2-d3
    rts

; ---------------------------------------------------------------------------
; SetTextCursor - Set text cursor position
; Params: x (SP+4), y (SP+8)
; 174 calls | 36 bytes | $03AB2C-$03AB4F
; ---------------------------------------------------------------------------
SetTextCursor:
    movem.l d2-d3,-(sp)                                    ; $03AB2C
    move.l  $10(sp),d2                                     ; $03AB30 | y
    move.l  $0C(sp),d3                                     ; $03AB34 | x
    move.w  d3,d0                                          ; $03AB38
    move.l  d0,-(sp)                                       ; $03AB3A
    bsr.w SetCursorX
    move.w  d2,d0                                          ; $03AB40
    move.l  d0,-(sp)                                       ; $03AB42
    bsr.w SetCursorY
    addq.l  #8,sp                                          ; $03AB48 | clean 2 pushed params
    movem.l (sp)+,d2-d3                                    ; $03AB4A
    rts                                                    ; $03AB4E
; === Translated block $03AB50-$03ACDC ===
; 4 functions, 396 bytes
