import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;


//******************Write Monitor************************


class write_monitor extends uvm_monitor;
`uvm_component_utils(write_monitor)  //component registration
//typedef uvm_component_registry#(write_monitor,"write_monitor") type_id;
 
virtual intf vif;//instantiating virtual interface and declaring handle
transaction_write txw;//instantiating read sequence item and declaring handle

uvm_analysis_port#(transaction_write) port_write;//analysis port for write monitor

int trans_count_write;
int w_count;

//Standard UVM Constructor
function new (string name = "write_monitor", uvm_component parent);
super.new(name, parent);
`uvm_info("WRITE_MONITOR_CLASS", "Inside constructor",UVM_LOW)
endfunction

//Build Phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
port_write = new("port_write", this);//object creation using new() constructor

     if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin//Checking to get Virtual IF from Config db
       `uvm_error("build_phase", "No virtual interface specified for this write_monitor instance")
     end
endfunction

//Connect Phase
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction 

//Run Phase
task run_phase(uvm_phase phase);
	super.run_phase(phase);

    	 fork
        	begin : write_monitor
            		forever @(negedge vif.wclk) begin
                	mon_write();
            		end
        	end

        	begin : write_completion
              wait (w_count == trans_count_write);
        	end
    	join

endtask
      
//Monitor Write task	  
task mon_write;
     
  transaction_write txw;

   	if (vif.winc==1) begin
	
 	txw=transaction_write::type_id::create("txw"); //object creation for write sequenceitem
 	txw.winc = vif.winc;
  	txw.wdata = vif.wdata;
	$display ("\t Monitor winc = %0h \t wdata = %0h \t w_count=%0d", txw.winc, txw.wdata, w_count+1);
   	port_write.write(txw);
	w_count=w_count +1;
		 
	end
endtask
endclass
