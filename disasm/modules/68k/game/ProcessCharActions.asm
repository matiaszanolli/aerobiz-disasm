; ============================================================================
; ProcessCharActions -- Processes all pending char actions for the current player; iterates char stat blocks, selects target chars via the selection UI, then calls ProcessCharacterAction for each active slot.
; Called: ?? times.
; 1168 bytes | $014202-$014691
; ============================================================================
ProcessCharActions:                                                  ; $014202
    link    a6,#-$4                                    ; 1 local var: -$4(a6) = saved player record ptr
    movem.l d2-d7/a2-a5,-(sp)

; --- Phase: Setup -- load current player index and locate their player record ---
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2                           ; d2 = current_player (0-3)
    move.w  d2,d0
    mulu.w  #$24,d0                                    ; offset = player * $24 (36 bytes/player record)
    movea.l #$00ff0018,a0                              ; player_records base
    lea     (a0,d0.w),a0                               ; a0 -> player record for current_player
    move.l  a0,-$0004(a6)                              ; save player record ptr in link frame

    movea.l #$00ffba6c,a4                              ; a4 -> city_data mid-table (base $FFBA80 + $EC)
    clr.w   d7                                         ; d7 = route slot index (0-based), init to 0

; --- Phase: Initial display setup -- clear screen and enter char-action mode ---
    pea     ($0040).w                                  ; arg: display mode $40
    clr.l   -(sp)
    pea     ($0010).w                                  ; arg: GameCommand $10 (display mode reset)
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64  ; GameCommand($10, 0, $40)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E  ; audio tick
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0                           ; screen_id (scenario index)
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0                                      ; player index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78  ; finalize display layout (player, screen_id, 2)
    lea     $001c(sp),sp

; locate this player's event_record: base $FFB9E8, stride $20 (32 bytes/player)
    move.w  d2,d0
    lsl.w   #$5,d0                                     ; offset = player * $20 (32 bytes/event record)
    movea.l #$00ffb9e8,a0                              ; event_records base
    lea     (a0,d0.w),a0                               ; a0 -> event_record for current_player
    movea.l a0,a5                                      ; a5 = this player's event_record base (held throughout loop)
    bra.w   .l14680                                    ; jump to loop-condition check (d3 tested at end)
; --- Phase: Main action loop -- iterate through char-action slots ---
.l14278:                                                ; $014278
    pea     ($0020).w                                  ; arg: height
    pea     ($0020).w                                  ; arg: width
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942  ; clear/render action selection panel
    clr.w   d5                                         ; d5 = "slot changed" flag (0 = unchanged)
    clr.w   d3                                         ; d3 = loop-exit code (0 = continue, $C = done, $FF = cancel)

; load the city_data sub-record for the current player into a4 from temp buffer
    pea     ($0014).w                                  ; count: $14 (20) bytes to copy
    clr.l   -(sp)
    move.l  a4,-(sp)                                   ; dest: city_data table ptr (a4)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520  ; read/display char slot info

; run the char bitfield search to find the next eligible char in this player's fleet
    move.w  ($00FF9A1C).l,d0                           ; screen_id
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0                                      ; player index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA  ; BitFieldSearch(player, screen_id) -> d0 = slot or $FF
    lea     $0024(sp),sp
    move.w  d0,d6                                      ; d6 = selected char slot index (or $FF = none available)
    cmpi.w  #$ff,d6
    bne.w   .l14394                                    ; skip no-char fallback if a valid slot was found

; --- Phase: No-char fallback -- scan entity bitfield for first set bit manually ---
; BitFieldSearch returned $FF: no char available via normal path.
; Fall back to a manual bitmask scan of the player's aircraft bitfield.
    move.l  #$8000,-(sp)                               ; arg: $8000 (display flag)
    pea     ($0005).w
    pea     ($0003).w
    pea     ($0020).w
    pea     ($0015).w
    clr.l   -(sp)
    pea     ($001A).w                                  ; GameCommand $1A (display mode for no-char state)
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64  ; GameCommand($1A, 0, $15, $20, 3, 5, $8000)
    lea     $001c(sp),sp
; locate the CharTypeRangeTable entry for this scenario type
    move.w  ($00FF9A1C).l,d0                           ; screen_id (scenario/category index)
    lsl.w   #$2,d0                                     ; * 4 bytes per CharTypeRangeTable entry
    movea.l #$0005ecbc,a0                              ; CharTypeRangeTable ($05ECBC): 7 × 4-byte range descriptors
    lea     (a0,d0.w),a0                               ; a0 -> range descriptor for this category
    movea.l a0,a3
    clr.w   d4                                         ; d4 = bit index within range, init 0
    bra.b   .l14328                                    ; jump to loop-condition check first

