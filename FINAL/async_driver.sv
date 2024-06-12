import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

//************************Write Driver************************

class write_driver extends uvm_driver#(transaction_write);//parameterized by write sequence item class
`uvm_component_utils(write_driver)//component registration
//typedef uvm_component_registry#(write_driver,"write_driver") type_id;

virtual intf intf_vi;//instantiating virtaul interface and declaring handle
transaction_write txw;//instantiating write sequence item and declaring handle
int trans_count_write;

//Standard UVM Constructor
function new (string name = "write_driver", uvm_component parent);
super.new(name, parent);
`uvm_info("WRITE_DRIVER_CLASS", "Inside constructor",UVM_LOW)
endfunction

//Build Phase
function void build_phase (uvm_phase phase);
super.build_phase(phase);
`uvm_info("WRITE_DRIVER_CLASS", "Build Phase",UVM_LOW)
		if(!(uvm_config_db #(virtual intf)::get (this, "*", "vif", intf_vi))) //Checking to get Virtual IF from Config db
		`uvm_error("WRITE_DRIVER_CLASS", "FAILED to get intf_vi from config DB")
endfunction


//Connect Phase
function void connect_phase (uvm_phase phase);
super.connect_phase(phase);
`uvm_info("WRITE_DRIVER_CLASS", "Connect Phase",UVM_LOW)
endfunction


//Write Drive Task 
task drive_write(transaction_write txw);
	@(posedge intf_vi.wclk);
  	this.intf_vi.winc = txw.winc;
        this.intf_vi.wdata = txw.wdata;

	
endtask


//Run Phase
task run_phase (uvm_phase phase);
super.run_phase(phase);
`uvm_info("DRIVER_CLASS", "Inside Run Phase",UVM_LOW)
this.intf_vi.wdata <=0;
this.intf_vi.winc <=0;

repeat(10) @(posedge intf_vi.wclk);
  		
  for (integer i = 0; i < trans_count_write ; i++) begin
    
			txw=transaction_write::type_id::create("txw");
			seq_item_port.get_next_item(txw);//Handshake Mechanisms
            wait(intf_vi.wfull ==0);
            drive_write(txw);//Calling write drive task
            seq_item_port.item_done();//Handshake Mechanisms

	end
			@(posedge intf_vi.wclk);
			this.intf_vi.winc =0;   	
endtask
endclass



//********************Read Driver**********************


class read_driver extends uvm_driver#(transaction_read);//parameterized by read sequence item class
`uvm_component_utils(read_driver)
//typedef uvm_component_registry#(read_driver,"read_driver") type_id;

virtual intf intf_vi;//instantiating virtaul interface and declaring handle
transaction_read txr;//instantiating virtaul read sequence item and declaring handle
int trans_count_read;

//Standard UVM Constructor
function new (string name = "read_driver", uvm_component parent);
super.new(name, parent);
`uvm_info("READ_DRIVER_CLASS", "Inside constructor",UVM_LOW)
endfunction

//Build Phase
function void build_phase (uvm_phase phase);
super.build_phase(phase);
`uvm_info("READ_DRIVER_CLASS", "Build Phase",UVM_LOW)
		if(!(uvm_config_db #(virtual intf)::get (this, "*", "vif", intf_vi))) //Checking to get Virtual IF from Config db
		`uvm_error("READ_DRIVER_CLASS", "FAILED to get intf_vi from config DB")
endfunction

//connect phase
function void connect_phase (uvm_phase phase);
super.connect_phase(phase);
`uvm_info("READ_DRIVER_CLASS", "Connect Phase",UVM_LOW)
endfunction

//Read Drive Task
task drive_read(transaction_read txr);
 	 @(posedge intf_vi.rclk);
  	this.intf_vi.rinc = txr.rinc;
        
  	
endtask

//Run Phase
task run_phase (uvm_phase phase);
super.run_phase(phase);
`uvm_info("DRIVER_CLASS", "Inside Run Phase",UVM_LOW)
this.intf_vi.rinc <=0;

          	repeat(10) @(posedge intf_vi.rclk);
			
          		for (integer j = 0; j < trans_count_read; j++) begin
			txr=transaction_read::type_id::create("txr");
						
					seq_item_port.get_next_item(txr);//Handshake Mechanisms
			
            		wait(intf_vi.rempty==0);

            		drive_read(txr);//Calling read drive task
            
            		seq_item_port.item_done();	//Handshake Mechanisms
			
    			end
			@(posedge intf_vi.rclk);
			this.intf_vi.rinc =0;
    	
endtask
endclass



