; ============================================================================
; RunIntroLoop -- Runs the full intro/demo sequence: displays 5 scenario preview screens, animates a globe flyby with CalcScreenCoord, then shows the opening animation; exits on Start or after full playback
; 1064 bytes | $03BD52-$03C179
; ============================================================================
RunIntroLoop:
; --- Phase: Setup ---
; 128-byte local frame: a4 = frame base (used as palette/color data staging buffer)
    link    a6,#-$80
    movem.l d2-d4/a2-a5, -(a7)
; a3 = GameCommand ($000D64) cached for all indirect calls
    movea.l  #$00000D64,a3
; a4 = -$80(a6): local work buffer for scroll/color data (128 bytes)
    lea     -$80(a6), a4
; a5 = $3BD1E: ROM callback used at l_3bea6 -- the "exit to title" routine
    movea.l  #$0003BD1E,a5
; --- Phase: Initial Display Setup (Intro Backgrounds) ---
; DisplaySetup: load and configure the 4 background display layers for the intro screen
; Layer 0: source pointer from ROM table at $77016 (first scenario preview background)
    pea     ($0010).w
    clr.l   -(a7)
    move.l  ($00077016).l, -(a7)
    jsr DisplaySetup
; Layer 1: second background from $7702E (alternate scenario preview)
    pea     ($0010).w
    pea     ($0010).w
    move.l  ($0007702E).l, -(a7)
    jsr DisplaySetup
; Layer 2: third background from $77046 (cycling between 2 entries via SignedMod later)
    pea     ($0010).w
    pea     ($0020).w
    move.l  ($00077046).l, -(a7)
    jsr DisplaySetup
; Layer 3: title/logo graphic from ROM $76EF6 (main title screen static layer)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076EF6).l
    jsr DisplaySetup
    lea     $30(a7), a7
; --- Phase: Load and Place Intro Graphics ---
; Decompress compressed graphic from ROM ($B7530) into $FF1804 (save_buf_base staging)
    move.l  ($000B7530).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
; CmdPlaceTile: place decompressed tile data at VRAM offset $37F, row $01
; $037F = VRAM tile address for the top-left intro graphic position
    pea     ($037F).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
; Second compressed element ($B7534): overlay graphic (title lettering or globe)
    move.l  ($000B7534).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
; Place at VRAM $3C0, tile row $3C ($60 = 96 pixel offset)
    pea     ($003C).w
    pea     ($03C0).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
; Third compressed element ($B7538): another overlay (secondary intro graphic)
    move.l  ($000B7538).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
; Place at VRAM $400, row $78 ($120 pixel offset)
    pea     ($0078).w
    pea     ($0400).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
; --- Phase: Configure Scroll and Menu for Intro ---
; GameCommand #$1B: place tile block from ROM $739CE (text/UI overlay tiles)
; Width=$20, height=$1C, col=0, row=0, page=1
    pea     ($000739CE).l
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $28(a7), a7
; GameCommand #$1B: second tile block from $740CE (scenario text panel)
; Width=$20, height=$1C, col=0, row=0, all layers
    pea     ($000740CE).l
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
; MenuSelectEntry: initialize menu cursor to position 0 (no selection yet)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr MenuSelectEntry
    lea     $24(a7), a7
; SetScrollBarMode: configure scroll bar (mode=3, speed=2, flags=0,0,1)
; Enables the intro scroll animation subsystem
    pea     ($0003).w
    pea     ($0002).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    jsr SetScrollBarMode
; ResourceUnload: release any previously loaded display resource (free slot for intro use)
    jsr ResourceUnload
; WaitForStartButton(timeout=$40 = 64 frames): wait up to 64 frames for Start press
; Returns d0=1 if Start pressed, 0 if timed out
    pea     ($0040).w
    bsr.w WaitForStartButton
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_3beac
; Start pressed during setup: skip directly to exit (show title screen)
l_3bea6:
    jsr     (a5)
    bra.w   l_3c170
; --- Phase: Scenario Preview Loop (5 scenarios * 4 screens each = 20 display passes) ---
l_3beac:
; d2 = scenario index (0-4); each scenario shows 4 preview screens then advances
    clr.w   d2
l_3beae:
; GameCommand #$F: display scenario entry panel
; Load and display scenario tile block from $747CE[d2*16] (scenario preview text block)
    pea     ($0068).w
    pea     ($0068).w
    move.w  d2, d0
    lsl.w   #$4, d0
