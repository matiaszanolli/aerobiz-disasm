; ============================================================================
; ShowDialog -- Display dialog with table lookup and optional input (38 calls)
; No link frame. Args via sp: d2=index, a2=data ptr, d6=row, d5=flag1, d4=flag2
; Returns result in d0 (from $7784 if flag1, else d3 default).
; ============================================================================
ShowDialog:                                                  ; $007912
    movem.l d2-d6/a2,-(sp)
    move.l  $001C(sp),d2                                     ; arg1: index
    move.l  $002C(sp),d4                                     ; arg5: flag2
    move.l  $0028(sp),d5                                     ; arg4: flag1
    move.l  $0024(sp),d6                                     ; arg3: row
    movea.l $0020(sp),a2                                     ; arg2: data pointer
    pea     ($0020).w                                        ; width = 32
    pea     ($0020).w                                        ; height = 32
    clr.l   -(sp)                                            ; left = 0
    clr.l   -(sp)                                            ; top = 0
    jsr SetTextWindow
    move.l  a2,-(sp)                                         ; data pointer
    pea     ($0001).w
    pea     ($0001).w
    move.w  d6,d0
    move.l  d0,-(sp)                                         ; row (extended)
    move.w  d2,d0
    move.l  d0,-(sp)                                         ; index (extended)
    pea     ($0002).w
    pea     ($0780).w
    move.w  d2,d0
    mulu.w  #$000A,d0                                        ; index * 10
    movea.l #$00FF03C0,a0                                    ; lookup table base
    move.w  (a0,d0.w),d1                                     ; table[index*10]
    move.l  d1,-(sp)
    jsr DrawCharInfoPanel
    lea     $30(sp),sp                                       ; clean 48 bytes
    cmpi.w  #$0001,d5                                        ; flag1 == 1?
    bne.s   .check_f2                                        ; no, check flag2
    pea     ($001A).w
    pea     ($0008).w
    bsr.w SelectPreviewPage
    addq.l  #8,sp                                            ; clean args
    move.w  d0,d3                                            ; d3 = result
    bra.s   .epilogue
.check_f2:                                                   ; $00798A
    cmpi.w  #$0001,d4                                        ; flag2 == 1?
    bne.s   .epilogue                                        ; no, skip
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #8,sp                                            ; clean args
.epilogue:                                                   ; $0079A0
    move.w  d3,d0                                            ; return value
    movem.l (sp)+,d2-d6/a2
    rts
; === Translated block $0079A8-$007A24 ===
; 1 functions, 124 bytes
