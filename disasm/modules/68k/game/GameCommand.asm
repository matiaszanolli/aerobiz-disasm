; ============================================================================
; GameCommand -- Central command dispatcher (most-called function, 306 calls)
; ============================================================================
; Takes a command number (0-46) as the first longword stack argument.
; Dispatches to one of 47 handler functions via jump table.
; Sets A5 = work RAM base ($FFF010) before calling the handler.
;
; Stack frame (move sr BEFORE link creates unusual layout):
;   0(a6) = saved A6          4(a6) = saved SR (word)
;   6(a6) = return address    A(a6) = command number (longword)
;   E(a6) = additional args (vary per command)
; ============================================================================
GameCommand:                                                 ; $000D64
    move    sr,-(sp)                                         ; Save SR (before link frame!)
    link    a6,#$0000                                        ; Create stack frame
    movem.l d2-d7/a2-a5,-(sp)                               ; Save working registers
    move.l  $A(a6),d7                                        ; D7 = command number (first arg)
    cmpi.l  #$0000002F,d7                                    ; Valid range: 0-46
    bcc.s   .error                                           ; Branch if >= 47 (invalid)
    movea.l #$00FFF010,a5                                    ; A5 = work RAM base
    lsl.w   #2,d7                                            ; D7 *= 4 (longword table offset)
    movea.l #GameCommandTable,a4                             ; A4 = jump table base
    movea.l 0(a4,d7.w),a4                                   ; A4 = handler address
    jsr     (a4)                                             ; Call handler
    movem.l (sp)+,d2-d7/a2-a5                               ; Restore registers
    unlk    a6                                               ; Destroy stack frame
    rtr                                                      ; Restore CCR + return
.error:                                                      ; $000D96
    bra.s   .error                                           ; Infinite loop (invalid cmd)
; -- Jump table: 47 command handlers (indexed 0-46) --
GameCommandTable:                                            ; $000D98
    dc.l    $000003A2,$000003BC,$0000045A,$0000046A          ; 0=SetVDPReg, 1=SetScrollMode, 2=GetVDPReg, 3=GetVDPStatus
    dc.l    $00000474,$0000047C,$000004F0,$00000520          ; 4=RunSubroutine, 5=SetupDMA, 6=TransferPlane, 7=LoadTiles
    dc.l    $00000550,$000005F8,$0000060C,$00000658          ; 8=SetupSprite, 9=CopyMemory, 10=ReadInput, 11=SetupObject
    dc.l    $000006F0,$0000070A,$00000724,$0000074A          ; 12=EnableDisplay, 13=HardwareInit, 14=WaitFrames, 15=UpdateSprites
    dc.l    $000007A4,$000007D8,$000024B8,$000024DE          ; 16=ClearSprites, 17=TestVRAM, 18=SendZ80Param, 19=SendZ80Byte
    dc.l    $000024FA,$000024DE,$0000250A,$00002568          ; 20=TriggerZ80, 21=SendZ80Byte, 22=LoadZ80Tables, 23=LoadZ80Encoded
    dc.l    $000024FA,$000024FA,$00000876,$00000944          ; 24=TriggerZ80, 25=TriggerZ80, 26=DMABatchWrite, 27=DMARowWrite
    dc.l    $000009F6,$00000A50,$00000A62,$00000A6C          ; 28=WaitDMA, 29=SetWorkFlags, 30=SystemReset, 31=InitCharTable
    dc.l    $00000AE8,$00000B28,$00000CEC,$00000BF0          ; 32=ClearCharTable, 33=SetCharState, 34=SetAnimState, 35=InitAnimation
    dc.l    $00000D04,$00000D3C,$00000E54,$00000E92          ; 36=SetTimer, 37=InitGameVars, 38=ClampCoords, 39=GetCoords
    dc.l    $00000EAA,$00000EBA,$00000F18,$00000F22          ; 40=ReadCombinedWord, 41=SetBoundsAndClamp, 42=SetScrollParam, 43=ScanStatusArray
    dc.l    $00000F42,$00000F7A,$00000D24                    ; 44=SaveBuffer, 45=StoreWorkByte, 46=ConditionalWrite
; ---
; === Translated block $000E54-$000F82 ===
; 7 functions, 302 bytes
