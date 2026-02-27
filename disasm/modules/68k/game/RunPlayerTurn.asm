; ============================================================================
; RunPlayerTurn -- Read current player, loop dispatching ProcessPlayerTurnAction per action; call end-of-turn handler on  action
; Called: ?? times.
; 166 bytes | $00D6BE-$00D763
; ============================================================================
RunPlayerTurn:                                                  ; $00D6BE
    link    a6,#-$4
    movem.l d2-d4,-(sp)
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
.ld6ce:                                                 ; $00D6CE
    move.w  ($00FF9A1C).l,d3
    pea     ($0002).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$12ee                           ; jsr $0112EE
    addq.l  #$8,sp
    move.w  d0,d4
    cmpi.w  #$ff,d0
    beq.b   .ld728
    cmpi.w  #$4,d4
    bge.b   .ld712
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$005c                                 ; jsr $00D764
    nop
    lea     $000c(sp),sp
    bra.b   .ld6ce
.ld712:                                                 ; $00D712
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$118a                                 ; jsr $00E8AA
    nop
    addq.l  #$8,sp
    bra.b   .ld6ce
.ld728:                                                 ; $00D728
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    movem.l -$0010(a6),d2-d4
    unlk    a6
    rts
; === Translated block $00D764-$00E08E ===
; 3 functions, 2346 bytes
