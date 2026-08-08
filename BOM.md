# Bill of Materials — Cragspire Atmospherics

Structures and items needed to build this system, grouped by Area (matches the [P&ID](diagrams/pid.html)). Status: designed, not yet run in-game — see the [handoff log](diagrams/handoff-log.html) for what's still unverified.

## Area 100 — Collection
| Device | Qty | Notes |
|---|---|---|
| Large Powered Vent | 4 | Mode set to Inward once placed |
| Pipe Analyzer | 1 | `rawSensor_100` |
| Digital Valve | 1 | `reliefValve_100` |
| Large Tank (Insulated) | 1 | Mars atmosphere raw buffer, 50,000 L — insulated so its pressure doesn't swing with exterior temperature |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_intake.ic10` |

## Area 200 — Compression & Cooling
| Device | Qty | Notes |
|---|---|---|
| Turbo Volume Pump | 2 | `pump1_200`/`pump2_200` |
| Pipe Analyzer | 2 | `tankSensor_200`, `coolSensor_200` |
| Digital Valve | 1 | `reliefValve_200` |
| Indicator Light (or equivalent) | 1 | `statusLight_200` — never confirmed the exact in-game device name, see Open Items |
| **Medium Radiator (radiative, not Convection)** | your call | passive, not IC-controlled; add more length until `statusLight_200` confirms CO2 is condensing. Radiators sit exterior on Mars, dumping heat into a thin/near-vacuum atmosphere — Medium **Convection** Radiator exchanges heat with surrounding atmosphere and has "no use in a vacuum," so it won't work here. Use the plain radiative Medium Radiator. |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_compression.ic10` |

## Area 300 — Phase Separation & Storage
| Device | Qty | Notes |
|---|---|---|
| Condensation Valve | 3 | CV-301/302/303, passive liquid separators run in parallel off the same gas line — redundancy, not sequential stages |
| Large Liquid Tank (Insulated) | 2 | holds byproduct liquid CO2 — insulated so it doesn't warm and re-vaporize before the Purge Valve in Area 400 draws it off |
| Filtration | 2 | FIL-301 (N2 filter), FIL-302 (O2 filter) — splits the post-condensation gas instead of dumping N2+O2 into one shared tank |
| Pipe Analyzer | 2 | `n2Sensor_300`, `o2Sensor_300` |
| Digital Valve | 2 | XV-302 (N2 tank relief), XV-303 (O2 network relief) — overpressure backstops, vent to exterior |
| Large Tank | your call | N2 tank — diagram shows 3 as representative, size to your needs. O2 output is piped to Area 500's tank bank instead of a separate local tank |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_gassplit.ic10` — Area 300 is no longer passive |

## Area 400 — CO2 Supply
| Device | Qty | Notes |
|---|---|---|
| Purge Valve | 1 | `liquidPurge_400` — drains Area 300's Liquid Tank, reuses CO2 already condensed there instead of re-filtering raw Mars air |
| Condensation Valve | 1 | CV-402, backup — catches gas that re-condenses before the buffer tank, passive, no pin needed |
| Tank | 1 | CO2 buffer (TK-401) |
| Pipe Analyzer | 2 | `co2Sensor_400`, `liquidSensor_400` (PA-402, reads TK-301 in Area 300) |
| Liquid Digital Valve | 1 | XV-403, TK-301 relief — liquid pipes burst at only 6,080 kPa, 10% of a gas pipe, so this trips well under that |
| Digital Valve | 1 | XV-404, CO2 buffer (TK-401) relief |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_co2supply.ic10` |

## Area 500 — Gas Production
| Device | Qty | Notes |
|---|---|---|
| Ice Crusher | 2 | ICR-501 (Oxite-fed, manual haul), ICR-502 (Nitrice-fed, manual haul) — replaces the Electrolyzer (2026-08-07) |
| Filtration | 3 | FIL-501 (O2 filter), FIL-502 (N2 filter), FIL-503 (N2O filter) |
| Pipe Analyzer | 3 | `o2Sensor_500` (PA-502), `n2Sensor_500` (PA-503), `n2oSensor_500b` (PA-504) |
| Digital Valve | 1 | XV-502, N2O buffer relief — kept modest (1,500 kPa) since the real risk is condensation, not tank burst |
| Tank | 1 | TK-502, N2O buffer — keep indoors at room temperature, low pressure; N2O condenses far more easily than anything else in this build |
| Large Tank | 2+ | TK-501, O2 storage bank — shared destination for 3 sources: Oxite-fed ICR-501, Area 300's collected O2, and Area 800's recaptured O2 |
| IC Housing + Integrated Circuit (IC10) | 2 | `atmospherics_icecrusher.ic10` (Oxite branch: O2 + N2) and `atmospherics_n2osupply.ic10` (Nitrice branch: N2O) |

## Area 600 — Regulation
| Device | Qty | Notes |
|---|---|---|
| Gas Sensor | 1 | `sensor_600` |
| Turbo Volume Pump | 3 | `n2Pump_600`, `o2Pump_600`, `co2Pump_600` — upgraded from Volume Pump (2026-08-07) for faster response to room demand swings |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_regulation.ic10` |

