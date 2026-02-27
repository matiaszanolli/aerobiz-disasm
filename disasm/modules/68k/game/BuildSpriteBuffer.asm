; ============================================================================
; BuildSpriteBuffer -- Build sprite attribute table in 512-byte local buffer, submit via GameCommand #15
; 156 bytes | $0052F2-$00538D
; ============================================================================
BuildSpriteBuffer:
    link    a6,#-$200
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d7
    movea.l $1c(a6), a3
    clr.w   d3
    clr.w   d5
    bra.b   l_05354
l_05308:
    clr.w   d2
    move.w  d3, d0
    lsl.w   #$3, d0
    lea     -$200(a6), a0
    lea     (a0,d0.w), a1
    movea.l a1, a2
    moveq   #$0,d6
    move.w  d5, d6
    lsl.l   #$3, d6
    moveq   #$0,d4
    move.w  d2, d4
    lsl.l   #$3, d4
    bra.b   l_0534c
l_05326:
    move.w  d6, (a2)
    clr.w   $2(a2)
    move.w  (a3)+, $4(a2)
    move.w  d4, $6(a2)
    addq.l  #$8, a2
    moveq   #$0,d0
    addq.w  #$1, d3
    move.w  d3, d0
    moveq   #$0,d1
    move.w  d7, d1
    add.l   d1, d0
    moveq   #$40,d1
    cmp.l   d0, d1
    ble.b   l_0535a
    addq.l  #$8, d4
    addq.w  #$1, d2
l_0534c:
    cmp.w   $16(a6), d2
    bcs.b   l_05326
    addq.w  #$1, d5
l_05354:
    cmp.w   $1a(a6), d5
    bcs.b   l_05308
l_0535a:
    moveq   #$0,d0
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    pea     -$200(a6)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    jsr GameCommand
    movem.l -$220(a6), d2-d7/a2-a3
    unlk    a6
    rts

; ---------------------------------------------------------------------------
; CmdSetBackground -- Set background display via GameCommand #26
; Args: $4(SP) = layer/mode parameter
; Called 46 times
; ---------------------------------------------------------------------------
CmdSetBackground:                                              ; $00538E
    MOVE.L  $4(SP),D1                                          ; arg (layer/mode)
    MOVE.L  #$00008000,-(SP)                                   ; push VRAM base
    PEA     ($0020).W                                          ; push 32 (height)
    PEA     ($0020).W                                          ; push 32 (width)
    CLR.L   -(SP)                                              ; push 0
    CLR.L   -(SP)                                              ; push 0
    MOVEQ   #0,D0
    MOVE.W  D1,D0                                              ; zero-extend arg
    MOVE.L  D0,-(SP)                                           ; push arg
    PEA     ($001A).W                                          ; command 26
    jsr GameCommand
    LEA     $1C(SP),SP                                         ; pop 7 args
    RTS
