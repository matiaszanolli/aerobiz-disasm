; ============================================================================
; CmdSaveBuffer -- Save 8 bytes to display buffer or clear display and reset sprite links if arg is zero
; 56 bytes | $000F42-$000F79
; ============================================================================
CmdSaveBuffer:
    bclr    #$0, $c62(a5)
    move.l  $e(a6), d2
    beq.b   l_00f64
    movea.l  #$00FFFC74,a2
    movea.l $12(a6), a3
    move.l  (a3)+, (a2)+
    move.l  (a3), (a2)
    bset    #$0, $c62(a5)
    bra.b   l_00f78
l_00f64:
    move.l  #$0, $7a(a5)
    jsr (InitSpriteLinks,PC)
    nop
    jsr (InitDisplayLayout,PC)
    nop
l_00f78:
    rts

; -- GameCommand 45: store byte to work RAM --
CmdStoreWorkByte:                                               ; $000F7A
    move.l  $e(a6), d0                                          ; D0 = arg1
    move.b  d0, $c6c(a5)                                        ; Store to $FFFC7C
    rts

; ===========================================================================
; Exception Handlers ($000F84-$000FE1)
; Pattern: moveq #exception_id,d0 -> bra.w ExceptionCommon
; ExceptionCommon: push SP and ID, call ErrorDisplay, halt
; ===========================================================================

BusError:                                                   ; $000F84
    moveq   #2,d0
    bra.w   ExceptionCommon
AddressError:                                               ; $000F8A
    moveq   #3,d0
    bra.w   ExceptionCommon
IllegalInstr:                                               ; $000F90
    moveq   #4,d0
    bra.w   ExceptionCommon
ZeroDivide:                                                 ; $000F96
    moveq   #5,d0
    bra.w   ExceptionCommon
ChkInstr:                                                   ; $000F9C
    moveq   #6,d0
    bra.w   ExceptionCommon
TrapvInstr:                                                 ; $000FA2
    moveq   #7,d0
    bra.w   ExceptionCommon
PrivilegeViol:                                              ; $000FA8
    moveq   #8,d0
    bra.w   ExceptionCommon
Trace:                                                      ; $000FAE
    moveq   #9,d0
    bra.w   ExceptionCommon
LineAEmulator:                                              ; $000FB4
    moveq   #10,d0
    bra.w   ExceptionCommon
LineFEmulator:                                              ; $000FBA
    moveq   #11,d0
    bra.w   ExceptionCommon
Reserved_0C:                                                ; $000FC0
    moveq   #12,d0
    bra.w   ExceptionCommon
Reserved_0D:                                                ; $000FC6
    moveq   #13,d0
    bra.w   ExceptionCommon
Reserved_0E:                                                ; $000FCC
    moveq   #14,d0
    bra.w   ExceptionCommon
Reserved_0F:                                                ; $000FD2
    moveq   #15,d0
                                                            ; falls through
ExceptionCommon:                                            ; $000FD4
    movea.l sp,a0
    move.l  a0,-(sp)
    move.l  d0,-(sp)
    jsr ErrorDisplay
ExceptionHalt:                                              ; $000FE0
    bra.s   ExceptionHalt

; ---------------------------------------------------------------------------
; === Translated block $000FE2-$001480 ===
; 19 functions, 1182 bytes
