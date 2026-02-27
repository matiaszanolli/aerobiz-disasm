; ============================================================================
; GameSetup1 -- Plays the company-name intro sequence (or intro replay path): clears screen, loads fonts, displays company banners with fade-in/out; also handles the title-screen attract loop waiting for Start
; 1222 bytes | $03B428-$03B8ED
; ============================================================================
; --- Phase: Function Prologue and Register Setup ---
GameSetup1:
    link    a6,#$0
    movem.l d2/a2-a5, -(a7)
; a2 = GameCommand ($0D64) -- central command dispatcher used throughout
    movea.l  #$00000D64,a2
; a3 = pointer to layer/palette table base at $76CFE (8 palette/layer pointers)
    movea.l  #$00076CFE,a3
; a4 = DrawLayersForward/Reverse dispatch stub at $4B6C
    movea.l  #$00004B6C,a4
; a5 = a3 + $34 = entry [13] in layer table (used as active palette pointer)
    movea.l a3, a5
    moveq   #$34,d0
    adda.l  d0, a5
; --- Phase: Entry-Point Branch ---
; $A(a6) = stack argument: 0 = title-screen attract mode, nonzero = intro sequence mode
    tst.w   $a(a6)
; if zero: jump to attract-loop path (l_3b74c); nonzero: fall through to intro sequence
    beq.w   l_3b74c
; --- Phase: Intro Sequence -- Screen Init ---
; ResourceLoad: load tile buffer from ROM $472CE with palette index $40
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($000472CE).l
    jsr     (a4)
; ClearScreen: erase both scroll planes via GameCmd #$1A ×2
    jsr ClearScreen
; GameCommand #$D: enable display output
    pea     ($000D).w
    jsr     (a2)
; InitTextColors: set up text palette entries (args: 0, 0)
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w InitTextColors
    lea     $18(a7), a7
; ClearSoundBuffer: silence any queued sound commands
    bsr.w ClearSoundBuffer
; load music/sound track ID from ROM word at $737F8 into d0
    moveq   #$0,d0
    move.w  ($000737F8).l, d0
; GameCommand #$1A: clear scroll plane A region (width=$20, height=$20, x=0, y=0)
; with music track as first arg -- starts background music for intro
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
; GameCommand #$1B: set up layer/palette entry -- source=$734F8, count=7, y=$C, x=$A, attr=$B
; loads the company-name intro banner tile data
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
; GameCommand #$C: flush/apply pending graphics command
    pea     ($000C).w
    jsr     (a2)
; DrawLayersForward: render all 8 palette layers in forward order (0→7) to show initial banner
    pea     ($0002).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  ($00076CFE).l, -(a7)
    jsr DrawLayersForward
    lea     $30(a7), a7
; GameCommand #$E: wait $14 frames then advance -- brief display pause after banner appears
; $14 = 20 frames (~0.33 seconds at 60fps)
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
; --- Phase: Intro Sequence -- Company Banner Fade-In Loop (entries 1-5) ---
; d2 = layer index counter; iterates 1..5 drawing successive company banners
    moveq   #$1,d2
l_3b4ea:
; ResourceLoad layer[d2]: d2*4 = byte offset into a3 layer table to get this layer's palette ptr
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
; d0 = d2 * 4 = longword offset into layer pointer table at a3 ($76CFE)
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
; load banner tile source address from ROM jump table at $48D18, indexed by d2
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00048D18,a0
    move.l  (a0,d0.w), -(a7)
; GameCommand #$1B: configure this layer's display parameters (count=5, y=$C, x=$A, attr=$B)
    pea     ($0005).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
; GameCommand #$E with arg 2: wait 2 frames between banners (brief inter-banner timing)
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a2)
    lea     $30(a7), a7
    addq.w  #$1, d2
; loop for company banners at indices 1..5 (6 entries total including index 0 above)
    cmpi.w  #$6, d2
    bcs.b   l_3b4ea
; re-apply banner tile data (same $734F8 block, count=7) to prepare for fade sequence
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
; --- Phase: Intro -- Palette Sweep UP (layers 6, 7, 8): fade-in upper banners ---
; d2 starts at 6; increments to 8 (exclusive), sweeping through layers 6..8
    moveq   #$6,d2
l_3b55e:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
; load palette pointer for layer d2 from table at a3; push as ResourceLoad arg
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
; wait 1 frame between each palette step (gradual fade effect)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$9, d2
; loop ascending through palette layers 6, 7, 8 (fade-in effect)
    bcs.b   l_3b55e
