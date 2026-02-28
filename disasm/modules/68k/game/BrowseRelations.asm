; ============================================================================
; BrowseRelations -- Collects up to 4 partner pointers, shows the relation panel, and runs a page-navigation loop calling FormatRelationStats for each visible partner
; ============================================================================
; Arguments: 8(a6) = char_index (d2), $C(a6) = player_index (d4), $10(a6) = partner_type (d6)
; A2 = GameCommand entry ($0D64)
; A3 = $FF13FC (input_mode_flag word): used to trigger countdown-mode input gating
; A4 = -$12(a6): frame counter word (animation tick)
; A5 = -$10(a6): partner pointer array base (4 × longword = 16 bytes: partner_ptrs[0..3])
; d3 = current displayed partner index (0-3)
; d5 = sub-display column/mode flag (1 = first display, 0 = subsequent)
; d7 = has_any_partner flag: 1 if at least one valid FindRelationRecord result found
BrowseRelations:                                                  ; $018F8E
    link    a6,#-$14
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d2        ; d2 = char_index (which character we are showing relations for)
    move.l  $000c(a6),d4        ; d4 = player_index (0-3: current player context)
    move.l  $0010(a6),d6        ; d6 = partner_type filter (which partner types to search)
    movea.l #$0d64,a2           ; a2 = GameCommand entry point
    movea.l #$00ff13fc,a3       ; a3 = input_mode_flag ($FF13FC): nonzero = countdown input active
    lea     -$0012(a6),a4       ; a4 = animation frame counter (word on frame)
    lea     -$0010(a6),a5       ; a5 = partner_ptrs[0] (4 longwords: pointers to relation records)
    clr.w   d7                  ; d7 = has_any_partner (0 until a partner is found)
    moveq   #$1,d5              ; d5 = first_display flag (1 = initial render, cleared after first)
    clr.w   d3                  ; d3 = partner slot index (0-3)
; --- Phase: Collect partner pointers via FindRelationRecord ---
; FindRelationRecord ($0081D2): searches $FF9A20 relation table for an entry matching
; (partner_slot, player_index, partner_type). Returns relation record pointer or NULL.
.l18fbc:                                                ; $018FBC
    move.w  d6,d0               ; partner_type filter
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0               ; player_index
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0               ; partner slot 0-3
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$81d2                           ; jsr FindRelationRecord ($0081D2)
    lea     $000c(sp),sp
; Store result pointer into partner_ptrs[d3] (longword array at a5, stride 4)
    move.w  d3,d1
    ext.l   d1
    lsl.l   #$2,d1              ; d1 = d3 * 4 (longword index)
    movea.l d1,a0
    move.l  d0,(a5,a0.l)        ; partner_ptrs[d3] = result (NULL = 0 if no match)
    beq.b   .l18fe8             ; NULL: no partner found for this slot
    moveq   #$1,d7              ; at least one partner found -- set has_any_partner flag
.l18fe8:                                                ; $018FE8
    addq.w  #$1,d3              ; next partner slot
    cmpi.w  #$4,d3              ; checked all 4 slots?
    blt.b   .l18fbc
; --- Phase: Check if any partners found -- exit if none ---
    cmpi.w  #$1,d7              ; has_any_partner == 1?
    bne.w   .l1923a             ; no partners at all -- return immediately
; --- Phase: Setup display panel ---
; Clear the relation panel area and stamp the panel background tiles
; GameCommand #$1A: clear box at (col=$00, row=$13, w=$20, h=$0C)
    clr.l   -(sp)
    pea     ($000C).w           ; height = $0C = 12 rows
    pea     ($0020).w           ; width  = $20 = 32 columns
    pea     ($0013).w           ; top row = $13 = 19
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w           ; GameCommand #$1A = clear/DrawBox
    jsr     (a2)
    lea     $001c(sp),sp
; GameCommand #$1A: draw relation panel frame (tile=$077D, priority=1)
; $077D = relation panel border tile
    pea     ($077D).w           ; panel border tile
    pea     ($000C).w           ; height = 12
    pea     ($0020).w           ; width  = 32
    pea     ($0013).w           ; top row = 19
    clr.l   -(sp)
    pea     ($0001).w           ; priority = 1
    pea     ($001A).w           ; GameCommand #$1A
    jsr     (a2)
; GameCommand #$16 (GameCmd16 wrapper): clear sprite layer #$37, mode 8
    pea     ($0008).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr GameCmd16 ($01E0B8)
; d3 = $FF signals "no current partner displayed yet" (first-display state)
    move.w  #$ff,d3
    bra.b   .l19054
; --- Phase: Advance to next non-null partner (wrap via SignedMod mod 4) ---
; If partner_ptrs[d2] is NULL, keep incrementing d2 until we find a valid slot
.l19044:                                                ; $019044
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0              ; d0 = d2 + 1
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr SignedMod ($03E146): d0 = (d2+1) mod 4
    move.w  d0,d2               ; d2 = next candidate partner index (wraps 0-3)
