; ============================================================================
; ShowTextDialog -- Display text dialog with formatted output (31 calls)
; Uses link frame. Displays formatted text via PrintfWide, does table lookup
; via $643C, then optionally calls $7784 or PollAction based on flag args.
; Args: $8.l=index, $C.l=data, $12.w=col, $16.w=param, $1A.w=flag1, $1E.w=flag2
; ============================================================================
ShowTextDialog:                                              ; $01183A
    link    a6,#$0000
    movem.l d2-d3,-(sp)
    move.l  $0008(a6),d2                                     ; d2 = index
    pea     ($0020).w                                        ; width = 32
    pea     ($0020).w                                        ; height = 32
    clr.l   -(sp)                                            ; left = 0
    clr.l   -(sp)                                            ; top = 0
    jsr SetTextWindow
    pea     ($0019).w                                        ; x = 25
    pea     ($0013).w                                        ; y = 19
    jsr SetTextCursor
    move.w  d2,d0
    mulu.w  #$0024,d0                                        ; index * 36 (record size)
    movea.l #$00FF001E,a0                                    ; record table base
    move.l  (a0,d0.w),-(sp)                                  ; push record field
    pea     ($0003F1B2).l                                    ; format string
    jsr PrintfWide
    lea     $20(sp),sp                                       ; clean 32 bytes
    move.l  $000C(a6),-(sp)                                  ; push data arg
    pea     ($0001).w
    pea     ($0001).w
    move.w  $0016(a6),d0
    move.l  d0,-(sp)                                         ; param (extended)
    move.w  d2,d0
    move.l  d0,-(sp)                                         ; index (extended)
    pea     ($0002).w
    pea     ($0780).w
    move.w  d2,d0
    mulu.w  #$000A,d0                                        ; index * 10
    move.w  $0012(a6),d1                                     ; col arg
    add.w   d1,d1                                            ; col * 2
    add.w   d1,d0                                            ; offset += col*2
    movea.l #$00FF03B8,a0                                    ; lookup table base
    move.w  (a0,d0.w),d1                                     ; table[index*10+col*2]
    move.l  d1,-(sp)
    jsr DrawCharInfoPanel
    lea     $20(sp),sp                                       ; clean 32 bytes
    cmpi.w  #$0001,$001A(a6)                                 ; flag1 == 1?
    bne.s   .check_f2                                        ; no, check flag2
    pea     ($001A).w
    pea     ($0006).w
    jsr SelectPreviewPage
    addq.l  #8,sp                                            ; clean args
    move.w  d0,d3                                            ; d3 = result
    bra.s   .epilogue
.check_f2:                                                   ; $0118E4
    cmpi.w  #$0001,$001E(a6)                                 ; flag2 == 1?
    bne.s   .epilogue                                        ; no, skip
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
.epilogue:                                                   ; $0118FA
    move.w  d3,d0                                            ; return value
    movem.l -$08(a6),d2-d3
    unlk    a6
    rts
