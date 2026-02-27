; ============================================================================
; FinalizeQuarterEnd -- Route-slot negotiation UI: presents the char browser,
; calls FindRouteSlotByCharState/CalcRouteRevenue/CalcCharAdvantage, handles
; the confirmation dialog, and commits the negotiation hire into the slot record.
; Called at quarter-end when a player initiates slot-bid negotiations.
; 1090 bytes | $027FF4-$028435
;
; Args (on stack, C-style):
;   $8(a6)  = player index       (d2)
;   $c(a6)  = quarter index      (d3)
;   $12(a6) = screen_id word     (a5 -> word ptr into caller's frame)
;
; Register map (stable across function body):
;   a3 = $0482FC  = StatusMsgPtrs[9..24] -- dialog text pointer table base
;   a4 = $01183A  = ShowTextDialog       -- modal dialog dispatch
;   a5 = $12(a6)  = ptr to screen_id word in caller's frame
;   d2 = player index (0-3)
;   d3 = quarter index (0-3)
;   d4 = selected char index (from BrowseCharList)
;   d5 = retry flag: 0=normal path, 1=reload screen after negotiation
;   d6 = CalcCharAdvantage result (char contribution score)
;   d7 = CalcRouteRevenue result (revenue tier 0-12+)
; ============================================================================
FinalizeQuarterEnd:
    link    a6,#-$50
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2                  ; d2 = player index
    move.l  $c(a6), d3                  ; d3 = quarter index

; --- Phase: Frame Setup ---
    movea.l  #$000482FC,a3              ; a3 = StatusMsgPtrs[9] (negotiation dialog strings)
    movea.l  #$0001183A,a4              ; a4 = ShowTextDialog function ptr
    lea     $12(a6), a5                 ; a5 = &screen_id (word in caller frame)
    clr.w   d5                          ; d5 = retry flag = 0

; --- Phase: Compute $FF0338 slot offset for this player/quarter ---
; Layout: (player << 5) + (quarter << 3) = byte offset into $FF0338 table
; $FF0338 is an 80-byte table: 4 players * 20 bytes, used by DrawPlayerRoutes
    move.w  d2, d0
    lsl.w   #$5, d0                     ; d0 = player * 32
    move.w  d3, d1
    lsl.w   #$3, d1                     ; d1 = quarter * 8
    add.w   d1, d0                      ; d0 = player*32 + quarter*8 = slot offset
    movea.l  #$00FF0338,a0              ; a0 = negotiation history table base
    lea     (a0,d0.w), a0               ; a0 -> this player/quarter slot in table
    movea.l a0, a2                      ; a2 = slot record ptr (preserved for writes)

; --- Phase: Initial Screen Load (relation panel + route scan) ---
    jsr ResourceLoad
    pea     ($0001).w
    move.w  (a5), d0                    ; screen_id
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0                      ; player index
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  (a5), d0                    ; screen_id
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0                      ; player index
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel                    ; display relationship panel for player
    pea     ($0001).w
    move.w  (a5), d0                    ; screen_id
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0                      ; player index
    ext.l   d0
    move.l  d0, -(a7)
    jsr ScanRouteSlots                  ; populate available route slots for display
    lea     $24(a7), a7
    jsr ResourceUnload

; --- Phase: Retry Check (reload screen if d5==1 after negotiation) ---
l_2807e:
    cmpi.w  #$1, d5
    bne.b   l_280d8                     ; d5 != 1: skip reload, go to char browser
    ; d5==1: a previous negotiation was committed, reload screen state
    jsr ResourceLoad
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ScanRouteSlots
    lea     $24(a7), a7
    jsr ResourceUnload
    clr.w   d5                          ; clear retry flag after reload

; --- Phase: Character Browser (BrowseCharList) ---
l_280d8:
    ; ShowTextDialog: "Who will you send to negotiate?" (StatusMsgPtrs[9], a3+$00)
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; quarter index
    move.l  $8(a3), -(a7)               ; StatusMsgPtrs[11] = "In what city shall we bid?"
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player index
    jsr     (a4)                        ; ShowTextDialog: city selection prompt
    ; Set text window to full-screen (32x32) for char browser
    pea     ($0020).w                   ; window width = 32
    pea     ($0020).w                   ; window height = 32
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0019).w                   ; cursor Y = 25
    pea     ($0007).w                   ; cursor X = 7
    jsr SetTextCursor
    lea     $30(a7), a7
    ; GameCommand $1A: draw char selection panel header
    ; Args: cmd=$1A, 0, 6, $1C, $13, 2, 0, 0
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    ; GameCommand $1A: draw char header with route ID $077E
    ; $077E = char list panel tile/asset index
    pea     ($077E).w                   ; char panel asset ID
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    pea     ($0017).w                   ; cursor Y = 23
    pea     ($0002).w                   ; cursor X = 2
    jsr SetTextCursor
    pea     $12(a6)                     ; screen_id ptr (BrowseCharList output area)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player index
    jsr BrowseCharList                  ; interactive char selection; returns char index in d0
    lea     $2c(a7), a7
    move.w  d0, d4                      ; d4 = selected char index
    cmpi.w  #$ff, d0                    ; $FF = cancelled (player pressed back/exit)
    beq.w   l_283ec                     ; cancelled: jump to exit/cleanup

