; ============================================================================
; RenderRouteStatus -- Draws the animated route status display: scrolls route-line sprites across the screen from right-to-left, then draws three route arc overlays and updates VRAM write positions
; 292 bytes | $03CDAC-$03CECF
; ============================================================================
RenderRouteStatus:
    link    a6,#-$4
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $8(a6), d3
    movea.l  #$00000D64,a2
    movea.l  #$0003CED0,a3
    jsr ResourceUnload
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    move.w  #$100, d3
    move.w  #$b0, d2
    bra.b   l_3ce10
l_3cde0:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0005FD36).l
    pea     ($0009).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    subq.w  #$2, d3
    subq.w  #$1, d2
l_3ce10:
    move.w  d3, d0
    ext.l   d0
    moveq   #-$60,d1
    cmp.l   d0, d1
    ble.b   l_3cde0
    pea     ($0009).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0058).w
    pea     ($00F0).w
    pea     ($003C).w
    jsr     (a3)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $28(a7), a7
    pea     ($0060).w
    pea     ($00F0).w
    pea     ($00BC).w
    jsr     (a3)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0040).w
    pea     ($00F0).w
    pea     ($007C).w
    jsr     (a3)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    move.l  #$8b00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    lea     $30(a7), a7
    move.l  #$8c00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    addq.l  #$8, a7
    clr.w   d2
l_3ce98:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (QueueVRAMWriteAddr,PC)
    nop
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $10(a7), a7
    addq.w  #$2, d2
    cmpi.w  #$f0, d2
    ble.b   l_3ce98
    pea     ($00C8).w
    pea     ($000E).w
    jsr     (a2)
    movem.l -$14(a6), d2-d3/a2-a3
    unlk    a6
    rts
