if [file exists "work"] {vdel -all}
vlib work
vlog FIFO_Package.sv async_fifo.sv testbench.sv async_basetest.sv async_driver.sv async_env.sv async_fulltest.sv async_interface.sv async_randomtest.sv async_read_agent.sv async_scoreboard.sv async_seq_item.sv async_sequence_basetest.sv async_sequence_fulltest.sv async_sequence_randomtest.sv async_sequencer.sv async_write_agent.sv coverage.sv async_write_agent.sv read_monitor.sv write_monitor.sv

#we will run the below command to see the injected bug

#vlog +define+BUG_INJECTION -sv async_fifo.sv

#vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll basetest.ucdb;" -voptargs="+cover=bcesf"
#vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll fulltest.ucdb;" -voptargs="+cover=bcesf"
#vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll randomtest.ucdb;" -voptargs="+cover=bcesf"

vsim -vopt work.tb_top -coverage  -voptargs="+cover=bcesf"
#vsim -vopt work.tb_top -coverage  -voptargs="+cover=bcesf"
#vsim -vopt work.tb_top -coverage  -voptargs="+cover=bcesf"

run -all


vcover merge output basetest.ucdb fulltest.ucdb randomtest.ucdb
vcover report -html output

coverage report -code bcesf
coverage report -codeAll
#coverage report -assert -binrhs -details -cvg
