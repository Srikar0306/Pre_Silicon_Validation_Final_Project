 import uvm_pkg::*;
`include "uvm_macros.svh"
 import fifo_pkg::*;


//*********************Write Agent**************************


class write_agent extends uvm_agent;
`uvm_component_utils(write_agent)//component registration
//typedef uvm_component_registry#(write_agent,"write_agent") type_id;

write_sequencer ws;//instantiating read sequencer and declaring handle
write_driver wd;//instantiating read driver and declaring handle
write_monitor wm;//instantiating read monitor and declaring handle


//Standard UVM Constructor
function new (string name = "write_agent", uvm_component parent);
super.new(name, parent);
`uvm_info("WRITE_AGENT_CLASS", "Inside constructor",UVM_LOW);
endfunction

//Build Phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
	
		ws = write_sequencer::type_id::create("ws", this);////Object creation for read sequencer
		wd = write_driver::type_id::create("wd", this);//Object creation for read driver
		wm = write_monitor::type_id::create("wm", this);//Object creation for read monitor

endfunction

//Connect Phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
wd.seq_item_port.connect(ws.seq_item_export);//connecting write driver port to Write sequencer export

endfunction

//Run Phase
task run_phase(uvm_phase phase);
super.run_phase(phase);
endtask
endclass
