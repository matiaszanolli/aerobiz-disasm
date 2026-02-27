; ============================================================================
; ReturnError -- Set carry flag and return to signal timeout or error to caller
; 6 bytes | $001C9A-$001C9F
; ============================================================================
ReturnError:
l_01c9a:
    ori.b   #$1, ccr
    rts
