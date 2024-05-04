vlib work

vlog FIFO_package.sv fifoenvironment.sv async_fifo.sv testbench.sv transaction.sv interface.sv fifotest.sv fifoscoreboard.sv fifomonitor.sv fifogenerator.sv fifodriver.sv

vsim -c -voptargs=+acc work.tb_top -do "run -all" &
