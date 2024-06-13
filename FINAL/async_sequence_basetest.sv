 import uvm_pkg::*;
`include "uvm_macros.svh"
 import fifo_pkg::*;


//*****************Write Sequence************************


class write_sequence extends uvm_sequence#(transaction_write);//parameterized by write sequence item class
`uvm_object_utils(write_sequence)//object registration
//typedef uvm_object_registry#(write_sequence,"write_sequence") type_id;

int tx_count_write=200;
transaction_write txw;
    
//Standard UVM Constructor
function new(string name = "write_sequence");
       super.new(name);
       `uvm_info("WRITE_SEQUENCE_CLASS", "Inside constructor",UVM_LOW)
endfunction

//Body task
task body();
        `uvm_info("WRITE_SEQUENCE_CLASS", "Inside body task",UVM_LOW)
  for (int i = 0; i < tx_count_write; i++) begin
			txw = transaction_write::type_id::create("txw");//Object creation for write sequence item class
			start_item(txw);
    		if (!(txw.randomize() with {txw.winc == 1;}));//randomization of inputs
			finish_item(txw);
		end
	
endtask
endclass


//********************Read Sequence************************

class read_sequence extends uvm_sequence#(transaction_read);//parameterized by read sequence item class
//`uvm_object_utils(read_sequence)//object registration
typedef uvm_object_registry#(read_sequence,"read_sequence") type_id;

int tx_count_read=201;

transaction_read txr;
    
//Standard UVM Constructor
function new(string name = "read_sequence");
       super.new(name);
       `uvm_info("READ_SEQUENCE_CLASS", "Inside constructor",UVM_LOW)
endfunction

//Body task
task body();
        `uvm_info("READ_SEQUENCE_CLASS", "Inside body task",UVM_LOW)
		for (int i = 0; i < tx_count_read; i++) begin
			txr = transaction_read::type_id::create("txr");//Object creation for read sequence item class
			start_item(txr);
          if(!(txr.randomize() with {txr.rinc == 1;}));//randomization of inputs
			finish_item(txr);
		end
	
endtask
endclass
