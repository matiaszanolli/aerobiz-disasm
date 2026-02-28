; ============================================================================
; ShowCharDetail -- Render full character detail panel: clear tiles, draw stat bars, format numeric stat fields
; Called: ?? times.
; 644 bytes | $007D92-$008015
;
; Args (pushed right-to-left before jsr, accessed via link frame):
;   $8(a6)  = d7: player index (0-3)
;   $c(a6)  = d5: char slot index
;   $14(a6) = d3: display column (text X position)
;   $18(a6) = d2: display row (text Y position)
;   $1c(a6) = d6: mode flag (1 = show portrait+LZ graphic, 0 = use CalcWeightedStat)
;   $20(a6) = d4: width mode (1 = narrow, 2 = wide; controls some format strings)
;
; Registers set up in prologue:
;   a5 = $3B270 (PrintfWide function pointer)
;   a4 = -$80(a6): local 128-byte string work buffer
;   a2 = $FFA6B8 + slot*$C: sub-region of bitfield_tab, stride 12 per slot
;   a3 = $FFB9E8 + player*$20 + slot*2: event_records entry for (player, slot)
;
; Key RAM / structures:
;   $FFA6B8 = sub-region of bitfield_tab ($FFA6A0+$18); stride $C per slot.
;             +$02 = secondary stat (display). +$01 = primary stat (rating).
;             +$08, +$09 = display stats A, B (inverted: shown as 100 - value).
;   $FFB9E8 = event_records base. Indexed player*$20 + slot*2.
;             (a3)+$00 = event byte A, +$01 = event byte B.
;
; Format strings (at ROM addresses):
;   $3E1A2 = secondary stat format (val * 10)
;   $3E19E = primary rating format (val * 10)
;   $3E19A = display stat A format (100 - val)
;   $3E196 = display stat B format (100 - val)
;   $3E192 = event field format (A - B, shown in d6=1 mode)
;   $3E18E = event byte B format (d6=1 mode)
;   $3E188 = CalcWeightedStat format (d6=0 mode)
; ============================================================================
ShowCharDetail:                                                  ; $007D92
    link    a6,#-$80
    movem.l d2-d7/a2-a5,-(sp)
    ; --- Phase: Load arguments ---
    move.l  $0018(a6),d2                            ; d2 = display row (Y position)
    move.l  $0014(a6),d3                            ; d3 = display column (X position)
    move.l  $0020(a6),d4                            ; d4 = width mode (1=narrow, 2=wide)
    move.l  $000c(a6),d5                            ; d5 = char slot index
    move.l  $001c(a6),d6                            ; d6 = mode (1=portrait, 0=weighted stat)
    move.l  $0008(a6),d7                            ; d7 = player index
    lea     -$0080(a6),a4                           ; a4 = local 128-byte string work buffer
    movea.l #$0003b270,a5                           ; a5 = PrintfWide function pointer
    ; --- Phase: Index into bitfield_tab sub-region ($FFA6B8) for this slot ---
    ; $FFA6B8 = $FFA6A0 + $18 (start of active char sub-region)
    ; stride $C per slot -> slot * $C
    move.w  d5,d0
    mulu.w  #$c,d0                                  ; slot * 12
    movea.l #$00ffa6b8,a0                           ; bitfield_tab sub-region base
    lea     (a0,d0.w),a0
    movea.l a0,a2                                   ; a2 = char stat record for this slot
    ; --- Phase: Index into event_records for (player, slot) ---
    ; event_records[$FFB9E8]: stride $20 per player, $2 per slot
    move.w  d7,d0
    lsl.w   #$5,d0                                  ; player * $20
    move.w  d5,d1
    add.w   d1,d1                                   ; slot * 2
    add.w   d1,d0
    movea.l #$00ffb9e8,a0                           ; event_records base
    lea     (a0,d0.w),a0
    movea.l a0,a3                                   ; a3 = event_records entry for (player, slot)
    ; --- Phase: Clear the tile area for this detail panel ---
    ; GameCommand #$10 = ClearTileArea (small): args ($40, 0, cmd)
    pea     ($0040).w                               ; size param $40
    clr.l   -(sp)
    pea     ($0010).w                               ; GameCommand #$10
    dc.w    $4eb9,$0000,$0d64                       ; jsr $000D64 (GameCommand)
    lea     $000c(sp),sp
    ; --- Phase: Portrait mode (d6 == 1): decompress and place char graphic ---
    cmpi.w  #$1,d6
    bne.b   .l7e50                                  ; d6 != 1 -> skip portrait, go to stats
    ; Decompress char portrait LZ from table at $A1AE8
    move.l  ($000A1AE8).l,-(sp)                     ; compressed data pointer from $A1AE8
    pea     ($00FF1804).l                           ; decompress into save_buf_base ($FF1804)
    dc.w    $4eb9,$0000,$3fec                       ; jsr $003FEC (LZ_Decompress)
    ; Place tile: $37 tiles wide, at VRAM index $6B4
    pea     ($0037).w                               ; width = $37 = 55 tiles
    pea     ($06B4).w                               ; VRAM tile index $6B4
    pea     ($00FF1804).l                           ; source: decompressed data
    dc.w    $4eb9,$0000,$4668                       ; jsr $004668 (CmdPlaceTile)
    ; Draw portrait at (col=d3, row=d2) via GameCommand #$1B
    pea     ($00070F78).l                           ; portrait resource string/ptr
    pea     ($0008).w                               ; width = 8
    pea     ($000E).w                               ; height = $E = 14
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                                ; row = d2
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                                ; col = d3
    pea     ($0001).w
    pea     ($001B).w                               ; GameCommand #$1B = DrawText/Tile
    dc.w    $4eb9,$0000,$0d64                       ; jsr $000D64 (GameCommand)
    lea     $0030(sp),sp
