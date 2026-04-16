# Validation Results

## What was validated

### Part 1: Single-process implementation
- **Functional sequence progression:** The datapath follows the expected 3k+1 transition behavior on each active cycle, producing the same iterative progression visible in the waveform trace.
- **`done` behavior:** The controller asserts `done` when the stopping condition is reached and holds the terminal state as expected.

### Part 2: ASM implementation
- **Functional sequence progression:** The ASM-controlled datapath executes the same 3k+1 step semantics across state transitions, with waveform evidence showing correct iterative updates.
- **`done` behavior:** `done` is asserted at completion in the terminal ASM state, indicating successful end-of-computation behavior.

## Evidence summary

| Artifact | Evidence type | What it supports |
|---|---|---|
| `part1_wave.pdf` | Simulation waveform | Single-process control/data progression and terminal `done` behavior |
| `part2_wave.pdf` | Simulation waveform | ASM state-driven progression and terminal `done` behavior |
| `process.vdi` | Synthesis/implementation log | Tool completion evidence for single-process design flow |
| `asm.vdi` | Synthesis/implementation log | Tool completion evidence for ASM design flow |
| `process.bit` | FPGA bitstream | Generated implementation artifact for single-process design |
| `asm.bit` | FPGA bitstream | Generated implementation artifact for ASM design |

## Interpretation
In plain terms, both versions repeatedly transform the current value using the same rule sequence and eventually signal “finished.” The waveform traces show the value updating step by step over time, and the `done` signal turning on at the end confirms that each implementation reaches a proper stopping point.

## Known constraints
- **7-bit datapath bound:** All arithmetic and state evolution are constrained to a 7-bit-wide representation.
- **Assignment-scoped objective:** Validation is scoped to the assignment goal (demonstrating correct operation for sequences with length **≥ 9**), not exhaustive proof over unbounded input widths.
