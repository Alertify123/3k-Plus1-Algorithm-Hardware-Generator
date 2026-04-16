add wave clk
add wave reset
add wave number_out
add wave term
add wave length
add wave done


force clk 0 0, 1 10 -r 20

force reset 1 0, 0 20

run 1350 ns