; bitmask walk: scan entity bitfield for the first set bit in this char's range
.l142fe:                                                ; $0142FE
; compute: test bit (range_base + d4) against player's aircraft fleet bitfield
    moveq   #$0,d0
    move.b  (a3),d0                                    ; d0 = range_base (CharTypeRangeTable byte[0])
    move.w  d4,d1
    ext.l   d1
    add.l   d1,d0                                      ; d0 = range_base + bit_index
    moveq   #$1,d1
    lsl.l   d0,d1                                      ; d1 = 1 << (range_base + bit_index)
    move.l  d1,d0
    move.w  d2,d1
    lsl.w   #$2,d1                                     ; offset = player * 4 (bitfield_tab: longword per player)
    movea.l #$00ffa6a0,a0                              ; bitfield_tab ($FFA6A0): aircraft fleet bitmask array
    and.l   (a0,d1.w),d0                               ; AND with player's fleet mask to test this bit
    beq.b   .l14326                                    ; bit clear -> try next index
    moveq   #$0,d6
    move.b  (a3),d6                                    ; d6 = range_base
    add.w   d4,d6                                      ; d6 = range_base + d4 = first matching char index
    bra.b   .l14336
.l14326:                                                ; $014326
    addq.w  #$1,d4                                     ; advance to next bit in range
.l14328:                                                ; $014328
    move.w  d4,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0001(a3),d1                               ; d1 = range_size (CharTypeRangeTable byte[1])
    cmp.l   d1,d0
    blt.b   .l142fe                                    ; loop while d4 < range_size
.l14336:                                                ; $014336
; d6 = found char index, or $FF if entire range exhausted with no match
    cmpi.w  #$ff,d6
    bne.b   .l14394                                    ; found a char -- proceed to action

; still no char found: display "no char" message and reset turn
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0003F772).l                              ; ptr to "no characters available" dialog string
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912  ; show dialog box with string
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C  ; sync/vblank wait
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E  ; finalize revenue side
    clr.l   -(sp)
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78  ; finalize display/expense side
    lea     $002c(sp),sp
; --- Phase: Char found -- select action slot ---
.l14394:                                                ; $014394
    cmpi.w  #$ff,d6
    beq.w   .l14464                                    ; still $FF = no char, skip to done
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E  ; audio tick before UI
; call char-action UI picker: presents the char selection menu and returns chosen slot
    move.w  d7,d0                                      ; d7 = current route slot (pre-selection)
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0                                      ; d6 = char index from bitfield scan
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0                                      ; player index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$09ee                                 ; jsr $014DA6  ; CharActionPicker(player, char_idx, route_slot) -> d0 = chosen slot or $FF
    nop
    lea     $0010(sp),sp
    move.w  d0,d7                                      ; d7 = newly chosen route slot (or $FF = cancelled)
    cmpi.w  #$ff,d7
    bne.b   .l14414                                    ; valid slot chosen -- go load the route slot
; user cancelled char selection or no valid action slot found
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C  ; sync/vblank wait
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E  ; finalize revenue side
    clr.l   -(sp)
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78  ; finalize expense/display side
    lea     $0018(sp),sp
    cmpi.w  #$7,($00FF9A1C).l                          ; screen_id == 7 = end-of-scenario screen
    bne.b   .l14464                                    ; not end-of-scenario: set done code below
    move.w  #$ff,d3                                    ; d3 = $FF = "cancelled/abort" exit code
    bra.b   .l14466
.l14414:                                                ; $014414
; --- Phase: Load route slot -- compute address for (player, slot) and copy in temp data ---
; route slot address: $FF9A20 + player * $320 + slot * $14
    move.w  d2,d0
    mulu.w  #$0320,d0                                  ; d0 = player * $320 (800 bytes/player = 40 slots * $14)
    move.w  d7,d1
    mulu.w  #$14,d1                                    ; d1 = slot * $14 (20 bytes/slot)
    add.w   d1,d0
    movea.l #$00ff9a20,a0                              ; route_slots base ($FF9A20)
    lea     (a0,d0.w),a0                               ; a0 -> route slot[player][d7]
    movea.l a0,a2                                      ; a2 = this slot's base address (held for field reads below)
    pea     ($0014).w                                  ; count: $14 (20) bytes = full slot record
    move.l  a4,-(sp)                                   ; dest: city_data working buffer (a4)
    clr.l   -(sp)
    move.l  a2,-(sp)                                   ; src: route slot
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538  ; memcpy(0, a2, $200003, a4, $14)
    moveq   #$0,d0
    move.b  $0001(a2),d0                               ; route_slot.city_b (dest city index)
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0                                    ; route_slot.city_a (source city index)
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$b324                           ; jsr $01B324  ; ShowRouteInfo(player, city_a, city_b)
    lea     $0020(sp),sp
    bra.b   .l14466
