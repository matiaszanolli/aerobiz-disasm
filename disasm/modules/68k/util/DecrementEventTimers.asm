; ============================================================================
; DecrementEventTimers -- Iterates the event-schedule table and for each event whose trigger date matches the current turn formats a notification, animates the info panel, displays it, then calls WriteEventField and UnpackEventRecord to commit the event effect.
; 576 bytes | $028B70-$028DAF
; ============================================================================
DecrementEventTimers:
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00048348,a4
    movea.l  #$0005EB2C,a5
    movea.l  #$0005FAB6,a2
    clr.w   d3
    movea.l a4, a3
    addq.l  #$8, a3
l_28b8c:
    move.w  (a2), d5
    lsl.w   #$2, d5
    add.w   $2(a2), d5
    addi.w  #$e174, d5
    cmp.w   ($00FF0006).l, d5
    bne.w   l_28d92
    tst.b   $4(a2)
    bne.b   l_28bf0
    moveq   #$10,d2
    moveq   #$0,d0
    move.b  $5(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  $7(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.l  ($00048348).l, -(a7)
l_28bde:
    pea     -$80(a6)
    jsr sprintf
    lea     $10(a7), a7
    bra.w   l_28ccc
l_28bf0:
    cmpi.b  #$1, $4(a2)
    bne.b   l_28c1e
    moveq   #$10,d2
    moveq   #$0,d0
    move.b  $5(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.l  $4(a4), -(a7)
l_28c0c:
    pea     -$80(a6)
    jsr sprintf
    lea     $c(a7), a7
    bra.w   l_28ccc
l_28c1e:
    cmpi.b  #$2, $4(a2)
    bne.b   l_28c6c
    moveq   #$10,d2
    cmpi.b  #$2, $7(a2)
    bcc.b   l_28c48
    pea     ($00041F72).l
l_28c36:
    moveq   #$0,d0
    move.b  $5(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.l  (a3), -(a7)
    bra.b   l_28bde
l_28c48:
    cmpi.b  #$4, $7(a2)
    bcc.b   l_28c58
    pea     ($00041F6A).l
    bra.b   l_28c36
l_28c58:
    moveq   #$0,d0
    move.b  $5(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.l  $24(a4), -(a7)
    bra.b   l_28c0c
l_28c6c:
    cmpi.b  #$3, $4(a2)
    bne.b   l_28c9e
    moveq   #$11,d2
    moveq   #$0,d0
    move.b  $5(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.l  $c(a4), -(a7)
    bra.w   l_28c0c
l_28c9e:
    cmpi.b  #$4, $4(a2)
    bne.b   l_28caa
l_28ca6:
    moveq   #$10,d2
    bra.b   l_28ccc
l_28caa:
    cmpi.b  #$5, $4(a2)
    beq.b   l_28cca
    cmpi.b  #$6, $4(a2)
    beq.b   l_28ca6
    cmpi.b  #$7, $4(a2)
    beq.b   l_28cca
    cmpi.b  #$8, $4(a2)
    bne.b   l_28ccc
l_28cca:
    moveq   #$11,d2
l_28ccc:
    cmpi.b  #$ff, $4(a2)
    beq.w   l_28d78
    pea     -$94(a6)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (PackEventRecord,PC)
    nop
    move.w  d0, d4
    move.l  d0, -(a7)
    pea     -$94(a6)
    jsr AnimateInfoPanel
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr InitInfoPanel
    cmpi.b  #$4, $4(a2)
    bne.b   l_28d0a
    move.l  $10(a4), -(a7)
    bra.b   l_28d46
l_28d0a:
    cmpi.b  #$5, $4(a2)
    bne.b   l_28d18
    move.l  $14(a4), -(a7)
    bra.b   l_28d46
l_28d18:
    cmpi.b  #$6, $4(a2)
    bne.b   l_28d26
    move.l  $18(a4), -(a7)
    bra.b   l_28d46
l_28d26:
    cmpi.b  #$7, $4(a2)
    bne.b   l_28d34
    move.l  $1c(a4), -(a7)
    bra.b   l_28d46
l_28d34:
    cmpi.b  #$8, $4(a2)
    bne.b   l_28d42
    move.l  $20(a4), -(a7)
    bra.b   l_28d46
l_28d42:
    pea     -$80(a6)
l_28d46:
    jsr DrawLabeledBox
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ClearListArea
    jsr ClearInfoPanel
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     -$94(a6)
    jsr PlaceItemTiles
    lea     $28(a7), a7
l_28d78:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (WriteEventField,PC)
    nop
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (UnpackEventRecord,PC)
    nop
    addq.l  #$8, a7
l_28d92:
    cmp.w   ($00FF0006).l, d5
    bgt.b   l_28da6
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$37, d3
    bcs.w   l_28b8c
l_28da6:
    movem.l -$b4(a6), d2-d5/a2-a5
    unlk    a6
    rts
