; ============================================================================
; ComputeAllianceScores -- Scores each alliance slot for the AI player based on status, char type, and priority flags; writes ranked list
; 514 bytes | $032398-$032599
;
; Algorithm summary:
;   For a given AI player (arg: d3), evaluate all 7 alliance type slots (indices 0-6)
;   and one "self" slot (index 7), computing a score for each. Scoring factors:
;     +$190 (+400): slot already established (status byte > 1)
;     +$C8  (+200): slot has priority flag and only 1 active player
;     +$190 (+400): slot empty and roster has room
;     +$64  (+100): turn is at a key quarter (index 3 or 5)
;     +$C8  (+200): alliance type status == 1 (active/current)
;     +$190 (+400): alliance type status == 2
;     +$12C (+300): alliance type status == 3 or 4
;     +$C8  (+200): duplicate alliance check passed
;     +$320 (+800): fewer than 7 filled slots (bonus for availability)
;   After scoring, bubble-sort the 8 slots by score descending, write
;   the ranked slot indices to $FFA7AC + player*2 entries.
;
; Register map (setup phase):
;   d3 = player_index (0-3) -- from stack arg $8(a6)
;   d7 = max_player_count threshold (clamped to 7)
;   d4 = active_player_count (from CountActivePlayers)
;   d2 = loop counter / alliance type index (0-7)
;   a4 = local score buffer (8 words, 16 bytes on stack, -$10(a6))
;   a5 = $FF0270 alliance status table base
;   a2 = player record pointer ($FF0018 + player*$24)
;   d2 = hub_city range index after RangeLookup
; ============================================================================
ComputeAllianceScores:
; --- Phase: Frame Setup ---
    link    a6,#-$10                    ; allocate 16 bytes of local stack space
    movem.l d2-d7/a2-a5, -(a7)         ; save all working registers
    move.l  $8(a6), d3                  ; d3 = player_index (0-3)
    lea     -$10(a6), a4                ; a4 = local score buffer (8 words for 8 alliance slots)
    movea.l  #$00FF0270,a5             ; a5 = $FF0270: alliance status table (TBD field, 8-byte stride per player)

; --- Phase: Compute max alliance count cap (d7 = min(7, $FF0004+4)) ---
    move.w  ($00FF0004).l, d7           ; d7 = word from $FF0004 (scenario/year parameter)
    ext.l   d7
    addq.l  #$4, d7                     ; d7 += 4 (adjust threshold)
    moveq   #$7,d0
    cmp.l   d7, d0                      ; is 7 <= d7?
    ble.b   l_323ca                     ; if so, cap at 7
    move.w  ($00FF0004).l, d7           ; recompute with offset
    ext.l   d7
    addq.l  #$4, d7
    bra.b   l_323cc
l_323ca:
    moveq   #$7,d7                      ; d7 = 7 (maximum alliance cap)
l_323cc:

; --- Phase: Count active players, find player record, hub range ---
    jsr CountActivePlayers              ; d0 = number of players with active_flag == 1
    move.w  d0, d4                      ; d4 = active_player_count
    move.w  d3, d0
    mulu.w  #$24, d0                    ; d0 = player_index * $24 (player record stride = 36)
    movea.l  #$00FF0018,a0             ; a0 = player_records base ($FF0018)
    lea     (a0,d0.w), a0              ; a0 -> this player's record
    movea.l a0, a2                      ; a2 = player record pointer

; --- Phase: RangeLookup on hub city to get region index ---
    moveq   #$0,d0
    move.b  $1(a2), d0                  ; d0 = player_record[+1] = hub_city index
    ext.l   d0
    move.l  d0, -(a7)                   ; push hub_city as arg
    jsr RangeLookup                     ; d0 = region/range index (0-7) for hub city
    move.w  d0, d2                      ; d2 = hub range index

; --- Phase: Clear local score buffer ---
    pea     ($0010).w                   ; push count = 16 bytes (8 slots * 2 bytes)
    clr.l   -(a7)                       ; push fill value = 0
    move.l  a4, -(a7)                   ; push dest = local score buffer
    jsr MemFillByte                     ; zero all 8 score words
    lea     $10(a7), a7                 ; pop 3 args (12 bytes = $C -- actually $10 frame; see below)

; --- Phase: Priority-flag bonus for single-player game (index d2) ---
    ; Check alliance_status[player * 8 + hub_range]
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0                     ; d0 = player_index * 8 (stride into $FF0270)
    lea     (a5,d0.l), a0              ; a0 -> player row in $FF0270
    moveq   #$0,d1
    move.w  d2, d1                      ; d1 = hub range index
    adda.l  d1, a0                      ; a0 -> status byte for this player's hub range
    cmpi.b  #$1, (a0)                   ; status == 1 (priority alliance slot)?
    bne.b   l_3244a                     ; no -> skip priority check
    cmpi.w  #$1, d4                     ; is this a single-player game?
    bne.b   l_3244a
    ; Single player + priority slot: call HasPriorityAlliance(hub_range)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)                   ; push hub_range index
    jsr (HasPriorityAlliance,PC)        ; checks if this alliance type has priority
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0                     ; returned 1 = has priority?
    bne.b   l_3246e                     ; no -> skip
    ; Award priority bonus to this slot's score
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0                      ; d0 = hub_range * 2 (word index)
    movea.l d0, a0
    addi.w  #$c8, (a4,a0.l)            ; score[hub_range] += 200 ($C8) for single-player priority
    bra.b   l_3246e

l_3244a:
    ; Status > 1 (established): award large bonus for this hub-range slot
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    lea     (a5,d0.l), a0              ; a0 -> player row in $FF0270
    moveq   #$0,d1
    move.w  d2, d1
    adda.l  d1, a0                      ; a0 -> status byte for hub range
    cmpi.b  #$1, (a0)                   ; status <= 1?
    bls.b   l_3246e                     ; <= 1: no bonus
    ; status >= 2 -> established alliance, big bonus
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0                      ; d0 = hub_range * 2
    movea.l d0, a0
    addi.w  #$7d0, (a4,a0.l)           ; score[hub_range] += 2000 ($7D0) for established alliance

l_3246e:
; --- Phase: Main Scoring Loop (iterate all 7 alliance type slots, d2 = 0..6) ---
    movea.l a4, a2                      ; a2 = pointer into score buffer (advances by 2 each iter)
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0                     ; d0 = player_index * 8
    lea     (a5,d0.l), a0              ; a0 = $FF0270 row for this player
    movea.l a0, a3                      ; a3 = status byte pointer (advances by 1 each iter)
    clr.w   d4                          ; d4 = count of scored (non-empty) slots found
    clr.w   d2                          ; d2 = slot index loop counter (0-7)
l_32480:
    ; Call BitFieldSearch(slot_index=d2, player_index=d3) to find a char in this slot
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)                   ; push slot_index
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)                   ; push player_index
    jsr BitFieldSearch                  ; d0 = character bitfield index for slot, or $20+ if empty
    addq.l  #$8, a7
    move.w  d0, d6                      ; d6 = BitFieldSearch result (char index or $20=none)
    cmpi.w  #$20, d0                    ; $20+ means no character found in this slot
    bcc.w   l_32536                     ; no char -> clear score for this slot

    ; Char found: check if alliance has room
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CountAllianceMembers,PC)       ; d0 = how many chars are already in this player's alliances
    nop
    addq.l  #$4, a7
    cmp.w   d7, d0                      ; is current count >= max cap?
    bcc.b   l_324d0                     ; at cap -> skip empty-slot bonus
    ; Room in alliance: check if this char's slot is empty in FindCharSlot
    moveq   #$0,d0
    move.w  d6, d0                      ; d0 = character index from BitFieldSearch
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0                      ; d0 = player index
    move.l  d0, -(a7)
    jsr FindCharSlot                    ; returns slot index or $FF if none
    addq.l  #$8, a7
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1                      ; is result == -1 (no existing slot)?
    bne.b   l_324d0                     ; slot exists -> no bonus
    addi.w  #$190, (a2)                 ; score += 400 ($190) for available empty slot

l_324d0:
    ; Check turn timing bonus: reward slot index 3 or 5 at early game turns
    jsr (CalcQuarterTurnOffset,PC)      ; d0 = current turn offset within quarter
    nop
    cmpi.w  #$14, d0                    ; offset >= 20 -> no timing bonus
    bcc.b   l_324ec
    cmpi.w  #$5, d2                     ; slot index == 5?
    beq.b   l_324e8
    cmpi.w  #$3, d2                     ; slot index == 3?
    bne.b   l_324ec
