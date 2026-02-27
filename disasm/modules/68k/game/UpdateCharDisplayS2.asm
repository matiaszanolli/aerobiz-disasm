; ============================================================================
; UpdateCharDisplayS2 -- Displays the purchase confirmation UI for a character slot: renders the char portrait and score panel, calls ReadCharInput for user input, deducts the total cost from the player's funds on confirm, updates the char age/salary record, and refreshes the panel
; 686 bytes | $02E8D8-$02EB85
; ============================================================================
UpdateCharDisplayS2:
    link    a6,#-$54
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $c(a6), d4
    move.l  $8(a6), d5
    lea     -$2(a6), a4
    lea     -$52(a6), a5
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  #$1, (a4)
    moveq   #$0,d6
    move.b  $1(a2), d6
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (CalcCharScore,PC)
    nop
    move.w  d0, d3
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.l  #$8000, -(a7)
    pea     ($0011).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $20(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0011).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($000A).w
    pea     ($0010).w
    pea     ($000A).w
    pea     ($0001).w
    jsr DrawBox
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($000B).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait
    lea     $18(a7), a7
.l2e9b4:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  ($000484CE).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($000B).w
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $20(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (ReadCharInput,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    andi.w  #$20, d0
    beq.w   .l2eb6e
    moveq   #$0,d0
    move.w  (a4), d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a4), d0
    move.l  d0, -(a7)
    move.l  ($000484D2).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($000B).w
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $24(a7), a7
    move.w  d0, d2
    cmpi.w  #$1, d2
    bne.w   .l2eb64
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0002).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    moveq   #$0,d0
    move.w  (a4), d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    add.l   d0, $6(a3)
    move.b  $1(a4), d0
    sub.b   d0, (a2)
    move.b  $1(a4), d0
    sub.b   d0, $1(a2)
    move.l  #$8000, -(a7)
    pea     ($000F).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000F).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    pea     ($0003).w
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (RefreshCharPanel,PC)
    nop
    lea     $30(a7), a7
    moveq   #$0,d0
    move.w  (a4), d0
    subq.l  #$1, d0
    beq.b   .l2eb14
    pea     ($000446D2).l
    bra.b   .l2eb1a
.l2eb14:
    pea     ($000446D0).l
.l2eb1a:
    movea.l  #$00FF1278,a0
    move.b  (a0,d4.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.w  (a4), d0
    move.l  d0, -(a7)
    move.l  ($000484D6).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($000B).w
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $28(a7), a7
    bra.b   .l2eb7a
.l2eb64:
    tst.w   d2
    bne.w   .l2e9b4
    bra.w   .l2e9b4
.l2eb6e:
    move.w  d2, d0
    andi.w  #$10, d0
    beq.w   .l2e9b4
    clr.w   (a4)
.l2eb7a:
    move.w  (a4), d0
    movem.l -$78(a6), d2-d6/a2-a5
    unlk    a6
    rts
