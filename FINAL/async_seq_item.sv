import uvm_pkg::*;
`include "uvm_macros.svh"


//******************Write Sequence item*********************

class transaction_write extends uvm_sequence_item;
`uvm_object_utils(transaction_write)//Object registration
//typedef uvm_object_registry#(transaction_write,"transaction_write") type_id;

rand bit [7:0] wdata;//rand for inputs
rand bit winc;
bit wfull;

//Standard UVM Constructor
function new(string name = "transaction_write");
        super.new(name);
endfunction
endclass


//*****************Read Sequence item***********************


class transaction_read extends uvm_sequence_item;
`uvm_object_utils(transaction_read)//Object registration
//typedef uvm_object_registry#(transaction_read,"transaction_read") type_id;

rand bit rinc;//rand for inputs
logic [7:0] rdata;
bit rempty;

//Standard UVM Constructor
function new(string name = "transaction_read");
        super.new(name);
endfunction
endclass
