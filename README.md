# 3k-1-Algorithm-Hardware-Generator
## System Architecture
- [Architecture diagrams and design notes](docs/architecture.md)
# 3k+1 Hardware Generator on FPGA: Two RTL Architectures, One Verified Result

This project implements the 3k+1 (Collatz-style) sequence in synthesizable VHDL and compares two digital design approaches on the same problem: a compact single-process FSM and a structured ASM-style datapath/control split. The design challenge is interesting because it blends arithmetic transformation logic, cycle-by-cycle state control, and hardware-oriented verification to determine the smallest input value *k* that produces a sequence length of at least 9, then carry that implementation through simulation and FPGA synthesis.

## Project Summary

This repository contains an FPGA-oriented implementation of the 3k+1 sequence engine, developed as a digital design exercise and documented for technical reviewers outside the course context. The core objective is to iterate candidate values of *k*, compute their sequence lengths in hardware, and stop when the length threshold (≥ 9) is met. Two architectures are provided to show different RTL decomposition strategies while preserving equivalent behavior.

## What I Built

- A **single-clocked-process RTL design** (`part1.vhd`) that integrates state evolution, arithmetic operations, counters, and outputs in one synchronous process.
- An **ASM-style RTL design** (`part2.vhd`) with explicit separation between datapath and control unit, improving modularity and traceability of state transitions.
- Simulation automation scripts for each design (`part1.do`, `part2.do`) for repeatable ModelSim runs.
- Constraint and FPGA output artifacts targeting the Nexys A7 board and Vivado synthesis flow.

## Technical Stack

- **Language:** VHDL (synthesizable RTL)
- **Simulation:** ModelSim (`.do` automation scripts)
- **Synthesis / Implementation:** Xilinx Vivado
- **FPGA Target:** Digilent **Nexys A7**

## Design 1: Single Clocked Process

The first implementation in [`part1.vhd`](./part1.vhd) uses a single synchronous process to manage:

- sequence update rule (even/odd branch),
- k-search progression,
- iteration counting,
- terminal condition detection,
- and output signaling.

This style is concise and straightforward for smaller state machines, with all behavior visible in one process body.

## Design 2: ASM Datapath + Control Unit

The second implementation in [`part2.vhd`](./part2.vhd) follows an Algorithmic State Machine (ASM) mindset:

- **Datapath** handles registers, arithmetic, comparators, and counters.
- **Control unit** orchestrates enables/selects and state transitions.

This decomposition mirrors industry RTL practices for medium/large controllers where verification and maintenance benefit from clear functional boundaries.

## Results

- **Computed result:** the smallest value of **k** with sequence length **≥ 9** is **6**.
- **Verification evidence:** waveform exports are included for both architectures:
  - `part1_wave.pdf`
  - `part2_wave.pdf`
- **Implementation artifacts:** generated FPGA outputs and intermediate artifacts are included (`process.bit`, `asm.bit`, `process.vdi`, `asm.vdi`).

## Repository Structure

| File | Purpose |
|---|---|
| `part1.vhd` | Single-process clocked RTL implementation |
| `part2.vhd` | ASM datapath + control RTL implementation |
| `3k.xdc` | FPGA pin/timing constraints |
| `part1.do` | ModelSim script for Design 1 simulation |
| `part2.do` | ModelSim script for Design 2 simulation |
| `part1_wave.pdf` | Waveform report for Design 1 |
| `part2_wave.pdf` | Waveform report for Design 2 |
| `process.bit` / `asm.bit` | Vivado bitstreams for both implementations |
| `process.vdi` / `asm.vdi` | Generated implementation/debug artifacts |

## How to Reproduce

1. **Simulate in ModelSim**
   - Load design + testbench sources.
   - Execute the relevant do-file:
     - `do part1.do`
     - `do part2.do`
   - Inspect waveform outputs and confirm threshold detection behavior.

2. **Synthesize/Implement in Vivado**
   - Create/open project targeting Nexys A7 device.
   - Add `part1.vhd` or `part2.vhd` and apply `3k.xdc`.
   - Run synthesis, implementation, and bitstream generation.
   - Optionally program board and observe outputs.

## Key Engineering Decisions

- Used **`numeric_std`** for strongly typed, synthesis-friendly arithmetic (instead of non-standard numeric packages).
- Applied **`resize`** where signal width adaptation is required to avoid truncation ambiguity and preserve intent.
- Avoided **`while` loops** in synthesizable RTL control flow to keep hardware mapping explicit and timing-analyzable.
- Modeled sequence progression as finite-state behavior to ensure predictable cycle-level operation and cleaner verification.

## Recruiter Notes

This project demonstrates transferable digital hardware skills:

- **FSM architecture and control design** (single-process and ASM partitioned styles)
- **RTL reasoning** (cycle-accurate sequencing, arithmetic datapath behavior)
- **Verification discipline** (scripted simulation runs + waveform artifact review)
- **FPGA implementation flow** (constraints, synthesis, implementation, bitstream outputs)

> Course context: this was completed as an academic digital design project, but the README is intentionally structured for external technical evaluation.
