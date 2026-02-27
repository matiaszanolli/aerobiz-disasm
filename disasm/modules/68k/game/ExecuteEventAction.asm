; ============================================================================
; ExecuteEventAction -- Iterates the active-event list; for events whose start or end dates match the current turn loads the char portrait screen, formats a dialog describing the outcome, waits for confirmation, and clears the event.
; 490 bytes | $029162-$02934B
; ============================================================================
ExecuteEventAction:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    lea     -$80(a6), a4
    movea.l  #$0005ECFC,a5
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    movea.l  #$00FFA6B8,a2
    clr.w   d3
    movea.l  #$00FF1278,a0
    lea     (a0,d3.w), a3
l_2919c:
    moveq   #$0,d5
    move.b  $6(a2), d5
    lsl.w   #$2, d5
    addi.w  #$ff24, d5
    moveq   #$0,d4
    move.b  $7(a2), d4
    lsl.w   #$2, d4
    addi.w  #$ff24, d4
    move.w  #$ff, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    move.w  d5, d1
    ext.l   d1
    subq.l  #$2, d1
    cmp.l   d1, d0
    bne.b   l_291fe
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00048370).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    clr.w   d2
    bra.w   l_292b4
l_291fe:
    cmp.w   ($00FF0006).l, d5
    bne.b   l_29238
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00048378).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    moveq   #$1,d2
    bra.b   l_292b4
l_29238:
    move.w  ($00FF0006).l, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$4, d1
    cmp.l   d1, d0
    bne.b   l_2927c
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($0004837C).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    moveq   #$2,d2
    bra.b   l_292b4
l_2927c:
    cmp.w   ($00FF0006).l, d4
    bne.b   l_292b4
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00048380).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    moveq   #$3,d2
l_292b4:
    cmpi.w  #$4, d2
    bcc.b   l_29332
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0004).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0008).w
    pea     ($0009).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait
    move.l  a4, -(a7)
    jsr DrawLabeledBox
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    tst.w   d2
    bne.b   l_2932c
    move.l  ($00048374).l, -(a7)
    jsr DrawLabeledBox
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $c(a7), a7
l_2932c:
    jsr ClearListArea
l_29332:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$1, a3
    addq.w  #$1, d3
    cmpi.w  #$10, d3
    bcs.w   l_2919c
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts
