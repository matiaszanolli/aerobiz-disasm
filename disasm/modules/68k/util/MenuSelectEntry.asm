; ============================================================================
; MenuSelectEntry -- Validate selection index, dispatch GameCommand calls
; Called: 14 times. Args (stack): 8(a6)=selection index (w), E(a6)=mode flag (w)
; ============================================================================
MenuSelectEntry:                                             ; $01D3AC
    link    a6,#$0000
    movem.l d2/a2/a3,-(sp)
    move.l  $0008(a6),d2                                 ; D2 = selection index
    movea.l #$00000D64,a2                                ; A2 = GameCommand
    movea.l #$00FFBD52,a3                                ; A3 = stored selection ptr
    move.w  ($00FF1274).l,d0                             ; D0 = display state
    andi.l  #$00000001,d0                                ; isolate active bit
    moveq   #1,d1
    cmp.l   d0,d1                                        ; active?
    bne.s   .done                                        ; no -> exit
    pea     ($0001).w
    bsr.w SetDisplayMode
    addq.l  #4,sp
    tst.w   d2                                           ; index >= 0?
    bge.s   .check_upper
    cmpi.w  #$0016,d2
    bgt.s   .done                                        ; out of range
.check_upper:                                            ; $01D3EA
    cmp.w   (a3),d2                                      ; already selected?
    beq.s   .do_set
    pea     ($0008).w
    pea     ($0013).w
    jsr     (a2)                                         ; GameCommand($13,$8)
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a2)                                         ; GameCommand($14,$E)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #2,d0                                        ; D0 = index * 4
    movea.l #$000F0000,a0                                ; A0 = table base
    move.l  (a0,d0.l),-(sp)                              ; push table[index]
    pea     ($0012).w
    jsr     (a2)                                         ; GameCommand($12,entry)
    lea     $18(sp),sp                                   ; clean 6 args (3 calls)
.do_set:                                                 ; $01D41C
    cmpi.w  #$0001,$000E(a6)                             ; mode flag == 1?
    bne.s   .store_ffff
    move.w  d2,(a3)                                      ; save selection
    pea     ($0001).w
    bra.s   .call_game15
.store_ffff:                                             ; $01D42C
    move.w  #$FFFF,(a3)                                  ; reset stored selection
    clr.l   -(sp)
.call_game15:                                            ; $01D432
    pea     ($0015).w
    jsr     (a2)                                         ; GameCommand($15,...)
.done:                                                   ; $01D438
    moveq   #0,d0
    movem.l -$C(a6),d2/a2/a3
    unlk    a6
    rts
