; ============================================================================
; GetPlayerCharCount -- Returns count of char slots occupied by the given player (via BitFieldSearch)
; 56 bytes | $036EDA-$036F11
; ============================================================================
GetPlayerCharCount:
    ; --- Phase: Setup ---
    ; Stack arg: $10(a7) = player_index (after movem saves d2-d4 = 3 longs = $C bytes, so $10 = original first arg)
    ; d4 = player index; d3 = running count of occupied slots; d2 = loop counter (slot 0-6)
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d4          ; d4 = player_index (arg after callee-saves)
    clr.w   d3                   ; d3 = slot count accumulator = 0
    clr.w   d2                   ; d2 = current slot index = 0
    ; --- Phase: Loop over 7 char slots (0-6), count those owned by player ---
l_36ee6:
    moveq   #$0,d0
    move.w  d2, d0               ; d0 = current slot index (zero-extended)
    move.l  d0, -(a7)            ; arg 2: slot_index
    moveq   #$0,d0
    move.w  d4, d0               ; d0 = player_index (zero-extended)
    move.l  d0, -(a7)            ; arg 1: player_index
    jsr BitFieldSearch           ; $006EEA: search bitfield_tab for slot owned by player; returns bit position in d0 ($20+ = not found)
    addq.l  #$8, a7
    cmpi.w  #$20, d0             ; d0 < $20 means a valid char was found in this slot
    bge.b   l_36f02              ; >= $20: slot empty/unowned, skip count increment
    addq.w  #$1, d3              ; slot occupied by this player: increment count
l_36f02:
    addq.w  #$1, d2              ; advance to next slot
    cmpi.w  #$7, d2              ; processed all 7 slots (0-6)?
    bcs.b   l_36ee6              ; no: continue loop
    ; --- Phase: Epilogue -- return count in d0 ---
    move.w  d3, d0               ; d0 = total count of char slots occupied by player
    movem.l (a7)+, d2-d4
    rts

RecruitCharacter:                                                  ; $036F12
    ; --- Phase: Setup ---
    ; a4 = route_slots+$1FC ($FF9A1C): points into route_slots area for current session
    ; a5 = GameCommand ($01E0B8)
    ; d2 = current player index (from $FF0016 = active_player_index)
    ; d3 = slot count (from (a4) = word at $FF9A1C, number of available recruit slots)
    ; d4 = result flag from $037A3C (0 = retry, nonzero = done)
    ; a3 = player_record ptr ($FF0018 + player*$24)
    ; a2 = scratch buffer at $FFBA6C (temporary recruit state)
    link    a6,#-$80
    movem.l d2-d4/a2-a5,-(sp)
    movea.l #$00ff9a1c,a4        ; a4 = recruit slot count / status word at $FF9A1C
    movea.l #$0001e0b8,a5        ; a5 = GameCommand ($01E0B8)
    clr.w   d4                   ; d4 = done flag = 0 (will be set when recruit finishes)
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2     ; d2 = active_player_index ($FF0016)
    move.w  d2,d0
    mulu.w  #$24,d0              ; d0 = player_index * $24 (stride of player_record)
    movea.l #$00ff0018,a0        ; a0 = player_records base ($FF0018)
    lea     (a0,d0.w),a0         ; a0 = &player_records[player_index] (stride $24)
    movea.l a0,a3                ; a3 = current player's record ptr
    movea.l #$00ffba6c,a2        ; a2 = temp recruit scratch buffer ($FFBA6C)
    ; --- Phase: Initialize recruit display ---
    pea     ($0014).w            ; arg: row $14 (20) -- display init position
    clr.l   -(sp)                ; arg: 0
    move.l  a2,-(sp)             ; arg: scratch buffer ptr
    dc.w    $4eb9,$0001,$d520    ; jsr $01D520 -- initialize recruit selection panel
    move.w  (a4),d3              ; d3 = current recruit slot count from $FF9A1C
    dc.w    $4eb9,$0001,$d71c    ; jsr $01D71C -- display sync / frame advance
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e    ; jsr $00538E -- load/initialize recruit display resources
    pea     ($0001).w
    clr.l   -(sp)
    jsr     (a5)                 ; GameCommand #$0: display init (arg 0)
    pea     ($0004).w            ; arg: mode $04
    pea     ($003B).w            ; arg: GameCommand #$3B
    jsr     (a5)                 ; GameCommand #$3B: set up tile area for recruit panel
    lea     $0020(sp),sp         ; clean up 8 args (8*4=32=$20 bytes)
    dc.w    $4eb9,$0001,$d748    ; jsr $01D748 = ResourceUnload: free previously loaded resource
    ; --- Phase: Check if player has room to recruit (player_record +$4 + +$5 < $28 = 40) ---
    ; player_record +$04 = occupied slot count A, +$05 = occupied slot count B
    moveq   #$0,d0
    move.b  $0004(a3),d0         ; d0 = player_record +$04: primary slot occupancy count
    moveq   #$0,d1
    move.b  $0005(a3),d1         ; d1 = player_record +$05: secondary slot occupancy count
    add.l   d1,d0                ; d0 = total occupied slots
    moveq   #$28,d1              ; $28 = 40 = max total slots
    cmp.l   d0,d1                ; total >= $28?
    ble.w   .l370f0              ; yes: full, show "no room" dialog -> skip recruit
    ; --- Phase: Search for available recruit slot ---
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg 2: d3 = slot count (search upper bound)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg 1: player_index
    dc.w    $4eb9,$0000,$6eea    ; jsr $006EEA = BitFieldSearch: find first available slot for player
    addq.l  #$8,sp
    move.b  d0,(a2)              ; store found slot index at (a2)+$00 in scratch buffer
    cmpi.b  #$ff,d0              ; $FF = no slot found (all full)?
    beq.w   .l370d2              ; yes: show "slots full" dialog
    ; --- Phase: Show recruit selection UI (first character select) ---
    clr.l   -(sp)                ; arg 4: 0
    moveq   #$0,d0
    move.b  (a2),d0              ; slot index from scratch buffer
    ext.l   d0
    move.l  d0,-(sp)             ; arg 3: found slot index
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg 2: d3 = slot count
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg 1: player_index
    dc.w    $4eba,$080c          ; jsr $0377DA (PC-relative): character selection UI for primary slot
    nop
    lea     $0010(sp),sp         ; clean up 4 args
    cmpi.w  #$1,d0               ; d0 == 1 means selection confirmed
    bne.w   .l37110              ; cancelled/failed: jump to cleanup epilogue
