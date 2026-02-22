# System Execution Flow -- Aerobiz Supersonic

Boot sequence, main loop, and interrupt handler documentation.
Updated as the disassembly progresses.

## Boot Sequence

(To be documented after tracing the reset vector)

```
Reset Vector ($000004)
  -> entry_point
    -> hardware initialization (VDP, Z80, controllers)
    -> RAM clear
    -> load sound driver to Z80
    -> display KOEI logo?
    -> title screen
    -> main game loop
```

## Main Loop

(To be documented)

## V-INT Handler

(To be documented -- this is typically the most important interrupt)

```
V-INT (Level 6 Interrupt)
  -> save registers
  -> VDP status read (acknowledge interrupt)
  -> DMA transfers (V-Blank is the safe window)
  -> controller reading
  -> sound driver communication
  -> game state update triggers
  -> restore registers
  -> RTE
```

## H-INT Handler

(To be documented if used -- many Genesis games don't use H-INT)

## Game State Machine

(To be documented -- Aerobiz likely has states for:)
- Title screen / KOEI logo
- Main menu
- New game setup (airline selection, starting city)
- Quarterly turn (route planning, fleet management)
- Events / news
- Financial reports
- Save/Load
- Ending sequences
