; ============================================================================
; RunScenarioMenu -- Runs the scenario selection menu loop: reads scenario state from $FF0A32, computes airline scores and prices, renders screen with char portrait and info panel, handles input to browse/select/confirm a scenario, writes chosen scenario back to $FF0A32
; Called: ?? times.
; 1254 bytes | $02C2FA-$02C7DF
;
; Frame state (link frame -$108, used registers):
;   a4 = -$84(a6) -- local working buffer (char portrait / price display)
;   a5 = $0004_83F0 -- ROM pointer table base (scenario display strings)
;   d3 = current player index (0-3)
;   d4 = scenario_word (low byte = stat_type index, high byte = display variant)
;   d2 = field_offset (byte offset into char_stat record, from char_stat_tab)
;   d5 = price_result (capped airline score from local calc)
;   d6 = display variant / menu row index (high byte of $FF0A32)
;   d7 = aircraft_category (from RangeLookup)
;   -$0002(a6) = char_stat_value (from GetCharStat)
; ============================================================================
RunScenarioMenu:                                                  ; $02C2FA
    link    a6,#-$108                                  ; -$108 bytes of locals: working buffer at -$84(a6) etc.
    movem.l d2-d7/a2-a5,-(sp)
    lea     -$0084(a6),a4                              ; a4 = local display buffer (char portrait area)
    movea.l #$000483f0,a5                              ; a5 = ROM ptr table $0004_83F0 (scenario string ptrs)

; --- Phase: Early-exit checks -- handle terminal state values in session_word_a32 ---
    cmpi.w  #$fffe,($00FF0A32).l                       ; $FFFE = "menu just exited" sentinel
    bne.b   .l2c320                                    ; not $FFFE: proceed to normal check
    dc.w    $4eba,$05b8                                 ; jsr $02C8D0  ; RunScenarioMenuReset (tear-down display)
    nop
    dc.w    $6000,$04b8                                 ; bra.w $02C7D6 ; return immediately
.l2c320:                                                ; $02C320
    cmpi.w  #$ffff,($00FF0A32).l                       ; $FFFF = "menu not yet started" sentinel
    dc.w    $6700,$04ac                                 ; beq.w $02C7D6 ; return immediately (uninitialized)

; --- Phase: Load player context -- player record and scenario stat descriptor ---
    moveq   #$0,d3
    move.b  ($00FF0016).l,d3                           ; d3 = current_player (0-3)
    move.w  d3,d0
    mulu.w  #$24,d0                                    ; offset = player * $24 (36 bytes/player record)
    movea.l #$00ff0018,a0                              ; player_records base
    lea     (a0,d0.w),a0
    movea.l a0,a2                                      ; a2 -> current player record (used for active_flag check)

; unpack scenario_word from $FF0A32:
;   low byte  = stat_type index (scenario/city index 0-88)
;   high byte = display variant / menu selection row
    move.w  ($00FF0A32).l,d4                           ; d4 = session_word_a32 (packed scenario state word)
    andi.w  #$ff,d4                                    ; d4 = stat_type index (low byte = scenario index)

; look up field offset for this stat type in char_stat_tab descriptor table
    move.w  d4,d0
    lsl.w   #$2,d0                                     ; stat_type * 4 (4 bytes per descriptor entry)
    movea.l #$00ff1298,a0                              ; char_stat_tab ($FF1298): 89 × 4-byte descriptors
    move.b  (a0,d0.w),d2                               ; d2 = field_offset = descriptor byte[0] (0..$38 within stat record)
    andi.l  #$ff,d2                                    ; zero-extend

; --- Phase: Compute airline scores -- 2D price simulation using char stat + aircraft data ---
; Call local helper $02C994 to compute a score from the field offset
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0628                                 ; jsr $02C994  ; CalcScenarioScore(field_offset) -> d0 = raw score
    nop
    move.w  d0,d5                                      ; d5 = raw airline score

; resolve aircraft category from stat_type via RangeLookup
    move.w  d4,d0                                      ; stat_type index (scenario/city index)
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648  ; RangeLookup(stat_type) -> d0 = aircraft_category
    move.w  d0,d7                                      ; d7 = aircraft_category (result from CharTypeRangeTable scan)

; extract display variant from high byte of session_word
    moveq   #$0,d6
    move.w  ($00FF0A32).l,d6
    asr.l   #$8,d6                                     ; d6 = high byte of session_word (display variant / menu row)
    andi.w  #$ff,d6                                    ; zero-extend

