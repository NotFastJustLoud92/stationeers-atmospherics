# Bill of Materials — Cragspire Atmospherics

Structures and items needed to build this system, grouped by Area (matches the [P&ID](diagrams/pid.html)). Status: designed, not yet run in-game — see the [handoff log](diagrams/handoff-log.html) for what's still unverified.

## Area 100 — Collection
| Device | Qty | Notes |
|---|---|---|
| Large Powered Vent | 4 | Mode set to Inward once placed |
| Pipe Analyzer | 1 | `rawSensor` |
| Digital Valve | 1 | `reliefValve` |
| Tank | 1 (optional) | Raw Buffer — could just be pipe volume, doesn't strictly need a tank |
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

## Area 300 — Phase Separation & Storage (passive, no IC housing)
| Device | Qty | Notes |
|---|---|---|
| Condensation Valve | 1 | passive liquid separator |
| Large Tank | your call | N2/O2 storage bank — diagram shows 3 as representative, size to your needs |
| Liquid Tank | 1 | holds byproduct liquid CO2 |

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
| Electrolyzer | 1 | ice-fed |
| Pipe Analyzer | 2 | `outputTemp`, `o2Sensor` |
| Digital Valve | 1 | `safetyVent` — autoignition safety |
| Indicator Light | 1 | `statusLight` |
| Large Tank | 2+ | O2 storage bank |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_electrolyzer.ic10` |

## Area 600 — Regulation
| Device | Qty | Notes |
|---|---|---|
| Gas Sensor | 1 | `sensor` |
| Volume Pump | 3 | `n2Pump`, `o2Pump`, `co2Pump` |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_regulation.ic10` |

## Area 800 — Recapture
| Device | Qty | Notes |
|---|---|---|
| Gas Sensor | 1 | `sensor` |
| Volume Pump | 1 | `recyclePump` |
| Filtration | 3 | O2+CO2, Pollutant, Volatiles cartridges |
| IC Housing + Integrated Circuit (IC10) | 1 | runs `atmospherics_recapture.ic10` |

## Filter cartridges (consumable items, not structures)
| Filter | Total | Goes into |
|---|---|---|
| O2 filter | 1 | FIL-801 |
| CO2 filter | 1 | FIL-801 |
| Pollutant filter | 1 | FIL-802 |
| Volatiles filter | 1 | FIL-803 |

## Diagnostics
| Device | Qty | Notes |
|---|---|---|
| IC Housing + Integrated Circuit (IC10) | 1 | for `hash_id.ic10` — standing tool for reading real `PrefabHash`es |

## Totals
- **Structures (fixed quantities): 47** — 4 Large Powered Vent, 2 Turbo Volume Pump, 4 Volume Pump, 6 Pipe Analyzer, 2 Gas Sensor, 3 Digital Valve, 2 Indicator Light, 3 Filtration, 1 Electrolyzer, 2 Condensation Valve, 1 Purge Valve, 1 Liquid Tank, 2 Tank, 7 IC Housing, 7 Integrated Circuit (IC10)
- **Structures (variable, sized to your build)**: Large Tank (Area 300 N2/O2 bank, Area 500 O2 bank), Medium Radiator ×N (Area 200), plus pipe/cable as needed
- **Consumables: 4 filter cartridges** across 3 Filtration units (all in Area 800 — Area 400 no longer filters, it reuses Area 300's liquid CO2)
