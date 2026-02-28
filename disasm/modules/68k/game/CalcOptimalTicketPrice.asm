; ============================================================================
; CalcOptimalTicketPrice -- Compute optimal ticket price from char stats and player cash, show purchase dialog, deduct cost if confirmed
; 1046 bytes | $00F75E-$00FB73
; ============================================================================
; --- Phase: Setup ---
; Args: $8(a6)=d2=player_index, $C(a6)=d6=char_slot_index, $10(a6)=d5=dialog_mode
; a4 = -$40(a6): 64-byte stack scratch buffer for formatted strings
; a5 = PrintfWide ($03B270) -- 2-tile wide font formatter
; -$82(a6) = purchase_occurred flag (0 = no, 1 = purchased)
CalcOptimalTicketPrice:
    link    a6,#-$84
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.l  $10(a6), d5
    move.l  $c(a6), d6
    lea     -$40(a6), a4
; a5 = PrintfWide ($03B270) -- format + display string using 2-tile wide font
    movea.l  #$0003B270,a5
; -$82(a6) = purchase_occurred: cleared at entry, set to 1 if player confirms purchase
    clr.w   -$82(a6)
; --- Phase: Locate player record ---
; player_record base = $FF0018 + player_index * $24 (36 bytes per player)
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
; a2 = player record pointer (DATA_STRUCTURES.md: player_records at $FF0018, stride $24)
    movea.l a0, a2