; --- Phase: Intro -- Palette Sweep DOWN (layers 9→5): hold then fade-out ---
; d2 starts at 9; decrements to 5 (exclusive via bhi), sweeping layers 9..6
    moveq   #$9,d2
l_3b58a:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
; 1-frame step for each palette level during fade-out
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    subq.w  #$1, d2
; bhi stops when d2 reaches 5 (unsigned > 5, so loop runs for 9, 8, 7, 6)
    cmpi.w  #$5, d2
    bhi.b   l_3b58a
; --- Phase: Intro -- Palette Sweep DOWN (layers 4→1): continue fade-out to black ---
; d2 = 4; decrements to 0 (inclusive, stops when d2 becomes 0)
    moveq   #$4,d2
l_3b5b6:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    subq.w  #$1, d2
; loop terminates when d2 reaches 0 (all levels faded, screen is black)
    tst.w   d2
    bne.b   l_3b5b6
; --- Phase: Intro -- Reload Banner and Pause Before Title ---
; re-emit banner layer setup ($734F8) then wait $A = 10 frames before next banner set
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
; $A = 10 frames pause between banner groups (~0.17 seconds)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
; --- Phase: Intro -- Fade-In Title Screen (layers 10→13) ---
; d2 starts at $A (10); increments to $E (14 exclusive) -- fade-in 4 palette levels
    moveq   #$A,d2
l_3b60c:
    pea     ($0010).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), -(a7)
    jsr     (a4)
; wait 4 frames per palette step -- slower, more dramatic title fade-in
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addq.w  #$1, d2
; loop for layers 10, 11, 12, 13 (4-step fade up to full brightness)
    cmpi.w  #$e, d2
    bcs.b   l_3b60c
; --- Phase: Intro -- Display Title Logo with Long Hold ---
; ResourceLoad with a5 (active palette pointer): load title screen palette
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr     (a4)
; GameCommand #$1B: set up title logo layer from ROM $7386A (count=2, y=$11, x=$9)
    pea     ($0007386A).l
    pea     ($0002).w
    pea     ($000E).w
    pea     ($0011).w
    pea     ($0009).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
; wait $78 = 120 frames = 2 seconds: hold title logo on screen
    pea     ($0078).w
    pea     ($000E).w
    jsr     (a2)
    lea     $30(a7), a7
; DrawLayersReverse (7→0): reverse-order layer render to dissolve title out
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr DrawLayersReverse
; ClearScreen: blank display before next graphic
    jsr ClearScreen
; reload title palette (a5) after clear
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr     (a4)
    lea     $1c(a7), a7
; --- Phase: Intro -- "Koei" Copyright Screen ---
; GameCommand #$1B: load Koei/copyright graphic from $737FA (count=2, y=$F, x=$2)
    pea     ($000737FA).l
    pea     ($0002).w
    pea     ($001C).w
    pea     ($000F).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
; DelayFrames $78 = 120 frames = 2 seconds: hold copyright screen
    pea     ($0078).w
    bsr.w DelayFrames
; FadeOutAndWait: fade palette to black over 5 steps, wait for completion
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    bsr.w FadeOutAndWait
    lea     $30(a7), a7
    jsr ClearScreen
; --- Phase: Intro -- Sega License Screen ---
; GameCommand #$1B: Sega license screen graphic from $738A2 (count=3, y=$B, x=$C)
    pea     ($000738A2).l
    pea     ($0003).w
    pea     ($0008).w
    pea     ($000B).w
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
; second Sega graphic from $738D2 (count=3, y=$E, x=$7)
    pea     ($000738D2).l
    pea     ($0003).w
    pea     ($0014).w
    pea     ($000E).w
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
; FadeInAndWait: fade up from black over 5 steps to reveal Sega license screen
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    bsr.w FadeInAndWait
; DelayFrames $B4 = 180 frames = 3 seconds: hold Sega license on screen
    pea     ($00B4).w
    bsr.w DelayFrames
    lea     $30(a7), a7
; FadeOutAndWait: fade palette to black, ending intro sequence
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    bsr.w FadeOutAndWait
    lea     $10(a7), a7
    jsr ClearScreen
; jump to function epilogue -- intro path done, skip attract loop
    bra.w   l_3b8e4
; --- Phase: Attract Loop -- Title Screen Setup ---
l_3b74c:
; GameCommand #$15: display setup/reset for attract-loop title screen
    clr.l   -(a7)
    pea     ($0015).w
    jsr     (a2)
    addq.l  #$8, a7
; RefreshAndWait: GameCmd #$E + #$14, returns nonzero if display mode change needed
    jsr RefreshAndWait
    tst.l   d0
