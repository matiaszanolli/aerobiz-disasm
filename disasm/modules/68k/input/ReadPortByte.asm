; ============================================================================
; ReadPortByte -- Read one I/O port and dispatch to handler based on detected controller protocol
; 50 bytes | $00195C-$00198D
; ============================================================================
ReadPortByte:
    movem.l d1-d7/a1-a3, -(a7)
    lea     ($00A10003).l, a0
    add.w   d0, d0
    adda.w  d0, a0
    add.w   d0, d0
    lea     $2(a1, d0.w), a2
    mulu.w  #$a, d0
    lea     $a(a1, d0.w), a1
    bsr.b   $19AE
    move.w  d0, -(a7)
    andi.w  #$e, d0
    add.w   d0, d0
    jsr     $198e(pc, d0.w)
    move.w  (a7)+, d0
    movem.l (a7)+, d1-d7/a1-a3
    rts
