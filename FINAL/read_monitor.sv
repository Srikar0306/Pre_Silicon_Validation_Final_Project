import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;


//*******************Read Monitor************************


class read_monitor extends uvm_monitor;
`uvm_component_utils(read_monitor) //component registration
//typedef uvm_component_registry#(read_monitor,"read_monitor") type_id;
 
virtual intf vif;//instantiating virtual interface and declaring handle
transaction_read txr;//instantiating read sequence item and declaring handle
bit write_complete_flag;

uvm_analysis_port#(transaction_read) port_read;//analysis port for read monitor

int trans_count_read;
int r_count;

//Standard UVM Constructor
function new (string name = "read_monitor", uvm_component parent);
super.new(name, parent);
`uvm_info("READ_MONITOR_CLASS", "Inside constructor",UVM_LOW)
endfunction


//Build Phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
port_read = new("port_read", this);//object creation using new() constructor
     if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin//Checking to get Virtual IF from Config db
       `uvm_error("build_phase", "No virtual interface specified for this read_monitor instance")
     end
endfunction

//Connect Phase
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction 
 
//Run phase
task run_phase(uvm_phase phase);
	super.run_phase(phase);

			fork 
				begin : read_monitor
	       				forever @(negedge vif.rclk)begin
        					mon_read();
    					end
				end
				begin
                  wait (r_count == trans_count_read);
				end
			join_any
endtask
 
//Monitor read task 
task mon_read;
     
  transaction_read txr;

if (vif.rinc==1)begin
txr=transaction_read::type_id::create("txr");//object creation for read sequenceitem
		fork
			begin
				@(negedge vif.rclk);
				txr.rdata = vif.rdata; 
              $display ("\t Monitor rinc = 1 \t rdata = %0h \t \t rcount=%0d",  txr.rdata, r_count+1);

   				port_read.write(txr);
				r_count= r_count +1;
			end
		join_none	
  	end
endtask
endclass
