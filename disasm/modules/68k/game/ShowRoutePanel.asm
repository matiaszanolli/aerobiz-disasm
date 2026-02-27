; ============================================================================
; ShowRoutePanel -- Renders the route panel background: loads route tile data, decompresses and uploads route graphics to VRAM, places available route slot icons at screen positions from the $FF1480 layout table, and overlays two navigation arrow tiles
; 444 bytes | $02CF50-$02D10B
; ============================================================================
ShowRoutePanel:
    link    a6,#$0
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $c(a6), d3
    move.l  $8(a6), d4
    movea.l  #$00000D64,a4
    movea.l  #$0004E65E,a5
    jsr ResourceLoad
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    pea     ($0001).w
    jsr CmdSetBackground
    pea     ($0010).w
    pea     ($0030).w
    move.l  a5, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr DisplaySetup
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a5, d0
    addi.l  #$e8, d0
    move.l  d0, -(a7)
    pea     ($0063).w
    pea     ($017B).w
    jsr VRAMBulkLoad
    lea     $30(a7), a7
    movea.l  #$00FF17E8,a3
    movea.l  #$00FF1480,a2
    clr.w   d2
.l2cfca:
    cmpi.w  #$1, (a3)
    bne.b   .l2d016
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    lsl.l   #$3, d0
    add.l   d1, d0
    add.l   d0, d0
    lea     (a5,d0.l), a0
    lea     $22(a0), a0
    move.l  a0, -(a7)
    pea     ($0003).w
    pea     ($0003).w
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  $2(a2), d1
    add.l   d1, d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    moveq   #$0,d1
    move.w  (a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
.l2d016:
    addq.l  #$2, a3
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$b, d2
    bcs.b   .l2cfca
    move.l  a5, d0
    addi.l  #$d6, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    pea     ($0003).w
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  $2(a2), d1
    add.l   d1, d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    moveq   #$0,d1
    move.w  (a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004A7DA).l
    jsr DisplaySetup
    lea     $28(a7), a7
    pea     ($0004A7FA).l
    pea     ($000C).w
    pea     ($0020).w
    moveq   #$0,d0
    move.w  d3, d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($0004AAFA).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($017A).w
    pea     ($0001).w
    jsr VRAMBulkLoad
    pea     ($077F).w
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $30(a7), a7
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    movem.l -$1c(a6), d2-d4/a2-a5
    unlk    a6
    rts
