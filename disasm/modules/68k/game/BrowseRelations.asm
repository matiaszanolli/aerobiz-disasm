; ============================================================================
; BrowseRelations -- Collects up to 4 partner pointers, shows the relation panel, and runs a page-navigation loop calling FormatRelationStats for each visible partner
; ============================================================================
BrowseRelations:                                                  ; $018F8E
    link    a6,#-$14
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d2
    move.l  $000c(a6),d4
    move.l  $0010(a6),d6
    movea.l #$0d64,a2
    movea.l #$00ff13fc,a3
    lea     -$0012(a6),a4
    lea     -$0010(a6),a5
    clr.w   d7
    moveq   #$1,d5
    clr.w   d3
.l18fbc:                                                ; $018FBC
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$81d2                           ; jsr $0081D2
    lea     $000c(sp),sp
    move.w  d3,d1
    ext.l   d1
    lsl.l   #$2,d1
    movea.l d1,a0
    move.l  d0,(a5,a0.l)
    beq.b   .l18fe8
    moveq   #$1,d7
.l18fe8:                                                ; $018FE8
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.b   .l18fbc
    cmpi.w  #$1,d7
    bne.w   .l1923a
    clr.l   -(sp)
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    pea     ($077D).w
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    pea     ($0008).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    move.w  #$ff,d3
    bra.b   .l19054
.l19044:                                                ; $019044
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
.l19054:                                                ; $019054
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    tst.l   (a5,a0.l)
    beq.b   .l19044
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0028(sp),sp
    tst.w   d0
    beq.b   .l19076
    moveq   #$1,d4
    bra.b   .l19078
.l19076:                                                ; $019076
    moveq   #$0,d4
.l19078:                                                ; $019078
    clr.w   d6
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   (a4)
.l19084:                                                ; $019084
    cmp.w   d2,d3
    beq.b   .l190b8
    pea     ($0001).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0013).w
    clr.l   -(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a5,a0.l),-(sp)
    dc.w    $4eba,$05b4                                 ; jsr $019660
    nop
    lea     $0018(sp),sp
    move.w  d2,d3
    clr.w   d5
.l190b8:                                                ; $0190B8
    tst.w   d4
    beq.b   .l190d8
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l190d8
.l190ca:                                                ; $0190CA
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8,sp
    bra.b   .l19084
.l190d8:                                                ; $0190D8
    clr.w   d4
    addq.w  #$1,(a4)
    cmpi.w  #$1,(a4)
    bne.b   .l1914a
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0098).w
    pea     ($0078).w
    pea     ($0039).w
    pea     ($0770).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00D0).w
    pea     ($0078).w
    pea     ($003A).w
    pea     ($0771).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    lea     $001c(sp),sp
.l1913c:                                                ; $01913C
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8,sp
    bra.b   .l1916a
.l1914a:                                                ; $01914A
    cmpi.w  #$f,(a4)
    bne.b   .l19162
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    addq.l  #$8,sp
    bra.b   .l1913c
.l19162:                                                ; $019162
    cmpi.w  #$1e,(a4)
    bne.b   .l1916a
    clr.w   (a4)
.l1916a:                                                ; $01916A
    move.w  d6,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$33,d0
    move.w  d0,d6
    ext.l   d0
    moveq   #$2,d1
    cmp.w   d1,d0
    beq.b   .l1919e
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l191c2
    moveq   #$20,d1
    cmp.w   d1,d0
    beq.b   .l191e6
    moveq   #$10,d1
    cmp.w   d1,d0
    beq.b   .l191e6
    bra.w   .l1922e
.l1919e:                                                ; $01919E
    move.w  #$1,(a3)
.l191a2:                                                ; $0191A2
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    tst.l   (a5,a0.l)
    beq.b   .l191a2
    bra.w   .l190ca
.l191c2:                                                ; $0191C2
    move.w  #$1,(a3)
.l191c6:                                                ; $0191C6
    move.w  d2,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    tst.l   (a5,a0.l)
    beq.b   .l191c6
    bra.w   .l190ca
.l191e6:                                                ; $0191E6
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.l   -(sp)
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    pea     ($077D).w
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    move.w  d7,d0
    bra.b   .l1923a
.l1922e:                                                ; $01922E
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    bra.w   .l190ca
.l1923a:                                                ; $01923A
    movem.l -$003c(a6),d2-d7/a2-a5
    unlk    a6
    rts
