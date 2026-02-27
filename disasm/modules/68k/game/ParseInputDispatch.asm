; ============================================================================
; ParseInputDispatch -- Dispatch one input packet parse step via type-code indexed jump table
; 36 bytes | $001BEC-$001C0F
; ============================================================================
ParseInputDispatch:
    moveq   #$0,d0
    move.b  (a2)+, d0
    cmpi.b  #$2, d0
    bhi.b   l_01c0a
    add.w   d0, d0
    add.w   d0, d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    bra.w   l_01c3a
    bra.w   l_01c10
    bra.w   l_01ad4
l_01c0a:
    lea     $a(a1), a1
    rts