.l7e50:                                            ; $007E50
    ; --- Phase: Set text window for stat display ---
    ; Window: width=$8, height=$F, at (col=d3, row=d2)
    pea     ($0008).w                               ; window width = 8
    pea     ($000F).w                               ; window height = $F = 15
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                                ; window row = d2
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                                ; window col = d3
    dc.w    $4eb9,$0003,$a942                       ; jsr $03A942 (SetTextWindow)
    ; --- Set text cursor for first stat line (col=d3, row=d2+8) ---
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                                ; base row
    move.w  d3,d0
    ext.l   d0
    addq.l  #$8,d0                                  ; col = d3 + 8
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                       ; jsr $03AB2C (SetTextCursor)
    ; --- Format and print secondary stat: value = char[+$02] * 5 * 2 (= * 10) ---
    moveq   #$0,d0
    move.w  $0002(a2),d0                            ; char record +$02 = secondary stat
    move.l  d0,-(sp)
    pea     ($0003E1A2).l                           ; format string for secondary stat
    move.l  a4,-(sp)                                ; string buffer
    dc.w    $4eb9,$0003,$b22c                       ; jsr $03B22C (sprintf)
    ; --- Print formatted string; width mode check silently discards result ---
    cmpi.w  #$2,d4                                  ; width mode == 2?  (result unused -- compiler artifact)
    move.l  a4,-(sp)
    jsr     (a5)                                    ; PrintfWide
    ; --- Set cursor for second stat line (col=d3+2, row=d2+9) ---
    move.w  d2,d0
    ext.l   d0
    addq.l  #$2,d0                                  ; col = d3 + 2
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$9,d0                                  ; row = d3 + 9
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                       ; jsr $03AB2C (SetTextCursor)
    lea     $0030(sp),sp
    ; --- Format and print primary rating: value = char[+$01] * 5 * 2 (= * 10) ---
    moveq   #$0,d0
    move.b  $0001(a2),d0                            ; char record +$01 = primary skill/rating
    move.l  d0,d1
    lsl.l   #$2,d0                                  ; val * 4
    add.l   d1,d0                                   ; val * 5
    add.l   d0,d0                                   ; val * 10
    move.l  d0,-(sp)
    pea     ($0003E19E).l                           ; format string for primary rating
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                       ; jsr $03B22C (sprintf)
    cmpi.w  #$2,d4                                  ; width mode == 2?  (result unused)
    move.l  a4,-(sp)
    jsr     (a5)                                    ; PrintfWide
    ; --- Set cursor for third stat line (col=d3+4, row=d2+4) ---
    move.w  d2,d0
    ext.l   d0
    addq.l  #$4,d0                                  ; col = d3 + 4
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0                                  ; row = d3 + 4
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                       ; jsr $03AB2C (SetTextCursor)
    ; --- Format display stat A: shown as (100 - char[+$08]) ---
    moveq   #$0,d0
    move.b  $0008(a2),d0                            ; char record +$08 = display stat A
    moveq   #$64,d1                                 ; $64 = 100
    sub.l   d0,d1                                   ; d1 = 100 - stat_A (invert: higher raw = worse)
    move.l  d1,-(sp)
    pea     ($0003E19A).l                           ; format string for display stat A
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                       ; jsr $03B22C (sprintf)
    cmpi.w  #$2,d4                                  ; width mode == 2?  (result unused)
    move.l  a4,-(sp)
    jsr     (a5)                                    ; PrintfWide
    ; --- Set cursor for fourth stat line (col=d3+4, row=d2+$B) ---
    move.w  d2,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$b,d0                                  ; row = d3 + $B = 11
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                       ; jsr $03AB2C (SetTextCursor)
    lea     $0030(sp),sp
    ; --- Format display stat B: shown as (100 - char[+$09]) ---
    moveq   #$0,d0
    move.b  $0009(a2),d0                            ; char record +$09 = display stat B
    moveq   #$64,d1                                 ; 100
    sub.l   d0,d1                                   ; d1 = 100 - stat_B (inverted)
    move.l  d1,-(sp)
    pea     ($0003E196).l                           ; format string for display stat B
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                       ; jsr $03B22C (sprintf)
    cmpi.w  #$2,d4                                  ; width mode == 2?  (result unused)
    move.l  a4,-(sp)
    jsr     (a5)                                    ; PrintfWide
    lea     $0010(sp),sp
    ; --- Phase: Last stat row differs by mode ---
    cmpi.w  #$1,d6                                  ; portrait mode?
    bne.b   .l7fca                                  ; no -> CalcWeightedStat path
    ; --- Portrait mode (d6==1): show event byte A - event byte B ---
    ; Set cursor for fifth stat line (col=d3+6, row=d2+4)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$6,d0                                  ; col = d3 + 6
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0                                  ; row = d3 + 4
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                       ; jsr $03AB2C (SetTextCursor)
    ; Format event A - B
    moveq   #$0,d0
    move.b  (a3),d0                                 ; event_records[+$0] = event byte A
    moveq   #$0,d1
    move.b  $0001(a3),d1                            ; event_records[+$1] = event byte B
    sub.l   d1,d0                                   ; d0 = A - B
    move.l  d0,-(sp)
    pea     ($0003E192).l                           ; format string for A-B delta
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                       ; jsr $03B22C (sprintf)
    cmpi.w  #$2,d4                                  ; width mode check (result unused)
    move.l  a4,-(sp)
    jsr     (a5)                                    ; PrintfWide
    ; Set cursor for sixth stat line (col=d3+6, row=d2+$B)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$b,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                       ; jsr $03AB2C (SetTextCursor)
    lea     $0020(sp),sp
    ; Format event byte B alone
    moveq   #$0,d0
    move.b  $0001(a3),d0                            ; event_records[+$1] = event byte B
    move.l  d0,-(sp)
    pea     ($0003E18E).l                           ; format string for event byte B
    bra.b   .l8000                                  ; -> sprintf + PrintfWide
