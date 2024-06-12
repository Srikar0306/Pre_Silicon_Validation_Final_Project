package fifo_pkg;

	`include "async_seq_item.sv"
	

//base test
`include "async_sequence_basetest.sv"
//full test
`include "async_sequence_fulltest.sv"
//random test
`include "async_sequence_randomtest.sv"
//half full test
//'include "async_sequence_halffulltest.sv"
//half empty test
//'include "async_sequence_halfemptytest.sv"
	`include "async_sequencer.sv"
	`include "async_driver.sv"
	`include "write_monitor.sv"
	`include "read_monitor.sv"
	`include "async_write_agent.sv"
	`include "async_read_agent.sv"
	`include "async_scoreboard.sv"

		
endpackage
