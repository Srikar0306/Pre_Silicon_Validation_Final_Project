 import uvm_pkg::*;
`include "uvm_macros.svh"
 import fifo_pkg::*;


//******************Read Agent********************

class read_agent extends uvm_agent;
//`uvm_component_utils(read_agent)//component registration
typedef uvm_component_registry#(read_agent,"read_agent") type_id;


read_sequencer rs;//instantiating read sequencer and declaring handle
read_driver rd;//instantiating read driver and declaring handle
read_monitor rm;////instantiating read monitor and declaring handle

//Standard UVM Constructor
function new (string name = "read_agent", uvm_component parent);
super.new(name, parent);
`uvm_info("READ_AGENT_CLASS", "Inside constructor",UVM_LOW);
endfunction


//Build Phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
	
		rs = read_sequencer::type_id::create("rs", this);//Object creation for read sequencer
		rd = read_driver::type_id::create("rd", this);//Object creation for read driver
		rm = read_monitor::type_id::create("rm", this);//Object creation for read monitor

endfunction

//Connect Phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
rd.seq_item_port.connect(rs.seq_item_export);//connecting read driver port to read sequencer export

endfunction

//Run Phase
task run_phase(uvm_phase phase);
super.run_phase(phase);
endtask
endclass
