; ============================================================================
; ShowCharInfoPage -- Variant of ShowCharInfoPageS2 using a different layout table ($485D6) and different sub-calls; same page structure (DrawCharInfoPanel + char name + wait/scroll) but for an alternate info page display context
; Called: ?? times.
; 190 bytes | $02F430-$02F4ED
; ============================================================================
ShowCharInfoPage:                                                  ; $02F430
    link    a6,#$0
    movem.l d2-d3,-(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    move.w  $000a(a6),d2
    move.l  $000c(a6),-(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0003).w
    pea     ($079E).w
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$000485d6,a0
    move.w  (a0,d0.w),d1
    move.l  d1,-(sp)
    dc.w    $4eb9,$0000,$643c                           ; jsr $00643C
    lea     $0030(sp),sp
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0010(sp),sp
    cmpi.w  #$1,$0016(a6)
    bne.b   .l2f4cc
    pea     ($0009).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$7784                           ; jsr $007784
    move.w  d0,d3
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0020).w
    pea     ($0008).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
    bra.b   .l2f4e2
.l2f4cc:                                                ; $02F4CC
    cmpi.w  #$1,$001a(a6)
    bne.b   .l2f4e2
    pea     ($0001).w
    pea     ($0003).w
    dc.w    $4eb9,$0001,$d62c                           ; jsr $01D62C
.l2f4e2:                                                ; $02F4E2
    move.w  d3,d0
    movem.l -$0008(a6),d2-d3
    unlk    a6
    rts