; ROM $747CE: table of scenario preview tile blocks, stride $10 bytes per scenario
    movea.l  #$000747CE,a0
    pea     (a0, d0.w)
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a3)
    lea     $18(a7), a7
; d3 = screen index within this scenario (0-3; 4 screens per scenario)
    clr.w   d3
l_3bed6:
; DisplaySetup: cycle through 2 background variants for the preview (via mod-2)
    pea     ($0010).w
    pea     ($0020).w
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$2,d1
; d3 mod 2 -> alternates between the two backgrounds in ROM table at $77046
    jsr SignedMod
    lsl.l   #$2, d0
    movea.l  #$00077046,a0
    move.l  (a0,d0.l), -(a7)
    jsr DisplaySetup
; WaitForStartButton($20 = 32 frames): show this preview for 32 frames or until Start
    pea     ($0020).w
    bsr.w WaitForStartButton
    lea     $10(a7), a7
    tst.w   d0
    bne.b   l_3bea6
    addq.w  #$1, d3
; Show 4 preview screens per scenario (d3 < 4)
    cmpi.w  #$4, d3
    bcs.b   l_3bed6
    addq.w  #$1, d2
; Cycle through 5 scenarios (d2 < 5)
    cmpi.w  #$5, d2
    bcs.b   l_3beae
; --- Phase: Globe Flyby Animation ($68 = 104 frames) ---
; d2 = animation frame counter for the globe sweep
    clr.w   d2
l_3bf1e:
; Every 8th frame: refresh the background layer
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$8,d1
    jsr SignedMod
; d0=0 every 8 frames: update the background (slow scroll / background swap)
    tst.l   d0
    bne.b   l_3bf5e
    pea     ($0010).w
    pea     ($0020).w
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_3bf3e
    addq.l  #$7, d0
l_3bf3e:
; Divide frame by 8 (asr #3), then mod 2 to select which background variant to show
    asr.l   #$3, d0
    moveq   #$2,d1
    jsr SignedMod
    lsl.l   #$2, d0
    movea.l  #$00077046,a0
    move.l  (a0,d0.l), -(a7)
    jsr DisplaySetup
    lea     $c(a7), a7
l_3bf5e:
; Display globe sprite for this frame: tile block from ROM $7480E
; X = $68 - d2 (globe moves left as frame advances: starts at right, sweeps left)
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$68,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0068).w
    pea     ($0007480E).l
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a3)
; Wait 4 frames between animation steps
    pea     ($0004).w
    bsr.w WaitForStartButton
    lea     $1c(a7), a7
    tst.w   d0
    bne.w   l_3bea6
    addq.w  #$1, d2
; Run $68 (104) frames of globe animation
    cmpi.w  #$68, d2
    bcs.b   l_3bf1e
; --- Phase: Clear Globe, Setup for Color Tileset ---
; GameCommand #$10: clear display region (height=2, mode=0)
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $c(a7), a7
; d2 = color tile loop counter (0-4: 5 color palette frames)
    clr.w   d2
; a2 = a4 + $40 = second half of local frame buffer (palette data for second plane)
    movea.l a4, a2
    moveq   #$40,d0
    adda.l  d0, a2
; --- Phase: Palette Scroll / Color Tileset Loop (5 frames) ---
l_3bfb0:
; MemMove($20 bytes): copy 32 bytes from ROM $77016[d2*4] into local frame buffer a4
; $77016 = plane A palette data table; each entry is a longword (ROM pointer)
    pea     ($0020).w
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$00077016,a0
    move.l  (a0,d0.l), -(a7)
    jsr MemMove
; MemMove($20 bytes): copy 32 bytes from $7702E[d2*4] into a4+$20 (second palette block)
    pea     ($0020).w
    move.l  a4, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$0007702E,a0
    move.l  (a0,d0.l), -(a7)
    jsr MemMove
; MemMove($20 bytes): copy 32 bytes from $7701A[d2*4] into a2 (second buffer plane A)
    pea     ($0020).w
    move.l  a2, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$0007701A,a0
    move.l  (a0,d0.l), -(a7)
    jsr MemMove
; MemMove($20 bytes): copy 32 bytes from $77032[d2*4] into a4+$60 (second buffer plane B)
    pea     ($0020).w
    move.l  a4, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$00077032,a0
    move.l  (a0,d0.l), -(a7)
    jsr MemMove
    lea     $30(a7), a7
