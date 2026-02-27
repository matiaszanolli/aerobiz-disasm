; ============================================================================
; InitDefaultScenario -- Copy default scenario data block from ROM to RAM and set initial game parameters
; 190 bytes | $00A526-$00A5E3
; ============================================================================
InitDefaultScenario:
    move.l  a2, -(a7)
    movea.l  #$00FF0118,a2
    move.l  #$ff0a3c, d0
    subi.l  #$ff0000, d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    pea     ($00FF0000).l
    pea     ($00046890).l
    jsr MemMove
    move.w  #$22, ($00FF999C).l
    move.w  #$21, ($00FFBA68).l
    move.w  #$21, ($00FF1288).l
    move.w  #$42, ($00FFBD4C).l
    move.w  #$32, ($00FF1294).l
    move.w  #$a, ($00FF0118).l
    move.w  #$e42, $2(a2)
    move.w  #$2ac, $4(a2)
    move.w  #$480, $6(a2)
    move.w  #$ffff, ($00FF0A32).l
    move.w  #$1, ($00FF0008).l
    move.w  #$1, ($00FF000A).l
    move.w  #$1, ($00FF000C).l
    move.w  #$1, ($00FF000E).l
    move.w  #$1, ($00FF0010).l
    pea     ($0030).w
    pea     ($00FF1480).l
    pea     ($00047600).l
    jsr MemMove
    lea     $18(a7), a7
    movea.l (a7)+, a2
    rts
