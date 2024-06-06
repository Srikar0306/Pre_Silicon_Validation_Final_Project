import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

`uvm_analysis_imp_decl(_port_a)
`uvm_analysis_imp_decl(_port_b)

int empty_count;


class fifo_scoreboard extends uvm_scoreboard;
`uvm_component_utils(fifo_scoreboard)
 uvm_analysis_imp_port_a#(transaction_write,fifo_scoreboard) write_port;
 uvm_analysis_imp_port_b#(transaction_read,fifo_scoreboard) read_port; 

transaction_write tw[$];
transaction_read tr[$];     
  
function new(string name,uvm_component parent);
    super.new(name,parent);

endfunction  
               
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
write_port= new("write_port",this);
read_port= new("read_port",this);  
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction 
 
function void write_port_a(transaction_write txw); 
tw.push_back(txw);
$display ("\t Scoreboard wdata = %0h", txw.wdata);
//make sure that the data is in FIFO  

endfunction

function void write_port_b(transaction_read txr);
  logic [7:0] popped_wdata;
	empty_count = tw.size;
  if (tw.size() > 0) begin
    popped_wdata = tw.pop_front().wdata;
    
    if (popped_wdata == txr.rdata)
      `uvm_info("SCOREBOARD", $sformatf("MATCH Expected Data: %0h --- DUT Read Data: %0h", popped_wdata, txr.rdata), UVM_MEDIUM)
    else
      `uvm_error("SCOREBOARD", $sformatf("Expected Data: %0h Does not match DUT Read Data: %0h", popped_wdata, txr.rdata))
  end 
      //else begin
   //`uvm_info("SCOREBOARD", "No Available Transaction", UVM_MEDIUM);
 // break;
 // end
  //end
    
endfunction


task compare_flags(); 
    if (tw.size > 256) begin
      
      `uvm_info("SCOREBOARD", "FIFO IS FULL", UVM_MEDIUM);
  end 
    //if (empty_count == 0) begin
    if (tw.size == 0) begin

    `uvm_info("SCOREBOARD", "FIFO IS EMPTY", UVM_MEDIUM);
    end

    if(tw.size == 129)
	    begin
	    `uvm_info("SCOREBOARD", "FIFO IS Half FULL", UVM_MEDIUM);
	    end

    if(empty_count == 129)
	    begin
	    `uvm_info("SCOREBOARD", "FIFO IS Half EMPTY", UVM_MEDIUM);
	    end
endtask
    



task run_phase(uvm_phase phase);
super.run_phase(phase);
  
endtask
  
endclass