; --- Phase: Char Availability Check ---
    movea.l  #$00FF09D8,a0              ; char_session_blk ($FF09D8): 89 bytes, 1/char
    move.b  (a0,d4.w), d0              ; load char d4's session status byte
    andi.b  #$3, d0                    ; mask low 2 bits: 0=free, nonzero=busy
    beq.b   l_281ca                    ; char is free, proceed to negotiation

; --- Phase: Char Busy -- Offer Support Role ---
    ; char is already active in negotiations elsewhere
    pea     ($0002).w
    pea     ($0037).w                   ; $0037 = "already negotiating" UI param
    jsr GameCmd16
    addq.l  #$8, a7
    ; ShowTextDialog: "Negotiations in progress. Add support?" (StatusMsgPtrs[19..21])
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; quarter index
    move.l  $24(a3), -(a7)             ; StatusMsgPtrs[18] = "Negotiations in progress..."
l_281ba:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player index
    jsr     (a4)                        ; ShowTextDialog (support offer prompt)
    lea     $18(a7), a7
    bra.w   l_2807e                     ; restart from retry check

; --- Phase: Negotiate -- Char Available, Load Slot State ---
l_281ca:
    ; char is free: mark as active negotiator and enter main negotiation flow
    move.w  d4, d0
    ori.w   #$8000, d0                  ; set bit 15: marks char as "active negotiator"
    move.w  d0, ($00FFA6B0).l          ; FFA6B0 = active negotiation char slot (char_idx | $8000)
    jsr ShowGameScreen                  ; refresh main game screen to reflect new state
    moveq   #$1,d5                      ; set retry flag: screen reload needed after this
    jsr ResourceUnload
    ; FindRouteSlotByCharState(char_idx, player) -> d0 = slot index, -1 if none
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; char index d4
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player index d2
    jsr (FindRouteSlotByCharState,PC)
    nop
    addq.l  #$8, a7
    ext.l   d0                          ; sign-extend slot index (-1 = no slot available)
    moveq   #-$1,d1                     ; compare against -1
    cmp.l   d0, d1
    bne.w   l_283d6                     ; d0 != -1: slot found, proceed
    ; d0 == -1: no existing route slot -- fresh hire, commit to slot record
    move.b  #$1, $1(a2)                 ; a2+1 = hired flag = 1 (slot record in $FF0338)
    move.b  d4, (a2)                    ; a2+0 = char index of hired negotiator