; --- Phase: Find character stat entry ---
; FindBitInField: locate bit for char_slot d6 in player d2's bitfield at $FFA6A0
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
; d3 = stat_type index (0-88, identifies the character's type in char_stat_tab)
    move.w  d0, d3
; Look up char_stat_tab descriptor at $FF1298 + stat_type*4 (4 bytes per entry)
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
; a3 = descriptor for this character type: [+0]=field_offset, [+1]=rating, [+2]=param, [+3]=cap
    movea.l a0, a3
; GetCharStat: fetch the character's primary skill byte from per-player stat record
; ($FF05C4 + player*$39 + descriptor[+0]); result = current skill value 0-255
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr GetCharStat
; d4 = character's primary skill stat (0-255)
    move.w  d0, d4
; --- Phase: Compute suggested market price (d7) ---
; Formula part 1: base_factor = (descriptor[+3] + $14) * (skill + 1)
; descriptor[+3] = cap/limit byte; $14=20 added as minimum base
    moveq   #$0,d7
    move.b  $3(a3), d7
    addi.w  #$14, d7
    move.w  d4, d0
    addq.w  #$1, d0
    mulu.w  d0, d7
; Part 2: time_offset = frame_counter / 3 + $1E
; frame_counter ($FF0006) adds temporal variation (randomness tied to game clock)
; $3 = divide by 3 to reduce rapid oscillation; $1E=30 = minimum variance offset
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv
    addi.l  #$1e, d0
; Part 3: d7 = base_factor * time_offset / $64
; $64=100: normalize to percentage (d7 is now the suggested market price in game currency units)
    moveq   #$0,d1
    move.w  d7, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
; d7 = suggested market price
    move.w  d0, d7
; --- Phase: Compute optimal ticket cost (d4) ---
; Formula: base = (descriptor[+3]*30 - descriptor[+3]) * 2 + $258
; = descriptor[+3] * (16-1) * 2 + 600 = descriptor[+3]*30 + 600 (approximately)
; $258 = 600: minimum base cost; scales with stat cap to reflect route class
    moveq   #$0,d0
    move.b  $3(a3), d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$4, d0
    sub.l   d1, d0
    add.l   d0, d0
    addi.l  #$258, d0
; Multiply by (skill + 1): higher skill = more expensive optimal price
    move.w  d4, d1
    ext.l   d1
    addq.l  #$1, d1
    jsr Multiply32
; Bias result: if negative (overflow), add 1 before arithmetic right-shift
    tst.l   d0
    bge.b   l_0f82a
    addq.l  #$1, d0
l_0f82a:
; Halve the result (arithmetic right shift by 1 = divide by 2, rounding toward zero)
    asr.l   #$1, d0
; d4 = optimal ticket price
    move.w  d0, d4
; --- Phase: Load screen and display character info ---
; ResourceLoad: load graphics resource set for this screen
    jsr ResourceLoad
; LoadScreen: initialize screen layout for player d2, slot d6
    pea     ($0001).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
; SetTextWindow: full-screen text area (left=0, top=0, width=$20=32, height=$20=32)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
; PlaceCharSprite: LZ decompress and place character portrait sprite
; at row=$18, col=$70, width=$37, height=$0640, palette 1, for character d3
    pea     ($0001).w
    pea     ($0640).w
    pea     ($0037).w
    pea     ($0070).w
    pea     ($0018).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCharSprite
; SetTextCursor + PrintfWide: display character title/label at col=$0B, row=$03
    pea     ($0003).w
    pea     ($000B).w
    jsr SetTextCursor
; Format string at $3EBB4 = character panel header label
    pea     ($0003EBB4).l
    jsr     (a5)
; Move cursor to col=$06, row=$0E: character name display area
    pea     ($000E).w
    pea     ($0006).w
    jsr SetTextCursor
    lea     $2c(a7), a7
; $5E680 = character name pointer table (indexed by stat_type * 4)
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
; PrintfWide: display character name from pointer table
    move.l  (a0,d0.w), -(a7)
    pea     ($0003EBB0).l
    jsr     (a5)
; Move cursor to col=$02, row=$06: skill label row
    pea     ($0006).w
    pea     ($0002).w
    jsr SetTextCursor
; Format string $3EB9C = stat/skill label text
    pea     ($0003EB9C).l
    jsr     (a5)
; Move cursor to col=$17, row=$06: market price value display position
    pea     ($0006).w
    pea     ($0017).w
    jsr SetTextCursor
; PrintfWide: display suggested market price (d7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($0003EB96).l
    jsr     (a5)
; Move cursor to col=$02, row=$09: cost label row
    pea     ($0009).w
    pea     ($0002).w
    jsr SetTextCursor
; Format string $3EB82 = "optimal price:" label
    pea     ($0003EB82).l
    jsr     (a5)
    lea     $30(a7), a7
; Move cursor to col=$17, row=$09: optimal price value display position
    pea     ($0009).w
    pea     ($0017).w
    jsr SetTextCursor
; PrintfWide: display optimal ticket price (d4)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($0003EB7C).l
    jsr     (a5)
; --- Phase: Build confirm-dialog string ---
; MemFillByte: zero the 64-byte string buffer at a4 (stack scratch area)
    pea     ($0040).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
; sprintf: format character type code into string buffer a4 using format at $477BC
    move.l  ($000477BC).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
; sprintf: format character name into secondary buffer -$80(a6) using format at $477C0
; and character name from $5E680 pointer table
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477C0).l, -(a7)
    pea     -$80(a6)
    jsr sprintf
    lea     $30(a7), a7
; StringAppend: concatenate name string (-$80(a6)) onto the type string (a4)
; Result in a4 = "CharType: CharName" for the purchase dialog
    pea     -$80(a6)
    move.l  a4, -(a7)
    jsr StringAppend
; ResourceUnload: release graphics set before showing dialog
    jsr ResourceUnload
; --- Phase: Show first purchase-offer dialog ---
; ShowTextDialog: display offer with player d2, dialog_mode d5, message string a4
; Dialog #1: initial offer -- "Purchase this character?" with the built string
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $20(a7), a7
; --- Phase: Check hire eligibility ---
; $FF09D8 = char_session_blk: check session byte for this character (indexed by stat_type)
; Low 2 bits nonzero = character not available (already hired or ineligible)
    movea.l  #$00FF09D8,a0
    move.b  (a0,d3.w), d0
    andi.l  #$3, d0
; If bits 0-1 set: character ineligible -- jump to "not available" dialog path
    bne.w   l_0fb44
; Check if player can afford optimal price: compare d4 vs player_record+$06 (cash field)
    moveq   #$0,d0
    move.w  d4, d0
; player_record +$06 = cash/treasury longword (DATA_STRUCTURES.md)
    cmp.l   $6(a2), d0
; If d4 > cash: player can't afford it -- jump to "insufficient funds" dialog
    bgt.w   l_0fb2c
; --- Phase: Confirmation dialog ---
; PreLoopInit: reset input/display state before confirmation sequence
    jsr PreLoopInit
; $FFA6B0 = display parameter (character index for ShowGameScreen)
    move.w  d3, d0
    ext.l   d0
    move.w  d0, ($00FFA6B0).l
; ShowGameScreen: render full character info screen (portrait + stats)
    jsr ShowGameScreen
    jsr ResourceUnload
; Build confirmation message using sprintf with format at $477C8 and character name
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477C8).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
; ShowTextDialog: confirmation dialog ("Confirm purchase?")
; Player d2, option_mode=$01, dialog_mode=$0 (yes/no choice)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $24(a7), a7
; If player chose "No" (d0 != 1): skip deduction, go to reload screen
    cmpi.w  #$1, d0
    bne.w   l_0faee
