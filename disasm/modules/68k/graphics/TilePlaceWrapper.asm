; ============================================================================
; TilePlaceWrapper -- Place tile block via GameCommand(8, 2) with sub-command 1 flag
; 66 bytes | $004626-$004667
; ============================================================================
TilePlaceWrapper:
    move.l  d2, -(a7)
    move.l  $10(a7), d2
    move.l  $c(a7), d1
    movea.l $8(a7), a0
    move.w  d1, d0
    andi.l  #$7ff, d0
    lsl.l   #$5, d0
    movea.l d0, a1
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$4, d0
    move.l  d0, -(a7)
    move.l  a1, -(a7)
    move.l  a0, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.l  (a7)+, d2
    rts

; ---------------------------------------------------------------------------
; CmdPlaceTile -- Place tile block via GameCommand(5, 2, ...)
; Args: $8(SP) = src pointer, $C(SP) = tile address, $10(SP) = count
; Called 46 times
; ---------------------------------------------------------------------------
CmdPlaceTile:                                                  ; $004668
    MOVE.L  D2,-(SP)                                           ; save D2
    MOVE.L  $10(SP),D2                                         ; arg3 (count)
    MOVE.L  $C(SP),D1                                          ; arg2 (tile address)
    MOVEA.L $8(SP),A0                                          ; arg1 (src pointer)
    MOVE.W  D1,D0
    ANDI.L  #$000007FF,D0                                      ; lower 11 bits
    LSL.L   #5,D0                                              ; * 32
    MOVEA.L D0,A1                                              ; A1 = tile offset
    CLR.L   -(SP)                                              ; push 0
    MOVE.L  A1,-(SP)                                           ; push tile*32
    MOVE.L  A0,-(SP)                                           ; push src
    MOVEQ   #0,D0
    MOVE.W  D2,D0                                              ; zero-extend count
    LSL.L   #4,D0                                              ; count * 16
    MOVE.L  D0,-(SP)                                           ; push count*16
    PEA     ($0002).W                                          ; sub-command 2
    PEA     ($0005).W                                          ; command 5
    jsr GameCommand
    LEA     $18(SP),SP                                         ; pop 6 args
    MOVE.L  (SP)+,D2                                           ; restore D2
    RTS
; === Translated block $0046A6-$004BC6 ===
; 13 functions, 1312 bytes