; if no display-mode adjustment needed, skip to l_3b76a
    beq.b   l_3b76a
; SetDisplayMode: update display hardware flags to match new mode
    clr.l   -(a7)
    jsr SetDisplayMode
    addq.l  #$4, a7
l_3b76a:
; InitTextColors: reset text palette to defaults (args: 0, 0 = both planes default)
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w InitTextColors
; ResourceLoad: load tile buffer from $472CE with palette index $40
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($000472CE).l
    jsr     (a4)
; GameCommand #$10: display init with palette index $40
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    lea     $20(a7), a7
; GameCommand #$1A: clear scroll plane A -- $8000 = high-priority clear, 32×32 at (0,0)
    move.l  #$8000, -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
; GameCommand #$1A: clear scroll plane B ($8000 flag, plane 1, 32×32 at origin)
    move.l  #$8000, -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
; GameCommand #$D: enable display output after clearing
    pea     ($000D).w
    jsr     (a2)
    lea     $20(a7), a7
; ClearSoundBuffer: silence Z80 sound queue before starting attract music
    bsr.w ClearSoundBuffer
; load attract-loop music track ID from ROM word at $737F8
    moveq   #$0,d0
    move.w  ($000737F8).l, d0
; GameCommand #$1A: start attract-loop BGM (track in d0 passed as first arg)
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
; GameCommand #$1B: load company/title banner tiles from $734F8 (count=7, y=$C, x=$A)
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
; GameCommand #$C: flush/apply pending display commands
    pea     ($000C).w
    jsr     (a2)
; FadeInAndWait: fade in from black over 5 steps to reveal title banner
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    bsr.w FadeInAndWait
    lea     $30(a7), a7
; DelayFrames $14 = 20 frames: brief hold after fade-in before scroll begins
    pea     ($0014).w
    bsr.w DelayFrames
; GameCommand #$1B: re-emit banner tile data with same args (scrolling effect step)
    pea     ($000734F8).l
    pea     ($0007).w
    pea     ($000C).w
    pea     ($000A).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
; DelayFrames $1E = 30 frames = 0.5 seconds: hold between banner display phases
    pea     ($001E).w
    bsr.w DelayFrames
; ResourceLoad with a5 (active palette): apply title palette
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    jsr     (a4)
    lea     $30(a7), a7
; DelayFrames $34 = 52 frames (~0.87 seconds): extended hold at full brightness
    pea     ($0034).w
    bsr.w DelayFrames
; GameCommand #$1B: load title-screen "Press Start" graphic from $7394A (count=3, y=$11, x=$5)
    pea     ($0007394A).l
    pea     ($0003).w
    pea     ($0016).w
    pea     ($0011).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $20(a7), a7
; --- Phase: Attract Loop -- Wait for Start Button (or Timeout) ---
; d2 = frame counter for attract-loop timeout
    clr.w   d2
l_3b89c:
; ReadInput: read joypad via GameCmd #10; returns nonzero if any button pressed
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
; any button press exits the wait loop immediately
    tst.l   d0
    bne.b   l_3b8bc
; no input: wait 1 frame before polling again
    pea     ($0001).w
    bsr.w DelayFrames
    addq.l  #$4, a7
    addq.w  #$1, d2
; $1F4 = 500 frames (~8.3 seconds): attract-loop auto-timeout, restarts attract sequence
    cmpi.w  #$1f4, d2
    bcs.b   l_3b89c
; --- Phase: Attract Loop -- Start Confirmed / Timeout ---
l_3b8bc:
; RefreshAndWait: confirm display mode is synchronized before transitioning
    jsr RefreshAndWait
    tst.l   d0
; spin until display mode is settled (no pending mode changes)
    bne.b   l_3b8bc
; FadeOutAndWait: fade screen to black over 5 steps before leaving title screen
    pea     ($0005).w
    pea     ($0010).w
    clr.l   -(a7)
    move.l  (a5), -(a7)
    bsr.w FadeOutAndWait
    jsr ClearScreen
; GameCommand #$1E: signal transition to game proper (resets display/scroll state)
    pea     ($001E).w
    jsr     (a2)
; --- Phase: Attract Loop End -- Infinite Spin (control transfer via interrupt) ---
; spin here forever; execution is resumed elsewhere via V-INT or game flow
l_3b8e2:
    bra.b   l_3b8e2
; --- Phase: Epilogue (intro path only) ---
l_3b8e4:
; restore saved registers from link frame and return (only reached via intro path)
    movem.l -$14(a6), d2/a2-a5
    unlk    a6
    rts
