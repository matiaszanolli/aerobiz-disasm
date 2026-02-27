; ============================================================================
; ResourceLoad -- Load resource if not already loaded (106 calls)
; Pushes 4 args, calls $4CB6, sets flag at $FFA7DC
; ============================================================================
ResourceLoad:                                                    ; $01D71C
    tst.w   ($00FFA7DC).l                                        ; Already loaded?
    bne.s   .done                                                ; Yes -> skip
    pea     ($0002).w                                            ; arg: 2
    pea     ($0040).w                                            ; arg: $40
    clr.l   -(sp)                                                ; arg: 0
    pea     ($00FF14BC).l                                        ; arg: work RAM buffer
    jsr DrawLayersReverse
    lea     $10(sp),sp                                           ; clean 16 bytes of args
    move.w  #$0001,($00FFA7DC).l                                 ; set loaded flag
.done:                                                           ; $01D746
    rts
