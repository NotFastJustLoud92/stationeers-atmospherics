# Stationeers Atmospherics — Cragspire Station

Full atmospherics build for a Stationeers dedicated server world (Cragspire, Mars2 / Hellas Crags): Mars-air collection, CO2 phase-change liquefaction, Ice Crusher gas production, separate N2/O2/CO2/N2O supply buffers with relief valves throughout, room regulation, and a closed-loop recapture system, all IC10-scripted and sectioned by control housing.

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
| `atmospherics_gassplit.ic10` | Area 300 — splits the post-condensation gas into N2 (own tank) and O2 (Area 500's tank bank), plus relief valves on both; Area 300 is no longer passive |
| `atmospherics_co2supply.ic10` | Area 400 — Purge Valve drains Area 300's liquid CO2 into a gas buffer (Regulation has nowhere else to draw CO2 from; reuses what collection already condenses out instead of re-filtering raw Mars air), plus relief valves on the liquid tank and the CO2 buffer |
| `atmospherics_icecrusher.ic10` | Area 500 — replaces the Electrolyzer (2026-08-07): Ice Crusher fed Oxite, filtered into O2 and N2, feeding the same shared tanks Area 300 uses |
| `atmospherics_n2osupply.ic10` | Area 500 — second Ice Crusher fed Nitrice, filtered into N2O; kept at low pressure and room temperature on purpose since N2O condenses far more easily than anything else in this build |
| `atmospherics_regulation.ic10` | Area 600 — holds the room at 60% N2 / 20% O2 / 20% CO2 @ 100 kPa via three Turbo Volume Pumps; the only thing that ever adds gas to the room |
| `atmospherics_recapture.ic10` | Area 800, main housing — skims excess CO2 above 20%, plus Pollutant and Methane+Hydrogen on any presence; everything captured goes to a storage tank, nothing returns to the room or vents to exterior |
| `atmospherics_recapture_riders.ic10` | Area 800, companion housing — mirrors the main housing's pump state onto the O2 and N2 filters (7 devices needs more pins than one housing has) |
| `atmospherics_intake_compression.ic10` | Superseded — kept for history, has a dead CO2-drain branch (Celsius/Kelvin bug) |
| `hash_id.ic10` | Diagnostic — wire any unknown device to it to read its real `PrefabHash` instead of guessing |

## Notes for anyone building this

- Every device is direct-wired to an IC housing pin — no `HASH()` batch-addressing anywhere, since a wrong guessed hash fails silently instead of erroring. When a loop needs more devices than one housing's 6 pins allow (Area 800's Recapture, at 7), it's split across two housings rather than reaching for a hash.
- "Compressor" is not a real Stationeers device — the compression stage uses **Turbo Volume Pumps**.
- The Condensation Valve that separates liquid CO2 out of the gas line is fully passive — no IC10 wiring needed for it. Area 400 uses a second one (CV-402) as a backup on the Purge Valve's output, to catch gas that re-condenses before the buffer tank — a documented failure mode of Purge Valves.
- Area 200's exterior radiators must be the radiative **Medium Radiator**, not Medium **Convection** Radiator — Convection needs surrounding atmosphere to work and has no use in a vacuum.
- The Mars-air raw buffer (Area 100) and the liquid CO2 tanks (Area 300) are **Insulated** variants — real, separate Stationeers structures built from insulated kits — so their contents don't gain/lose heat from the surrounding environment.
- N2, O2, CO2, and N2O each get their own storage — nothing is blended in a shared tank. Area 800's Recapture loop only ever returns gas to a tank; Regulation's three pumps are the sole path back into the room.
- Area 500 produces gas by crushing ore, not electrolysis: an Ice Crusher fed Oxite yields ~90% O2 / 10% N2, and a second one fed Nitrice yields N2O. No H2 byproduct, no autoignition risk.
- N2O condenses far more easily than anything else in this build — its triple point sits around −21°C. Its supply branch is deliberately kept at low pressure and room temperature, the opposite of the CO2 line's high-pressure/cold-radiator approach.
- Every tank in the build has its own relief valve venting to exterior. TK-301 (liquid CO2) uses a **Liquid Digital Valve**, a real, separate device from the regular gas-side Digital Valve used everywhere else.
- Area 800 has a passive emergency buffer tank on its room-air intake, as a reserve in case the base depressurizes.
- Pollutant and Methane/Hydrogen aren't vented in Area 800 — they're captured to dedicated storage tanks (TK-802, TK-803) instead. This is a safety contingency: Volatile Ice melts into Methane + Hydrogen if it ends up inside the base, so Recapture treats any reading of either gas (or Pollutant) as something to scrub immediately, same as it already did for Pollutant alone. "Volatiles" was renamed to "Methane" in a game update — same gas.
- Full reasoning, sourcing, and the list of what's still unverified is in the handoff log.
