; ============================================================================
; UpdateGameStateS2 -- Process pending route slot state changes in $FF09CE: execute trade offers and display route slot result notifications for types 0 and 1.
; 750 bytes | $022FC8-$0232B5
; ============================================================================
UpdateGameStateS2:
    ; --- Phase: Setup ---
    ; Processes up to 2 pending route state change records stored at $FF09CE.
    ; Each 4-byte record: +$00=type (0=trade offer, 1=route notification), +$01=player_index, +$02=slot_index, +$03=unused
    ; a2 = current record pointer, starts at $FF09CE, advances by 4 each iteration
    ; d3 = iteration counter (0-1); loop processes exactly 2 entries
    ; a5 = local sprintf output buffer ($80 bytes at -$80(a6), also -$a0(a6) for $20-byte variant)
    link    a6,#-$A0
    movem.l d2-d3/a2-a5, -(a7)
    lea     -$80(a6), a5         ; a5 = sprintf output buffer (-$80(a6), 128 bytes)
    movea.l  #$00FF09CE,a2       ; a2 = route_field_c ($FF09CE): pending route state change records
    clr.w   d3                   ; d3 = iteration counter = 0
    ; =========================================================
    ; Main loop: process 2 route state change records (d3 = 0 and 1)
    ; =========================================================
l_22fdc:
    tst.b   (a2)                 ; +$00 = type byte: 0 = trade offer, 1 = route notification
    bne.w   l_23112              ; nonzero: type 1 path (route notification)
    ; =========================================================
    ; --- Branch: type == 0 -- trade offer ---
    ; =========================================================
    ; If flight_active ($FF000A), load and decompress tile pair #$12 for the trade animation
    tst.w   ($00FF000A).l        ; $FF000A = flight_active flag
    beq.b   l_22ff8              ; no active flight: skip tile pair load
    pea     ($0012).w            ; arg 2: tile pair index $12 (trade animation tiles)
    clr.l   -(a7)                ; arg 1: 0
    jsr DecompressTilePair       ; decompress and install tile pair for trade display
    addq.l  #$8, a7
l_22ff8:
    ; InitInfoPanel with arg 0: initialize the info panel display area (blank state)
    clr.l   -(a7)                ; arg: 0
    jsr InitInfoPanel            ; $023930-area: init / clear info panel tiles
    ; Compute route slot address: &route_slots[player * $320 + slot * $14]
    ; a2+$01 = player_index, a2+$02 = slot_index
    moveq   #$0,d0
    move.b  $2(a2), d0           ; d0 = slot_index (route_field_c +$02)
    mulu.w  #$14, d0             ; d0 = slot_index * $14 (route slot stride = 20 bytes)
    move.l  d0, -(a7)            ; save slot offset on stack temporarily
    moveq   #$0,d0
    move.b  $1(a2), d0           ; d0 = player_index (route_field_c +$01)
    mulu.w  #$320, d0            ; d0 = player_index * $320 (per-player route area stride = 800 bytes)
    add.l   (a7)+, d0            ; d0 = player*$320 + slot*$14 (combined offset, pops saved slot offset)
    movea.l  #$00FF9A20,a0       ; a0 = route_slots base ($FF9A20)
    lea     (a0,d0.w), a0        ; a0 = &route_slots[player][slot]
    movea.l a0, a3               ; a3 = route slot record ptr
    ; Fetch city B name: route_slot +$01 = city_b index; $5E680 = ROM city name pointer table
    moveq   #$0,d0
    move.b  $1(a3), d0           ; route_slot +$01 = city_b index
    lsl.w   #$2, d0              ; d0 *= 4 (long pointer index)
    movea.l  #$0005E680,a0       ; a0 = ROM city name pointer table ($5E680)
    move.l  (a0,d0.w), -(a7)     ; push city_b name string ptr as sprintf arg
    ; Fetch city A name: route_slot +$00 = city_a index
    moveq   #$0,d0
    move.b  (a3), d0             ; route_slot +$00 = city_a index
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)     ; push city_a name string ptr as sprintf arg
    ; Fetch player name: $FF00A8 is player_name_tab (16-byte entries, indexed by player_index*$10)
    moveq   #$0,d0
    move.b  $1(a2), d0           ; player_index from record
    lsl.w   #$4, d0              ; d0 *= $10 (player_name_tab stride = 16 bytes)
    movea.l  #$00FF00A8,a0       ; a0 = player_name_tab ($FF00A8)
    pea     (a0, d0.w)           ; push &player_name_tab[player_index] as sprintf arg
    pea     ($000480DC).l        ; ROM format string for trade offer box (e.g. "Player: %s\nRoute: %s -> %s")
    move.l  a5, -(a7)            ; destination = local sprintf buffer
    jsr sprintf                  ; format trade offer info string
    move.l  a5, -(a7)            ; push formatted string
    jsr (DrawLabeledBox,PC)      ; $02377C: draw framed labeled info box with text
    nop
    lea     $1c(a7), a7          ; clean 7 args (5 sprintf + 1 DrawLabeledBox + buf = $1C=28 bytes)
    ; Display: if flight_active use TogglePageDisplay, else PollAction (wait for button)
    tst.w   ($00FF000A).l        ; flight_active?
    beq.b   l_23088              ; no: standard PollAction wait
    pea     ($0003).w            ; arg: mode 3
    jsr TogglePageDisplay        ; page-flip display (non-blocking, for animated flight mode)
    addq.l  #$4, a7
    bra.b   l_23098
