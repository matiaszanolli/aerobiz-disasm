; ============================================================================
; ShowGameScreen -- Render the main game screen: decompress graphics, place tiles, initialize route display panel, quarterly grid, and conditionally the relation panel.
; Called: ?? times.
; 212 bytes | $020A64-$020B37
; ============================================================================
ShowGameScreen:                                                  ; $020A64
    movem.l d2-d3,-(sp)
    moveq   #$0,d3
    move.b  ($00FF0016).l,d3
    move.w  ($00FFA6B0).l,d2
    andi.w  #$7fff,d2
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0010).w
    pea     ($0010).w
    pea     ($000769FE).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($00071098).l
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    move.l  ($000A1AF0).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($00FA).w
    pea     ($0001).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$004c                                 ; jsr $020B38
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0454                                 ; jsr $020F52
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$04e8                                 ; jsr $020FF2
    nop
    lea     $001c(sp),sp
    move.w  ($00FFA6B0).l,d0
    andi.w  #$8000,d0
    beq.b   .l20b2c
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0670                                 ; jsr $021196
    nop
    addq.l  #$4,sp
.l20b2c:                                                ; $020B2C
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    movem.l (sp)+,d2-d3
    rts
; === Translated block $020B38-$021E5E ===
; 29 functions, 4902 bytes
