; ============================================================================
; ProcessTextControl -- Issues a single GameCommand DMA tile transfer (cmd 5, sub 2): computes the VRAM offset from row and col arguments (shifted left), and sends the source pointer and tile count to the display system.
; 56 bytes | $01D8AA-$01D8E1
; ============================================================================
ProcessTextControl:
    move.l  d2, -(a7)
    move.l  $c(a7), d2
    move.l  $8(a7), d1
    movea.l $10(a7), a0
    clr.l   -(a7)
    move.w  d1, d0
    ext.l   d0
    lsl.l   #$5, d0
    move.l  d0, -(a7)
    move.l  a0, -(a7)
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0005).w
    jsr GameCommand
    lea     $18(a7), a7
    move.l  (a7)+, d2
    rts
