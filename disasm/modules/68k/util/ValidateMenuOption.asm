; ============================================================================
; ValidateMenuOption -- Decompress and place the background tile for a validated menu option: mod 20 index lookup in $000482AC, LZ_Decompress to $FF1804, CmdPlaceTile2.
; 90 bytes | $023896-$0238EF
; ============================================================================
ValidateMenuOption:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$14,d1
    jsr SignedMod
    move.w  d0, d2
    add.w   d0, d0
    movea.l  #$000482AC,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    lsl.l   #$2, d0
    movea.l  #$00088C90,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0078).w
    pea     ($0640).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
    lea     $14(a7), a7
    move.l  (a7)+, d2
    rts
