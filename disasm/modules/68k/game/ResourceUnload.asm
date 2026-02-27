; ============================================================================
; ResourceUnload -- Unload resource if loaded (95 calls)
; Pushes 4 args, calls $4D04, clears flag at $FFA7DC
; ============================================================================
ResourceUnload:                                                  ; $01D748
    tst.w   ($00FFA7DC).l                                        ; Is it loaded?
    beq.s   .done                                                ; No -> skip
    pea     ($0002).w                                            ; arg: 2
    pea     ($0040).w                                            ; arg: $40
    clr.l   -(sp)                                                ; arg: 0
    pea     ($00FF14BC).l                                        ; arg: work RAM buffer
    jsr DrawLayersForward
    lea     $10(sp),sp                                           ; clean 16 bytes of args
    clr.w   ($00FFA7DC).l                                        ; clear loaded flag
.done:                                                           ; $01D770
    rts
; ---
; === Translated block $01D772-$01D7BE ===
; 1 functions, 76 bytes
