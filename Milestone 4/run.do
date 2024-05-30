vlib work
vlog FIFO_Package.sv async_fifo.sv testbench.sv async_basetest.sv async_driver.sv async_env.sv async_interface.sv async_read_agent.sv async_scoreboard.sv async_seq_item.sv async_sequence_basetest.sv async_sequencer.sv async_write_agent.sv async_write_agent.sv read_monitor.sv write_monitor.sv
vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll basetest.ucdb; run -all"