; RenderColorTileset(a4, a2, mode=0, count=$20, step=6):
; Renders and DMAss the assembled palette data as a color scroll / gradient display
    pea     ($0006).w
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    move.l  a4, -(a7)
    bsr.w RenderColorTileset
; WaitForStartButton($20 = 32 frames): hold each palette frame for 32 frames
    pea     ($0020).w
    bsr.w WaitForStartButton
    lea     $18(a7), a7
    tst.w   d0
    bne.w   l_3bea6
    addq.w  #$1, d2
; Show 5 palette scroll frames (d2 < 5)
    cmpi.w  #$5, d2
    bcs.w   l_3bfb0
; --- Phase: Final Start Wait Before Globe Sweep Ends ---
; WaitForStartButton($40 = 64 frames): final pause -- press Start to skip, else continue
    pea     ($0040).w
    bsr.w WaitForStartButton
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_3bea6
; --- Phase: Globe Coordinate Sweep ($110 = 272 frames) ---
; This section computes (x,y) screen coordinates for a sprite following an arc
; using CalcScreenCoord: maps (frame, amplitude) to a coordinate via sine-wave calculation
    clr.w   d2
l_3c070:
; CalcScreenCoord(d2, 0, $10F - d2, $130):
; Arg1=d2 (frame), Arg2=0 (X param), Arg3=$10F-d2 (decreasing Y), Arg4=$130 (amplitude)
; Returns d0 = computed X screen coordinate for this frame's globe position
    move.w  d2, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  #$10f, d0
    sub.w   d2, d0
    move.l  d0, -(a7)
    pea     ($0130).w
    bsr.w CalcScreenCoord
; d3 = X coordinate from first CalcScreenCoord call
    move.w  d0, d3
; CalcScreenCoord(d2, $10F-d2, $10F-d2, $110):
; Both time params sweep from $10F to 0 -> computes Y coordinate along the arc
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  #$10f, d0
    sub.w   d2, d0
    move.l  d0, -(a7)
    move.w  #$10f, d0
    sub.w   d2, d0
    move.l  d0, -(a7)
    pea     ($0110).w
    bsr.w CalcScreenCoord
    lea     $20(a7), a7
; d4 = Y coordinate from second CalcScreenCoord call
    move.w  d0, d4
; Subtract $30 (48) from both X and Y to center the globe sprite on screen
    ext.l   d0
    subi.l  #$30, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    subi.l  #$30, d0
    move.l  d0, -(a7)
; GameCommand #$F: place globe sprite tile $7481E at computed (X-$30, Y-$30)
; $7481E = globe sprite tile graphic (animated spinning globe during intro flyover)
    pea     ($0007481E).l
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a3)
; WaitForStartButton(1 frame): advance one frame per coordinate step
    pea     ($0001).w
    bsr.w WaitForStartButton
    lea     $1c(a7), a7
    tst.w   d0
    bne.w   l_3bea6
    addq.w  #$1, d2
; Run $110 (272) frames of globe arc animation
    cmpi.w  #$110, d2
    bcs.b   l_3c070
; --- Phase: Post-Globe Setup and Opening Animation ---
; GameCommand #$10: clear globe sprite area (mode=2, arg=0)
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
; MemMove($80 bytes): copy 128 bytes from ROM $FF14BC (tile_buf) into local frame a4
; tile_buf holds 64-byte resource table; copying for opening animation data staging
    pea     ($0080).w
    move.l  a4, -(a7)
    pea     ($00FF14BC).l
    jsr MemMove
; RenderColorTileset(args): render the opening animation color gradient frame
; Arg: palette from ROM $48D30, count=$40, step=6, a4 staged data
    pea     ($0006).w
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00048D30).l
    move.l  a4, -(a7)
    bsr.w RenderColorTileset
    lea     $2c(a7), a7
; SetScrollBarMode: reset scroll bar (mode=3, speed=2, flags=0,0,0) -- clear scroll anim
    pea     ($0003).w
    pea     ($0002).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetScrollBarMode
; UpdateScrollRegisters($FFFF, 0, 0): reset scroll offsets to zero for title screen entry
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$ffff, -(a7)
    bsr.w UpdateScrollRegisters
; GameCommand #$10: final display enable (arg=$40 = priority flush, mode=2)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $2c(a7), a7
; GameCommand #$1A: place final title screen tile block from no source (clear + bg setup)
; Sets up the "PRESS START" overlay for the title screen
    move.l  #$8000, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
l_3c170:
    movem.l -$9c(a6), d2-d4/a2-a5
    unlk    a6
    rts
