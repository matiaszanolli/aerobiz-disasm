; ============================================================================
; ResizeUIPanel -- Returns the city-slot index of a given character in a given player's route list: scans the player's flight entries at $FF9A20 comparing the destination city byte, and returns the matched index in D0 (or 0xFF if not found).
; 146 bytes | $01FF0C-$01FF9D
; ============================================================================
ResizeUIPanel:
    movem.l d2-d5/a2, -(a7)
    move.l  $18(a7), d2
    move.l  $1c(a7), d3
    move.w  #$ff, d5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    moveq   #$0,d4
    move.b  $4(a1), d4
    moveq   #$0,d0
    move.b  $5(a1), d0
    add.w   d0, d4
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   $1(a2)
    beq.b   l_1ff96
    moveq   #$0,d0
    move.b  $4(a1), d0
    mulu.w  #$14, d0
    move.w  d2, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  $4(a1), d2
    bra.b   l_1ff92
l_1ff7e:
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d3, d0
    bne.b   l_1ff8c
    move.w  d2, d5
    bra.b   l_1ff96
l_1ff8c:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_1ff92:
    cmp.w   d4, d2
    bcs.b   l_1ff7e
l_1ff96:
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2
    rts


; === Translated block $01FF9E-$020000 ===
; 1 functions, 98 bytes