; read the char's stat value for this scenario slot via GetCharStat(player, stat_type)
    move.w  d4,d0                                      ; stat_type
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0                                      ; player index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9d92                           ; jsr $009D92  ; GetCharStat(player, stat_type) -> d0 = stat byte
    lea     $0010(sp),sp
    move.w  d0,-$0002(a6)                              ; save char stat value in link frame

; --- Phase: Compute display price -- cap score at 6, apply RNG-seeded formula ---
; Capped formula: d5 = min(d5, 6) -> "max airline score for display" = 6
    cmpi.w  #$6,d5
    ble.b   .l2c3b4                                    ; score <= 6: use as-is
    move.w  d5,d0
    ext.l   d0
    bra.b   .l2c3b6
.l2c3b4:                                                ; $02C3B4
    moveq   #$6,d0                                     ; clamp to maximum of 6
.l2c3b6:                                                ; $02C3B6
    move.w  d0,d5                                      ; d5 = capped score (0-6)

; compute price: base = frame_counter >> 4, add $1F4 (500); uses RNG-like formula
    move.w  ($00FF0006).l,d0                           ; frame_counter (signed word)
    ext.l   d0
    bge.b   .l2c3c6                                    ; non-negative: use directly
    moveq   #$f,d1
    add.l   d1,d0                                      ; bias up by $F to round toward zero for negative values
.l2c3c6:                                                ; $02C3C6
    asr.l   #$4,d0                                     ; d0 = frame_counter / 16 (arithmetic shift right)
    moveq   #$64,d1                                    ; d1 = $64 = 100 (multiplier / modulus)
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C  ; Modulo32(d0, 100) -> d0 = frame_counter/16 mod 100
    addi.l  #$01f4,d0                                  ; d0 += $1F4 (500); base price component

; second term: (char_stat_value + aircraft_category) mod 100 + $7D0 (2000)
    move.w  d5,d1
    ext.l   d1                                         ; d1 = capped score
    movea.l d7,a0                                      ; a0 = aircraft_category (long saved in a0)
    move.w  -$0002(a6),d7                              ; d7 = char_stat_value (from GetCharStat)
    ext.l   d7
    exg     d7,a0                                      ; swap: d7 = aircraft_category, a0 = char_stat_value
    add.l   a0,d1                                      ; d1 = capped_score + char_stat_value
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C  ; Modulo32(d1, 100) -> d0 = (score+stat) mod 100
    addi.l  #$07d0,d0                                  ; d0 += $7D0 (2000); final display price
    move.l  d0,d5                                      ; d5 = computed display price (in game currency units)

; --- Phase: Check player active flag -- only render if player is active ---
    cmpi.b  #$01,(a2)                                  ; player_record.active_flag == 1?
    dc.w    $6600,$031e                                 ; bne.w $02C718  ; inactive player: skip to input handler

; --- Phase: Render char portrait -- load portrait graphic and draw info panel ---
; select portrait graphic: if field_offset==0 use default, else use char-type specific
    tst.w   d2                                         ; d2 = field_offset (0 = no stat, else stat type)
    bne.b   .l2c40e                                    ; non-zero field: select typed portrait
    move.l  ($0005EB2C).l,-(sp)                        ; CountryRoutePtrs[0] = default route type string ptr
    pea     ($00042F34).l                              ; ptr to default portrait/dialog string in GameStatusText
    bra.b   .l2c422
.l2c40e:                                               ; $02C40E
; field_offset > 0: look up char-type specific portrait string
    move.w  d2,d0
    lsl.w   #$2,d0                                     ; field_offset * 4 (longword ptr table index)
    movea.l #$0005eb2c,a0                              ; CountryRoutePtrs ($05EB2C): char/route type string ptrs
    move.l  (a0,d0.w),-(sp)                            ; push ptr to route type name string for this char
    move.l  ($0004842C).l,-(sp)                        ; ptr to secondary portrait descriptor string
.l2c422:                                               ; $02C422
    move.l  a4,-(sp)                                   ; arg: local display buffer (portrait area)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C  ; RenderCharPortrait(a4, str1, str2)
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C  ; sync/vblank wait
    dc.w    $4eb9,$0000,$814a                           ; jsr $00814A  ; clear/prepare info panel

; finalize revenue display for this player/screen
    pea     ($0001).w
    move.w  d7,d0                                      ; aircraft_category
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0                                      ; player index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E  ; FinalizeRevenue(player, aircraft_cat, 1)