l_23088:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction               ; $01D62C: wait for button press (blocking)
    addq.l  #$8, a7
l_23098:
    ; Update char_stat_subtab entry for this player: $FF0120 + player_index*4
    ; char_stat_subtab +$01 = countdown timer byte; subtract $14 (20), clamp to 0
    moveq   #$0,d0
    move.b  $1(a2), d0           ; player_index
    lsl.w   #$2, d0              ; d0 *= 4 (char_stat_subtab stride)
    movea.l  #$00FF0120,a0       ; a0 = char_stat_subtab ($FF0120)
    lea     (a0,d0.w), a0        ; a0 = &char_stat_subtab[player_index]
    movea.l a0, a4               ; a4 = char_stat_subtab entry ptr
    moveq   #$0,d2
    move.b  $1(a4), d2           ; d2 = current timer value at subtab +$01
    addi.w  #$ffec, d2           ; d2 -= $14 (20): decrement countdown (two's complement: $FFEC = -$14)
    tst.w   d2                   ; result <= 0?
    ble.b   l_230c0              ; yes: clamp to 0
    move.w  d2, d0
    ext.l   d0                   ; d0 = decremented timer (positive)
    bra.b   l_230c2
l_230c0:
    moveq   #$0,d0               ; clamp to 0 (don't go negative)
l_230c2:
    move.b  d0, $1(a4)           ; store updated timer back to subtab +$01
    ; Execute the trade offer for this route slot
    pea     ($0001).w            ; arg 3: mode 1
    move.l  a3, -(a7)            ; arg 2: route slot ptr
    moveq   #$0,d0
    move.b  $1(a2), d0           ; player_index
    move.l  d0, -(a7)            ; arg 1: player_index
    jsr (ExecuteTradeOffer,PC)   ; execute the pending trade offer; d0=1 means trade was accepted
    nop
    lea     $c(a7), a7           ; clean 3 args
    cmpi.w  #$1, d0              ; trade accepted?
    bne.b   l_23102              ; no: skip acceptance dialog
    ; Trade accepted: show result dialog from ROM $48114
    pea     ($00048114).l        ; ROM string: trade accepted notification text
    jsr (DrawLabeledBox,PC)      ; draw the trade-accepted labeled box
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction               ; wait for button press to dismiss dialog
    lea     $c(a7), a7           ; clean 1 (pea $48114) + PollAction 2 args = 3 args = $C
l_23102:
    jsr (ClearListArea,PC)       ; $0237A8: clear the list/route display area
    nop
    jsr ClearInfoPanel           ; $023930: clear the info panel tile area
    bra.w   l_2320e              ; -> advance to next record
    ; =========================================================
    ; --- Branch: type != 0 -- check for type == 1 (route notification) ---
    ; =========================================================
l_23112:
    cmpi.b  #$1, (a2)            ; type byte == 1?
    bne.w   l_2320e              ; no (unexpected type): skip this record
    ; If flight_active, load tile pair #$13 for route notification display
    tst.w   ($00FF000A).l
    beq.b   l_23132
    pea     ($0013).w            ; arg 2: tile pair index $13 (route notification tiles)
    pea     ($0001).w            ; arg 1: 1
    jsr DecompressTilePair
    addq.l  #$8, a7
