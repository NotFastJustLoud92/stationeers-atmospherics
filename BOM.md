# Bill of Materials — Cragspire Atmospherics

Structures and items needed to build this system, grouped by Area (matches the [P&ID](diagrams/pid.html)). Status: designed, not yet run in-game — see the [handoff log](diagrams/handoff-log.html) for what's still unverified.

## Area 100 — Collection
| Device | Qty | Notes |
|---|---|---|
| Large Powered Vent | 4 | Mode set to Inward once placed |
| Pipe Analyzer | 1 | `rawSensor` |
| Digital Valve | 1 | `reliefValve` |
| Large Tank (Insulated) | 1 | Mars atmosphere raw buffer, 50,000 L — insulated so its pressure doesn't swing with exterior temperature |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_intake.ic10` |

## Area 200 — Compression & Cooling
| Device | Qty | Notes |
|---|---|---|
| Turbo Volume Pump | 2 | `pump1`/`pump2` |
| Pipe Analyzer | 2 | `tankSensor`, `coolSensor` |
| Digital Valve | 1 | `reliefValve` |
| Indicator Light (or equivalent) | 1 | `statusLight` — never confirmed the exact in-game device name, see Open Items |
| **Medium Radiator (radiative, not Convection)** | your call | passive, not IC-controlled; add more length until `statusLight` confirms CO2 is condensing. Radiators sit exterior on Mars, dumping heat into a thin/near-vacuum atmosphere — Medium **Convection** Radiator exchanges heat with surrounding atmosphere and has "no use in a vacuum," so it won't work here. Use the plain radiative Medium Radiator. |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_compression.ic10` |

## Area 300 — Phase Separation & Storage
| Device | Qty | Notes |
|---|---|---|
| Condensation Valve | 1 | CV-301, passive liquid separator |
| Large Liquid Tank (Insulated) | 2 | holds byproduct liquid CO2 — insulated so it doesn't warm and re-vaporize before the Purge Valve in Area 400 draws it off |
| Filtration | 2 | FIL-301 (N2 filter), FIL-302 (O2 filter) — splits the post-condensation gas instead of dumping N2+O2 into one shared tank |
| Pipe Analyzer | 2 | `n2Sensor`, `o2Sensor` |
| Large Tank | your call | N2 tank — diagram shows 3 as representative, size to your needs. O2 output is piped to Area 500's tank bank instead of a separate local tank |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_gassplit.ic10` — Area 300 is no longer passive |

## Area 400 — CO2 Supply
| Device | Qty | Notes |
|---|---|---|
| Purge Valve | 1 | `liquidPurge` — drains Area 300's Liquid Tank, reuses CO2 already condensed there instead of re-filtering raw Mars air |
| Condensation Valve | 1 | CV-402, backup — catches gas that re-condenses before the buffer tank, passive, no pin needed |
| Tank | 1 | CO2 buffer |
| Pipe Analyzer | 1 | `co2Sensor` |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_co2supply.ic10` |

## Area 500 — O2 Supply
| Device | Qty | Notes |
|---|---|---|
| Electrolyzer | 1 | ice-fed, manual haul — unchanged |
| Pipe Analyzer | 2 | `outputTemp`, `o2Sensor` |
| Digital Valve | 1 | `safetyVent` — autoignition safety |
| Indicator Light | 1 | `statusLight` |
| Large Tank | 2+ | O2 storage bank — now the shared destination for 3 sources: the electrolyzer, Area 300's collected O2, and Area 800's recaptured O2 |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_electrolyzer.ic10` |

## Area 600 — Regulation
| Device | Qty | Notes |
|---|---|---|
| Gas Sensor | 1 | `sensor` |
| Turbo Volume Pump | 3 | `n2Pump`, `o2Pump`, `co2Pump` — upgraded from Volume Pump (2026-08-07) for faster response to room demand swings |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_regulation.ic10` |

## Area 800 — Recapture
| Device | Qty | Notes |
|---|---|---|
| Gas Sensor | 1 | `sensor` |
| Volume Pump | 1 | `recyclePump` |
| Filtration | 5 | FIL-801 (O2), FIL-802 (CO2), FIL-803 (N2), FIL-804 (Pollutant), FIL-805 (Volatiles) — one cartridge each, no more shared units |
| IC Housing + Integrated Circuit (IC10) | 2 | main housing runs `atmospherics_recapture.ic10`; companion runs `atmospherics_recapture_riders.ic10` — one housing only has 6 pins and this loop needs 7 devices |

## Filter cartridges (consumable items, not structures)
| Filter | Total | Goes into |
|---|---|---|
| N2 filter | 2 | FIL-301 (Area 300), FIL-803 (Area 800) |
| O2 filter | 2 | FIL-302 (Area 300), FIL-801 (Area 800) |
| CO2 filter | 1 | FIL-802 (Area 800) |
| Pollutant filter | 1 | FIL-804 (Area 800) |
| Volatiles filter | 1 | FIL-805 (Area 800) |

## Diagnostics
| Device | Qty | Notes |
|---|---|---|
| IC Housing + Integrated Circuit (IC10) | 1 | for `hash_id.ic10` — standing tool for reading real `PrefabHash`es |

## Totals
- **Structures (fixed quantities): 58** — 4 Large Powered Vent, 5 Turbo Volume Pump, 1 Volume Pump, 8 Pipe Analyzer, 2 Gas Sensor, 3 Digital Valve, 2 Indicator Light, 7 Filtration, 1 Electrolyzer, 2 Condensation Valve, 1 Purge Valve, 1 Large Tank (Insulated), 2 Large Liquid Tank (Insulated), 1 Tank, 9 IC Housing, 9 Integrated Circuit (IC10)
- **Structures (variable, sized to your build)**: Large Tank (Area 300 N2 bank, Area 500 O2 bank), Medium Radiator ×N (Area 200), plus pipe/cable as needed
- **Consumables: 7 filter cartridges** across 7 Filtration units (2 in Area 300 — N2/O2 split; 5 in Area 800 — Recapture)