; --- Phase: Revenue Check ---
    ; CalcRouteRevenue(player, quarter) -> d0 = revenue tier (0=low, 12+=high)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; quarter
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player
    jsr CalcRouteRevenue
    addq.l  #$8, a7
    move.w  d0, d7                      ; d7 = revenue tier
    cmpi.w  #$c, d0                     ; $C = 12: is route high-revenue? (premium threshold)
    bgt.w   l_283b4                     ; revenue > 12: skip advantage check, show rejection

; --- Phase: Char Advantage Check ---
    ; CalcCharAdvantage(char_idx, player) -> d0 = advantage score (<=0 means no advantage)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; char index
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player
    jsr CalcCharAdvantage
    addq.l  #$8, a7
    move.w  d0, d6                      ; d6 = char advantage score
    ble.w   l_28360                     ; d6 <= 0: char has no advantage, branch to city check

; --- Phase: Slot Count Picker ---
    ; Char has advantage: present slot count picker dialog
    ; ShowTextDialog: "How many slots?" (StatusMsgPtrs[13] = a3+$10)
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; quarter
    move.l  $10(a3), -(a7)             ; StatusMsgPtrs[13] = "How many slots?"
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player
    jsr     (a4)                        ; ShowTextDialog: slot count query
    ; RunSlotCountPicker(d6) -> d0 = chosen slot count (0 = cancelled)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; d6 = max available slot count
    jsr (RunSlotCountPicker,PC)
    nop
    lea     $1c(a7), a7
    move.w  d0, d6                      ; d6 = chosen slot count
    ble.w   l_2834a                     ; <= 0: player cancelled, clear slot record

; --- Phase: Confirm Negotiation Dialog ---
    ; Player chose N slots: write count, build confirm message, show yes/no dialog
    move.b  d6, $2(a2)                  ; a2+2 = negotiation slot count
    ; Build confirmation string: "Negotiations take %d months. Shall we negotiate?"
    ; sprintf(-$50(a6), StatusMsgPtrs[12], d7)
    move.w  d7, d0                      ; d7 = revenue tier (used as month count)
    ext.l   d0
    move.l  d0, -(a7)                   ; %d arg = month count
    move.l  $c(a3), -(a7)              ; StatusMsgPtrs[12] = format string with %d
    pea     -$50(a6)                    ; destination: link frame local buffer (-$50)
    jsr sprintf
    ; ShowTextDialog: formatted "shall we negotiate?" message (player/quarter context)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$50(a6)                    ; formatted message string
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)                        ; ShowTextDialog: yes/no confirm
    lea     $24(a7), a7
    cmpi.w  #$1, d0                     ; d0=1 = player confirmed
    bne.w   l_2834a                     ; not confirmed: clear and cancel

; --- Phase: Commit Negotiation (player confirmed) ---
    ; Load/display graphics for the confirmed negotiation
    pea     ($0008).w
    pea     ($000A).w
    jsr GameCmd16                       ; GameCmd16(8, 10): load negotiation result screen
    pea     ($000A).w
    pea     ($0028).w
    jsr GameCmd16                       ; GameCmd16(10, 40): display result panel
    ; GameCommand $1A: show "I will begin negotiations." panel
    ; StatusMsgPtrs[17] text with slot highlight color ($8000 = highlight flag)
    move.l  #$8000, -(a7)              ; display flag: $8000 = highlighted/confirmed style
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand                     ; draw negotiation start confirmation panel
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)              ; highlighted style
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand                     ; draw result overlay
    ; Load compressed graphics for the negotiation result animation
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0015).w                   ; $0015 = graphics slot ID for negotiation sequence
    jsr LoadCompressedGfx
    lea     $28(a7), a7
    ; ShowTextDialog: "I will begin negotiations." (StatusMsgPtrs[17] = a3+$20)
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $20(a3), -(a7)             ; StatusMsgPtrs[17] = "I will begin negotiations."
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)                        ; ShowTextDialog: final confirmation message
    lea     $18(a7), a7
    bra.w   l_283ec                     ; negotiation committed, jump to exit

