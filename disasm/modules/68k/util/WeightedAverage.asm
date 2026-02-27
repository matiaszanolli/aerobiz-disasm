; ============================================================================
; WeightedAverage -- Computes a weighted average: multiplies value-A by weight-B and value-B by weight-A (via Multiply32), sums the products, then divides by the total weight (A+B); returns zero if both weights are zero.
; Called: ?? times.
; 82 bytes | $01E346-$01E397
; ============================================================================
WeightedAverage:                                                  ; $01E346
    movem.l d2-d4,-(sp)
    move.l  $0014(sp),d2
    move.l  $001c(sp),d3
    move.w  d2,d0
    or.w    d3,d0
    bne.b   .l1e35c
    moveq   #$0,d0
    bra.b   .l1e392
.l1e35c:                                                ; $01E35C
    moveq   #$0,d0
    move.w  $001a(sp),d0
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $0016(sp),d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$0,d1
    move.w  d2,d1
    moveq   #$0,d4
    move.w  d3,d4
    add.l   d4,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.w  d0,d2
.l1e392:                                                ; $01E392
    movem.l (sp)+,d2-d4
    rts
; ---------------------------------------------------------------------------
; PreLoopInit -- Initialize display layers before main game loop
; Sets up display mode (GameCommand 16) and two background layers (GameCommand 26)
; Called 57 times
; ---------------------------------------------------------------------------
PreLoopInit:                                                   ; $01E398
    MOVE.L  A2,-(SP)                                           ; save A2
    MOVEA.L #$00000D64,A2                                      ; A2 = GameCommand
    PEA     ($0040).W                                          ; push 64 (columns)
    CLR.L   -(SP)                                              ; push 0
    PEA     ($0010).W                                          ; command 16 (set display mode)
    JSR     (A2)                                               ; GameCommand(16, 0, 64)
    MOVE.L  #$00008000,-(SP)                                   ; push VRAM base
    PEA     ($0020).W                                          ; push 32 (height)
    PEA     ($0020).W                                          ; push 32 (width)
    CLR.L   -(SP)                                              ; push 0 (y)
    CLR.L   -(SP)                                              ; push 0 (x)
    CLR.L   -(SP)                                              ; push 0 (layer 0)
    PEA     ($001A).W                                          ; command 26 (set background)
    JSR     (A2)                                               ; GameCommand(26, 0, 0, 0, 32, 32, $8000)
    LEA     $28(SP),SP                                         ; pop 10 args (both calls)
    MOVE.L  #$00008000,-(SP)                                   ; push VRAM base
    PEA     ($0020).W                                          ; push 32 (height)
    PEA     ($0020).W                                          ; push 32 (width)
    CLR.L   -(SP)                                              ; push 0 (y)
    CLR.L   -(SP)                                              ; push 0 (x)
    PEA     ($0001).W                                          ; push 1 (layer 1)
    PEA     ($001A).W                                          ; command 26
    JSR     (A2)                                               ; GameCommand(26, 1, 0, 0, 32, 32, $8000)
    LEA     $1C(SP),SP                                         ; pop 7 args
    MOVEA.L (SP)+,A2                                           ; restore A2
    RTS
