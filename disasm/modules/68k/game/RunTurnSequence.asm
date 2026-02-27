; ============================================================================
; RunTurnSequence -- Renders the full turn intro sequence (route maps, banner graphics, city panels) for the current player, loops over three route-panel subviews, then handles end-of-turn input and invokes CalcRouteRevenue on exit.
; Called: ?? times.
; 1490 bytes | $029ABC-$02A08D
; ============================================================================
; Register usage throughout:
;   a3 = GameCommand dispatcher ($0D64)
;   a4 = save_buf_base ($FF1804) -- used as context for display/LZ calls
;   a5 = DisplaySetup ($5092) -- called for tile/sprite setup
;   d4 = current player index (0-3), loaded from current_player ($FF0016)
;   d2 = route panel subview index (0-2), then reused as char-slot index
;   d5 = input-pending flag (1 = more input to process, 0 = done)
;   d6 = last action button mask returned by $02A6B8 (navigation/confirm bits)
;   a2 = AI decision table entry for this player ($FF03F0 + player*$C)
RunTurnSequence:                                                  ; $029ABC
    link    a6,#-$4
    movem.l d2-d6/a2-a5,-(sp)
    movea.l #$0d64,a3                   ; a3 = GameCommand ($0D64) dispatcher
    movea.l #$00ff1804,a4               ; a4 = save_buf_base ($FF1804) display context
    movea.l #$5092,a5                   ; a5 = DisplaySetup ($5092)
    dc.w    $4eb9,$0001,$d71c           ; jsr $01D71C  -- VBlank sync
    moveq   #$0,d4
    move.b  ($00FF0016).l,d4            ; d4 = current_player (0-3)
    move.w  d4,d0
    mulu.w  #$c,d0                      ; player * $C (12 bytes per entry)
    movea.l #$00ff03f0,a0              ; $FF03F0 = AI decision table (4 players × $C bytes)
    lea     (a0,d0.w),a0
    movea.l a0,a2                       ; a2 = AI decision table entry for this player

; --- Phase: display initialization -- clear screen, run entry animation ---
    dc.w    $4eb9,$0001,$e398           ; jsr $01E398  -- screen/display init
    pea     ($0004C68E).l              ; ptr into GameStatusText (banner string A)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($000B).w
    pea     ($0003).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)                        ; GameCommand $1B: render text panel (row=3, col=$B, ...)
    pea     ($0004C696).l              ; ptr into GameStatusText (banner string B)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec           ; jsr $003FEC  -- load/decompress resource
    lea     $0024(sp),sp
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($00B2).w
    dc.w    $4eb9,$0001,$d568           ; jsr $01D568  -- display blit (x=$B2, y=4)
    pea     ($0004C610).l              ; ptr into GameStatusText (banner string C)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($000B).w
    pea     ($000C).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)                        ; GameCommand $1B: render text panel (row=$C, col=$B)
    lea     $002c(sp),sp
    pea     ($0004C618).l              ; ptr into GameStatusText (banner string D)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec           ; jsr $003FEC
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($00AE).w
    dc.w    $4eb9,$0001,$d568           ; jsr $01D568  -- display blit (x=$AE, y=4)
    lea     $0018(sp),sp
    pea     ($0004C596).l              ; ptr into GameStatusText (header panel string)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($000B).w
    pea     ($0015).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)                        ; GameCommand $1B: render text panel (row=$15, col=$B)
    pea     ($0004C59E).l              ; ptr into GameStatusText
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($00AA).w
    dc.w    $4eb9,$0001,$d568           ; jsr $01D568  -- display blit (x=$AA, y=4)

; --- Phase: draw route map and city connection panels ---
    pea     ($00072A6C).l              ; route map tile data A (first city column)
    pea     ($0002).w
    pea     ($0007).w
    pea     ($0010).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)                        ; GameCommand $1B: render route panel row 0 (col=4)
    lea     $002c(sp),sp
    pea     ($00072A88).l              ; route map tile data B (second city column)
    pea     ($0002).w
    pea     ($0007).w
    pea     ($0010).w
    pea     ($000D).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)                        ; GameCommand $1B: render route panel row 1 (col=$D)
    lea     $001c(sp),sp
    pea     ($00072AA4).l              ; route map tile data C (third city column)
    pea     ($0002).w
    pea     ($0007).w
    pea     ($0010).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)                        ; GameCommand $1B: render route panel row 2 (col=$16)

