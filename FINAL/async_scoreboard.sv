import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

`uvm_analysis_imp_decl(_port_a)//implementation port
`uvm_analysis_imp_decl(_port_b)//implementation port

int empty_count;


class fifo_scoreboard extends uvm_scoreboard;
`uvm_component_utils(fifo_scoreboard)//component registration
//typedef uvm_component_registry#(fifo_scoreboard,"fifo_scoreboard") type_id;

 uvm_analysis_imp_port_a#(transaction_write,fifo_scoreboard) write_port;//implementation port for scoreboard from write monitor
 uvm_analysis_imp_port_b#(transaction_read,fifo_scoreboard) read_port;//implementation port for scoreboard from read monitor

transaction_write tw[$];//instantiating write sequence item and declaring handle
transaction_read tr[$];//instantiating read sequence item and declaring handle    
 
//Standard UVM Constructor
function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction  

//Build phase           
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
write_port= new("write_port",this);//object creation using new() constructor
read_port= new("read_port",this);  //object creation using new() constructor
endfunction

//Connect Phase
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction 

//Write Method
function void write_port_a(transaction_write txw); 
tw.push_back(txw);
$display ("\t Scoreboard wdata = %0h", txw.wdata);
//make sure that the data is in FIFO  

endfunction

//Read Method
function void write_port_b(transaction_read txr);
  logic [7:0] popped_wdata;
	empty_count = tw.size;
  if (tw.size() > 0) begin
    popped_wdata = tw.pop_front().wdata;
    
    if (popped_wdata == txr.rdata)
      `uvm_info("SCOREBOARD", $sformatf("MATCH Expected Data!: %0h --- DUT Read Data: %0h", popped_wdata, txr.rdata), UVM_MEDIUM)
    else
      `uvm_error("SCOREBOARD", $sformatf("Expected Data: %0h Does not match DUT Read Data: %0h", popped_wdata, txr.rdata))
  end     
endfunction

//Compare task
task compare_flags(); 
    if (tw.size > 256) begin
      
      `uvm_info("SCOREBOARD", "FIFO IS FULL", UVM_MEDIUM);
  end 
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
    
//Run Phase
task run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask
  
endclass