; --- Phase: Process confirmed purchase ---
; Set purchase_occurred flag
    move.w  #$1, -$82(a6)
; Deduct optimal price from player cash: player_record+$06 -= d4
    moveq   #$0,d0
    move.w  d4, d0
; player_record +$06 = cash (longword); subtract ticket cost
    sub.l   d0, $6(a2)
; --- Record hire in $FF0338 table ---
; $FF0338 = per-player character assignment block (stride $20 per player, $08 per slot)
; index = player*$20 + slot*$08
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
; Write character's stat_type index to assignment slot byte 0
    move.b  d3, (a2)
; Write status $03 to assignment slot byte 1 (status = hired/active)
    move.b  #$3, $1(a2)
; GameCmd16 calls: update sprite layers for character slot assignment display
    pea     ($0001).w
    clr.l   -(a7)
    jsr GameCmd16
    pea     ($000A).w
    pea     ($000A).w
    jsr GameCmd16
    pea     ($000A).w
    pea     ($0028).w
    jsr GameCmd16
    lea     $18(a7), a7
; GameCommand #$1A: clear two text areas (old stat/info regions) after hiring
; First: width=$0A, height=$20, col=$05, row=0, priority $8000
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
; Second: same dimensions, col=$05, row=1 (clear below first area)
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
; LoadCompressedGfx: reload compressed graphics index $16, width=$0A, height=$05
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0016).w
    jsr LoadCompressedGfx
    lea     $28(a7), a7
; ShowTextDialog: "success" confirmation message after purchase
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000477D0).l, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
; --- Phase: Reload relation screen ---
l_0faee:
    jsr ResourceLoad
    jsr PreLoopInit
; LoadScreen: reload base screen for player d2, slot d6
    pea     ($0001).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
; ShowRelPanel: display character relationship panel for slot d6 of player d2
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $18(a7), a7
    bra.b   l_0fb66
; --- Phase: "Insufficient funds" dialog ---
; ShowTextDialog: player cannot afford this character
l_0fb2c:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
; Format string at $477C4 = "insufficient funds" message
    move.l  ($000477C4).l, -(a7)
    bra.b   l_0fb5a
; --- Phase: "Not available" dialog ---
; Character already hired or ineligible (char_session_blk byte low bits != 0)
l_0fb44:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
; Format string at $477CC = "not available" / "already hired" message
    move.l  ($000477CC).l, -(a7)
; Shared ShowTextDialog call for both error paths (funds / eligibility)
l_0fb5a:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
; --- Phase: Exit ---
; Return purchase_occurred flag (-$82(a6)) to caller
l_0fb66:
    move.w  -$82(a6), d0
    movem.l -$ac(a6), d2-d7/a2-a5
    unlk    a6
    rts
