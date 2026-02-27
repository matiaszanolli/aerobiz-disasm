; ============================================================================
; LoadScreen -- Load and initialize a game screen
; Called: 38 times. Args (stack, no link): $10(sp)=screen_type, $14(sp)=screen_id
; ============================================================================
LoadScreen:                                                  ; $006A2E
    movem.l d2-d3/a2,-(sp)
    move.l  $0014(sp),d2                                 ; D2 = screen_id
    move.l  $0010(sp),d3                                 ; D3 = screen_type
    movea.l #$00000D64,a2                                ; A2 = GameCommand
    move.w  d2,($00FF9A1C).l                             ; store screen_id
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a2)                                         ; GameCommand($10,0,$40)
    clr.l   -(sp)
    jsr CmdSetBackground
    clr.l   -(sp)
    pea     ($0004E1EC).l
    pea     ($0001).w
    pea     ($077F).w
    jsr VRAMBulkLoad
    lea     $20(sp),sp
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)                                         ; GameCommand($1A,...)
    lea     $1C(sp),sp
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0017).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)                                         ; GameCommand($1A,...)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    jsr DisplaySetup
    lea     $28(sp),sp
    pea     ($00070198).l
    pea     ($0016).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)                                         ; GameCommand($1B,...)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #2,d0                                        ; D0 = screen_id * 4
    movea.l #$0009511C,a0                                ; A0 = screen table base
    move.l  (a0,d0.l),-(sp)                              ; push table[screen_id]
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(sp),sp
    cmpi.w  #$0004,d3                                    ; screen_type >= 4?
    bge.s   .skip_calc
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                                     ; push screen_id
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                                     ; push screen_type
    jsr UpdateSlotDisplays
    addq.l  #8,sp
.skip_calc:                                              ; $006B1E
    pea     ($02C0).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)                                         ; GameCommand($1A,...)
    lea     $28(sp),sp
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0017).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)                                         ; GameCommand($1A,...)
    lea     $1C(sp),sp
    movem.l (sp)+,d2-d3/a2
    rts
