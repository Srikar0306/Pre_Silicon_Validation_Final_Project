vlib work

vlog FIFO_package.sv fifoenvironment.sv async_fifo.sv testbench.sv transaction.sv interface.sv fifotest.sv fifoscoreboard.sv fifomonitor.sv fifogenerator.sv fifodriver.sv


vsim -coverage tb_top -voptargs="+cover=bcesf"
vlog -cover bcs async_fifo.sv
vsim -coverage tb_top -do "run -all; exit"
run -all
coverage report -code bcesf
coverage report -assert -binrhs -details -cvg
vcover report -html coverage_results
coverage report -codeAll