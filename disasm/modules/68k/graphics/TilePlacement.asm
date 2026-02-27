; ============================================================================
; TilePlacement -- Set up tile/sprite parameters, call GameCommand #15 (100 calls)
; Builds 8-byte parameter block on stack from args, then dispatches.
; Args via link frame: $E-$22(a6) = various tile params
; ============================================================================
TilePlacement:                                                   ; $01E044
    link    a6,#-8                                               ; allocate 8 bytes local
    lea     -8(a6),a0                                            ; A0 = local buffer
    move.w  #$0080,-8(a6)                                        ; buf[0] = $80 (default flags)
    move.w  $1A(a6),d0                                           ; D0 = tile row param
    addi.w  #$FFFF,d0                                            ; D0 -= 1
    andi.w  #$0003,d0                                            ; D0 &= 3 (0-3)
    moveq   #$0A,d1                                              ; D1 = 10
    lsl.w   d1,d0                                                ; D0 <<= 10 (row -> VRAM offset)
    move.w  $1E(a6),d1                                           ; D1 = tile col param
    addi.w  #$FFFF,d1                                            ; D1 -= 1
    andi.w  #$0003,d1                                            ; D1 &= 3 (0-3)
    lsl.w   #8,d1                                                ; D1 <<= 8 (col -> VRAM offset)
    or.l    d1,d0                                                ; combine row + col
    move.w  d0,2(a0)                                             ; buf[2] = tile position
    move.w  $22(a6),d0                                           ; D0 = palette/priority
    andi.w  #$FC00,d0                                            ; keep top 6 bits
    or.w    $A(a6),d0                                            ; OR with tile ID arg
    move.w  d0,4(a0)                                             ; buf[4] = tile attr + ID
    move.w  #$0080,6(a0)                                         ; buf[6] = $80 (flags)
    move.w  $16(a6),d0                                           ; D0 = height param
    ext.l   d0                                                   ; sign-extend
    move.l  d0,-(sp)                                             ; push height
    move.w  $12(a6),d0                                           ; D0 = width param
    ext.l   d0                                                   ; sign-extend
    move.l  d0,-(sp)                                             ; push width
    move.l  a0,-(sp)                                             ; push buffer ptr
    pea     ($0001).w                                            ; push 1 (mode)
    move.w  $E(a6),d0                                            ; D0 = plane select
    ext.l   d0                                                   ; sign-extend
    move.l  d0,-(sp)                                             ; push plane
    pea     ($000F).w                                            ; GameCommand #15
    jsr GameCommand
    unlk    a6                                                   ; cleanup (discards args + locals)
    rts
