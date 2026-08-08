# Stationeers Atmospherics — Cragspire Station

Full atmospherics build for a Stationeers dedicated server world (Cragspire, Mars2 / Hellas Crags): Mars-air collection, CO2 phase-change liquefaction, separate N2/O2/CO2 supply buffers, room regulation, and a closed-loop recapture system, all IC10-scripted and sectioned by control housing.

**Status: fully designed, not yet run in-game.** Treat everything here as a build plan, not a confirmed-working setup — see the Open Items section in the handoff log for what's still unverified.

## Diagrams

Open these directly in a browser (no server needed):

- [`diagrams/pid.html`](diagrams/pid.html) — full Process & Instrumentation Diagram. Eight numbered process areas, every device tagged, each IC10 housing drawn with its field-device wiring.
- [`diagrams/handoff-log.html`](diagrams/handoff-log.html) — engineering log: room target, design decisions, researched facts (with sources), open items, and the full IC10 script listing.

## Bill of materials

[`BOM.md`](BOM.md) — every structure and item needed, by Area, with quantities and a running total.

## Scripts

[`scripts/`](scripts) — the actual `.txt` IC10 files, same as what's loaded on the build machine at `Desktop\Stationeers IC10 Scripts\`. Import directly into an IC Housing in-game.

| File | Housing / role |
|---|---|
| `atmospherics_intake.ic10` | Area 100 — vent gating, no internal pressure limiter on Powered Vents so this is the only overpressure protection on the raw side |
| `atmospherics_compression.ic10` | Area 200 — Turbo Volume Pump bank + cooling telemetry + overpressure relief |
| `atmospherics_gassplit.ic10` | Area 300 — splits the post-condensation gas into N2 (own tank) and O2 (Area 500's tank bank); Area 300 is no longer passive |
| `atmospherics_co2supply.ic10` | Area 400 — Purge Valve drains Area 300's liquid CO2 into a gas buffer (Regulation has nowhere else to draw CO2 from; reuses what collection already condenses out instead of re-filtering raw Mars air) |
| `atmospherics_electrolyzer.ic10` | Area 500 — O2 supply + autoignition safety trip (H2/O2 mix ignites above 300°C) |
| `atmospherics_regulation.ic10` | Area 600 — holds the room at 60% N2 / 20% O2 / 20% CO2 @ 100 kPa; the only thing that ever adds gas to the room |
| `atmospherics_recapture.ic10` | Area 800, main housing — skims excess CO2 above 20%, plus Pollutant/Volatiles on any presence; everything captured goes to a tank, nothing returns to the room |
| `atmospherics_recapture_riders.ic10` | Area 800, companion housing — mirrors the main housing's pump state onto the O2 and N2 filters (7 devices needs more pins than one housing has) |
| `atmospherics_intake_compression.ic10` | Superseded — kept for history, has a dead CO2-drain branch (Celsius/Kelvin bug) |
| `hash_id.ic10` | Diagnostic — wire any unknown device to it to read its real `PrefabHash` instead of guessing |

## Notes for anyone building this

- Every device is direct-wired to an IC housing pin — no `HASH()` batch-addressing anywhere, since a wrong guessed hash fails silently instead of erroring. When a loop needs more devices than one housing's 6 pins allow (Area 800's Recapture, at 7), it's split across two housings rather than reaching for a hash.
- "Compressor" is not a real Stationeers device — the compression stage uses **Turbo Volume Pumps**.
- The Condensation Valve that separates liquid CO2 out of the gas line is fully passive — no IC10 wiring needed for it. Area 400 uses a second one (CV-402) as a backup on the Purge Valve's output, to catch gas that re-condenses before the buffer tank — a documented failure mode of Purge Valves.
- Area 200's exterior radiators must be the radiative **Medium Radiator**, not Medium **Convection** Radiator — Convection needs surrounding atmosphere to work and has no use in a vacuum.
- The Mars-air raw buffer (Area 100) and the liquid CO2 tanks (Area 300) are **Insulated** variants — real, separate Stationeers structures built from insulated kits — so their contents don't gain/lose heat from the surrounding environment.
- N2, O2, and CO2 each get their own storage — nothing is blended in a shared tank. Area 800's Recapture loop only ever returns gas to a tank; Regulation's three pumps are the sole path back into the room.
- Full reasoning, sourcing, and the list of what's still unverified is in the handoff log.