.l14464:                                                ; $014464
    moveq   #$c,d3                                     ; d3 = $C = "all done" exit code
.l14466:                                                ; $014466
; --- Phase: Action dispatch -- call ProcessCharacterAction and handle result ---
    cmpi.w  #$c,d3
    beq.w   .l14680                                    ; d3=$C = all slots processed, exit loop
    cmpi.w  #$ff,d3
    beq.w   .l14680                                    ; d3=$FF = user cancelled, exit loop
; call ProcessCharacterAction (at $014692) -- performs the actual char action
    move.l  a4,-(sp)                                   ; arg: city_data working buffer
    move.w  d2,d0                                      ; player index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0212                                 ; jsr $014692  ; ProcessCharacterAction(player, a4) -> d0 = result code
    nop
    addq.l  #$8,sp
    move.w  d0,d3                                      ; d3 = action result (1 = "replace slot", else continue)
    cmpi.w  #$1,d3
    bne.b   .l144c8                                    ; result != 1: check for slot-change condition

; --- Phase: Action result 1 -- replace this route slot with another ---
; ProcessCharacterAction returned 1 = player wants to swap this slot
    move.l  a2,-(sp)                                   ; arg: current route slot ptr
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$19b4                           ; jsr $0119B4  ; SwapRouteSlot(player, slot_ptr) -> assigns new route
    addq.l  #$8,sp
    clr.w   d7                                         ; reset route slot index to 0 after swap
    movea.l -$0004(a6),a0                              ; reload player record ptr from link frame
    move.b  $0004(a0),d0                               ; player_record.domestic_slots
    andi.l  #$ff,d0
    movea.l -$0004(a6),a0
    move.b  $0005(a0),d1                               ; player_record.intl_slots
    andi.l  #$ff,d1
    add.l   d1,d0                                      ; total active slots = domestic + intl
    bgt.w   .l14636                                    ; if any slots remain, continue to tail
    moveq   #$c,d3                                     ; no slots left: set done exit code
    bra.w   .l14636

; --- Phase: Slot change detection -- compare slot fields to detect modification ---
.l144c8:                                                ; $0144C8
    cmpi.w  #$ff,d3
    beq.w   .l14636                                    ; cancelled: skip change detection, go to tail
; compare key route slot fields between a2 (current slot) and a4 (saved copy from before action)
; if any differ, d5 will be set to 1 = "slot was modified"
    move.b  $0002(a2),d0                               ; route_slot.plane_type (packed nibbles: plane A/B class)
    cmp.b   $0002(a4),d0                               ; vs saved copy
    bne.b   .l144f8                                    ; plane_type changed
    move.b  $0003(a2),d0                               ; route_slot.frequency
    cmp.b   $0003(a4),d0
    bne.b   .l144f8                                    ; frequency changed
    move.w  $0004(a2),d0                               ; route_slot.ticket_price
    cmp.w   $0004(a4),d0
    bne.b   .l144f8                                    ; ticket_price changed
    move.b  $000a(a2),d0                               ; route_slot.status_flags
    cmp.b   $000a(a4),d0                               ; compare against saved status_flags
    beq.b   .l144fa                                    ; all fields identical: no change
.l144f8:                                                ; $0144F8
    moveq   #$1,d5                                     ; d5 = 1: slot was modified

; --- Phase: Slot modified -- confirm and commit change ---
.l144fa:                                                ; $0144FA
    cmpi.w  #$1,d5
    bne.w   .l14636                                    ; no modification detected: skip confirmation

; slot changed: show two-panel confirmation display, then ask player to confirm
    move.l  #$8000,-(sp)
    pea     ($0005).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64  ; GameCommand($1A, ...) -- display before-state panel
    lea     $001c(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0005).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64  ; GameCommand($1A, 1, ...) -- display after-state panel
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0003F748).l                              ; ptr to "confirm route change?" dialog string
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912  ; ShowConfirmDialog(player, $3F748, 0, 1, 0) -> d0 = 0/1
    lea     $0030(sp),sp
    cmpi.w  #$1,d0
    bne.w   .l14636                                    ; player declined: skip commit

