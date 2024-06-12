 import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

class fifo_env extends uvm_env;
`uvm_component_utils(fifo_env) //Component registration
//typedef uvm_component_registry#(fifo_env,"fifo_env") type_id;

write_agent wa;//instantiating write agent and declaring handle
read_agent ra;//instantiating read and declaring handle
fifo_scoreboard scb;//instantiating scoreboard and declaring handle

//Standard UVM Constructor
function new(string name, uvm_component parent);
      super.new(name, parent);
endfunction


//Build Phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
     wa = write_agent::type_id::create("wa", this);//object creation for write agent
     ra = read_agent::type_id::create("ra", this);//object creation for read agent
     scb = fifo_scoreboard::type_id::create("scb", this);//object creation for scoreboard 

endfunction
  
//Connect Phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
   
     wa.wm.port_write.connect(scb.write_port);//Connecting Write Monitor Analysis Port to Scoreboard Imp. Port
     ra.rm.port_read.connect(scb.read_port);//Connecting Read Monitor Analysis Port to Scoreboard Imp. Port
    
endfunction

//Run Phase
task run_phase (uvm_phase phase);
super.run_phase(phase);
endtask
endclass


