if [file exists "work"] {vdel -all}
vlib work
vlog FIFO_Package.sv  async_interface.sv async_fifo.sv testbench.sv async_basetest.sv async_driver.sv async_env.sv  async_read_agent.sv async_scoreboard.sv async_seq_item.sv async_sequence_basetest.sv async_sequence_fulltest.sv async_sequence_randomtest.sv async_sequencer.sv async_write_agent.sv coverage.sv async_write_agent.sv read_monitor.sv write_monitor.sv

#we will run the below commands to see the injected bug
#vlog +define+EMPTY_BUG -sv async_fifo.sv
#vlog +define+FULL_BUG -sv async_fifo.sv

vsim -vopt work.tb_top -coverage  -voptargs="+cover=bcesf"

coverage exclude -src N:/work/work/async_driver.sv -line 25
coverage exclude -src N:/work/work/async_driver.sv -line 26
coverage exclude -src N:/work/work/async_driver.sv -line 93
coverage exclude -src N:/work/work/async_driver.sv -line 94
coverage exclude -src N:/work/work/read_monitor.sv -line 33
coverage exclude -src N:/work/work/read_monitor.sv -line 34
coverage exclude -src N:/work/work/write_monitor.sv -line 32
coverage exclude -src N:/work/work/write_monitor.sv -line 33




coverage report -code bcesf

set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

coverage save async_fifo.ucdb
vcover report async_fifo.ucdb
vcover report async_fifo.ucdb -cvg -details
vcover report -html output
