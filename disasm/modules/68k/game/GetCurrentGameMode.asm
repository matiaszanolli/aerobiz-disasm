; ============================================================================
; GetCurrentGameMode -- Runs the alliance slot management screen: validates the player's alliance slot, fills a local 28-byte buffer, and iterates through alliance entries (body continues into section_030000)
; 60 bytes | $02FFC4-$02FFFF
; ============================================================================
GetCurrentGameMode:
    link    a6,#-$15C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    lea     -$1c(a6), a5
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (ValidateAllianceSlot,PC)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    dc.w    $6700,$02D4                                         ; beq $0302BA
    pea     ($001C).w
    pea     ($00FF).w
    move.l  a5, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    clr.w   d4
    clr.w   d6