; Draw world-map background tile block ($76ADE data)
    pea     ($0010).w                   ; tile count
    pea     ($0030).w                   ; VRAM destination
    pea     ($00076ADE).l              ; world map tile graphics
    jsr     (a5)                        ; DisplaySetup: load/display tile block
    move.l  ($000A1B30).l,-(sp)        ; ptr from ROM ptr table at $0A1B30 (player-portrait data)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec           ; jsr $003FEC  -- load/decompress player portrait
    lea     $0030(sp),sp
    pea     ($0048).w
    pea     ($005B).w
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$4668           ; jsr $004668  -- blit portrait tile (x=$5B, y=$48)
    pea     ($0007267C).l              ; city/route connection line graphics
    pea     ($0012).w
    pea     ($001C).w
    pea     ($0001).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)                        ; GameCommand $1B: render connection graphic
    lea     $0028(sp),sp
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076B1E).l              ; second world-map overlay graphics
    jsr     (a5)                        ; DisplaySetup
    pea     ($0004BD5A).l              ; route label string A
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0005).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)                        ; GameCommand $1B: render route label (row=4, col=5)
    lea     $0028(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004BD96).l              ; route summary text (quarterly revenue/profit data)
    pea     ($001E).w
    pea     ($003D).w
    dc.w    $4eb9,$0001,$d568           ; jsr $01D568  -- display blit (x=$3D, y=$1E)
    move.l  ($000A1B60).l,-(sp)        ; ptr from ROM ptr table (second player resource)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec           ; jsr $003FEC
    pea     ($001E).w
    pea     ($0001).w
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$4668           ; jsr $004668  -- blit tile (x=1, y=$1E)
    lea     $0028(sp),sp
    pea     ($000732DC).l              ; route slot label B
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0005).w
    pea     ($000D).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)                        ; GameCommand $1B: render route label (row=$D, col=5)
    lea     $001c(sp),sp
    pea     ($0004C178).l              ; route slot label C
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0005).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)                        ; GameCommand $1B: render route label (row=$16, col=5)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004C1B4).l              ; route slot summary text
    pea     ($001E).w
    pea     ($001F).w
    dc.w    $4eb9,$0001,$d568           ; jsr $01D568  -- display blit (x=$1F, y=$1E)
    lea     $0030(sp),sp

; Draw stat-panel graphics tiles ($4C734 and $4C854)
    pea     ($0004C734).l              ; stat panel graphic A (VRAM tile block)
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0640).w                  ; $0640 = VRAM destination word
    dc.w    $4eb9,$0001,$d7be           ; jsr $01D7BE  -- DMA/blit to VRAM at $0640
    pea     ($0004C854).l              ; stat panel graphic B
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0649).w                  ; $0649 = VRAM destination word (9 tiles after $0640)
    dc.w    $4eb9,$0001,$d7be           ; jsr $01D7BE
    lea     $0020(sp),sp

; --- Phase: loop over 3 route-panel subviews (d2 = 0, 1, 2) ---
; Each subview shows a different category of route/city info for this player.
    clr.w   d2                         ; d2 = subview index (0 = routes, 1 = cities, 2 = aircraft)
.l29d7c:                                                ; $029D7C
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: subview index
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: player index
    dc.w    $4eba,$0354                ; jsr $02A0DE  -- render route panel subview
    nop
    addq.l  #$8,sp
    addq.w  #$1,d2
    cmpi.w  #$3,d2                     ; rendered all 3 subviews?
    blt.b   .l29d7c

; --- Phase: initial input wait -- detect if player wants to advance ---
    dc.w    $4eb9,$0001,$d748           ; jsr $01D748  -- VBlank sync
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec           ; jsr $01E1EC  -- wait for input (no timeout)
    addq.l  #$4,sp
    tst.w   d0                          ; d0 = input result (0 = no input / timeout)
    beq.b   .l29db0
    moveq   #$1,d5                      ; d5 = 1: input received, more processing needed
    bra.b   .l29db2
.l29db0:                                                ; $029DB0
    moveq   #$0,d5                      ; d5 = 0: no input, skip further input loop
.l29db2:                                                ; $029DB2
    clr.w   d2                         ; reset char-slot index
    moveq   #$1,d3                      ; d3 = first-iteration flag (1 = first pass)

; --- Phase: main input/display loop -- process per-frame input and update panels ---
.l29db6:                                                ; $029DB6
    cmpi.w  #$1,d3                      ; first iteration?
    bne.b   .l29dda                     ; skip event check after first pass
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($000420FE).l              ; event string ptr in ROM (event check message)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: player index
    dc.w    $4eb9,$0000,$7912           ; jsr $007912  -- check/display player event
    lea     $0014(sp),sp
    clr.w   d3                         ; clear first-iteration flag

