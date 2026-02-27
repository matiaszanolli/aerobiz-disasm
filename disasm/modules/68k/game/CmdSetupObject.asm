; ============================================================================
; CmdSetupObject -- Initialize multi-sprite object in work RAM: set positions, tile IDs, and trigger display
; 152 bytes | $000658-$0006EF
; ============================================================================
CmdSetupObject:
    move.l  $26(a6), d0
    beq.w   l_006e2
    move.l  $16(a6), d0
    move.w  d0, $b26(a5)
    move.w  #$1, $b28(a5)
    move.l  $e(a6), d0
    move.b  d0, $b2b(a5)
    move.l  d0, d2
    move.l  d0, d4
    movea.l $1a(a6), a0
    move.l  $1e(a6), d7
    move.l  $22(a6), d6
    move.l  $12(a6), d1
    move.b  d1, $b2c(a5)
    subq.w  #$1, d1
    lsl.l   #$3, d0
    lsl.l   #$1, d2
    addi.w  #$7a, d0
    addi.w  #$b2e, d2
    addq.w  #$1, d4
l_0069e:
    move.w  (a0), d5
    add.w   d6, d5
    move.w  d5, (a5,d2.w)
    addq.w  #$2, d2
    move.w  (a0)+, d5
    add.w   d6, d5
    move.w  d5, (a5,d0.w)
    addq.w  #$2, d0
    move.w  (a0)+, d5
    andi.w  #$ff00, d5
    add.b   d4, d5
    move.w  d5, (a5,d0.w)
    addq.w  #$2, d0
    addq.w  #$1, d4
    move.w  (a0)+, (a5,d0.w)
    addq.w  #$2, d0
    move.w  (a0)+, d5
    add.w   d7, d5
    move.w  d5, (a5,d0.w)
    addq.w  #$2, d0
    dbra    d1, $69E
    moveq   #$1,d0
    move.b  d0, $b2a(a5)
    move.b  d0, $b2d(a5)
    bra.b   l_006ee
l_006e2:
    move.b  #$0, $b2a(a5)
    jmp     $7a4(pc)
    nop
l_006ee:
    rts
