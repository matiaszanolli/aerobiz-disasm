; ============================================================================
; RenderStatusScreenS2 -- Renders the per-player status overview: sets up a display box, prints the player name header, loops through 7 route slots drawing route name and occupancy status, then calls ShowCharDetailS2
; 290 bytes | $02B766-$02B887
; ============================================================================
RenderStatusScreenS2:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d3
    movea.l  #$0003B270,a4
    movea.l  #$0003AB2C,a5
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004A598).l
    jsr DisplaySetup
    pea     ($0013).w
    pea     ($0018).w
    pea     ($0003).w
    pea     ($0004).w
    jsr DrawBox
    pea     ($0004).w
    pea     ($0006).w
    jsr     (a5)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00042772).l
    jsr     (a4)
    lea     $2c(a7), a7
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$00FF0270,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0130,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l2b7ea:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    jsr     (a5)
    cmpi.w  #$2, d2
    bne.b   .l2b808
    pea     ($00042762).l
    bra.b   .l2b816
.l2b808:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
.l2b816:
    pea     ($0004276E).l
    jsr     (a4)
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0016).w
    jsr     (a5)
    lea     $18(a7), a7
    tst.l   (a2)
    beq.b   .l2b848
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    pea     ($0004275E).l
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l2b852
.l2b848:
    pea     ($0004275A).l
    jsr     (a4)
    addq.l  #$4, a7
.l2b852:
    addq.l  #$1, a3
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.b   .l2b7ea
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ClearTileArea
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ShowCharDetailS2,PC)
    nop
    lea     $c(a7), a7
    movem.l (a7)+, d2-d3/a2-a5
    rts


; === Translated block $02B888-$02BDB8 ===
; 3 functions, 1328 bytes