; draw char info panel (stat display)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9f4a                           ; jsr $009F4A  ; DrawCharInfoPanel(aircraft_cat) -- renders stat bar

    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748  ; VBlank sync

; present scenario description text dialog
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a4,-(sp)                                   ; arg: display buffer
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912  ; ShowScenarioDialog(player, a4, 0, 0, 1)
    lea     $0030(sp),sp

; --- Phase: Menu row rendering -- dispatch on display variant (d6) ---
; d6 = display variant (from high byte of $FF0A32):
;   0-3: active scenario slots -- render "from/to" route string pair
;   4+:  extended slot range -- jump table dispatch to cases 4-7
    cmpi.w  #$4,d6
    bge.b   .l2c4c8                                    ; d6 >= 4: use jump table for extended cases

; --- d6 in 0-3: render route display line for this scenario slot ---
    move.w  d2,d0
    lsl.w   #$2,d0                                     ; field_offset * 4
    movea.l #$0005eb2c,a0                              ; CountryRoutePtrs ($05EB2C)
    move.l  (a0,d0.w),-(sp)                            ; route type name string (from/city A)
    move.w  d6,d0
    ext.l   d0
    lsl.l   #$2,d0                                     ; variant * 4 (longword ptr index)
    movea.l d0,a0
    move.l  (a5,a0.l),-(sp)                            ; a5+variant*4 = scenario display string ptr (ROM table $0004_83F0)
    move.l  a4,-(sp)                                   ; display buffer
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C  ; RenderRouteDisplay(a4, scenario_str, route_type_str)