; --- Phase: Commit route change -- update city_data popularity for both endpoints ---
; city_data is stored at $FFBA80 with stride: city_idx * 8 + player * 2 (odd byte = popularity)
; Formula: city_data[(city * 8) + (player * 2) + 1] -= frequency

    moveq   #$0,d0
    move.b  (a2),d0                                    ; route_slot.city_a (source city index)
    lsl.w   #$3,d0                                     ; * 8 (4 entries × 2 bytes per city)
    move.w  d2,d1
    add.w   d1,d1                                      ; player * 2 (stride within each city's block)
    add.w   d1,d0                                      ; offset into city_data
    move.b  $0003(a2),d1                               ; route_slot.frequency
    movea.l #$00ffba81,a0                              ; city_data+1 ($FFBA81): odd-byte popularity fields
    sub.b   d1,(a0,d0.w)                               ; city_a popularity -= frequency (undo old assignment)

    moveq   #$0,d0
    move.b  $0001(a2),d0                               ; route_slot.city_b (dest city index)
    lsl.w   #$3,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    move.b  $0003(a2),d1                               ; route_slot.frequency
    movea.l #$00ffba81,a0
    sub.b   d1,(a0,d0.w)                               ; city_b popularity -= frequency (undo old assignment)

; copy the modified slot data (from a4 working copy) back over the live slot
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0  ; GetRouteEventSlot(slot_ptr) -> d0 = event offset
    andi.l  #$ffff,d0
    add.l   d0,d0                                      ; * 2 (event_records stride is 2)
    lea     (a5,d0.l),a0                               ; a5 = this player's event_record base
    addq.l  #$1,a0                                     ; +1 = odd-byte target within event record
    movea.l a0,a3
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402  ; GetRouteFareComponent(slot_ptr) -> d0 = fare value
    add.b   d0,(a3)                                    ; update event_record fare field (add new fare)

; write updated slot fields back from working buffer to live slot
    pea     ($0014).w                                  ; count: $14 (20) bytes
    move.l  a2,-(sp)                                   ; dest: live route slot
    clr.l   -(sp)
    move.l  a4,-(sp)                                   ; src: working buffer (has player's chosen values)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538  ; memcpy(0, a4, $200003, a2, $14)

; re-apply new assignment: add new frequency back to both city popularity fields
    moveq   #$0,d0
    move.b  (a2),d0                                    ; route_slot.city_a
    lsl.w   #$3,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    move.b  $0003(a2),d1                               ; route_slot.frequency (now updated)
    movea.l #$00ffba81,a0
    add.b   d1,(a0,d0.w)                               ; city_a popularity += new frequency

    moveq   #$0,d0
    move.b  $0001(a2),d0                               ; route_slot.city_b
    lsl.w   #$3,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    move.b  $0003(a2),d1                               ; route_slot.frequency
    movea.l #$00ffba81,a0
    add.b   d1,(a0,d0.w)                               ; city_b popularity += new frequency

; update event_record with new fare (subtract old fare component)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0  ; GetRouteEventSlot(slot_ptr) -> d0
    andi.l  #$ffff,d0
    add.l   d0,d0
    lea     (a5,d0.l),a0
    addq.l  #$1,a0
    movea.l a0,a3
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402  ; GetRouteFareComponent -> d0
    lea     $0024(sp),sp
    sub.b   d0,(a3)                                    ; event_record fare field -= old fare (finalize delta)
    ori.b   #$01,$000a(a2)                             ; route_slot.status_flags |= $01 (mark slot as updated/pending)

; --- Phase: Action tail -- sync and advance to next slot ---
.l14636:                                                ; $014636
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C  ; sync/vblank wait
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398  ; post-action UI update
    pea     ($0001).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E  ; finalize revenue side
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78  ; finalize expense/display side
    lea     $0018(sp),sp
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748  ; VBlank sync before next iteration

; --- Phase: Loop condition -- continue if d3 != $C (done), else exit ---
.l14680:                                                ; $014680
    cmpi.w  #$c,d3
    bne.w   .l14278                                    ; not done: go back to top of slot loop
    movem.l -$2C(a6),d2-d7/a2-a5                      ; restore all saved registers
    unlk    a6
    rts
; === Translated block $014692-$016958 ===
; 11 functions, 8902 bytes
