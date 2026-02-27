; ============================================================================
; CheckEventMatch -- Test if the active event state in $FF09C2 matches a given character code across multiple criteria (char list, aircraft type, char index, D648, $022554).
; Called: ?? times.
; 310 bytes | $021FD4-$022109
; ============================================================================
CheckEventMatch:                                                  ; $021FD4
    movem.l d2-d5/a2-a4,-(sp)
    move.l  $0024(sp),d2
    move.l  $0020(sp),d4
    movea.l #$d648,a4
    movea.l #$00ff09c2,a2
    clr.w   d5
    cmpi.b  #$ff,(a2)
    beq.w   .l22106
    cmpi.w  #$5,d2
    beq.b   .l22006
    moveq   #$0,d0
    move.b  (a2),d0
    cmp.w   d2,d0
    bne.w   .l22106
.l22006:                                                ; $022006
    tst.w   d2
    beq.b   .l22010
    cmpi.w  #$5,d2
    bne.b   .l22058
.l22010:                                                ; $022010
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$3,d0
    movea.l #$0005f9e1,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    clr.w   d3
    bra.b   .l2204c
.l22028:                                                ; $022028
    moveq   #$0,d0
    move.b  (a3),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    ext.l   d0
    moveq   #$0,d1
    move.w  d4,d1
    cmp.l   d1,d0
    bne.b   .l22048
.l22042:                                                ; $022042
    moveq   #$1,d0
    dc.w    $6000,$00ce                                 ; bra.w $022114
.l22048:                                                ; $022048
    addq.l  #$1,a3
    addq.w  #$1,d3
.l2204c:                                                ; $02204C
    cmpi.w  #$5,d3
    bge.b   .l22058
    cmpi.b  #$ff,(a3)
    bne.b   .l22028
.l22058:                                                ; $022058
    cmpi.w  #$1,d2
    beq.b   .l22064
    cmpi.w  #$5,d2
    bne.b   .l22092
.l22064:                                                ; $022064
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005fa11,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    ext.l   d0
    moveq   #$0,d1
    move.w  d4,d1
    cmp.l   d1,d0
    beq.b   .l22042
.l22092:                                                ; $022092
    cmpi.w  #$2,d2
    beq.b   .l2209e
    cmpi.w  #$5,d2
    bne.b   .l220a8
.l2209e:                                                ; $02209E
    moveq   #$0,d0
    move.b  $0001(a2),d0
    cmp.w   d4,d0
    beq.b   .l22042
.l220a8:                                                ; $0220A8
    cmpi.w  #$3,d2
    beq.b   .l220b4
    cmpi.w  #$5,d2
    bne.b   .l220d2
.l220b4:                                                ; $0220B4
    moveq   #$0,d0
    move.b  $0001(a2),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    ext.l   d0
    moveq   #$0,d1
    move.w  d4,d1
    cmp.l   d1,d0
    beq.w   .l22042
.l220d2:                                                ; $0220D2
    cmpi.w  #$4,d2
    beq.b   .l220de
    cmpi.w  #$5,d2
    bne.b   .l22106
.l220de:                                                ; $0220DE
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    dc.w    $4eba,$046c                                 ; jsr $022554
    nop
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    ext.l   d0
    moveq   #$0,d1
    move.w  d4,d1
    cmp.l   d1,d0
    beq.w   .l22042
.l22106:                                                ; $022106
    addq.l  #$4,a2
    addq.w  #$1,d5
    dc.w    $0C45,$0002,$6D00                                ; $02210A
; === Translated block $022110-$022554 ===
; 8 functions, 1092 bytes
