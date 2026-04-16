# 3k+1 (Collatz) Sequence Generator

This project implements a **3k+1 (Collatz) Sequence Generator** in VHDL with two versions of the same algorithm:

- `part1.vhd`: single-process behavioral implementation.
- `part2.vhd`: ASM/FSM-style implementation with datapath control signals.

Both designs use fixed-width unsigned arithmetic and expose the same top-level outputs.

## Signal Mapping

The table below maps internal registers/signals used in each implementation to the top-level output ports and their algorithm meaning.

| Algorithm meaning | `part1.vhd` internal name | `part2.vhd` internal name | Output port |
|---|---|---|---|
| Current starting value `n` being tested | `number` | `number_reg` | `number_out` |
| Current Collatz term for active sequence | `term` | `term` | `term_out` |
| Completion flag asserted when termination criterion is reached (`length >= 9` at `term = 1`) | `done` | `done` | `done_out` |
| Sequence length counter for current `n` (internal only) | `length` | `length` | *(not exported)* |

## ModelSim helper scripts

### `part1.do`

Expected waveforms:

- **Ports**: `clk`, `reset`, `number_out`.
- **Internal signals**: `term`, `length`, `done`.

In `part1.vhd`, only `number_out`, `term_out`, and `done_out` are entity outputs; `term`, `length`, and `done` in the script are internal architecture signals being viewed directly for debugging.

### `part2.do`

Expected waveforms:

- **Ports**: `clk`, `reset`, `number_out`.
- **Internal signals**: `state`, `term`, `length`, `done`.

`state` is an internal FSM signal (no output port). As in `part1.do`, `term`, `length`, and `done` refer to internals; the corresponding output ports are `term_out` and `done_out`.

## Fixed 7-bit width note

Both implementations use `unsigned(6 downto 0)` registers/signals, so values are constrained to **7 bits (0..127)**.

- This keeps logic small and simple for FPGA demonstration.
- Tradeoff: intermediate or final values beyond 127 wrap/truncate due to fixed-width arithmetic.

The odd-term update expression

```vhdl
resize((term * 3) + 1, 7)
```

is used in:

- `part1.vhd` (behavioral process, `CALC_NEXT` branch).
- `part2.vhd` (datapath update when `do_mult = '1'`).