.l19054:                                                ; $019054
; Check partner_ptrs[d2] is non-NULL (i.e. a valid relation record exists for slot d2)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0              ; d0 = d2 * 4 (longword offset)
    movea.l d0,a0
    tst.l   (a5,a0.l)           ; partner_ptrs[d2] == NULL?
    beq.b   .l19044             ; NULL: try next slot
; Found a valid slot at d2. Read input to detect dual-player vs. single-player mode:
; ReadInput mode 0 returns: d0 nonzero if second player is also active (2P mode)
    clr.l   -(sp)               ; mode = 0 (normal read)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr ReadInput ($01E1EC)
    lea     $0028(sp),sp
    tst.w   d0
    beq.b   .l19076
    moveq   #$1,d4              ; d4 = 1: two-player mode active
    bra.b   .l19078
.l19076:                                                ; $019076
    moveq   #$0,d4              ; d4 = 0: single-player mode
; --- Phase: Initialise navigation state ---
.l19078:                                                ; $019078
    clr.w   d6                  ; d6 = input accumulator (last processed input bits)
    clr.w   (a3)                ; input_mode_flag ($FF13FC) = 0: no countdown mode active
    clr.w   ($00FFA7D8).l       ; input_init_flag ($FFA7D8) = 0: reset input state machine
    clr.w   (a4)                ; animation frame counter = 0
; --- Phase: Main display/input loop ---
; Check if d2 (target partner to display) != d3 (currently displayed partner)
.l19084:                                                ; $019084
    cmp.w   d2,d3               ; is new target same as currently displayed?
    beq.b   .l190b8             ; same: skip redraw
; Different partner selected -- render relation stats for partner d2
; FormatRelationStats ($019660): formats and prints relation stats for a partner
; Args: partner_ptr (longword), d2 (partner_index), player_index (d4→push), d5 (sub-column), mode=1
    pea     ($0001).w           ; display_mode = 1 (full stats render)
    move.w  d5,d0               ; sub-column/layout flag
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0013).w           ; row base = $13 (relation panel area)
    clr.l   -(sp)               ; reserved / padding
    move.w  d2,d0               ; partner_index
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0              ; d0 = d2 * 4 (longword index)
    movea.l d0,a0
    move.l  (a5,a0.l),-(sp)    ; partner_ptr = partner_ptrs[d2]
    dc.w    $4eba,$05b4                                 ; jsr FormatRelationStats ($019660)
    nop
    lea     $0018(sp),sp
    move.w  d2,d3               ; update currently-displayed partner (d3 = d2)
    clr.w   d5                  ; d5 = 0: subsequent renders (not first)
; --- Phase: Check for 2-player input ---
.l190b8:                                                ; $0190B8
    tst.w   d4                  ; 2-player mode?
    beq.b   .l190d8             ; single-player: skip 2P input check
    clr.l   -(sp)               ; ReadInput mode 0
    dc.w    $4eb9,$0001,$e1ec                           ; jsr ReadInput ($01E1EC)
    addq.l  #$4,sp
    tst.w   d0                  ; any 2P input this frame?
    beq.b   .l190d8             ; no 2P input: continue normally
; 2P input present: route to GameCommand #$E (display update) and loop
.l190ca:                                                ; $0190CA
    pea     ($0003).w
    pea     ($000E).w           ; GameCommand #$E = display sync
    jsr     (a2)
    addq.l  #$8,sp
    bra.b   .l19084             ; go back to display loop top
; --- Phase: Animate panel scroll indicator ---
; (a4) = animation frame counter; incremented each loop iteration
; Milestones trigger tile placements for the scroll-indicator arrows
.l190d8:                                                ; $0190D8
    clr.w   d4                  ; clear 2P input flag
    addq.w  #$1,(a4)            ; increment animation frame counter
    cmpi.w  #$1,(a4)            ; first frame after reset?
    bne.b   .l1914a             ; not frame 1: check other milestones
; Frame 1: place left-arrow scroll indicator tile ($0770) at pixel (x=$39, y=$78)
; TilePlacement args: tile, priority, height, width, x, y, pal
    move.l  #$8000,-(sp)        ; high-priority tile flag
    pea     ($0001).w           ; height = 1
    pea     ($0001).w           ; width  = 1
    pea     ($0098).w           ; x pixel = $98 = 152
    pea     ($0078).w           ; y pixel = $78 = 120
    pea     ($0039).w           ; palette/attr field
    pea     ($0770).w           ; tile index $0770 = left scroll arrow
    dc.w    $4eb9,$0001,$e044                           ; jsr TilePlacement ($01E044)
    pea     ($0001).w
    pea     ($000E).w           ; GameCommand #$E = display update
    jsr     (a2)
    lea     $0024(sp),sp