## Area 800 — Recapture
| Device | Qty | Notes |
|---|---|---|
| Gas Sensor | 1 | `sensor_800` |
| Volume Pump | 1 | `recyclePump_800` |
| Tank | 3 | TK-801 (emergency buffer, passive, reserve room air if the base depressurizes), TK-802 (Pollutant storage), TK-803 (Methane + Hydrogen mix — Volatile Ice safety contingency) |
| Filtration | 5 | FIL-801 (O2), FIL-802 (CO2), FIL-803 (N2), FIL-804 (Pollutant), FIL-805 (Methane + Hydrogen — one unit, two cartridges loaded) |
| IC Housing + Integrated Circuit (IC10) | 2 | main housing runs `atmospherics_recapture.ic10`; companion runs `atmospherics_recapture_riders.ic10` — one housing only has 6 pins and this loop needs 7 devices |

## Filter cartridges (consumable items, not structures)
| Filter | Total | Goes into |
|---|---|---|
| N2 filter | 3 | FIL-301 (Area 300), FIL-502 (Area 500), FIL-803 (Area 800) |
| O2 filter | 3 | FIL-302 (Area 300), FIL-501 (Area 500), FIL-801 (Area 800) |
| N2O filter | 1 | FIL-503 (Area 500) |
| CO2 filter | 1 | FIL-802 (Area 800) |
| Pollutant filter | 1 | FIL-804 (Area 800) |
| Methane filter | 1 | FIL-805 (Area 800) — same gas as "Volatiles," renamed in a game update |
| Hydrogen filter | 1 | FIL-805 (Area 800) — second cartridge in the same unit as the Methane filter |

## Diagnostics
| Device | Qty | Notes |
|---|---|---|
| IC Housing + Integrated Circuit (IC10) | 1 | for `hash_id.ic10` — standing tool for reading real `PrefabHash`es |

## Totals
- **Structures (fixed quantities): 75** — 4 Large Powered Vent, 5 Turbo Volume Pump, 1 Volume Pump, 10 Pipe Analyzer, 2 Gas Sensor, 6 Digital Valve, 1 Liquid Digital Valve, 1 Indicator Light, 10 Filtration, 2 Ice Crusher, 4 Condensation Valve, 1 Purge Valve, 1 Large Tank (Insulated), 2 Large Liquid Tank (Insulated), 5 Tank, 10 IC Housing, 10 Integrated Circuit (IC10)
- **Structures (variable, sized to your build)**: Large Tank (Area 300 N2 bank, Area 500 O2 bank), Medium Radiator ×N (Area 200), plus pipe/cable as needed
- **Consumables: 11 filter cartridges** across 10 Filtration units (2 in Area 300 — N2/O2 split; 3 in Area 500 — O2/N2/N2O; 5 in Area 800 — Recapture, one of which holds 2 cartridges)
