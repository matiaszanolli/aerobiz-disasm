; ============================================================================
; HandleCharEventTrigger -- Scans the player's route slots for type-3 char events; for each found shows the departure/arrival relation panel, presents a hire/dismiss dialog with the char's name, sets the route-flag bit, and clears the slot.
; 386 bytes | $02AC6A-$02ADEB
; ============================================================================
HandleCharEventTrigger:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $8(a6), d3
    lea     -$80(a6), a4
    movea.l  #$0000D648,a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
.l2aca4:
    cmpi.b  #$3, $1(a2)
    bne.w   .l2add6
    moveq   #$0,d2
    move.b  (a2), d2
    cmpi.b  #$1, (a3)
    bne.w   .l2adac
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    addq.l  #$4, a7
    cmp.w   ($00FF9A1C).l, d0
    beq.b   .l2ad12
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.w  d0, d5
    jsr ResourceLoad
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0003).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $1c(a7), a7
    jsr ResourceUnload
.l2ad12:
    clr.l   -(a7)
    pea     ($000E).w
    jsr MenuSelectEntry
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00042304).l
    move.l  a4, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    addq.l  #$4, a7
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000422C8).l
    move.l  a4, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    pea     ($0007).w
    jsr SelectMenuItem
    lea     $28(a7), a7
.l2adac:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FF08EC,a0
    or.l    d0, (a0,d1.w)
.l2add6:
    addq.l  #$8, a2
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.w   .l2aca4
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts
