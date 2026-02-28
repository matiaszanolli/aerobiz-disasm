; ============================================================================
; UpdatePlayerRating -- Scans player char slots for rival match; returns lowest-cost slot index or $FF on failure
; 214 bytes | $034BEE-$034CC3
; ============================================================================
UpdatePlayerRating:
; --- Phase: Setup ---
; Args (no link frame; register-based): $20(sp)=player_index, $24(sp)=search_bit_index
    movem.l d2-d6/a2-a3, -(a7)
; d2 = player_index
    move.l  $20(a7), d2
; d6 = search_bit_index (bit to find in the player's bitfield roster)
    move.l  $24(a7), d6
; d5 = $FF: default return value (no valid slot found)
    move.w  #$ff, d5
; Locate this player's record in player_records ($FF0018, stride $24 = 36 bytes)
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
; a3 = pointer to this player's player_record
    movea.l a0, a3
; --- Phase: BitFieldSearch to Verify the Bit Exists ---
; BitFieldSearch(player_index=d2, bit_index=d6): search the $FFA6A0 bitfield for d6's bit
; Returns d0 = bit slot index, or $20 if the bit is not in this player's roster
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
; d4 = returned bit slot index
    move.w  d0, d4
; $20 (32) = sentinel "not found": if not found, return $FF immediately
    cmpi.w  #$20, d4
    bcc.w   l_34cbc
; --- Phase: CountMatchingChars to Check Roster Depth ---
; CountMatchingChars(player_index=d2, bit_index=d4):
; Count how many chars in this player's roster match the same character type
; Must have MORE than 2 matches to be worth searching for a rival
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr CountMatchingChars
    addq.l  #$8, a7
; If 2 or fewer matching chars, no rival competition possible -- return $FF
    cmpi.w  #$2, d0
    ble.b   l_34cbc
; --- Phase: FindCharSlot to Locate the Rival's Slot ---
; Initialize d3 = $FFFF (no best slot found yet; used to track minimum gross_revenue)
    move.w  #$ffff, d3
; FindCharSlot(bit_index=d4, player=d2): find which route slot holds this character
; Returns d0 = slot index, or $FF if not assigned to any slot
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr FindCharSlot
    addq.l  #$8, a7
; d6 = returned slot index
    move.w  d0, d6
    ext.l   d0
; $FF sign-extended to -1: char not in any slot, return $FF
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   l_34cbc
; --- Phase: Locate Route Slot in route_slots Array ---
; Compute pointer: route_slots + player_index * $320 + slot_index * $14
; route_slots base = $FF9A20; player stride = $320 (800 bytes); slot stride = $14 (20 bytes)
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d6, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
; a2 = pointer to the located route_slot record
    movea.l a0, a2
; d2 now reused as the current slot scan index (starts from slot d6)
    move.w  d6, d2
    bra.b   l_34ca6
; --- Phase: Scan Forward for Lowest-Cost Route Slot ---
l_34c88:
; route_slot+$00 = city_a (byte): source city index
; If city_a > d4 (the bit index / char threshold), this slot is beyond the search range
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
; city_a > bit_index: stop scanning (slots are ordered by city_a)
    bgt.b   l_34cbc
; Compare this slot's gross_revenue ($8(a2)) with the running minimum (d3)
; route_slot+$08 = gross_revenue (word): current accumulated revenue this quarter
    cmp.w   $8(a2), d3
; If current minimum (d3) <= this slot's revenue, keep the current best
    bls.b   l_34ca0
; This slot has lower revenue than the current minimum: update best slot
    move.w  $8(a2), d3
; d5 = slot index of the lowest-cost rival slot found so far
    move.w  d2, d5
l_34ca0:
; Advance to next route slot (a2 += $14)
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_34ca6:
; Loop condition: continue while d2 < (domestic_slots + intl_slots) for this player
; player_record+$04 = domestic_slots, player_record+$05 = intl_slots
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_34c88
; --- Phase: Return ---
l_34cbc:
; Return d5: the slot index of the lowest-revenue rival slot, or $FF if none found
    move.w  d5, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts

RemoveCharRelation:                                                  ; $034CC4
; --- Phase: Setup ---
; Args: $8(a6) = player_index (d2), $C(a6) = slot_index (d3)
; Frame: -$3C bytes of locals (name string buffers for both chars)
    link    a6,#-$3c
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0008(a6),d2
    move.l  $000c(a6),d3
; a4 = route_slots base ($FF9A20) -- used throughout for slot address computation
    movea.l #$00ff9a20,a4
; a3 = pointer to this player's player_record ($FF0018 + player_index * $24)
; player_record fields: +$04=domestic_slots, +$05=intl_slots, +$02=route_type_a, +$03=route_type_b
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
; --- Phase: Validate Slot Index is Within Active Slot Range ---
; Check lower bound: d3 (slot_index) must be >= domestic_slots (player_record+$04)
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
; player_record+$04 = domestic_slots count
    move.b  $0004(a3),d1
    cmp.l   d1,d0
; If slot_index < domestic_slots, slot is out of the relation range -- exit immediately
    blt.w   .l34f80
; Check upper bound: d3 < (domestic_slots + intl_slots)
    moveq   #$0,d0
    move.b  $0004(a3),d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
; If slot_index >= total slots, also out of range -- exit
    ble.w   .l34f80
; --- Phase: Compute Route Slot Address ---
; Slot byte-offset within player's route array: slot_index * $14 (stride 20 bytes)
; $14 = sizeof(route_slot); compute: d3 * 4 + d3 = d3*5; then *4 = d3*20
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    move.l  d0,-(sp)
; Multiply player_index by $320 (player stride in route_slots): Multiply32(player_index, $320)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
; a2 = route_slots + player_offset + slot_offset = pointer to this specific route_slot
    lea     (a4,d0.l),a0
    adda.l  (sp)+,a0
    movea.l a0,a2
; --- Phase: Format Both Character Names (sprintf into frame locals) ---
; route_slot+$00 = city_a (byte): source city index -> use as char code to look up name
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
; ROM table at $5E680: char name string pointer table (4 bytes per char code)
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
; sprintf into -$1E(a6) (30-byte local buffer): char A's name
    pea     -$001e(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
; route_slot+$01 = city_b (byte): destination city -> char B name
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
; sprintf into -$3C(a6) (second 30-byte local buffer): char B's name
    pea     -$003c(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
; --- Phase: Compute Relation Value ---
; CalcRelationValue(mode=3, char_a=city_a_byte, char_b=city_b_byte)
; Multi-mode character value calculator; mode 3 = negotiation / relation score
    pea     ($0003).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$a506                           ; jsr $01A506
; Round up result toward zero before dividing by 2 (arithmetic rounding)
    bge.b   .l34d8c
    addq.l  #$1,d0
.l34d8c:                                                ; $034D8C
; d5 = CalcRelationValue / 2 (halved relation value for cash-back on removal)
    asr.l   #$1,d0
    move.l  d0,d5
; --- Phase: Look Up Display and Bitfield Values ---
; RangeLookup(char_b code): map char B's code to region category (0-7)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
; d4 = region category for char B (0-7)
    move.w  d0,d4
; GetByteField4($74E0): extract packed 4-bit byte field from route_slot[0] (char A slot data)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
; d7 = byte field value from char A (used for bitfield table indexing)
    move.w  d0,d7
; GetLowNibble($7402): extract low nibble from route_slot[0] (char A sub-category)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    lea     $0028(sp),sp
; d6 = low nibble of char A slot (char sub-type)
    move.w  d0,d6
; --- Phase: Remove from Bitfield or Extended Bitmask ---
; Check if char B's code < $20 (32): short range chars use the compact $FFA6A0 bitfield
    cmpi.b  #$20,$0001(a2)
    bcc.b   .l34de2
; Short-range char (code < $20): remove from entity bitfield at $FFA6A0
; Build bitmask: 1 << char_b_code, then XOR it out of the player's longword bitfield
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
; Index into $FFA6A0: player_index * 4 (4 bytes = 1 longword per player)
    move.w  d2,d1
    lsl.w   #$2,d1
; $FFA6A0 = bitfield_tab (entity bitfield array); XOR clears the bit for this char
    movea.l #$00ffa6a0,a0
    eor.l   d0,(a0,d1.w)
; Decrement player_record+$02 (route_type_a count): one fewer short-range char slot
    subq.b  #$01,$0002(a3)
    bra.b   .l34e22
.l34de2:                                                ; $034DE2
; Long-range char (code >= $20): remove from extended bitmask at $FFBD6C
; Translate char_b code through $5ECBE table to get local bitmask offset
    moveq   #$0,d0
    move.b  $0001(a2),d0
; ROM $5ECBE: region base-code table, indexed by d4 (region category * 4, word reads)
    move.w  d4,d1
    lsl.w   #$2,d1
    movea.l #$0005ecbe,a0
    move.b  (a0,d1.w),d1
    andi.l  #$ff,d1
; Subtract base to get relative bit position within this region's bitmask
    sub.w   d1,d0
    moveq   #$1,d1
    lsl.w   d0,d1
    move.l  d1,d0
; Compute index into $FFBD6C: player_index * $E + d7 (byte field) * 2 + d4 (region) * 2
    move.w  d2,d1
    mulu.w  #$e,d1
    movea.l d7,a0
    move.w  d4,d7
    add.w   d7,d7
    exg     d7,a0
    add.w   a0,d1
; $FFBD6C: extended bitmask (adjacent to win_left $FFBD68); XOR clears this char's bit
    movea.l #$00ffbd6c,a0
    eor.w   d0,(a0,d1.w)
; Decrement player_record+$03 (route_type_b): one fewer long-range/international char slot
    subq.b  #$01,$0003(a3)
.l34e22:                                                ; $034E22
; --- Phase: Update City Data Popularity Counts ---
; Decrement city_data popularity for city_a ($FFBA81, stride-2 storage)
; city_data = 89 cities * 4 entries * 2 bytes; entry for city_a at offset city_a*8 + player*2
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$3,d0
; city_a * 8: each city takes 8 bytes in the stride-2 city_data block
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
; route_slot+$03 = frequency byte: represents contribution level to subtract
    move.b  $0003(a2),d1
; $FFBA81 = city_data + 1 (the odd-byte of each stride-2 pair = popularity counter)
    movea.l #$00ffba81,a0
    sub.b   d1,(a0,d0.w)
; Same for city_b: decrement its popularity by the same frequency value
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$3,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    move.b  $0003(a2),d1
    movea.l #$00ffba81,a0
    sub.b   d1,(a0,d0.w)
; --- Phase: Refund Relation Value to Player's Cash ---
; player_record+$06 = cash (longword); add back half the relation value (d5)
    add.l   d5,$0006(a3)
; Decrement player_record+$05 (intl_slots): one fewer active international route
    subq.b  #$01,$0005(a3)
; --- Phase: Update event_records Stat ($FFB9E9) ---
; event_records: $FFB9E8 + player_index * $20 + slot_index * 2 + 1 (stride-2, odd byte)
    move.w  d2,d0
    lsl.w   #$5,d0
    move.w  d7,d1
    add.w   d1,d1
    add.w   d1,d0
; d6 (low nibble of char A) = stat to add back to the event record entry
    movea.l #$00ffb9e9,a0
    add.b   d6,(a0,d0.w)
; --- Phase: Compact Slot Array if Not Last Slot ---
; If slot_index < $27 (39), shift the tail of the route slot array left to fill the gap
    cmpi.w  #$27,d3
    bcc.b   .l34eaa
; MemCopy: shift remaining slots left: destination = a2+$14 (one slot ahead), source = a2
; count = ($28 - slot_index) * $14 - $14 bytes to move
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$28,d1
    sub.l   d0,d1
    move.l  d1,d0
; Compute byte count: ($28 - d3) * 5 * 4 = ($28 - d3) * $14
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    subi.l  #$14,d0
    move.l  d0,-(sp)
; destination = a2 (current slot position -- overwrite it)
    move.l  a2,-(sp)
    clr.l   -(sp)
; source = a2 + $14 (next slot -- shift back)
    move.l  a2,d0
    moveq   #$14,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
; MemCopy($1D538): safe overlapping memmove for route slot compaction
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538
    lea     $0014(sp),sp
.l34eaa:                                                ; $034EAA
; --- Phase: Clear Last Slot (now a duplicate after compaction) ---
; Zero $14 (20) bytes at route_slots + player_offset + $30C (slot 39 area)
; This wipes the stale copy left at the end after the shift
    pea     ($0014).w
    clr.l   -(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
; Multiply32(player_index, $320) = player byte offset in route_slots
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    lea     (a4,d0.l),a0
; $30C = offset of slot 39 within the 800-byte player block ($320 - $14)
    lea     $030c(a0),a0
    move.l  a0,-(sp)
; MemFillByte: fill 20 bytes with 0x00 (clear the vacated last slot)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    lea     $000c(sp),sp
; Set city_a byte of last slot to $FF (marks slot as empty / unused)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    movea.l d0,a0
    lea     $030c(a4),a1
; route_slots[player][39].city_a = $FF (empty sentinel)
    move.b  #$ff,(a1,a0.l)
; Set city_b byte of last slot to $FF as well
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    movea.l d0,a0
    lea     $030d(a4),a1
; route_slots[player][39].city_b = $FF
    move.b  #$ff,(a1,a0.l)
; --- Phase: Optional UI Display (if $12(a6) == 1) ---
; If the display-update argument is set, redraw the removal confirmation panel
    cmpi.w  #$1,$0012(a6)
    bne.b   .l34f80
; DrawBox(col=2, row=$11, width=$1C, height=8): draw dialog box for removal confirmation
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
; PrintfWide: print "char_a removed from char_b's route" confirmation message
; Args: player name block at $FF00A8[player_index*16] (unknown block $FF00A8, stride $10)
    pea     -$003c(a6)
    pea     -$001e(a6)
    move.w  d2,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
; Format string at $448E4: removal confirmation text with two char names
    pea     ($000448E4).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
; LoadScreenGfx($68CA): load portrait for char B (player_index=d2, with resource flag=1)
    pea     ($0001).w
    clr.l   -(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$68ca                           ; jsr $0068CA
    lea     $002c(sp),sp
; ShowRelPanel($6B78): display the relation panel at (col=2, row=7) for char B
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
; PollInputChange($30 frames = 48): wait up to 48 frames for any input before returning
    pea     ($001E).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
.l34f80:                                                ; $034F80
    movem.l -$0060(a6),d2-d7/a2-a4
    unlk    a6
    rts
    dc.w    $48E7,$3020,$242F; $034F8A
; === Translated block $034F90-$0357FE ===
; 11 functions, 2158 bytes
