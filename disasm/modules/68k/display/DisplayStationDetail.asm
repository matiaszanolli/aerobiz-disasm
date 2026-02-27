; ============================================================================
; DisplayStationDetail -- Displays the station/facility detail screen for a given city and player: loads resources, decompresses and renders station graphics to VRAM, shows the char portrait, facility name, ownership string, and optionally animates a facility tile sequence
; 746 bytes | $02BA24-$02BD0D
; ============================================================================
DisplayStationDetail:
    link    a6,#-$84
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.l  $10(a6), d5
    move.l  $c(a6), d6
    movea.l  #$00000D64,a2
    movea.l  #$00FF1804,a3
    movea.l  #$00005092,a4
    movea.l  #$0001D98C,a5
    jsr ResourceLoad
    clr.l   -(a7)
    move.l  #$fc00, -(a7)
    pea     ($0400).w
    pea     ($0001).w
    pea     ($0007).w
    jsr     (a2)
    jsr PreLoopInit
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    jsr     (a5)
    move.w  #$866, -$2(a6)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$2(a6)
    jsr     (a4)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004A0EE).l
    jsr     (a4)
    pea     ($0004A25E).l
    move.l  a3, -(a7)
    jsr LZ_Decompress
    lea     $30(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($003E).w
    pea     ($0025).w
    jsr VRAMBulkLoad
    pea     ($0004A10E).l
    pea     ($000C).w
    pea     ($000E).w
    pea     ($0003).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($00049F78).l
    move.l  a3, -(a7)
    jsr LZ_Decompress
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0024).w
    pea     ($0001).w
    jsr VRAMBulkLoad
    lea     $1c(a7), a7
    pea     ($00049DC8).l
    pea     ($000C).w
    pea     ($0012).w
    pea     ($0003).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    moveq   #$12,d4
    moveq   #$7,d3
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait
    pea     ($0004A514).l
    move.l  a3, -(a7)
    jsr LZ_Decompress
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0008).w
    pea     ($0063).w
    jsr VRAMBulkLoad
    pea     ($0004A504).l
    pea     ($0002).w
    pea     ($0004).w
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $30(a7), a7
    jsr ResourceUnload
    cmpi.w  #$1, d5
    bne.b   l_2bbd0
    pea     ($0004277E).l
    bra.b   l_2bbd6
l_2bbd0:
    pea     ($00042776).l
l_2bbd6:
    movea.l  #$00FF1278,a0
    move.b  (a0,d6.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00042784).l
    pea     -$82(a6)
    jsr sprintf
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     -$82(a6)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $28(a7), a7
    cmpi.w  #$1, ($00FF000A).l
    bne.w   l_2bcca
    clr.l   -(a7)
    jsr LoadDisplaySet
    addq.l  #$4, a7
    clr.w   d2
l_2bc3c:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr     (a5)
    move.w  d2, d0
    andi.w  #$1, d0
    beq.b   l_2bc62
    move.w  #$2cc, -$2(a6)
    bra.b   l_2bc68
l_2bc62:
    move.w  #$468, -$2(a6)
l_2bc68:
    pea     ($0001).w
    pea     ($001C).w
    pea     -$2(a6)
    jsr     (a4)
    lea     $1c(a7), a7
    cmpi.w  #$4c, d2
    bne.b   l_2bca8
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
l_2bca8:
    addq.w  #$1, d2
    cmpi.w  #$98, d2
    blt.b   l_2bc3c
    pea     ($0018).w
    jsr     (a2)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0018).w
    jsr     (a2)
    lea     $10(a7), a7
l_2bcca:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ResourceLoad
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    jsr     (a4)
    clr.l   -(a7)
    pea     ($0007).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr     (a5)
    jsr ClearBothPlanes
    movem.l -$a8(a6), d2-d6/a2-a5
    unlk    a6
    rts