l_324e8:
    addi.w  #$64, (a2)                  ; score += 100 for key-quarter timing match

l_324ec:
    ; Score based on alliance status byte for this slot
    cmpi.b  #$1, (a3)                   ; status == 1?
    bne.b   l_324f8
    addi.w  #$c8, (a2)                  ; score += 200 for status == 1 (active)
    bra.b   l_32514
l_324f8:
    cmpi.b  #$2, (a3)                   ; status == 2?
    bne.b   l_32504
    addi.w  #$190, (a2)                 ; score += 400 for status == 2 (high priority)
    bra.b   l_32514
l_32504:
    cmpi.b  #$3, (a3)                   ; status == 3?
    beq.b   l_32510
    cmpi.b  #$4, (a3)                   ; status == 4?
    bne.b   l_32514
l_32510:
    addi.w  #$12c, (a2)                 ; score += 300 for status == 3 or 4

l_32514:
    ; Bonus if this slot is a duplicate alliance (already have one)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)                   ; push slot_index
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)                   ; push player_index
    jsr (CheckDuplicateAlliance,PC)     ; returns 1 if player already holds this alliance type
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_32532
    addi.w  #$c8, (a2)                  ; score += 200 for duplicate alliance type
l_32532:
    addq.w  #$1, d4                     ; increment count of scored (non-empty) slots
    bra.b   l_32538
l_32536:
    clr.w   (a2)                        ; no char -> zero this slot's score

l_32538:
    ; Advance pointers and loop counter
    addq.l  #$2, a2                     ; next score word
    addq.l  #$1, a3                     ; next status byte in $FF0270
    addq.w  #$1, d2                     ; d2++
    cmpi.w  #$7, d2                     ; loop for slots 0-6 (7 iterations)
    bcs.w   l_32480

; --- Phase: Availability Bonus (< 7 slots filled) ---
    cmpi.w  #$7, d4                     ; did we find < 7 non-empty slots?
    bcc.b   l_32552                     ; >= 7 filled -> no bonus
    addi.w  #$320, $e(a4)              ; score[7] += 800 ($320) for the "self" slot (index 7 at +$E)

; --- Phase: Sort 8 scores descending and write ranked indices to $FFA7AC ---
    ; Simple selection sort: find max 8 times, record winning index, zero it, repeat
l_32552:
    clr.w   d3                          ; d3 = output rank counter (0-7)
l_32554:
    movea.l a4, a2                      ; a2 = score buffer start
    moveq   #-$A,d4                     ; d4 = running max score (init to -10)
    clr.w   d2                          ; d2 = current slot index
l_3255a:
    cmp.w   (a2), d4                    ; current score > running max?
    bge.b   l_32562                     ; no -> keep current max
    move.w  (a2), d4                    ; update max score
    move.w  d2, d5                      ; d5 = index of new max
l_32562:
    addq.l  #$2, a2                     ; next score word
    addq.w  #$1, d2
    cmpi.w  #$8, d2                     ; loop 8 slots
    bcs.b   l_3255a

    ; Zero the found max slot so it won't be picked again
    moveq   #$0,d0
    move.w  d5, d0
    add.l   d0, d0                      ; d0 = winning_index * 2
    movea.l d0, a0
    move.w  #$ff9c, (a4,a0.l)          ; mark slot as -100 ($FF9C signed) so it won't rank again

    ; Write ranked index to $FFA7AC output table
    ; $FFA7AC: alliance-rank output table (stride 2, 8 entries per player? layout TBD)
    move.w  d3, d0
    add.w   d0, d0                      ; d0 = rank * 2
    movea.l  #$00FFA7AC,a0
    move.w  d5, (a0,d0.w)              ; ranked_output[rank] = winning slot index

    addq.w  #$1, d3
    cmpi.w  #$8, d3                     ; repeat for all 8 ranks
    bcs.b   l_32554

; --- Phase: Epilogue ---
    movem.l -$38(a6), d2-d7/a2-a5     ; restore registers (offset from a6 frame base)
    unlk    a6
    rts
