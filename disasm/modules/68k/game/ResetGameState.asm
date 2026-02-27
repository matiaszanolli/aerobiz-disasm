; ============================================================================
; ResetGameState -- Clears and initialises all key gameplay flags and cursor/window state variables to their default values before a new game screen
; 108 bytes | $03A8D6-$03A941
; ============================================================================
ResetGameState:                                                  ; $03A8D6
    clr.w   ($00FF1800).l
    clr.w   ($00FF128A).l
    clr.w   ($00FFBDA6).l
    clr.w   ($00FF1290).l
    move.w  #$1f,($00FF1000).l
    move.w  #$1,($00FF99DE).l
    clr.w   ($00FFBD4A).l
    move.w  #$1,($00FFA77A).l
    clr.w   ($00FFBDA4).l
    clr.w   ($00FFBD68).l
    clr.w   ($00FFB9E4).l
    moveq   #$20,d0
    move.w  d0,($00FFBD48).l
    move.w  d0,($00FFBDA8).l
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  #$1,($00FF128C).l
    rts
; ---------------------------------------------------------------------------
; SetTextWindow - Define text rendering window bounds
; Params: left (SP+4), top (SP+8), width (SP+12), height (SP+16)
; Sets win_left, win_top, win_right, win_bottom and calls cursor helpers
; 124 calls | 106 bytes | $03A942-$03A9AB
; ---------------------------------------------------------------------------
SetTextWindow:
    movem.l d2-d5,-(sp)                                    ; $03A942
    move.l  $14(sp),d2                                     ; $03A946 | left
    move.l  $1C(sp),d3                                     ; $03A94A | width
    move.l  $18(sp),d4                                     ; $03A94E | top
    move.l  $20(sp),d5                                     ; $03A952 | height
    move.w  d2,($FFBD68).l                                 ; $03A956 | win_left
    move.w  d2,($FF1290).l                                 ; $03A95C | win_left_dup
    move.w  d4,($FFB9E4).l                                 ; $03A962 | win_top
    moveq   #0,d0                                          ; $03A968
    move.w  d2,d0                                          ; $03A96A
    moveq   #0,d1                                          ; $03A96C
    move.w  d3,d1                                          ; $03A96E
    add.l   d1,d0                                          ; $03A970 | left + width
    subq.l  #1,d0                                          ; $03A972 | right = left+width-1
    move.l  d0,d3                                          ; $03A974
    move.w  d0,($FFBDA8).l                                 ; $03A976 | win_right
    move.w  d3,($FF1000).l                                 ; $03A97C | win_right_dup
    move.w  d4,d0                                          ; $03A982
    add.w   d5,d0                                          ; $03A984 | top + height
    addi.w  #$FFFF,d0                                      ; $03A986 | bottom = top+height-1
    move.w  d0,($FFBD48).l                                 ; $03A98A | win_bottom
    move.w  d2,d0                                          ; $03A990
    move.l  d0,-(sp)                                       ; $03A992
    jsr (SetCursorX,PC)
    nop                                                    ; $03A998
    move.w  d4,d0                                          ; $03A99A
    move.l  d0,-(sp)                                       ; $03A99C
    jsr (SetCursorY,PC)
    nop                                                    ; $03A9A2
    addq.l  #8,sp                                          ; $03A9A4 | clean 2 pushed params
    movem.l (sp)+,d2-d5                                    ; $03A9A6
    rts                                                    ; $03A9AA
