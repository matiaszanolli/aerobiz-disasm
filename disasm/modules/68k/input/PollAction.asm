; ============================================================================
; PollAction -- Poll for action/input with different loop strategies (65 calls)
; If flag $FF0A34 is clear, delays 60 frames and returns 16 (default).
; Otherwise loops calling utility $1E1EC based on arg at $E(a6).
; ============================================================================
PollAction:                                                      ; $01D62C
    link    a6,#$0000                                            ; create stack frame
    movem.l d2/a2,-(sp)                                          ; save working registers
    movea.l #$0001E1EC,a2                                        ; A2 = utility function
    tst.w   ($00FF0A34).l                                        ; is UI/system active?
    beq.s   .inactive                                            ; no -> delay and return default
    tst.w   $E(a6)                                               ; test second arg
    bne.s   .pollA                                               ; non-zero -> flush-then-wait
    bra.s   .once                                                ; zero -> single call
; -- Flush loop: call GameCmd #14 between polls (re-entry) --
.retryA:                                                         ; $01D64A
    pea     ($0001).w                                            ; sub-arg: 1
    pea     ($000E).w                                            ; GameCommand #14
    jsr GameCommand
    addq.l  #8,sp                                                ; clean 2 pea args
; -- Flush: poll until result is zero (release detection) --
.pollA:                                                          ; $01D65A
    clr.l   -(sp)                                                ; push 0 (utility arg)
    jsr     (a2)                                                 ; call utility $1E1EC
    addq.l  #4,sp                                                ; clean arg
    tst.w   d0                                                   ; still active?
    bne.s   .retryA                                              ; non-zero -> keep flushing
    bra.s   .pollB                                               ; zero -> now wait for input
; -- Wait loop: call GameCmd #14 between polls (re-entry) --
.retryB:                                                         ; $01D666
    pea     ($0001).w                                            ; sub-arg: 1
    pea     ($000E).w                                            ; GameCommand #14
    jsr GameCommand
    addq.l  #8,sp                                                ; clean 2 pea args
; -- Wait: poll until result is non-zero (press detection) --
.pollB:                                                          ; $01D676
    clr.l   -(sp)                                                ; push 0 (utility arg)
    jsr     (a2)                                                 ; call utility $1E1EC
    addq.l  #4,sp                                                ; clean arg
    move.w  d0,d2                                                ; D2 = result
    beq.s   .retryB                                              ; zero -> keep waiting
    bra.s   .result                                              ; non-zero -> done
; -- Single call path --
.once:                                                           ; $01D682
    clr.l   -(sp)                                                ; push 0 (utility arg)
    jsr     (a2)                                                 ; call utility $1E1EC
    addq.l  #4,sp                                                ; clean arg
    move.w  d0,d2                                                ; D2 = result
    bra.s   .result
; -- Inactive path: delay and return default --
.inactive:                                                       ; $01D68C
    pea     ($003C).w                                            ; push 60 (frame count)
    jsr (PollInputChange,PC)
    nop                                                          ; padding
    moveq   #$10,d2                                              ; D2 = 16 (default result)
.result:                                                         ; $01D698
    move.w  d2,d0                                                ; D0 = result
    movem.l -8(a6),d2/a2                                         ; restore from link frame
    unlk    a6                                                   ; destroy stack frame
    rts
