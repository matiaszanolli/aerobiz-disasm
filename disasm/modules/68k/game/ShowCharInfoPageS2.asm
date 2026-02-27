; ============================================================================
; ShowCharInfoPageS2 -- Displays one page of a character info dialog: sets the text window, calls DrawCharInfoPanel with layout from table at $485BE, prints the character name, then either waits for a button press or runs a SelectPreviewPage scroll loop depending on the mode flag
; 230 bytes | $02F34A-$02F42F
; ============================================================================
ShowCharInfoPageS2:
    link    a6,#-$4
    movem.l d2-d3, -(a7)
    move.l  $8(a6), d2
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.l  $c(a6), -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0003).w
    pea     ($079E).w
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$000485BE,a0
    move.w  (a0,d0.w), d1
    move.l  d1, -(a7)
    jsr DrawCharInfoPanel
    lea     $30(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0008).w
    pea     ($000B).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004471A).l
    jsr PrintfWide
    lea     $20(a7), a7
    cmpi.w  #$1, $16(a6)
    bne.b   .l2f40e
    pea     ($0009).w
    pea     ($0002).w
    jsr SelectPreviewPage
    move.w  d0, d3
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0020).w
    pea     ($0008).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $24(a7), a7
    bra.b   .l2f424
.l2f40e:
    cmpi.w  #$1, $1a(a6)
    bne.b   .l2f424
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
.l2f424:
    move.w  d3, d0
    movem.l -$c(a6), d2-d3
    unlk    a6
    rts