.l36fde:                                                ; $036FDE
    ; --- Phase: Confirmed -- show character name dialog and second UI phase ---
    dc.w    $4eb9,$0001,$d748    ; jsr $01D748 = ResourceUnload
    moveq   #$0,d0
    move.b  (a2),d0              ; slot index stored at scratch+$00
    lsl.w   #$2,d0               ; d0 *= 4 (long pointer table index)
    movea.l #$0005e680,a0        ; a0 = ROM char name pointer table ($5E680)
    move.l  (a0,d0.w),-(sp)      ; push char name string ptr
    move.l  ($000485F6).l,-(sp)  ; push ROM format string ptr ($485F6) for name dialog
    pea     -$0080(a6)           ; destination = local sprintf buffer (-$80(a6), $80 bytes)
    dc.w    $4eb9,$0003,$b22c    ; jsr $03B22C = sprintf: format char name into buffer
    ; ShowDialog args: player_index, formatted_string, mode_2, 0, 0
    pea     ($0001).w            ; arg 5: 1
    clr.l   -(sp)                ; arg 4: 0
    clr.l   -(sp)                ; arg 3: 0
    pea     -$0080(a6)           ; arg 2: formatted name string
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg 1: player_index
    dc.w    $4eb9,$0000,$7912    ; jsr $007912 = ShowDialog: display the character name confirm dialog
    ; --- Phase: Second character slot selection UI ---
    moveq   #$0,d0
    move.b  (a2),d0              ; primary slot index
    ext.l   d0
    move.l  d0,-(sp)             ; arg 3: primary slot index
    move.w  (a4),d0              ; reload slot count from $FF9A1C (may have changed)
    ext.l   d0
    move.l  d0,-(sp)             ; arg 2: updated slot count
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg 1: player_index
    dc.w    $4eba,$0130          ; jsr $037162 (PC-relative): secondary character slot selection UI
    nop
    lea     $002c(sp),sp         ; clean up combined stack from two call sequences (11 args * 4 = $2C)
    move.b  d0,$0001(a2)         ; store secondary slot result at scratch+$01
    cmpi.b  #$ff,d0              ; $FF = secondary selection cancelled?
    beq.w   .l37110              ; yes: go to cleanup epilogue
    ; --- Phase: Confirm secondary selection and finalize recruit ---
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $0001(a2),d0         ; secondary slot index from scratch+$01
    ext.l   d0
    move.l  d0,-(sp)             ; arg 3: secondary slot index
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg 2: slot count
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg 1: player_index
    dc.w    $4eba,$0778          ; jsr $0377DA (PC-relative): confirm secondary slot UI
    nop
    lea     $0010(sp),sp
    cmpi.w  #$1,d0               ; d0 == 1 means confirmed
    bne.b   .l370c8              ; not confirmed: check done flag, possibly retry
    ; --- Phase: Execute recruit -- apply changes to game state ---
    move.l  a2,-(sp)             ; arg 2: scratch buffer ptr (holds slot indices)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg 1: player_index
    dc.w    $4eba,$09c2          ; jsr $037A3C (PC-relative): execute recruit, apply to game state; returns nonzero=done
    nop
    move.w  d0,d4                ; d4 = done flag (nonzero = recruit completed, exit loop)
    move.w  (a4),d0              ; reload slot count from $FF9A1C
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9f4a    ; jsr $009F4A: refresh/update display after recruit
    dc.w    $4eb9,$0001,$d71c    ; jsr $01D71C: display sync
    dc.w    $4eb9,$0001,$e398    ; jsr $01E398: additional post-recruit display update
    pea     ($0001).w
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e    ; jsr $006A2E: update player summary panel (mode 1)
    pea     ($0002).w
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78    ; jsr $006B78: update player detail panel (mode 2)
    lea     $0024(sp),sp         ; clean up 9 args from the block above ($24 = 36 bytes)
