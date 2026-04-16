add wave clk
add wave reset
add wave state
add wave number_out
add wave term
add wave length
add wave done

force clk 0 0, 1 2 -r 4

# X in the beginning
force reset 0 0, 1 2, 0 6

run 60 ns

