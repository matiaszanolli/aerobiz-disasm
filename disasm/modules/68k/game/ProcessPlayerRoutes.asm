; ============================================================================
; ProcessPlayerRoutes -- Marks a player's changed route slot as pending, accumulates route bitmasks, then clears route-slot bits that changed since last turn.
; 140 bytes | $011B26-$011BB1
; ============================================================================
ProcessPlayerRoutes:
    link    a6,#-$4
    movem.l d2-d5, -(a7)
    move.l  $8(a6), d4
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    move.l  (a0,d0.w), d5
    movea.l $c(a6), a0
    ori.b   #$80, $a(a0)
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0019,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$1,d3
    lsl.l   d0, d3
    pea     -$4(a6)
    move.l  d3, -(a7)
    move.l  d3, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (AccumulateRouteBits,PC)
    nop
    lea     $10(a7), a7
    moveq   #$1,d3
    clr.w   d2
l_11b7e:
    move.l  -$4(a6), d0
    move.l  d5, d1
    eor.l   d1, d0
    and.l   d3, d0
    beq.b   l_11b9e
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (ClearRouteSlotBit,PC)
    nop
    addq.l  #$8, a7
l_11b9e:
    add.l   d3, d3
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    blt.b   l_11b7e
    movem.l -$14(a6), d2-d5
    unlk    a6
    rts

UpdateRouteMask:                                                  ; $011BB2
    link    a6,#-$4
    movem.l d2-d6/a2,-(sp)
    move.l  $0008(a6),d4
    move.l  $000c(a6),d6
    movea.l #$00ff08ec,a2
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a2,a0.l),d5
    move.w  d4,d0
    mulu.w  #$24,d0
    movea.l #$00ff0019,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    moveq   #$1,d3
    lsl.l   d0,d3
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.w  d4,d1
    lsl.l   #$2,d1
    movea.l d1,a0
    eor.l   d0,(a2,a0.l)
    pea     -$0004(a6)
    move.l  d3,-(sp)
    move.l  d3,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$013e                                 ; jsr $011D50
    nop
    lea     $0010(sp),sp
    moveq   #$1,d3
    clr.w   d2
.l11c1e:                                                ; $011C1E
    move.l  -$0004(a6),d0
    move.l  d5,d1
    eor.l   d1,d0
    and.l   d3,d0
    beq.b   .l11c3e
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0234                                 ; jsr $011E6C
    nop
    addq.l  #$8,sp
.l11c3e:                                                ; $011C3E
    add.l   d3,d3
    addq.w  #$1,d2
    cmpi.w  #$20,d2
    blt.b   .l11c1e
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00a8                                 ; jsr $011CF6
    nop
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l11c7a
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a2,a0.l),d0
    move.l  d5,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$08a2                                 ; jsr $012514
    nop
    addq.l  #$8,sp
    bra.b   .l11caa
.l11c7a:                                                ; $011C7A
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a2,a0.l),d0
    move.l  d5,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0b34                                 ; jsr $0127D6
    nop
    lea     $000c(sp),sp
.l11caa:                                                ; $011CAA
    move.w  d0,d2
    cmpi.w  #$1,d2
    bne.b   .l11cd4
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a2,a0.l),d0
    move.l  d5,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$03aa                                 ; jsr $012076
    nop
    addq.l  #$8,sp
    bra.b   .l11cec
.l11cd4:                                                ; $011CD4
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  d5,(a2,a0.l)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$111c                                 ; jsr $012E04
    nop
.l11cec:                                                ; $011CEC
    movem.l -$001c(a6),d2-d6/a2
    unlk    a6
    rts
; === Translated block $011CF6-$012E92 ===
; 11 functions, 4508 bytes
