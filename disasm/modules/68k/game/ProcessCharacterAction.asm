; ============================================================================
; ProcessCharacterAction -- Applies a single char action to a relation slot; shows the bonus screen, loops calling ApplyCharacterEffect until confirmed or cancelled, and restores stats on cancel.
; 524 bytes | $014692-$01489D
; ============================================================================
ProcessCharacterAction:
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $2c(a7), d3
    movea.l $30(a7), a2
    movea.l  #$0001489E,a3
    movea.l  #$00FFBA80,a4
    movea.l  #$00FFBD4E,a5
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    adda.l  d1, a0
    move.b  $1(a0), d7
    andi.l  #$ff, d7
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    adda.l  d1, a0
    move.b  $1(a0), d6
    andi.l  #$ff, d6
    jsr PreLoopInit
    move.l  a2, -(a7)
    jsr GetByteField4
    move.w  d0, ($00FFBD5C).l
    move.l  a2, -(a7)
    jsr GetLowNibble
    move.w  d0, (a5)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$5, d0
    move.l  d0, d4
    move.w  ($00FFBD5C).l, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $1(a5), d1
    movea.l  #$00FFB9E9,a0
    add.b   d1, (a0,d0.w)
    jsr ResourceLoad
    move.l  a2, -(a7)
    jsr (CalcCharacterBonus,PC)
    nop
    moveq   #$2,d2
    moveq   #$1,d5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0005).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr FormatRelationDisplay
    lea     $20(a7), a7
    bra.w   .l1483c
.l1475e:
    move.l  a2, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ApplyCharacterEffect,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    tst.w   d2
    bne.b   .l147d8
    move.b  $a(a2), d0
    btst    #$1, d0
    beq.b   .l147aa
    andi.b  #$1, $a(a2)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    bra.b   .l147cc
.l147aa:
    ori.b   #$2, $a(a2)
    pea     ($0007193C).l
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
.l147cc:
    jsr GameCommand
    lea     $1c(a7), a7
    bra.b   .l14836
.l147d8:
    cmpi.w  #$1, d2
    beq.b   .l14850
    cmpi.w  #$2, d2
    bne.b   .l147f4
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderTilePattern,PC)
    nop
    bra.b   .l14834
.l147f4:
    cmpi.w  #$3, d2
    bne.b   .l1480a
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (DrawScreenElement,PC)
    nop
    bra.b   .l14834
.l1480a:
    cmpi.w  #$4, d2
    bne.b   .l14820
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateScreenLayout,PC)
    nop
    bra.b   .l14834
.l14820:
    cmpi.w  #$5, d2
    bne.b   .l1483c
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RefreshDisplayArea,PC)
    nop
.l14834:
    addq.l  #$8, a7
.l14836:
    move.l  a2, -(a7)
    jsr     (a3)
    addq.l  #$4, a7
.l1483c:
    jsr ResourceUnload
    cmpi.w  #$ff, d2
    beq.b   .l14850
    cmpi.w  #$6, d2
    bne.w   .l1475e
.l14850:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    adda.l  d1, a0
    move.b  d7, $1(a0)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    adda.l  d1, a0
    move.b  d6, $1(a0)
    move.w  ($00FFBD5C).l, d0
    add.w   d0, d0
    add.w   d4, d0
    move.b  $1(a5), d1
    movea.l  #$00FFB9E9,a0
    sub.b   d1, (a0,d0.w)
    move.w  d2, d0
    movem.l (a7)+, d2-d7/a2-a5
    rts
