# part2.do waveform setup for 3k+1 (Collatz) Sequence Generator (ASM/FSM)
# NOTE: number_out is a top-level output port.
# NOTE: state, term, length, and done below are internal architecture signals (not top-level ports).

add wave clk
add wave reset
add wave state
add wave number_out
add wave term
add wave length
add wave done

force clk 0 0, 1 2 -r 4

# X values at startup are expected until reset sequencing settles.
force reset 0 0, 1 2, 0 6

run 60 ns
