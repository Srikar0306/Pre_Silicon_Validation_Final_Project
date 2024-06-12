
import uvm_pkg::*;
import fifo_pkg::*;
`include "uvm_macros.svh"
`include "async_env.sv"



class fifo_random_test extends uvm_test;
  `uvm_component_utils(fifo_random_test)//component registration
	//typedef uvm_component_registry#(fifo_random_test,"fifo_random_test") type_id;
	
    fifo_env env;//instantiating environment and declaring handle
    write_sequence_random w_seq;//instantiating write sequence and declaring handle
    read_sequence_random r_seq;//instantiating read sequence and declaring handle
	
	//Standard UVM Constructor
  function new(string name = "fifo_random_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

	//Build Phase
    function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);//Object creation for environment
    endfunction
	
	//Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction 
	
	//End of Elaboration Phase
    function void end_of_elaboration();
        super.end_of_elaboration();
        uvm_root::get().print_topology();//to print the complete UVM topology
    endfunction

    task run_phase(uvm_phase phase );
        env.wa.wd.trans_count_write=100;//Number of transaction for write in write driver
        env.ra.rd.trans_count_read=100;//Number of transaction for read in write driver

        env.wa.wm.trans_count_write=100;//Number of transaction for write in write monitor
        env.ra.rm.trans_count_read=100;//Number of transaction for write in read monitor

        phase.raise_objection(this, "Starting fifo_write_seq in main phase");//phase synchronization

        fork
            begin
                $display("/t Starting sequence w_seq run_phase");
                w_seq = write_sequence_random::type_id::create("w_seq", this);//object creation for write sequence
                
                w_seq.start(env.wa.ws);
            end
            begin
                $display("/t Starting sequence r_seq run_phase");
                r_seq = read_sequence_random::type_id::create("r_seq", this);//object creation for read sequence
                r_seq.start(env.ra.rs);
            end
        join
      
        #100ns;
 		
      	env.scb.compare_flags();//Scoreboard compare flags taskb 
        phase.drop_objection(this , "Finished fifo_seq in main phase");//phase synchronization


        #2000;
        $finish;
    endtask

endclass