; render price/score panel line below the portrait
    move.w  d6,d0
    lsl.w   #$2,d0
    movea.l #$000483e0,a0                              ; secondary scenario string ptr table ($0004_83E0)
    move.l  (a0,d0.w),-(sp)                            ; secondary label string (price row label)
    move.l  $0010(a5),-(sp)                            ; a5+$10 = separator/spacer string from ptr table
    pea     -$0106(a6)                                 ; local price text buffer at -$106(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C  ; RenderPricePanel(-$106(a6), sep, label)
    lea     $0018(sp),sp
    lea     -$0106(a6),a3                              ; a3 -> formatted price text (used by input handler below)
    dc.w    $6000,$00b0                                 ; bra.w $02C576 ; jump to input handler
.l2c4c8:                                               ; $02C4C8
; --- d6 in 4-7: extended display cases, dispatched via PC-relative jump table ---
    move.w  d6,d0
    ext.l   d0
    subq.l  #$4,d0                                     ; normalize: case 4->0, 5->1, 6->2, 7->3
    moveq   #$3,d1
    cmp.l   d1,d0
    dc.w    $6200,$0096                                 ; bhi.w $02C56A  ; out of range (d6 > 7): skip
; PC-relative jump table dispatch: table at $02C4E0 (4 entries × word offset)
    add.l   d0,d0                                      ; * 2 (word offsets in jump table)
    move.w  $2c4e0(pc,d0.l),d0                         ; load signed offset from jump table
    jmp     $2c4e0(pc,d0.w)                            ; jump to case handler (PC = $02C4E0 base)
    ; WARNING: 768 undecoded trailing bytes at $02C4E0
    ; Jump table at $02C4E0 (4 word entries, offsets from $02C4E0):
    ;   [0] = $0008  -> case 4: d6==4 handler
    ;   [1] = $002A  -> case 5: d6==5 handler
    ;   [2] = $004A  -> case 6: d6==6 handler
    ;   [3] = $005E  -> case 7: d6==7 handler
    ; Remaining dc.w block is the untranslated bodies of cases 4-7 and the input loop ($02C576-$02C7DF).
    dc.w    $0008
    dc.w    $002a
    dc.w    $004a
    dc.w    $005e
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $3004
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $e680
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f2d
    dc.w    $0014
    dc.w    $6054
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f2d
    dc.w    $001c
    dc.w    $2f0c
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b22c
    dc.w    $4fef
    dc.w    $000c
    dc.w    $6040
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f2d
    dc.w    $0024
    dc.w    $60de
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $3004
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $e680
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f2d
    dc.w    $002c
    dc.w    $2f0c
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b22c
    dc.w    $4fef
    dc.w    $0010
    dc.w    $3006
    dc.w    $48c0
    dc.w    $e788
    dc.w    $2040
    dc.w    $2675
    dc.w    $88f8
    dc.w    $42a7
    dc.w    $2f0c
    dc.w    $3004
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $025e
    dc.w    $4e71
    dc.w    $4878
    dc.w    $0020
    dc.w    $4878
    dc.w    $0020
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $a942
    dc.w    $4878
    dc.w    $000f
    dc.w    $4878
    dc.w    $0001
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $ab2c
    dc.w    $2f05
    dc.w    $4879
    dc.w    $0004
    dc.w    $2f20
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b270
    dc.w    $4fef
    dc.w    $002c
    dc.w    $42a7
    dc.w    $2f0b
    dc.w    $3004
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $021c
    dc.w    $4e71
    dc.w    $4878
    dc.w    $0020
    dc.w    $4878
    dc.w    $0020
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $a942
    dc.w    $4878
    dc.w    $0019
    dc.w    $4878
    dc.w    $0013
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $ab2c
    dc.w    $3003
    dc.w    $c0fc
    dc.w    $0024
    dc.w    $207c
    dc.w    $00ff
    dc.w    $001e
    dc.w    $2f30
    dc.w    $0000
    dc.w    $4879
    dc.w    $0004
    dc.w    $2f1a
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b270
    dc.w    $4fef
    dc.w    $002c
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $2f39
    dc.w    $0004
    dc.w    $8430
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $7912
    dc.w    $4fef
    dc.w    $0014
    dc.w    $0c40
    dc.w    $0001
    dc.w    $6600
    dc.w    $00ae
    dc.w    $baaa
    dc.w    $0006
    dc.w    $6e00
    dc.w    $0088
    dc.w    $33fc
    dc.w    $ffff
    dc.w    $00ff
    dc.w    $0a32
    dc.w    $9baa
    dc.w    $0006
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f39
    dc.w    $0004
    dc.w    $8434
    dc.w    $2f0c
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b22c
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $2f0c
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $7912
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f2d
    dc.w    $0034
    dc.w    $2f0c
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b22c
    dc.w    $4fef
    dc.w    $002c
    dc.w    $42a7
    dc.w    $2f0c
    dc.w    $3004
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0140
    dc.w    $4e71
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $02ca
    dc.w    $4e71
    dc.w    $4fef
    dc.w    $0014
    dc.w    $6034
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $2f39
    dc.w    $0004
    dc.w    $8438
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $7912
    dc.w    $4fef
    dc.w    $0014
    dc.w    $42a7
    dc.w    $2f2d
    dc.w    $0038
    dc.w    $3004
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $00f8
    dc.w    $4e71
    dc.w    $4fef
    dc.w    $000c
    dc.w    $4878
    dc.w    $0040
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0010
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $0d64
    dc.w    $4fef
    dc.w    $000c
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $814a
    dc.w    $4878
    dc.w    $0007
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $9f4a
    dc.w    $6000
    dc.w    $00c0
    dc.w    $4246
    dc.w    $2005
    dc.w    $0680
    dc.w    $0000
    dc.w    $2710
    dc.w    $b0aa
    dc.w    $0006
    dc.w    $6c3c
    dc.w    $3004
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $9d92
    dc.w    $508f
    dc.w    $0c40
    dc.w    $0001
    dc.w    $6f22
    dc.w    $33fc
    dc.w    $ffff
    dc.w    $00ff
    dc.w    $0a32
    dc.w    $9baa
    dc.w    $0006
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0220
    dc.w    $4e71
    dc.w    $508f
    dc.w    $7c01
    dc.w    $4878
    dc.w    $0008
    dc.w    $4878
    dc.w    $001c
    dc.w    $4878
    dc.w    $0011
    dc.w    $4878
    dc.w    $0002
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $5a04
    dc.w    $0c46
    dc.w    $0001
    dc.w    $6624
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $3003
    dc.w    $e948
    dc.w    $207c
    dc.w    $00ff
    dc.w    $00a8
    dc.w    $4870
    dc.w    $0000
    dc.w    $4879
    dc.w    $0004
    dc.w    $2f00
    dc.w    $6022
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $3003
    dc.w    $e948
    dc.w    $207c
    dc.w    $00ff
    dc.w    $00a8
    dc.w    $4870
    dc.w    $0000
    dc.w    $4879
    dc.w    $0004
    dc.w    $2ede
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b270
    dc.w    $4878
    dc.w    $001e
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $e2f4
    dc.w    $4cee
    dc.w    $3cfc
    dc.w    $fed0
    dc.w    $4e5e
    dc.w    $4e75
; === Translated block $02C7E0-$02C9C8 ===
; 4 functions, 488 bytes
