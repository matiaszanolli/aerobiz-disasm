; ============================================================================
; ProcessCharAnimS2 -- Processes up to four pending char-event animation records for a player's route slots: formats a narrative message describing the event (hire, fire, accident, purchase) and shows a text dialog, then clears the animation record.
; 546 bytes | $02A922-$02AB43
; ============================================================================
ProcessCharAnimS2:
    link    a6,#-$100
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d6
    lea     -$100(a6), a4
    movea.l  #$000483C4,a5
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d6, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d5
.l2a95c:
    move.b  $1(a2), d0
    andi.b  #$c0, d0
    beq.w   .l2ab2e
    cmpi.b  #$1, (a3)
    bne.w   .l2ab1c
    move.b  $1(a2), d0
    btst    #$6, d0
    beq.b   .l2a97e
    clr.w   d3
    bra.b   .l2a980
.l2a97e:
    moveq   #$1,d3
.l2a980:
    andi.b  #$3f, $1(a2)
    cmpi.b  #$6, $1(a2)
    bne.b   .l2a994
    moveq   #$0,d4
    move.b  (a2), d4
    bra.b   .l2a9a6
.l2a994:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d4
.l2a9a6:
    cmpi.b  #$1, $1(a2)
    bne.b   .l2a9e0
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00042244).l
.l2a9d0:
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.w   .l2aac4
.l2a9e0:
    cmpi.b  #$3, $1(a2)
    bne.b   .l2aa0c
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00042212).l
    bra.b   .l2a9d0
.l2aa0c:
    cmpi.b  #$5, $1(a2)
    bne.b   .l2aa7e
    moveq   #$0,d2
    move.b  $2(a2), d2
    cmpi.b  #$20, (a2)
    bcc.b   .l2aa32
    moveq   #$0,d0
    move.b  (a2), d0
    mulu.w  #$6, d0
    add.w   d2, d0
    movea.l  #$00FF1704,a0
    bra.b   .l2aa40
.l2aa32:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    add.w   d2, d0
    movea.l  #$00FF1620,a0
.l2aa40:
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000421DC).l
    bra.b   .l2aab8
.l2aa7e:
    cmpi.b  #$6, $1(a2)
    bne.b   .l2aac4
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.w  $6(a2), d0
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($000421B8).l
.l2aab8:
    move.l  a4, -(a7)
    jsr sprintf
    lea     $14(a7), a7
.l2aac4:
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    beq.b   .l2aafa
    jsr ResourceLoad
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    lea     $c(a7), a7
    jsr ResourceUnload
.l2aafa:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
.l2ab1c:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
.l2ab2e:
    addq.l  #$8, a2
    addq.w  #$1, d5
    cmpi.w  #$4, d5
    bcs.w   .l2a95c
    movem.l -$124(a6), d2-d6/a2-a5
    unlk    a6
    rts
