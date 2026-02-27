; ============================================================================
; QueueVRAMWriteAddr -- Sets up the VRAM write-address registers in the shadow buffer at $FF5804 (offset words $4/$6) and issues GameCommand $08/$05 to upload the address to the VDP
; 126 bytes | $03D0C0-$03D13D
; ============================================================================
QueueVRAMWriteAddr:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    move.l  $10(a7), d3
    movea.l  #$00FF5804,a2
    move.w  d3, d0
    or.w    d2, d0
    bne.b   l_3d0ec
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    bra.b   l_3d0f4
l_3d0ec:
    move.w  d3, $4(a2)
    move.w  d2, $6(a2)
l_3d0f4:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    clr.l   -(a7)
    move.l  a2, d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    jsr GameCommand
    lea     $1c(a7), a7
    clr.l   -(a7)
    move.l  #$fc00, -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    jsr GameCommand
    lea     $18(a7), a7
    movem.l (a7)+, d2-d3/a2
    rts
