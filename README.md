# Traffic Light Controller with Emergency Preemption
**Language**: SystemVerilog (IEEE 1800-2012)
**Difficulty**: Medium (Level 3)
**Domain**: Hierarchical Finite State Machine
**Engines**: In-Browser WASM & Cloud Server

## Specifications
Main Road and Side Road controller:
- Vehicle sensor on side road (`side_car`).
- Emergency siren signal (`emergency`) immediately forces all red, then green for Main road.
- Timed Green, Yellow, and All-Red pedestrian safety intervals.