; Place right-arrow scroll indicator tile ($0771) at pixel (x=$3A, y=$D0)
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00D0).w           ; x pixel = $D0 = 208
    pea     ($0078).w           ; y pixel = $78 = 120
    pea     ($003A).w
    pea     ($0771).w           ; tile index $0771 = right scroll arrow
    dc.w    $4eb9,$0001,$e044                           ; jsr TilePlacement ($01E044)
    lea     $001c(sp),sp
.l1913c:                                                ; $01913C
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)                 ; GameCommand #$E: final display sync for this frame
    addq.l  #$8,sp
    bra.b   .l1916a             ; proceed to input polling
; Frame $0F (15): trigger sprite-clear (GameCmd16 #$39, mode 2)
; This periodically clears the scroll arrow sprites as a blinking effect
.l1914a:                                                ; $01914A
    cmpi.w  #$f,(a4)            ; frame 15?
    bne.b   .l19162
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr GameCmd16 ($01E0B8): clear indicator sprite
    addq.l  #$8,sp
    bra.b   .l1913c
; Frame $1E (30): reset animation frame counter (30-frame blink cycle)
.l19162:                                                ; $019162
    cmpi.w  #$1e,(a4)           ; frame 30?
    bne.b   .l1916a             ; not yet: go to input
    clr.w   (a4)                ; reset animation counter (restart blink cycle)
; --- Phase: Process input (ProcessInputLoop) ---
; d6 holds previous input bits; processed result drives navigation
.l1916a:                                                ; $01916A
    move.w  d6,d0               ; previous input state (for repeat/edge detect)
    move.l  d0,-(sp)
    pea     ($000A).w           ; timeout = $0A = 10 frames
    dc.w    $4eb9,$0001,$e290                           ; jsr ProcessInputLoop ($01E290)
    addq.l  #$8,sp
; Mask to buttons we care about: $33 = Up, Down, Left, Right (d-pad bits)
    andi.w  #$33,d0
    move.w  d0,d6               ; d6 = filtered input bits for this frame
    ext.l   d0
; Decode input: check each d-pad bit and dispatch
    moveq   #$2,d1
    cmp.w   d1,d0               ; bit 1 = Right?
    beq.b   .l1919e
    moveq   #$1,d1
    cmp.w   d1,d0               ; bit 0 = Left?
    beq.b   .l191c2
    moveq   #$20,d1
    cmp.w   d1,d0               ; bit 5 = B button (next page fast)?
    beq.b   .l191e6
    moveq   #$10,d1
    cmp.w   d1,d0               ; bit 4 = A button (confirm/exit)?
    beq.b   .l191e6
    bra.w   .l1922e             ; no recognised input: clear flags and loop
; --- Navigation: Right d-pad (+1 partner, wrapping at 4) ---
.l1919e:                                                ; $01919E
    move.w  #$1,(a3)            ; input_mode_flag = 1: activate countdown input gate
.l191a2:                                                ; $0191A2
; Advance d2 by 1 (mod 4) and skip any NULL partner slots
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0              ; d0 = d2 + 1
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr SignedMod: d0 = (d2+1) mod 4
    move.w  d0,d2               ; advance partner index
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    tst.l   (a5,a0.l)           ; partner_ptrs[d2] valid?
    beq.b   .l191a2             ; NULL: skip to next slot
    bra.w   .l190ca             ; redraw and loop
; --- Navigation: Left d-pad (-1 partner, wrapping at 4, step of 3 = -1 mod 4) ---
.l191c2:                                                ; $0191C2
    move.w  #$1,(a3)            ; input_mode_flag = 1
.l191c6:                                                ; $0191C6
; Retreat d2 by 1 (mod 4): add 3 then mod 4 to go backwards without negative modulo
    move.w  d2,d0
    ext.l   d0
    addq.l  #$3,d0              ; d0 = d2 + 3 (equivalent to d2 - 1 mod 4)
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr SignedMod: d0 = (d2+3) mod 4
    move.w  d0,d2
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    tst.l   (a5,a0.l)           ; partner_ptrs[d2] valid?
    beq.b   .l191c6             ; NULL: skip to next slot
    bra.w   .l190ca
; --- Navigation: A or B button (exit browse loop, return has_any_partner flag) ---
.l191e6:                                                ; $0191E6
    clr.w   (a3)                ; input_mode_flag = 0: cancel countdown mode
    clr.w   ($00FFA7D8).l       ; input_init_flag = 0: reset input state
; Redraw/clear the panel area (same GameCommand sequence as initial setup)
    clr.l   -(sp)
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    pea     ($077D).w           ; panel border tile
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
; Return has_any_partner (d7) in d0: 1 if at least one partner was found and displayed
    move.w  d7,d0
    bra.b   .l1923a             ; jump to function epilogue
; --- No recognised input: clear flags and continue loop ---
.l1922e:                                                ; $01922E
    clr.w   (a3)                ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l       ; input_init_flag = 0
    bra.w   .l190ca             ; back to display sync and top of main loop
.l1923a:                                                ; $01923A
    movem.l -$003c(a6),d2-d7/a2-a5
    unlk    a6
    rts
