; ============================================================================
; RoundValue -- Generates a 16-byte tile digit sprite from a 0-99 value: splits the value into tens/units, looks up pre-built 8-long digit bitmaps from a table at $48E00, ORs the two digit rows together into the caller-supplied output buffer, or zeros the buffer if value <= 0.
; 142 bytes | $01DF30-$01DFBD
; ============================================================================
RoundValue:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d2
    movea.l $20(a7), a3
    movea.l  #$00048E00,a5
    tst.w   d2
    ble.b   l_1dfa8
    cmpi.w  #$63, d2
    bge.b   l_1df52
    move.w  d2, d0
    ext.l   d0
    bra.b   l_1df54
l_1df52:
    moveq   #$63,d0
l_1df54:
    move.w  d0, d2
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d3
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    move.w  d0, d2
    tst.w   d3
    ble.b   l_1df84
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$5, d0
    lea     (a5,d0.l), a0
    addq.l  #$2, a0
    movea.l a0, a2
    bra.b   l_1df8a
l_1df84:
    movea.l a5, a2
    lea     $140(a2), a2
l_1df8a:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$5, d0
    lea     (a5,d0.l), a0
    movea.l a0, a4
    clr.w   d2
l_1df98:
    move.l  (a2)+, d0
    or.l    (a4)+, d0
    move.l  d0, (a3)+
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    blt.b   l_1df98
    bra.b   l_1dfb8
l_1dfa8:
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    bsr.w MemFillByte
    lea     $c(a7), a7
l_1dfb8:
    movem.l (a7)+, d2-d3/a2-a5
    rts

; ---------------------------------------------------------------------------
PlaceFormattedTiles:                                                  ; $01DFBE
    link    a6,#-$20
    movem.l d2-d4,-(sp)
    move.l  $000c(a6),d2
    move.l  $0014(a6),d3
    move.l  $0008(a6),d4
    pea     -$0020(a6)
    move.w  $001a(a6),d0
    move.l  d0,-(sp)
    bsr.w RoundValue
    pea     -$0020(a6)
    pea     ($0001).w
    move.w  d3,d0
    move.l  d0,-(sp)
    bsr.w ProcessTextControl
    cmpi.w  #$e,d4
    bne.b   .l1dffe
    cmpi.w  #$1e,d2
    bne.b   .l1dffe
    moveq   #$e,d2
.l1dffe:                                                ; $01DFFE
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0020                                 ; jsr $01E044
    nop
    lea     $0030(sp),sp
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    movem.l -$002c(a6),d2-d4
    unlk    a6
    rts