.l29dda:                                                ; $029DDA
; Refresh both world-map tile blocks each iteration
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076ADE).l
    jsr     (a5)                        ; refresh map tile block A
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004C158).l
    jsr     (a5)                        ; refresh map tile block B
    lea     $0018(sp),sp

; If d5 set, poll for additional input (e.g., confirm button press to advance)
    tst.w   d5
    beq.b   .l29e1e                     ; d5=0 -> skip input polling, go to action dispatch
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec           ; jsr $01E1EC  -- poll for further input
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l29e1e                     ; no input -> go to action dispatch

; Input received: push confirm command and loop back for another frame
    pea     ($0002).w
.l29e14:                                                ; $029E14
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $E (cmd=14): scroll/advance display
    addq.l  #$8,sp
    bra.b   .l29db6                    ; loop back to top of input/display loop

; --- Phase: action dispatch -- read button mask, route to subpanel action ---
.l29e1e:                                                ; $029E1E
    clr.w   d5
    pea     ($003C).w                  ; $3C = 60 frames timeout for input
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0                      ; arg: slot_index + 1 (1-based)
    move.l  d0,-(sp)
    pea     ($0003).w                  ; arg: panel type (3 = char/slot selector)
    dc.w    $4eba,$0886                ; jsr $02A6B8  -- read navigation input with timeout
    nop
    move.w  d0,d6                      ; d6 = button bitmask from $02A6B8

; Issue command to hide/dim current selection marker
    pea     ($0008).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $E (cmd=8): dim current marker
    lea     $0014(sp),sp
    move.w  d6,d0
    andi.w  #$10,d0                    ; bit 4 = Exit/Back button
    bne.w   .l2a02e                    ; if set -> exit turn sequence
    move.w  d6,d0
    andi.w  #$20,d0                    ; bit 5 = Confirm/A button
    beq.w   .l2a006                    ; not confirm -> check directional

; --- Confirm pressed: dispatch to per-subpanel char/slot selection ---
; d2 selects which subpanel: 0 = AI param 0, 1 = AI param 1, 2 = AI param 2
    move.w  #$0ccc,-$0002(a6)          ; store tile attribute word ($0CCC) to stack temp
    pea     ($0001).w
    move.w  d2,d6
    ext.l   d6
    addi.l  #$34,d6                    ; offset $34 + subview_index into display table
    move.l  d6,-(sp)
    pea     -$0002(a6)
    jsr     (a5)                        ; DisplaySetup: highlight selection tile A ($0CCC)
    move.w  #$0866,-$0002(a6)          ; second tile attribute ($0866)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    addi.l  #$37,d0                    ; offset $37 + subview_index
    move.l  d0,-(sp)
    pea     -$0002(a6)
    jsr     (a5)                        ; DisplaySetup: highlight selection tile B ($0866)
    lea     $0018(sp),sp

; Dispatch by subview index (d2): 0 = AI byte at +$09, 1 = AI byte at +$0B, 2 = AI byte at +$0A
    move.w  d2,d0
    ext.l   d0
    tst.w   d0
    beq.b   .l29eb0                    ; d2=0 -> subpanel 0 (AI decision byte 0)
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l29f12                    ; d2=1 -> subpanel 1 (AI decision byte 1)
    moveq   #$2,d1
    cmp.w   d1,d0
    beq.w   .l29f6a                    ; d2=2 -> subpanel 2 (AI decision byte 2)
    bra.w   .l29fbe

; --- Subpanel 0: select/modify AI decision byte 0 (a2+$09) ---
.l29eb0:                                                ; $029EB0
    moveq   #$0,d0
    move.b  $0009(a2),d0               ; read AI decision table byte at +$09
    move.l  d0,-(sp)                   ; arg: current value
    clr.l   -(sp)                      ; arg: selection type = 0
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: player index
    dc.w    $4eba,$05b2                ; jsr $02A474  -- show char/option selector
    nop
    lea     $000c(sp),sp
    move.w  d0,d3                      ; d3 = selected value (-1 = cancelled, else new value)
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l29fbe                    ; cancelled (returned -1) -> skip update
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0009(a2),d1              ; compare against current value
    cmp.l   d1,d0
    beq.w   .l29fbe                    ; unchanged -> skip update
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: new selected value
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: subpanel index
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: player index
    dc.w    $4eba,$0184                ; jsr $02A07E  -- validate/confirm char selection
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0                     ; confirmed?
    bne.w   .l29fbe
    move.b  d3,$0009(a2)              ; update AI decision byte 0 with new selection
    bra.w   .l29fbe

