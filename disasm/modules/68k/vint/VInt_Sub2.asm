; ============================================================================
; VInt_Sub2 -- Invoke per-frame V-INT callback via function pointer stored in work RAM
; 8 bytes | $0016CC-$0016D3
; ============================================================================
VInt_Sub2:
    movea.l $bd0(a5), a0
    jsr     (a0)
    rts
