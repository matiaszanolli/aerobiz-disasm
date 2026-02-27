; ============================================================================
; BuildAircraftAttrTable -- Copy aircraft attribute tables from ROM to RAM, interpolating between scenario variants per player count
; 470 bytes | $00C68A-$00C85F
; ============================================================================
BuildAircraftAttrTable:
    link    a6,#-$8
    movem.l d2/a2-a5, -(a7)
    pea     ($0039).w
    pea     ($00FF99A4).l
    clr.l   -(a7)
    pea     ($0005EC10).l
    clr.l   -(a7)
    jsr MemCopy
    pea     ($00C0).w
    pea     ($00FF1704).l
    clr.l   -(a7)
    pea     ($0005F0C6).l
    clr.l   -(a7)
    jsr MemCopy
    lea     $28(a7), a7
    pea     ($00E4).w
    pea     ($00FF1620).l
    clr.l   -(a7)
    pea     ($0005F186).l
    clr.l   -(a7)
    jsr MemCopy
    pea     ($0040).w
    pea     ($00FF0728).l
    clr.l   -(a7)
    pea     ($0005F532).l
    clr.l   -(a7)
    jsr MemCopy
    lea     $28(a7), a7
    tst.w   ($00FF0002).l
    bne.b   .l0c74a
    pea     ($0164).w
    pea     ($00FF1298).l
    clr.l   -(a7)
    pea     ($0005F26A).l
    clr.l   -(a7)
    jsr MemCopy
    lea     $14(a7), a7
    pea     ($00B2).w
    pea     ($00FF8824).l
    clr.l   -(a7)
    pea     ($0005F572).l
.l0c73a:
    clr.l   -(a7)
    jsr MemCopy
    lea     $14(a7), a7
    bra.w   .l0c856
.l0c74a:
    cmpi.w  #$3, ($00FF0002).l
    bne.b   .l0c786
    pea     ($0164).w
    pea     ($00FF1298).l
    clr.l   -(a7)
    pea     ($0005F3CE).l
    clr.l   -(a7)
    jsr MemCopy
    lea     $14(a7), a7
    pea     ($00B2).w
    pea     ($00FF8824).l
    clr.l   -(a7)
    pea     ($0005F624).l
    bra.b   .l0c73a
.l0c786:
    movea.l  #$0005F26A,a4
    movea.l  #$0005F3CE,a3
    movea.l  #$00FF1298,a2
    move.l  #$5f572, -$4(a6)
    move.l  #$5f624, -$8(a6)
    movea.l  #$00FF8824,a5
    clr.w   d2
.l0c7b0:
    move.b  (a3), (a2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ScaleAircraftAttrValue,PC)
    nop
    move.b  d0, $1(a2)
    moveq   #$0,d0
    move.b  $2(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ScaleAircraftAttrValue,PC)
    nop
    move.b  d0, $2(a2)
    moveq   #$0,d0
    move.b  $3(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ScaleAircraftAttrValue,PC)
    nop
    move.b  d0, $3(a2)
    movea.l -$8(a6), a0
    move.b  (a0), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    movea.l -$4(a6), a0
    move.b  (a0), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ScaleAircraftAttrValue,PC)
    nop
    lea     $20(a7), a7
    move.b  d0, (a5)
    clr.b   $1(a5)
    addq.l  #$4, a4
    addq.l  #$4, a3
    addq.l  #$4, a2
    addq.l  #$2, -$4(a6)
    addq.l  #$2, -$8(a6)
    addq.l  #$2, a5
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.w   .l0c7b0
.l0c856:
    movem.l -$1c(a6), d2/a2-a5
    unlk    a6
    rts