; --- Subpanel 1: select/modify AI decision byte 1 (a2+$0B) ---
.l29f12:                                                ; $029F12
    moveq   #$0,d0
    move.b  $000b(a2),d0               ; read AI decision table byte at +$0B
    move.l  d0,-(sp)
    pea     ($0001).w                  ; selection type = 1
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$054e                ; jsr $02A474  -- show char/option selector
    nop
    lea     $000c(sp),sp
    move.w  d0,d3
    blt.w   .l29fbe                    ; negative return (< 0) = cancelled
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $000b(a2),d1
    cmp.l   d1,d0
    beq.b   .l29fbe                    ; unchanged
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0128                ; jsr $02A07E  -- validate/confirm
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.b   .l29fbe
    move.b  d3,$000b(a2)              ; update AI decision byte 1
    bra.b   .l29fbe

; --- Subpanel 2: select/modify AI decision byte 2 (a2+$0A) ---
.l29f6a:                                                ; $029F6A
    moveq   #$0,d0
    move.b  $000a(a2),d0               ; read AI decision table byte at +$0A
    move.l  d0,-(sp)
    pea     ($0002).w                  ; selection type = 2
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$04f6                ; jsr $02A474  -- show char/option selector
    nop
    lea     $000c(sp),sp
    move.w  d0,d3
    blt.b   .l29fbe                    ; negative = cancelled
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $000a(a2),d1
    cmp.l   d1,d0
    beq.b   .l29fbe                    ; unchanged
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00d2                ; jsr $02A07E  -- validate/confirm
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.b   .l29fbe
    move.b  d3,$000a(a2)              ; update AI decision byte 2

; --- Redraw selection indicators and re-render the subview ---
.l29fbe:                                                ; $029FBE
    move.w  #$0222,-$0002(a6)          ; tile attr $0222 = deselected marker A
    pea     ($0001).w
    move.l  d6,-(sp)                   ; tile destination index (set when confirm was pressed)
    pea     -$0002(a6)
    jsr     (a5)                        ; DisplaySetup: restore deselected appearance A
    move.w  #$0424,-$0002(a6)          ; tile attr $0424 = deselected marker B
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    addi.l  #$37,d0                    ; slot display index
    move.l  d0,-(sp)
    pea     -$0002(a6)
    jsr     (a5)                        ; DisplaySetup: restore deselected appearance B
    moveq   #$1,d3                     ; reset first-iteration flag
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: subpanel index
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: player index
    dc.w    $4eba,$00e2                ; jsr $02A0DE  -- re-render this subpanel
    nop
    lea     $0020(sp),sp
    bra.b   .l2a026                    ; join loop-continue path

; --- Directional input: advance slot index (D-pad left/right navigation) ---
.l2a006:                                                ; $02A006
    move.w  d6,d0
    andi.w  #$8,d0                     ; bit 3 = right/next
    beq.b   .l2a016                    ; not right -> go left/previous path
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0                     ; advance slot index by 1
    bra.b   .l2a01c
.l2a016:                                                ; $02A016
    move.w  d2,d0
    ext.l   d0
    addq.l  #$2,d0                     ; left: advance by 2 (wraps around mod 3)
.l2a01c:                                                ; $02A01C
    moveq   #$3,d1                     ; modulus = 3 (3 subpanels)
    dc.w    $4eb9,$0003,$e146           ; jsr $03E146  -- d0 = d0 mod d1
    move.w  d0,d2                      ; update slot/subpanel index
.l2a026:                                                ; $02A026
    pea     ($0005).w                  ; arg: display mode 5 (re-enter input loop)
    bra.w   .l29e14                    ; issue GameCommand $E and loop

; --- Phase: exit -- VBlank sync then finalize revenue/expense for this player ---
.l2a02e:                                                ; $02A02E
    dc.w    $4eb9,$0001,$d71c           ; jsr $01D71C  -- VBlank sync
    pea     ($0040).w                  ; cmd param
    clr.l   -(sp)
    pea     ($0010).w                  ; cmd $10 = reset display mode / clear screen state
    jsr     (a3)                        ; GameCommand $10: display cleanup
    pea     ($0001).w
    move.w  ($00FF9A1C).l,d0           ; screen_id ($FF9A1C) = current scenario/screen index
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: scenario/screen id
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: player index
    dc.w    $4eb9,$0000,$6a2e           ; jsr $006A2E  -- finalize revenue  (writes quarter_accum_a)
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0           ; screen_id again
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78           ; jsr $006B78  -- finalize expenses (writes quarter_accum_b)
    movem.l -$0028(a6),d2-d6/a2-a5
    unlk    a6
    rts
; === Translated block $02A07E-$02A738 ===
; 5 functions, 1722 bytes
