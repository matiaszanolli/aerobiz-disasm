; ============================================================================
; GameSetup1 -- Plays the company-name intro sequence (or intro replay path): clears screen, loads fonts, displays company banners with fade-in/out; also handles the title-screen attract loop waiting for Start
; 1222 bytes | $03B428-$03B8ED
; ============================================================================
GameSetup1:
    link    a6,#$0
    movem.l d2/a2-a5, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$00076CFE,a3
    movea.l  #$00004B6C,a4
    movea.l a3, a5
    moveq   #$34,d0
    adda.l  d0, a5
    tst.w   $a(a6)
    beq.w   l_3b74c
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($000472CE).l
    jsr     (a4)
    jsr ClearScreen
    pea     ($000D).w
    jsr     (a2)
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w InitTextColors
    lea     $18(a7), a7
    bsr.w ClearSoundBuffer
    moveq   #$0,d0
    move.w  ($000737F8).l, d0
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($000C).w
    jsr     (a2)
    pea     ($0002).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  ($00076CFE).l, -(a7)
    jsr DrawLayersForward
    lea     $30(a7), a7
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    moveq   #$1,d2
l_3b4ea:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00048D18,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0005).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a2)
    lea     $30(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    bcs.b   l_3b4ea
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    moveq   #$6,d2
l_3b55e:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$9, d2
    bcs.b   l_3b55e
    moveq   #$9,d2
l_3b58a:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    subq.w  #$1, d2
    cmpi.w  #$5, d2
    bhi.b   l_3b58a
    moveq   #$4,d2
l_3b5b6:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    subq.w  #$1, d2
    tst.w   d2
    bne.b   l_3b5b6
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    moveq   #$A,d2
l_3b60c:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$e, d2
    bcs.b   l_3b60c
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr     (a4)
    pea     ($0007386A).l
    pea     ($0002).w
    pea     ($000E).w
    pea     ($0011).w
    pea     ($0009).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0078).w
    pea     ($000E).w
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr DrawLayersReverse
    jsr ClearScreen
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr     (a4)
    lea     $1c(a7), a7
    pea     ($000737FA).l
    pea     ($0002).w
    pea     ($001C).w
    pea     ($000F).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0078).w
    bsr.w DelayFrames
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    bsr.w FadeOutAndWait
    lea     $30(a7), a7
    jsr ClearScreen
    pea     ($000738A2).l
    pea     ($0003).w
    pea     ($0008).w
    pea     ($000B).w
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($000738D2).l
    pea     ($0003).w
    pea     ($0014).w
    pea     ($000E).w
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    bsr.w FadeInAndWait
    pea     ($00B4).w
    bsr.w DelayFrames
    lea     $30(a7), a7
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    bsr.w FadeOutAndWait
    lea     $10(a7), a7
    jsr ClearScreen
    bra.w   l_3b8e4
l_3b74c:
    clr.l   -(a7)
    pea     ($0015).w
    jsr     (a2)
    addq.l  #$8, a7
    jsr RefreshAndWait
    tst.l   d0
    beq.b   l_3b76a
    clr.l   -(a7)
    jsr SetDisplayMode
    addq.l  #$4, a7
l_3b76a:
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w InitTextColors
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($000472CE).l
    jsr     (a4)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    lea     $20(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    pea     ($000D).w
    jsr     (a2)
    lea     $20(a7), a7
    bsr.w ClearSoundBuffer
    moveq   #$0,d0
    move.w  ($000737F8).l, d0
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($000C).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    bsr.w FadeInAndWait
    lea     $30(a7), a7
    pea     ($0014).w
    bsr.w DelayFrames
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($001E).w
    bsr.w DelayFrames
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr     (a4)
    lea     $30(a7), a7
    pea     ($0034).w
    bsr.w DelayFrames
    pea     ($0007394A).l
    pea     ($0003).w
    pea     ($0016).w
    pea     ($0011).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $20(a7), a7
    clr.w   d2
l_3b89c:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.l   d0
    bne.b   l_3b8bc
    pea     ($0001).w
    bsr.w DelayFrames
    addq.l  #$4, a7
    addq.w  #$1, d2
    cmpi.w  #$1f4, d2
    bcs.b   l_3b89c
l_3b8bc:
    jsr RefreshAndWait
    tst.l   d0
    bne.b   l_3b8bc
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    bsr.w FadeOutAndWait
    jsr ClearScreen
    pea     ($001E).w
    jsr     (a2)
l_3b8e2:
    bra.b   l_3b8e2
l_3b8e4:
    movem.l -$14(a6), d2/a2-a5
    unlk    a6
    rts
