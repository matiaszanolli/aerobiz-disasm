; ============================================================================
; InitAnimTable -- Initialize boot animation: copy gradient palette, poll VRAM, cycle until done
; 122 bytes | $001CA0-$001D19
; ============================================================================
InitAnimTable:
    move.w  #$28, $46(a5)
    move.w  #$12c, $48(a5)
    move.b  #$a, $4a(a5)
    moveq   #$0,d0
    lea     $1d1a(pc, d0.w), a0
    movea.l  #$00FFF06A,a1
    moveq   #$A,d0
l_01cc0:
    move.w  (a0)+, (a1)+
    dbra    d0, $1CC0
l_01cc6:
    bsr.w UpdateAnimTimer
    move.b  #$1, $36(a5)
l_01cd0:
    move.b  $36(a5), d0
    bne.b   l_01cd0
    movea.l  #$00A10003,a3
    jsr (CmdTestVRAM_WithA3,PC)
    cmpi.b  #$f, d0
    beq.b   l_01d08
    movea.l  #$00FFFC06,a0
    moveq   #$7,d1
l_01cee:
    cmpi.w  #$2, (a0)
    bne.b   l_01d00
    move.b  $3(a0), d2
    andi.b  #$f0, d2
    bne.b   l_01d18
    bra.b   l_01d08
l_01d00:
    btst    #$7, $3(a0)
    bne.b   l_01d18
l_01d08:
    adda.l  #$a, a0
    dbra    d1, $1CEE
    subq.w  #$1, $48(a5)
    bne.b   l_01cc6
l_01d18:
    rts

; Blue-dominant cycling gradient palette (31 words = 62 bytes)
; Used by InitAnimTable and UpdateAnimTimer to animate the boot-screen palette
; at RAM $FFF06A. Each call copies 11 consecutive words from this table to VRAM
; color RAM via the DMA buffer. The counter in $46(a5) steps backward by 2 per
; frame, cycling through the table to produce a smooth blue shimmer effect.
; Color format: %0000BBB0GGG0RRR0
BlueAnimPalette:                                                ; $001D1A
    dc.w    $0EC0,$0EA0,$0E80; $001D1A
    dc.w    $0E60,$0E40,$0E20,$0E00,$0C00,$0A00,$0800,$0600; $001D20
    dc.w    $0800,$0A00,$0C00,$0E00,$0E20,$0E40,$0E60,$0E80; $001D30
    dc.w    $0EA0,$0EC0,$0EA0,$0E80,$0E60,$0E40,$0E20,$0E00; $001D40
    dc.w    $0C00,$0A00,$0800,$0600; $001D50

; === Translated block $001D58-$001D88 ===
; 1 functions, 48 bytes
