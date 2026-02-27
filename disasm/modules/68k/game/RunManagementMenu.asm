; ============================================================================
; RunManagementMenu -- Runs the main management menu for a player's turn: shows the management screen background and player city chart, presents a 4-item menu (game mode, alliance roster, stats summary, char management), and loops until the player selects exit
; 292 bytes | $02FA28-$02FB4B
; ============================================================================
RunManagementMenu:
    link    a6,#$0
    movem.l d2-d3, -(a7)
    move.l  $8(a6), d3
    move.l  ($000A1B28).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($003E).w
    pea     ($0109).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($000725D8).l
    pea     ($0008).w
    pea     ($0008).w
    pea     ($0008).w
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
l_2fa80:
    clr.w   d2
l_2fa82:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($00047B4C).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    pea     ($0004).w
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    jsr RunPlayerSelectUI
    lea     $24(a7), a7
    move.w  d0, d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.b   l_2fae8
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($00047B50).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    cmpi.w  #$1, d0
    beq.b   l_2fb42
    bra.b   l_2fa80
l_2fae8:
    move.w  d2, d0
    ext.l   d0
    moveq   #$3,d1
    cmp.l   d1, d0
    bhi.b   l_2fa82
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0008
    dc.w    $0018
    dc.w    $0024
    dc.w    $0030
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (GetCurrentGameMode,PC)
    nop
l_2fb0e:
    addq.l  #$4, a7
    bra.w   l_2fa82
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ManageAllianceRoster,PC)
    nop
    bra.b   l_2fb0e
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowStatsSummary
    bra.b   l_2fb0e
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RunCharManagement
    addq.l  #$8, a7
    bra.w   l_2fa82
l_2fb42:
    movem.l -$8(a6), d2-d3
    unlk    a6
    rts
