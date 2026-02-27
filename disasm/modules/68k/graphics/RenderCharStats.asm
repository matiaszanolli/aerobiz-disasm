; ============================================================================
; RenderCharStats -- Renders the character statistics panel: uploads four stat-icon tiles, draws stat bars for each of four stat categories, and displays numeric values via GameCommand $0F/$0E
; 496 bytes | $03CED0-$03D0BF
; ============================================================================
RenderCharStats:
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $28(a7), d2
    move.l  $24(a7), d3
    move.l  $20(a7), d4
    movea.l  #$00000D64,a2
    movea.l  #$00FF1804,a3
    movea.l  #$00052162,a4
    movea.l  #$00003FEC,a5
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00052142).l
    jsr DisplaySetup
    move.l  a4, -(a7)
    move.l  a3, -(a7)
    jsr     (a5)
    move.l  a4, d0
    moveq   #$68,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.l  a3, d0
    addi.l  #$360, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.l  a4, d0
    addi.l  #$aa, d0
    move.l  d0, -(a7)
    move.l  a3, d0
    addi.l  #$6c0, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.l  a4, d0
    addi.l  #$f6, d0
    move.l  d0, -(a7)
    move.l  a3, d0
    addi.l  #$a20, d0
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($0014).w
    jsr LoadDisplaySet
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($76A0).w
    move.l  a3, -(a7)
    pea     ($01B0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($0018).w
    jsr     (a2)
    pea     ($0015).w
    jsr LoadDisplaySet
    lea     $20(a7), a7
    bra.b   l_3cfba
l_3cf8c:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0005FD7E).l
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a2)
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    subq.w  #$6, d3
l_3cfba:
    cmp.w   d2, d3
    bge.b   l_3cf8c
    moveq   #$1,d2
l_3cfc0:
    clr.l   -(a7)
    pea     ($76A0).w
    move.w  d2, d0
    ext.l   d0
    move.l  #$1b0, d1
    jsr Multiply32
    add.l   d0, d0
    pea     (a3, d0.l)
    pea     ($01B0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_3cfc0
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    subi.w  #$14, d4
    subi.w  #$18, d3
    pea     ($0018).w
    jsr     (a2)
    pea     ($0016).w
    jsr LoadDisplaySet
    clr.l   -(a7)
    pea     ($76A0).w
    pea     ($00052282).l
    pea     ($0240).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    lea     $2c(a7), a7
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0005FDB6).l
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a2)
    lea     $18(a7), a7
    moveq   #$1,d2
l_3d066:
    clr.l   -(a7)
    pea     ($76A0).w
    move.w  d2, d0
    mulu.w  #$480, d0
    movea.l  #$00052282,a0
    pea     (a0, d0.w)
    pea     ($0240).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_3d066
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    movem.l (a7)+, d2-d4/a2-a5
    rts
