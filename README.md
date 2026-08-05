# Stationeers Atmospherics — Cragspire Station

Full atmospherics build for a Stationeers dedicated server world (Cragspire, Mars2 / Hellas Crags): Mars-air collection, CO2 phase-change liquefaction, O2/CO2 supply buffers, room regulation, and CO2 recapture, all IC10-scripted and sectioned by control housing.

**Status: fully designed, not yet run in-game.** Treat everything here as a build plan, not a confirmed-working setup — see the Open Items section in the handoff log for what's still unverified.

## Diagrams

Open these directly in a browser (no server needed):

- [`diagrams/pid.html`](diagrams/pid.html) — full Process & Instrumentation Diagram. Eight numbered process areas, every device tagged, each IC10 housing drawn with its field-device wiring.
- [`diagrams/handoff-log.html`](diagrams/handoff-log.html) — engineering log: room target, design decisions, researched facts (with sources), open items, and the full IC10 script listing.

## Scripts

[`scripts/`](scripts) — the actual `.txt` IC10 files, same as what's loaded on the build machine at `Desktop\Stationeers IC10 Scripts\`. Import directly into an IC Housing in-game.

| File | Housing / role |
|---|---|
| `atmospherics_intake.ic10` | Area 100 — vent gating, no internal pressure limiter on Powered Vents so this is the only overpressure protection on the raw side |
| `atmospherics_compression.ic10` | Area 200 — Turbo Volume Pump bank + cooling telemetry + overpressure relief |
| `atmospherics_co2supply.ic10` | Area 400 — taps raw Mars air for a CO2 gas buffer (Regulation has nowhere else to draw CO2 from) |
| `atmospherics_electrolyzer.ic10` | Area 500 — O2 supply + autoignition safety trip (H2/O2 mix ignites above 300°C) |
| `atmospherics_regulation.ic10` | Area 600 — holds the room at 60% N2 / 20% O2 / 20% CO2 @ 100 kPa |
| `atmospherics_recapture.ic10` | Area 800 — skims excess CO2 back out once it climbs above 20% |
| `atmospherics_intake_compression.ic10` | Superseded — kept for history, has a dead CO2-drain branch (Celsius/Kelvin bug) |
| `hash_id.ic10` | Diagnostic — wire any unknown device to it to read its real `PrefabHash` instead of guessing |

## Notes for anyone building this

- Every device is direct-wired to an IC housing pin — no `HASH()` batch-addressing anywhere, since a wrong guessed hash fails silently instead of erroring.
- "Compressor" is not a real Stationeers device — the compression stage uses **Turbo Volume Pumps**.
- The Condensation Valve that separates liquid CO2 out of the gas line is fully passive — no IC10 wiring needed for it.
- Full reasoning, sourcing, and the list of what's still unverified is in the handoff log.
