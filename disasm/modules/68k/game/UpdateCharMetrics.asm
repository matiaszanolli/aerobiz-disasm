; ============================================================================
; UpdateCharMetrics -- Records a char-pair relation, updates alliance bitmasks and VSRAM, adjusts stamina, shows relation panel
; 774 bytes | $0339DC-$033CE1
; ============================================================================
; --- Phase: Setup and Relation Value Check ---
UpdateCharMetrics:
    link    a6,#-$18
    movem.l d2-d7/a2-a5, -(a7)
    ; d3 = player index (arg 1, $8(a6))
    move.l  $8(a6), d3
    ; d4 = char_index_a (arg 3, $10(a6)) -- first character in the pair
    move.l  $10(a6), d4
    ; d5 = char_index_b (arg 2, $C(a6)) -- second character in the pair
    move.l  $c(a6), d5
    ; a4 = bitfield_tab base ($FFA6A0): entity bitfield array, indexed entity*4
    movea.l  #$00FFA6A0,a4
    ; a5 = local scratch longword at -$18(a6) (stores computed relation value)
    lea     -$18(a6), a5
    ; Locate player record: $FF0018 + player_index * $24 (36 bytes/player)
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    ; a2 = pointer to this player's record (player_records base)
    movea.l a0, a2
    ; Compute the relation value for the char pair (mode 3)
    ; CalcRelationValue: returns a fitness/compatibility score for the pairing
    pea     ($0003).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcRelationValue
    lea     $c(a7), a7
    ; Store relation value at a5 (local scratch)
    move.l  d0, (a5)
    ; player_record+$06 = cash balance; compare with computed relation value
    ; If cash < relation value, the player can't afford this pairing -- skip
    move.l  $6(a2), d0
    cmp.l   (a5), d0
    ble.w   l_33cd4
; --- Phase: Determine Route Type and Update Slot Counts ---
    ; RangeLookup: map char_index_b (d5) to range category 0-7 (d2)
    ; This identifies whether char B is in a domestic or international route category
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    ; d2 = range category for char B
    move.w  d0, d2
    ; RangeLookup: map char_index_a (d4) to range category 0-7 (d6)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    ; d6 = range category for char A
    move.w  d0, d6
    ; If categories differ: cross-range pairing -> increment domestic_slots (+$04)
    cmp.w   d6, d2
    beq.b   l_33a54
    ; player_record+$04 = domestic_slots; cross-category increments this
    addq.b  #$1, $4(a2)
    bra.b   l_33a58
l_33a54:
    ; Same category: intra-range pairing -> increment intl_slots (+$05)
    addq.b  #$1, $5(a2)
l_33a58:
; --- Phase: Build Relation Record and Insert ---
    ; Zero the 20-byte ($14) record area at -$14(a6) for the new relation entry
    pea     ($0014).w
    clr.l   -(a7)
    pea     -$14(a6)
    jsr MemFillByte
    ; a3 = pointer to the new zeroed relation record (on the stack frame)
    lea     -$14(a6), a3
    ; ApplyRelationBonus: fills the relation record with bonus stats for this player/char pair
    ; arg: player_index, record_ptr, char_a, char_b, arg5 from $16(a6)
    moveq   #$0,d0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ApplyRelationBonus,PC)
    nop
    ; Set relation_record+$0A status_flags = $04 (ESTABLISHED bit)
    move.b  #$4, $a(a3)
    ; InsertRelationRecord: inserts the completed relation record into the sorted table
    ; at $FF9A20 for this player
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr InsertRelationRecord
    lea     $30(a7), a7
; --- Phase: Update Alliance Bitmasks ---
    ; Cross-range pairing: set bits for BOTH chars in the player's bitfield_tab entry
    cmp.w   d6, d2
    beq.b   l_33b08
    ; relation_record[0] = char A's category bit index; set its bit in bitfield_tab[player]
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    ; bitfield_tab[$FFA6A0] indexed by player_index * 4
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    ; Set char A's bit in the player's 32-bit entity bitfield
    or.l    d0, (a4,a0.l)
    ; relation_record[1] = char B's category bit index; set its bit too
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    ; --- Update cross-category alliance byte in VSRAM-adjacent table $FFA7BC ---
    ; Table indexed [player*7 + other_range]: marks that player_range d2 is allied with d6
    moveq   #$1,d0
    lsl.b   d6, d0
    move.w  d3, d1
    mulu.w  #$7, d1
    add.w   d2, d1
    movea.l  #$00FFA7BC,a0
    ; Set bit for range d6 in alliance byte for (player, range d2)
    or.b    d0, (a0,d1.w)
    ; And set the reciprocal: range d2 is allied with d6 (symmetric)
    moveq   #$1,d0
    lsl.b   d2, d0
    move.w  d3, d1
    mulu.w  #$7, d1
    add.w   d6, d1
    movea.l  #$00FFA7BC,a0
    or.b    d0, (a0,d1.w)
    bra.w   l_33bba