.l370c8:                                                ; $0370C8
    ; --- Phase: Check done flag -- retry loop or exit ---
    move.w  (a4),d3              ; refresh d3 = slot count from $FF9A1C
    tst.w   d4                   ; d4 nonzero = recruit finalized, exit
    beq.w   .l36fde              ; d4 == 0: not done yet, loop back to name dialog phase
    bra.b   .l37110              ; done: proceed to epilogue
.l370d2:                                                ; $0370D2
    ; --- Branch: BitFieldSearch returned $FF -- no recruit slots available ---
    pea     ($0004).w            ; GameCommand mode $04
    pea     ($0037).w            ; GameCommand #$37: clear/reset recruit panel display
    jsr     (a5)                 ; GameCommand
    addq.l  #$8,sp
    ; Show "slots full" dialog: mode 2, ROM string from $4861E
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    move.l  ($0004861E).l,-(sp)  ; ROM string: "no recruit slots available" message
    bra.b   .l37100              ; -> shared ShowDialog call
.l370f0:                                                ; $0370F0
    ; --- Branch: player has >= $28 total slots occupied -- team full ---
    ; Show "team full" dialog: mode 2, ROM string at $44E94
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($00044E94).l        ; ROM string: "team is full" / max capacity message
.l37100:                                                ; $037100
    ; --- Shared: ShowDialog for error messages (full team / no slots) ---
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg 1: player_index
    dc.w    $4eb9,$0000,$7912    ; jsr $007912 = ShowDialog: display error message to player
    lea     $0014(sp),sp         ; clean up 5 args
.l37110:                                                ; $037110
    ; --- Phase: Epilogue -- restore display and return ---
    dc.w    $4eb9,$0001,$d71c    ; jsr $01D71C: display sync
    pea     ($0004).w            ; GameCommand mode $04
    pea     ($0037).w            ; GameCommand #$37: restore recruit panel / close UI
    jsr     (a5)                 ; GameCommand
    ; Refresh player panels: mode 1 then mode 2
    pea     ($0001).w
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e    ; jsr $006A2E: update player summary panel
    pea     ($0002).w
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78    ; jsr $006B78: update player detail panel
    move.w  (a4),d0              ; reload final slot count
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9f4a    ; jsr $009F4A: final display refresh
    movem.l -$009c(a6),d2-d4/a2-a5
    unlk    a6
    rts
; === Translated block $037162-$0377C8 ===
; 1 functions, 1638 bytes
