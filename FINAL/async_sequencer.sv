import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

//*********************Write Sequencer***********************


class write_sequencer extends uvm_sequencer #(transaction_write);//parameterized by write sequence item class
`uvm_component_utils(write_sequencer)//component registrattion
//typedef uvm_component_registry#(write_sequencer,"write_sequencer") type_id;

//Standard UVM Constructor 
function new (string name = "write_sequencer", uvm_component parent);
super.new(name, parent);
`uvm_info("WRITE_SEQUENCER_CLASS", "Inside constructor",UVM_LOW)
endfunction

//Build Phase
function void build_phase (uvm_phase phase);
super.build_phase(phase);
`uvm_info("WRITE_SEQUENCER_CLASS", "Build Phase",UVM_LOW)
endfunction

//Connect Phase
function void connect_phase (uvm_phase phase);
super.connect_phase(phase);
`uvm_info("WRITE_SEQUENCER_CLASS", "Connect Phase",UVM_LOW)
endfunction

endclass


//************************Read Sequencer***************************



class read_sequencer extends uvm_sequencer #(transaction_read);//parameterized by read sequence item class
`uvm_component_utils(read_sequencer)//component registration
//typedef uvm_component_registry#(read_sequencer,"read_sequencer") type_id;

//Standard UVM Constructor 
function new (string name = "read_sequencer", uvm_component parent);
super.new(name, parent);
`uvm_info("READ_SEQUENCER_CLASS", "Inside constructor",UVM_LOW)
endfunction

//Build phase
function void build_phase (uvm_phase phase);
super.build_phase(phase);
`uvm_info("READ_SEQUENCER_CLASS", "Build Phase",UVM_LOW)
endfunction

//Connect Phase
function void connect_phase (uvm_phase phase);
super.connect_phase(phase);
`uvm_info("READ_SEQUENCER_CLASS", "Connect Phase",UVM_LOW)
endfunction

endclass