; --- Phase: Cancel / Clear Slot Record ---
l_2834a:
    ; Cancelled or rejected: zero out the 8-byte slot record at a2
    pea     ($0008).w                   ; count = 8 bytes
    clr.l   -(a7)                       ; fill value = 0
    move.l  a2, -(a7)                   ; dest = a2 (negotiation slot in $FF0338)
    jsr MemFillByte                     ; zero entire slot record
    lea     $c(a7), a7
    bra.w   l_2807e                     ; restart from retry check

; --- Phase: No Advantage Path -- City Congestion Check ---
l_28360:
    ; d6 <= 0: char has no advantage for this route
    ; Zero out the slot record first
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    ; Check city congestion: compute city_data index for char d4 / player d2
    ; city_data at $FFBA80: stride 8 per city (4 entries x 2 bytes), +player*2 selects player column
    move.w  d4, d0
    lsl.w   #$3, d0                     ; d0 = char_idx * 8 (city_data stride = 8 bytes/city)
    move.w  d2, d1
    add.w   d1, d1                      ; d1 = player * 2 (word offset within city entry)
    add.w   d1, d0                      ; d0 = city_data offset for this char/player
    movea.l  #$00FFBA80,a0              ; city_data base ($FFBA80 = 89 cities x 4x2 bytes)
    tst.b   (a0,d0.w)                  ; test city_data[char_idx][player].byte0 = occupancy
    beq.b   l_2839e                     ; zero = city slot available (not congested)

; --- Phase: City Congested -- show "already negotiating here" message ---
    ; ShowTextDialog: "We already have someone in this city negotiating."
    ; (StatusMsgPtrs[16] = a3+$1C)
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $14(a3), -(a7)             ; StatusMsgPtrs[14] = "max slots" / "city congested"
    bra.w   l_281ba                    ; -> ShowTextDialog then retry

; --- Phase: City Available -- show "can't negotiate due to war" check ---
l_2839e:
    ; City slot is free but another condition blocks (war flag in city_data)
    ; ShowTextDialog: "We can't negotiate with this city due to the war." (StatusMsgPtrs[18])
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $18(a3), -(a7)             ; StatusMsgPtrs[15] = "It doesn't look promising."
    bra.w   l_281ba                    ; -> ShowTextDialog then retry

; --- Phase: High Revenue Route -- Cannot Negotiate ---
l_283b4:
    ; Revenue tier > 12: route is premium, negotiation not available
    ; ShowTextDialog: "It doesn't look promising." (StatusMsgPtrs[15] = a3+$18)
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $18(a3), -(a7)             ; StatusMsgPtrs[15] = "It doesn't look promising."
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)                        ; ShowTextDialog: rejection message
    lea     $18(a7), a7
    bra.w   l_2834a                    ; -> cancel/clear slot

; --- Phase: Slot Already Taken ---
l_283d6:
    ; FindRouteSlotByCharState returned a valid slot: char is already assigned
    ; ShowTextDialog: "Our company already has the maximum number of slots." (StatusMsgPtrs[14])
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $1c(a3), -(a7)             ; StatusMsgPtrs[16] = "already negotiating in city"
    bra.w   l_281ba                    ; -> ShowTextDialog then retry

; --- Phase: Exit / Final Screen Restore ---
l_283ec:
    cmpi.w  #$1, d5                    ; was a negotiation committed (d5==1)?
    bne.b   l_2842a                    ; no: skip screen reload
    ; Restore relation panel display after committing a negotiation
    jsr ResourceLoad
    jsr PreLoopInit                    ; reset main loop display state
    pea     ($0001).w
    move.w  (a5), d0                   ; screen_id
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0                     ; player index
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel                   ; redisplay relation panel with updated state
l_2842a:
    move.w  (a5), d0                   ; return value = screen_id word
    movem.l -$78(a6), d2-d7/a2-a5
    unlk    a6
    rts
