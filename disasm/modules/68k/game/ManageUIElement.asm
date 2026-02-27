; ============================================================================
; ManageUIElement -- Searches a player's route list for a route that connects two given city indices (in either order): scans the flight-path entries at $FF9A20 comparing (src,dst) and (dst,src) pairs, and returns the matching slot index in D0 (or 0xFF if none found).
; 204 bytes | $01FB84-$01FC4F
; ============================================================================
ManageUIElement:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d2
    move.l  $28(a7), d3
    move.l  $24(a7), d4
    move.w  #$ff, d6
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d5
    move.b  $4(a3), d5
    moveq   #$0,d0
    move.b  $5(a3), d0
    add.w   d0, d5
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    tst.b   $1(a2)
    beq.b   l_1fc48
    tst.b   $1(a1)
    beq.b   l_1fc48
    moveq   #$0,d0
    move.b  $4(a3), d0
    mulu.w  #$14, d0
    move.w  d2, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  $4(a3), d2
    bra.b   l_1fc44
l_1fc16:
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d4, d0
    bne.b   l_1fc2c
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d3, d0
l_1fc26:
    bne.b   l_1fc3e
    move.w  d2, d6
    bra.b   l_1fc48
l_1fc2c:
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d3, d0
    bne.b   l_1fc3e
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d4, d0
    bra.b   l_1fc26
l_1fc3e:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_1fc44:
    cmp.w   d5, d2
    bcs.b   l_1fc16
l_1fc48:
    move.w  d6, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts
