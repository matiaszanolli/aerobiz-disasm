; ============================================================================
; SetCursorX -- Sets the current text cursor X position (column) in $FF128A
; Called: ?? times.
; 10 bytes | $03AAFE-$03AB07
; ============================================================================
SetCursorX:                                                  ; $03AAFE
    move.w  $0006(sp),($00FF128A).l
    rts
; === Translated block $03AB08-$03AB2C ===
; 1 functions, 36 bytes