.l7fca:                                            ; $007FCA
    ; --- Non-portrait mode (d6==0): show CalcWeightedStat result ---
    ; Set cursor for final stat (col=d3+6, row=d2+5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$5,d0                                  ; row = d3 + 5
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                       ; jsr $03AB2C (SetTextCursor)
    addq.l  #$8,sp
    ; Call CalcWeightedStat: args = (slot, player)
    move.w  d5,d0
    move.l  d0,-(sp)                                ; char slot
    move.w  d7,d0
    move.l  d0,-(sp)                                ; player index
    dc.w    $4eba,$002a                             ; jsr $008016 (CalcWeightedStat, PC-relative)
    nop
    addq.l  #$8,sp
    andi.l  #$ffff,d0                               ; zero-extend result word to long
    move.l  d0,-(sp)                                ; push weighted stat value
    pea     ($0003E188).l                           ; format string for weighted stat
.l8000:                                            ; $008000
    ; --- Common sprintf + PrintfWide for the final stat line ---
    move.l  a4,-(sp)                                ; string buffer
    dc.w    $4eb9,$0003,$b22c                       ; jsr $03B22C (sprintf)
    move.l  a4,-(sp)
    jsr     (a5)                                    ; PrintfWide: print final formatted stat
    movem.l -$00a8(a6),d2-d7/a2-a5
    unlk    a6
    rts
