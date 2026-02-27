; ============================================================================
; InitAllGameTables -- Zero all major game RAM regions (player records, route slots, char stats, city data) and init route slot sentinels
; 754 bytes | $00B74C-$00BA3D
; ============================================================================
InitAllGameTables:
    movem.l d2/a2-a5, -(a7)
    movea.l  #$0001D520,a2
    movea.l  #$00FF88DC,a3
    movea.l  #$00FF9A20,a4
    movea.l  #$0001D538,a5
    pea     ($0090).w
    clr.l   -(a7)
    pea     ($00FF0018).l
    jsr     (a2)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00FF00A8).l
    jsr     (a2)
    pea     ($0030).w
    clr.l   -(a7)
    pea     ($00FF00E8).l
    jsr     (a2)
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF0130).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF01B0).l
    jsr     (a2)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00FF0230).l
    jsr     (a2)
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($00FF0270).l
    jsr     (a2)
    pea     ($0018).w
    clr.l   -(a7)
    pea     ($00FF0290).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FFB9E8).l
    jsr     (a2)
    pea     ($0050).w
    clr.l   -(a7)
    pea     ($00FF02E8).l
    jsr     (a2)
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF0338).l
    jsr     (a2)
    pea     ($0030).w
    clr.l   -(a7)
    pea     ($00FF03F0).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FF08EC).l
    jsr     (a2)
    pea     ($00C0).w
    pea     ($00FF).w
    pea     ($00FF0420).l
    jsr     (a2)
    pea     ($00E4).w
    pea     ($00FF).w
    pea     ($00FF04E0).l
    jsr     (a2)
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($00FF09A2).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0059).w
    clr.l   -(a7)
    pea     ($00FF09D8).l
    jsr     (a2)
    pea     ($001C).w
    clr.l   -(a7)
    pea     ($00FFBDE4).l
    jsr     (a2)
    pea     ($001C).w
    clr.l   -(a7)
    pea     ($00FFA7BC).l
    jsr     (a2)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FFA6A0).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0038).w
    clr.l   -(a7)
    pea     ($00FFBD6C).l
    jsr     (a2)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FF1278).l
    jsr     (a2)
    pea     ($02C8).w
    clr.l   -(a7)
    pea     ($00FFBA80).l
    jsr     (a2)
    pea     ($00E4).w
    clr.l   -(a7)
    pea     ($00FF05C4).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0C80).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr     (a2)
    lea     $c(a7), a7
    move.b  #$ff, ($00FF9A20).l
    move.b  #$ff, $1(a4)
    moveq   #$1,d2
.l0b8f2:
    pea     ($0014).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    pea     (a4, d0.l)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$28, d2
    blt.b   .l0b8f2
    moveq   #$1,d2
.l0b91c:
    pea     ($0320).w
    move.w  d2, d0
    ext.l   d0
    move.l  #$320, d1
    jsr Multiply32
    pea     (a4, d0.l)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0b91c
    pea     ($00C0).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr     (a2)
    lea     $c(a7), a7
    move.w  #$ff, ($00FF88DC).l
    move.w  #$ff, $2(a3)
    moveq   #$1,d2
.l0b966:
    pea     ($000C).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    pea     (a3, d0.l)
    clr.l   -(a7)
    move.l  a3, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0b966
    moveq   #$1,d2
.l0b990:
    pea     ($0030).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$4, d0
    pea     (a3, d0.l)
    clr.l   -(a7)
    move.l  a3, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0b990
    pea     ($0070).w
    clr.l   -(a7)
    pea     ($00FF1004).l
    jsr     (a2)
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($00FF09C2).l
    jsr     (a2)
    clr.w   d2
.l0b9d6:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF09C2,a0
    move.b  #$ff, (a0,d0.w)
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   .l0b9d6
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($00FF09CA).l
    jsr     (a2)
    move.b  #$ff, ($00FF09CA).l
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($00FF09CE).l
    jsr     (a2)
    lea     $30(a7), a7
    clr.w   d2
.l0ba18:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF09CE,a0
    move.b  #$ff, (a0,d0.w)
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   .l0ba18
    move.w  #$ff, ($00FF09D6).l
    movem.l (a7)+, d2/a2-a5
    rts
