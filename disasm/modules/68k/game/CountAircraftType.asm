; ============================================================================
; CountAircraftType -- Counts how many of 89 aircraft slots at $FF1298 have a type byte matching the given type code; returns the count in D0
; 52 bytes | $02C994-$02C9C7
; ============================================================================
CountAircraftType:
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d4
    movea.l  #$00FF1298,a0
    clr.w   d2
    clr.w   d3
    bra.b   l_2c9ba
l_2c9a8:
    moveq   #$0,d0
    move.b  (a0), d0
    move.w  d4, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_2c9b6
    addq.w  #$1, d3
l_2c9b6:
    addq.l  #$4, a0
    addq.w  #$1, d2
l_2c9ba:
    cmpi.w  #$59, d2
    blt.b   l_2c9a8
    move.w  d3, d0
    movem.l (a7)+, d2-d4
    rts

RunPurchaseMenu:                                                  ; $02C9C8
    link    a6,#-$4
    movem.l d2-d4/a2-a3,-(sp)
    movea.l #$00ff9a1c,a2
    movea.l #$0001d71c,a3
    moveq   #$0,d4
    move.b  ($00FF0016).l,d4
    jsr     (a3)
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0001).w
    pea     ($0009).w
    dc.w    $4eb9,$0001,$d3ac                           ; jsr $01D3AC
    dc.w    $4eba,$00fa                                 ; jsr $02CAF6
    nop
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0174                                 ; jsr $02CB7C
    nop
    lea     $000c(sp),sp
    dc.w    $4eba,$0288                                 ; jsr $02CC9A
    nop
    clr.w   d3
.l2ca18:                                                ; $02CA18
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$00ff1584,a0
    cmpi.w  #$1,(a0,d0.w)
    bne.b   .l2ca2e
    move.w  d3,d2
    bra.b   .l2ca36
.l2ca2e:                                                ; $02CA2E
    addq.w  #$1,d3
    cmpi.w  #$b,d3
    bcs.b   .l2ca18
.l2ca36:                                                ; $02CA36
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$028c                                 ; jsr $02CCD0
    nop
    addq.l  #$8,sp
    move.w  d0,d2
    move.w  #$ff,($00FF17C6).l
    cmpi.w  #$b,d2
    bcc.b   .l2ca70
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$07fc                                 ; jsr $02D264
    nop
    addq.l  #$8,sp
    bra.b   .l2ca36
.l2ca70:                                                ; $02CA70
    cmpi.w  #$b,d2
    bne.b   .l2ca86
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$1856                                 ; jsr $02E2D4
    nop
    addq.l  #$4,sp
    bra.b   .l2ca36
.l2ca86:                                                ; $02CA86
    cmpi.w  #$b,d2
    bhi.b   .l2cab2
    jsr     (a3)
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($0007).w
    clr.l   -(sp)
    dc.w    $4eba,$04ae                                 ; jsr $02CF50
    nop
    lea     $000c(sp),sp
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    bra.b   .l2ca36
.l2cab2:                                                ; $02CAB2
    move.w  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9f4a                           ; jsr $009F4A
    jsr     (a3)
    pea     ($0001).w
    move.w  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    movem.l -$0018(a6),d2-d4/a2-a3
    unlk    a6
    rts
; === Translated block $02CAF6-$02F430 ===
; 25 functions, 10554 bytes
