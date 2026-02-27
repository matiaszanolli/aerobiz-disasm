; ============================================================================
; ValidateCharCode -- Set up and display the character code validation screen background: DisplaySetup, LZ_Decompress validation graphic, CmdPlaceTile, window setup.
; 104 bytes | $023E40-$023EA7
; ============================================================================
ValidateCharCode:
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A7E).l
    jsr DisplaySetup
    move.l  ($000A1B10).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($002C).w
    pea     ($0342).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $20(a7), a7
    pea     ($00071F40).l
    pea     ($0002).w
    pea     ($0016).w
    pea     ($0017).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    rts
