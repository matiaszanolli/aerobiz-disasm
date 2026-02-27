; ============================================================================
; ClearControllerS2 -- Runs the aircraft selection/assignment UI: draws route and character panels, handles directional input to cycle valid slots, shows a character name dialog on confirm, calls ProcessCrewSalary/FindAvailableSlot for slot management, and exits on B/cancel
; 640 bytes | $02CCD0-$02CF4F
; ============================================================================
ClearControllerS2:
    link    a6,#-$80
    movem.l d2-d5/a2-a4, -(a7)
    move.l  $8(a6), d4
    movea.l  #$00000D64,a2
    movea.l  #$00007912,a3
    movea.l  #$00048476,a4
    move.w  $e(a6), d2
    jsr ClearBothPlanes
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0007).w
    clr.l   -(a7)
    jsr (ShowRoutePanel,PC)
    nop
    lea     $c(a7), a7
    jsr ResourceUnload
.l2cd14:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  (a4), -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $14(a7), a7
    clr.w   d3
.l2cd2a:
    pea     ($0007).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ShowCharPanelS2,PC)
    nop
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addq.w  #$1, d3
    cmpi.w  #$1, d3
    bne.b   .l2cdba
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    pea     ($0018).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    pea     ($00A0).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l2cdac:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   .l2cdda
.l2cdba:
    cmpi.w  #$f, d3
    bne.b   .l2cdd2
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2cdac
.l2cdd2:
    cmpi.w  #$1e, d3
    bne.b   .l2cdda
    clr.w   d3
.l2cdda:
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, d5
    andi.w  #$20, d0
    beq.b   .l2ce60
    cmpi.w  #$b, d2
    bcc.w   .l2cf02
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF1584,a0
    tst.w   (a0,d0.w)
    bne.w   .l2cf02
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00048482).l, -(a7)
    pea     -$80(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     -$80(a6)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $20(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  (a4), -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $14(a7), a7
    bra.w   .l2cd2a
.l2ce60:
    move.w  d5, d0
    andi.w  #$10, d0
    beq.b   .l2ce6e
    moveq   #$C,d2
    bra.w   .l2cf02
.l2ce6e:
    move.w  d5, d0
    andi.w  #$4, d0
    beq.b   .l2cec4
.l2ce76:
    tst.w   d2
    bne.b   .l2ce7e
    moveq   #$A,d2
    bra.b   .l2ce94
.l2ce7e:
    cmpi.w  #$3, d2
    bne.b   .l2ce88
    moveq   #$B,d2
    bra.b   .l2ce94
.l2ce88:
    cmpi.w  #$b, d2
    bne.b   .l2ce92
    moveq   #$2,d2
    bra.b   .l2ce94
.l2ce92:
    subq.w  #$1, d2
.l2ce94:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF17E8,a0
    cmpi.w  #$1, (a0,d0.w)
    bne.b   .l2ce76
.l2cea6:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    pea     ($0006).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    bra.w   .l2cd2a
.l2cec4:
    move.w  d5, d0
    andi.w  #$8, d0
    beq.w   .l2cd2a
.l2cece:
    cmpi.w  #$a, d2
    bne.b   .l2ced8
    clr.w   d2
    bra.b   .l2ceee
.l2ced8:
    cmpi.w  #$2, d2
    bne.b   .l2cee2
    moveq   #$B,d2
    bra.b   .l2ceee
.l2cee2:
    cmpi.w  #$b, d2
    bne.b   .l2ceec
    moveq   #$3,d2
    bra.b   .l2ceee
.l2ceec:
    addq.w  #$1, d2
.l2ceee:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF17E8,a0
    cmpi.w  #$1, (a0,d0.w)
    bne.b   .l2cece
    bra.b   .l2cea6
.l2cf02:
    cmpi.w  #$c, d2
    bcc.b   .l2cf44
    cmpi.w  #$b, d2
    bne.b   .l2cf2e
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (FindAvailableSlot,PC)
    nop
    lea     $c(a7), a7
    cmpi.w  #$10, d0
    bcs.b   .l2cf44
    bra.w   .l2cd14
.l2cf2e:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (ProcessCrewSalary,PC)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   .l2cd14
.l2cf44:
    move.w  d2, d0
    movem.l -$9c(a6), d2-d5/a2-a4
    unlk    a6
    rts
