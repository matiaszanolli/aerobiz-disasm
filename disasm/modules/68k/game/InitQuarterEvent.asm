; ============================================================================
; InitQuarterEvent -- Reads the quarter-indexed event-count and popularity tables, stores the values in RAM, then calls a random-check function; if it returns 1 the popularity cap is set to 100.
; Called: ?? times.
; 94 bytes | $02949A-$0294F7
; ============================================================================
InitQuarterEvent:                                                  ; $02949A
    move.l  d2,-(sp)
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l294a8
    addq.l  #$3,d0
.l294a8:                                                ; $0294A8
    asr.l   #$2,d0
    move.w  d0,d2
    movea.l #$0005fcb0,a0
    move.b  (a0,d2.w),d0
    andi.l  #$ff,d0
    move.w  d0,($00FFBD4C).l
    movea.l #$0005fc6e,a0
    move.b  (a0,d2.w),d0
    andi.l  #$ff,d0
    move.w  d0,($00FF1294).l
    clr.l   -(sp)
    pea     ($0002).w
    dc.w    $4eb9,$0002,$1fd4                           ; jsr $021FD4
    addq.l  #$8,sp
    cmpi.w  #$1,d0
    bne.b   .l294f4
    move.w  #$64,($00FF1294).l
.l294f4:                                                ; $0294F4
    move.l  (sp)+,d2
    rts
; === Translated block $0294F8-$029ABC ===
; 3 functions, 1476 bytes
