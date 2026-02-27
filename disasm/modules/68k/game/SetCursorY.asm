; ============================================================================
; SetCursorY -- Sets the current text cursor Y position (row) in $FFBDA6
; Called: ?? times.
; 10 bytes | $03AAF4-$03AAFD
; ============================================================================
SetCursorY:                                                  ; $03AAF4
    move.w  $0006(sp),($00FFBDA6).l
    rts
