vlib work

vlog async_fifo.sv
vlog fifo_memory.sv
vlog sync_r2w.sv
vlog sync_w2r.sv
vlog rptr_empty.sv
vlog wptr_full.sv
vlog testbench.sv

vsim -c -gADDRSIZE=228 async_fifo_tb
vsim work.async_fifo_tb
vsim -voptargs=+acc work.async_fifo_tb
add wave -r *
add wave sim:/async_fifo_tb/* 
#do wave.do

run -all
