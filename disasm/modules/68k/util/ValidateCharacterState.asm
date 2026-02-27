; ============================================================================
; ValidateCharacterState -- Decompresses status-icon tiles and displays one of three status tile sets based on char action flags in offset $A (bits 2/1/0 -> active/changed/pending).
; 212 bytes | $01489E-$014971
; ============================================================================
ValidateCharacterState:
    link    a6,#-$10
    movem.l d2-d3/a2, -(a7)
    movea.l $8(a6), a2
    moveq   #-$1,d3
    pea     ($0004E28A).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0018).w
    pea     ($037B).w
    jsr VRAMBulkLoad
    lea     $1c(a7), a7
    move.b  $a(a2), d0
    btst    #$2, d0
    beq.b   .l148e8
    moveq   #$0,d3
    bra.b   .l14902
.l148e8:
    move.b  $a(a2), d0
    btst    #$1, d0
    beq.b   .l148f6
    moveq   #$10,d3
    bra.b   .l14902
.l148f6:
    move.b  $a(a2), d0
    btst    #$0, d0
    beq.b   .l14902
    moveq   #$8,d3
.l14902:
    moveq   #-$1,d0
    cmp.l   d3, d0
    bge.b   .l14946
    clr.w   d2
    move.w  d2, d0
    ext.l   d0
    add.l   d3, d0
    addi.l  #$637b, d0
    move.l  d0, d3
.l14918:
    move.w  d2, d0
    add.w   d0, d0
    move.w  d3, -$10(a6, d0.w)
    addq.l  #$1, d3
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    blt.b   .l14918
    pea     -$10(a6)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0009).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001B).w
    bra.b   .l14962
.l14946:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0009).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
.l14962:
    jsr GameCommand
    movem.l -$1c(a6), d2-d3/a2
    unlk    a6
    rts