l_23132:
    ; InitInfoPanel with arg 1: initialize info panel (different mode from type-0 path)
    pea     ($0001).w            ; arg: 1
    jsr InitInfoPanel
    ; Compute route slot address (same formula as type-0 path above)
    moveq   #$0,d0
    move.b  $2(a2), d0           ; slot_index
    mulu.w  #$14, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0           ; player_index
    mulu.w  #$320, d0
    add.l   (a7)+, d0            ; combined offset (pops saved)
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3               ; a3 = route slot ptr
    ; Fetch city B name (route_slot +$01)
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)     ; city_b name ptr
    ; Fetch city A name (route_slot +$00)
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)     ; city_a name ptr
    ; Fetch player name (same $FF00A8 table, player_index * $10 stride)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)           ; &player_name_tab[player_index]
    pea     ($00048158).l        ; ROM format string for route notification (different from $480DC)
    move.l  a5, -(a7)            ; sprintf destination
    jsr sprintf
    move.l  a5, -(a7)
    jsr (DrawLabeledBox,PC)      ; draw route notification labeled box
    nop
    lea     $1c(a7), a7
    ; Display: toggle vs poll based on flight_active (same pattern as type-0)
    tst.w   ($00FF000A).l
    beq.b   l_231c4
    pea     ($0003).w
    jsr TogglePageDisplay
    addq.l  #$4, a7
    bra.b   l_231d4
l_231c4:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
l_231d4:
    jsr (ClearListArea,PC)       ; clear list area
    nop
    jsr ClearInfoPanel           ; clear info panel
    ; Update char_stat_subtab +$01 for this player: subtract $A (10), clamp to 0
    ; (slightly smaller decrement than type-0's $14)
    moveq   #$0,d0
    move.b  $1(a2), d0           ; player_index
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4               ; a4 = char_stat_subtab entry
    moveq   #$0,d2
    move.b  $1(a4), d2           ; current timer value at subtab +$01
    addi.w  #$fff6, d2           ; d2 -= $A (10): decrement by 10 (two's complement: $FFF6 = -$A)
    tst.w   d2
    ble.b   l_23208              ; <= 0: clamp to 0
    move.w  d2, d0
    ext.l   d0
    bra.b   l_2320a
l_23208:
    moveq   #$0,d0               ; clamp to 0
l_2320a:
    move.b  d0, $1(a4)           ; store updated timer
l_2320e:
    ; --- Advance to next record ---
    addq.l  #$4, a2              ; advance record pointer by 4 bytes (one record)
    addq.w  #$1, d3              ; increment iteration counter
    cmpi.w  #$2, d3              ; processed both records?
    blt.w   l_22fdc              ; no: loop back for second record
    ; =========================================================
    ; --- Phase: Check $FF09D6 for a third notification (route slot change alert) ---
    ; $FF09D6: if not $FF, holds a player_index for an additional labeled box notification
    ; =========================================================
    cmpi.w  #$ff, ($00FF09D6).l  ; $FF09D6 = pending_notify_player: $FF means no notification
    beq.w   l_232ac              ; $FF: nothing to display, jump to epilogue
    ; InitInfoPanel with $F: initialize info panel in mode $F (notification mode)
    pea     ($000F).w
    jsr InitInfoPanel
    ; Build notification string: player_name + $FF00A8 player_name_tab entry
    move.w  ($00FF09D6).l, d0    ; d0 = pending notify player_index
    lsl.w   #$4, d0              ; d0 *= $10 (player_name_tab stride)
    movea.l  #$00FF00A8,a0       ; a0 = player_name_tab
    pea     (a0, d0.w)           ; push &player_name_tab[notify_player_index]
    pea     -$a0(a6)             ; destination buffer (-$a0(a6): 160-byte area above sprintf buf)
    jsr StringConcat             ; concatenate player name into -$a0(a6) buffer
    ; Format first notification box: format string $48198
    pea     -$a0(a6)             ; arg: concatenated player name string
    pea     ($00048198).l        ; ROM format string for first notify box
    move.l  a5, -(a7)            ; sprintf destination
    jsr sprintf
    move.l  a5, -(a7)
    jsr (DrawLabeledBox,PC)      ; draw first notification labeled box
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction               ; wait for button press
    ; Format second notification box: format string $481DA (different message for same player)
    pea     -$a0(a6)             ; arg: same player name string (already in buffer)
    pea     ($000481DA).l        ; ROM format string for second notify box
    move.l  a5, -(a7)
    jsr sprintf
    lea     $30(a7), a7          ; clean combined stack: StringConcat(2)+sprintf1(3)+DrawLabeledBox(1)+PollAction(2)+sprintf2(3) args
    move.l  a5, -(a7)
    jsr (DrawLabeledBox,PC)      ; draw second notification labeled box
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction               ; wait for button press to dismiss second notification
    jsr (ClearListArea,PC)       ; clear list area
    nop
    jsr ClearInfoPanel           ; clear info panel
l_232ac:
    ; --- Phase: Epilogue ---
    movem.l -$b8(a6), d2-d3/a2-a5
    unlk    a6
    rts
