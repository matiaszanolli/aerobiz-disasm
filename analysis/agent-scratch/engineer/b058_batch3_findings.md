# B-058 Batch 3 Findings: section_030000.asm lines 14001–21243

## Summary

- **TODOs replaced**: 46
- **Range covered**: lines 14001–21243 of `disasm/sections/section_030000.asm`
- **Remaining TODOs in file**: 8 (all at lines 6183–6990, outside the assigned range)

## Functions Described (in order)

| Function | Description summary |
|---|---|
| RenderGameDialogs | Negotiation/dialog UI loop for a match slot with offer adjustment and partner browse |
| ValidateGameState | Checks if a character (by code pair) already exists in a player's active roster |
| FinalizeGameTurn | Checks alliance permission bit in $FFA7BC for two players; returns allowed/blocked |
| GameLoopExit | Stub exit point (RTS only, 2 bytes) |
| GraphicsCleanup | Loads world-map tile graphics and runs an animated display loop (136 frames) |
| LoadGraphicLine | Copies a row of graphic tiles from source buffer to work area at $FFAA64 |
| ShowCharPortrait | Renders character portrait sprite with name panel at given screen coordinates |
| LoadGameGraphics | Loads and uploads all in-game character/route/city graphics to VRAM |
| ResetGameState | Clears and initialises all key gameplay flags and window state variables |
| ClearTileArea | Fills entire background plane with blank tiles via GameCommand $1A |
| ParseDecimalDigit | Reads ASCII decimal digits and accumulates integer value; advances pointer |
| IntToDecimalStr | Recursive unsigned int-to-decimal ASCII string converter |
| IntToHexStr | Recursive unsigned int-to-hex ASCII string converter |
| AccumulateDigit | Clamps two width values to 0–32 and stores in text column counter variables |
| ClearTextBuffer | Resets text column counters to zero |
| SetCursorY | Sets text cursor Y position in $FFBDA6 |
| SetCursorX | Sets text cursor X position in $FF128A |
| SetTextCursorXY | Sets both cursor X and Y by calling SetCursorX then SetCursorY |
| CountFormatChars | Counts printable characters in a formatted string, skipping ESC sequences |
| RenderTextLine | Flushes current text line buffer to VDP via GameCommand $1B |
| SkipControlChars | Scans string counting printable chars while skipping ESC control sequences |
| FindCharInSet | Looks up a byte in the table at $048978; returns 1/0 |
| Vsprintf | Full C-style vsprintf: %d/%u/%x/%s/%c/%w, width, precision, left-align, zero-pad, $ |
| PrintfDirect | Formats string via Vsprintf into local buffer, then renders via RenderTextBlock |
| InitTextColors | Initialises text CRAM palette entries and uploads two palette rows to VDP |
| ClearSoundBuffer | Stops sound ($0D), reloads font tiles from ROM, re-enables display ($0C) |
| DelayFrames | Busy-wait N frames via GameCommand $0E countdown loop |
| FadeOutAndWait | Steps palette brightness 7→0 (fade out); returns 1 if interrupted |
| FadeInAndWait | Steps palette brightness 0→7 (fade in); returns 1 if interrupted |
| GameSetup1 | Company-name intro + title attract loop with fade/scroll animations |
| CalcScreenCoord | Computes weighted blend coordinate using Multiply32 + UnsignedDivide |
| WaitForStartButton | Polls controller up to N frames; returns 1 if Start pressed |
| DelayWithInputCheck | Delays N frames while detecting Start button; stores result in $FFA78E |
| RenderColorTileset | Animates 8-step palette-cycle color fade toward target palette |
| UpdateScrollRegisters | Updates VDP horizontal/vertical scroll registers for planes A and B |
| InitGameScreen | Loads graphics, resets state, renders 20-block scenario intro with pauses |
| PlayIntroSequence | Loads resources and configures scroll/display for intro animation |
| RunIntroLoop | Full intro/demo: 5 scenario previews, globe flyby, opening animation |
| ShowGameOverScreen | Clears screen and loads game-over graphics |
| LoadMapGraphics | Loads world-map LZ tiles, tiles to VRAM, animates scrolling region preview |
| RenderEndingCredits | Staff-roll screen with horizontal scroll oscillation and credit text blocks |
| RenderMainMenu | Main title-screen menu with option text and WaitForStartButton |
| GameSetup2 | Top-level new-game loop: intro → credits or main menu → Start button wait |
| ShowPlayerScreen | Routes to correct player status screen based on player index and airline type |
| InitStatusScreenGfx | Loads all status-screen background graphics and uploads to VRAM |
| RenderRouteStatus | Animated route status display with scrolling route-line sprites |
| RenderCharStats | Renders character statistics panel with stat bars and numeric values |
| SetVRAMWriteAddr | Sets VRAM write-address in shadow buffer and issues GameCommand $08/$05 |
| SetVRAMReadAddr | Sets VRAM read-address in shadow buffer and issues GameCommand $08/$05 |
| FillRectColor | Fills a rectangular plane area with solid color tiles |
| RenderPlayerStatusUI | Loads and uploads complete player-status panel graphics to VRAM |
| RenderDetailedStats | Full detailed player-stats screen: stat bars, aircraft icons, ShowPlayerDetailScreen |
| InitCursorPalette | Fills cursor CRAM at $FF159C with 64 white entries and uploads to VDP |
| ShowPlayerDetailScreen | Scrolling player detail screen with 17 text rows built from player data |
| ShowAlternatePlayerView | Alternate player info screen with competitor data in 17-row text panel |
| RenderPlayerListUI | 13-row player rankings screen built from player name table at $0658D2 |

## Notable Observations

1. **AccumulateDigit naming mismatch**: The function `AccumulateDigit` does not actually accumulate a digit in the arithmetic sense. It clamps and stores two text window width values (max column counters). The name suggests digit accumulation for number parsing, but the body is purely about text column bounds. The description reflects the actual behavior.

2. **GraphicsCleanup naming mismatch**: This function is the world-map animation/display routine, not a cleanup in the destructive sense. It loads graphics and runs an interactive animation loop. The name is misleading.

3. **ValidateGameState naming mismatch**: This is actually a roster membership check -- it looks up whether a character already exists in a player's active slot array. It does not validate general game state.

4. **FinalizeGameTurn naming mismatch**: This checks alliance permission from a bit table -- it does not finalize a turn. The actual logic is a bitfield lookup for alliance legality.

5. **SetVRAMWriteAddr / SetVRAMReadAddr**: These are shadow-register updaters that work through GameCommand $08/$05 -- they do not write directly to VDP ports. The distinction between write and read is which word offsets in $FF5804 are populated.

6. **Vsprintf**: A complete custom printf engine with support for `%d`, `%u`, `%x`, `%s`, `%c`, `%w` (wide string), field width, precision, left-align flag (`-`), zero-pad flag (`0`), and a `$` currency suffix. It writes to an intermediate 30-char stack buffer before copying to the destination.

## TODOs Not Resolved

None. All 46 TODOs in the assigned range (lines 14001–21243) have been replaced with concrete descriptions.

The 8 TODOs that remain in the file (lines 6183–6990: EvaluateCharPool, CheckCharAvailable, CalcCharValueAI, GetCharProfitAI, SortCharsByValue, StartMatchSequence, RunMatchTurn, ApplyMatchDamage) are outside the assigned range and were not touched.
