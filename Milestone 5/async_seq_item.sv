import uvm_pkg::*;
`include "uvm_macros.svh"

//----------------------------------------------------------------
//			Write Sequence item
//-----------------------------------------------------------------

class transaction_write extends uvm_sequence_item;
`uvm_object_utils(transaction_write)

rand bit [7:0] wdata;
rand bit winc;
bit wfull;

function new(string name = "transaction_write");
        super.new(name);
endfunction
endclass

//----------------------------------------------------------------
//			Read Sequence item
//-----------------------------------------------------------------

class transaction_read extends uvm_sequence_item;
`uvm_object_utils(transaction_read)

rand bit rinc;
logic [7:0] rdata;
bit rempty;

function new(string name = "transaction_read");
        super.new(name);
endfunction
endclass
