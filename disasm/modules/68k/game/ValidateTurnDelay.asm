; ============================================================================
; ValidateTurnDelay -- Return 1 if aggregate character morale exceeds 90 and a random check on the excess passes, indicating a turn delay should be applied.
; 66 bytes | $021E1C-$021E5D
; ============================================================================
ValidateTurnDelay:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    move.w  d2, d0
    ext.l   d0
    subi.l  #$5a, d0
    ble.b   l_21e3a
    move.w  d2, d0
    ext.l   d0
    subi.l  #$5a, d0
    bra.b   l_21e3c
l_21e3a:
    moveq   #$0,d0
l_21e3c:
    move.w  d0, d2
    pea     ($0063).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_21e58
    moveq   #$1,d0
    bra.b   l_21e5a
l_21e58:
    moveq   #$0,d0
l_21e5a:
    move.l  (a7)+, d2
    rts

ProcessTradeAction:                                                  ; $021E5E
    movem.l d2-d5/a2-a4,-(sp)
    move.l  $0020(sp),d4
    movea.l $0028(sp),a3
    movea.l $0024(sp),a4
    moveq   #$0,d2
    move.b  (a4),d2
    moveq   #$0,d3
    move.b  (a3),d3
    movea.l #$00ff09c2,a2
    clr.w   d5
    moveq   #$0,d0
    move.b  (a2),d0
    moveq   #$4,d1
    cmp.l   d1,d0
    dc.w    $6200,$00ac                                 ; bhi.w $021F34
    add.l   d0,d0
    move.w  $21e94(pc,d0.l),d0
    jmp     $21e94(pc,d0.w)
    ; WARNING: 274 undecoded trailing bytes at $021E94
    dc.w    $000a
    dc.w    $0042
    dc.w    $005a
    dc.w    $007e
    dc.w    $0084
    dc.w    $1004
    dc.w    $2f00
    dc.w    $4878
    dc.w    $0005
    dc.w    $7000
    dc.w    $102a
    dc.w    $0001
    dc.w    $e748
    dc.w    $207c
    dc.w    $0005
    dc.w    $f9e1
    dc.w    $4870
    dc.w    $0000
    dc.w    $4eba
    dc.w    $05c6
    dc.w    $4e71
    dc.w    $4fef
    dc.w    $000c
    dc.w    $4a40
    dc.w    $676e
    dc.w    $7401
    dc.w    $3003
    dc.w    $48c0
    dc.w    $6c02
    dc.w    $5280
    dc.w    $e280
    dc.w    $3600
    dc.w    $605e
    dc.w    $7000
    dc.w    $102a
    dc.w    $0001
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $fa11
    dc.w    $1030
    dc.w    $0000
    dc.w    $b004
    dc.w    $6648
    dc.w    $60d8
    dc.w    $7000
    dc.w    $1004
    dc.w    $0280
    dc.w    $0000
    dc.w    $ffff
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $d648
    dc.w    $588f
    dc.w    $7200
    dc.w    $122a
    dc.w    $0001
    dc.w    $b041
    dc.w    $6628
    dc.w    $0642
    dc.w    $0019
    dc.w    $6022
    dc.w    $b82a
    dc.w    $0001
    dc.w    $6016
    dc.w    $7000
    dc.w    $102a
    dc.w    $0001
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0632
    dc.w    $4e71
    dc.w    $588f
    dc.w    $7200
    dc.w    $1204
    dc.w    $b041
    dc.w    $6604
    dc.w    $7464
    dc.w    $7664
    dc.w    $588a
    dc.w    $5245
    dc.w    $0c45
    dc.w    $0002
    dc.w    $6d00
    dc.w    $ff40
    dc.w    $247c
    dc.w    $00ff
    dc.w    $09ca
    dc.w    $4a12
    dc.w    $6616
    dc.w    $b82a
    dc.w    $0001
    dc.w    $6610
    dc.w    $7000
    dc.w    $102a
    dc.w    $0002
    dc.w    $9440
    dc.w    $7000
    dc.w    $102a
    dc.w    $0002
    dc.w    $9640
    dc.w    $0c42
    dc.w    $0001
    dc.w    $6f06
    dc.w    $3002
    dc.w    $48c0
    dc.w    $6002
    dc.w    $7001
    dc.w    $3400
    dc.w    $0c42
    dc.w    $0064
    dc.w    $6c06
    dc.w    $3002
    dc.w    $48c0
    dc.w    $6002
    dc.w    $7064
    dc.w    $1880
    dc.w    $0c43
    dc.w    $0001
    dc.w    $6f06
    dc.w    $3003
    dc.w    $48c0
    dc.w    $6002
    dc.w    $7001
    dc.w    $3600
    dc.w    $0c43
    dc.w    $0064
    dc.w    $6c06
    dc.w    $3003
    dc.w    $48c0
    dc.w    $6002
    dc.w    $7064
    dc.w    $1680
    dc.w    $4cdf
    dc.w    $1c3c
    dc.w    $4e75
; === Translated block $021FA6-$021FD4 ===
; 1 functions, 46 bytes