; --- Phase: Intra-Range Alliance Handling ---
l_33b08:
    ; Same range: check if char_b index < $20 (domestic chars, index 0-31)
    cmpi.w  #$20, d5
    bcc.b   l_33b26
    ; Domestic char B: just set its bit in the player's entity bitfield
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    bra.b   l_33b60
l_33b26:
    ; International char B (index >= $20): update VSRAM/CRAM word table at $FFBD6C
    ; $5ECBE is a ROM table; entry d2*4 byte 0 = base range offset for this category
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ; Compute within-category offset: d5 - base = position within the range
    move.w  d5, d7
    sub.w   d0, d7
    ; Bit position: 1 << (d5 - base)
    moveq   #$1,d0
    lsl.w   d7, d0
    ; Table offset into $FFBD6C: player*14 + category*2 (stride-2 word table)
    move.w  d3, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  d2, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    ; Set the bit in the category word for this player
    or.w    d0, (a0,d1.w)
    ; Increment player_record+$03 (route_type_b = international route count)
    addq.b  #$1, $3(a2)
l_33b60:
    ; Similarly check char A (d4): if domestic (< $20), just set bitfield bit
    cmpi.w  #$20, d4
    bcc.b   l_33b80
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    bra.b   l_33bba
l_33b80:
    ; International char A (>= $20): same $FFBD6C table update as above for char A's range
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d4, d7
    sub.w   d0, d7
    moveq   #$1,d0
    lsl.w   d7, d0
    move.w  d3, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  d6, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    or.w    d0, (a0,d1.w)
    ; Increment route_type_b for player
    addq.b  #$1, $3(a2)
; --- Phase: Count Active Alliance Bits and Deduct Cost ---
l_33bba:
    ; Clear player_record+$02 (route_type_a) -- will be recomputed by counting live bits
    clr.b   $2(a2)
    clr.w   d2
; Loop over all 32 possible char indices (bits 0..31 in the player's entity bitfield)
l_33bc0:
    ; Test if bit d2 is set in this player's bitfield_tab entry
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    ; If bit is set, this entity is currently active in an alliance for this player
    and.l   (a4,a0.l), d0
    beq.b   l_33bdc
    ; Increment route_type_a (count of active alliance entities)
    addq.b  #$1, $2(a2)
l_33bdc:
    addq.w  #$1, d2
    ; 32 chars maximum (indices 0-31 = $20)
    cmpi.w  #$20, d2
    bcs.b   l_33bc0
    ; --- Deduct relation cost from player's cash ---
    ; player_record+$06 = cash; subtract the relation value computed at entry
    move.l  (a5), d0
    sub.l   d0, $6(a2)
    ; --- Reduce stamina of char B in event_records ($FFB9E9) ---
    ; GetByteField4: reads a byte subfield (nibble index) from the relation record
    move.l  a3, -(a7)
    jsr GetByteField4
    andi.l  #$ffff, d0
    ; Index into event_records: offset = d0*2 + player*$20
    ; event_records: $FFB9E8, 4 records * $20 bytes; use $FFB9E9 (odd-byte access = stamina)
    add.l   d0, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E9,a0
    adda.l  d0, a0
    ; a2 = pointer to this char's stamina byte in event_records
    movea.l a0, a2
    ; GetLowNibble: return lower 4 bits of relation_record[0] (encoded stamina cost)
    move.l  a3, -(a7)
    jsr GetLowNibble
    ; Subtract stamina cost from the event_record byte
    sub.b   d0, (a2)
    ; --- Add bonus to city_data ($FFBA81) for char B and char A ---
    ; city_data indexed: city * 8 + player * 2 (stride-2 storage, odd byte = value)
    ; relation_record+$03 = bonus value from ApplyRelationBonus
    move.w  d5, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a3), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
    ; Repeat for char A
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a3), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
; --- Phase: Display Relation Result Panel ---
    ; Draw dialog box (col=2, row=$11=17, width=$1C=28, height=8)
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    jsr DrawBox
    ; Look up char A's display name pointer from $5E680 (ROM name table, stride 4)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    ; Look up char B's display name pointer
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    ; Player name area: $FF00A8 + player_index * $10 (16-byte per-player name buffer)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    ; ROM format string at $448BA: relation result announcement text
    pea     ($000448BA).l
    ; PrintfWide: render the result string in 2-tile wide font
    jsr PrintfWide
    lea     $28(a7), a7
    ; LoadScreenGfx: load graphical assets for the relation result screen
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    ; ShowRelPanel: display the character relationship affinity panel
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    ; ShowPlayerInfo: show player cash balance and stats after deduction
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    ; Wait for player input ($1E = 30 frames max)
    pea     ($001E).w
    jsr PollInputChange
    ; Return 1 = success (relation was affordable and applied)
    moveq   #$1,d3
    bra.b   l_33cd6
; --- Phase: Insufficient Funds Path ---
l_33cd4:
    ; Return 0 = failed (cash < relation value)
    clr.w   d3
l_33cd6:
    move.w  d3, d0
    movem.l -$40(a6), d2-d7/a2-a5
    unlk    a6
    rts
