import uvm_pkg::*;
//import fifo_pkg::*;
`include "uvm_macros.svh"
`include "async_interface.sv"
`include "async_basetest.sv"
//`include "async_fulltest.sv"
//`include "async_randomtest.sv"
//'include "async_halffulltest.sv"
//'include "async_halfemptytest.sv"

module tb_top;
bit rclk,wclk,rrst,wrst;
  always #4 wclk = ~wclk;
  always #10 rclk = ~rclk;
  
  intf intf(wclk,rclk,wrst,rrst);
  


Async_FIFO DUT (.wdata(intf.wdata),
            .wfull(intf.wfull),
            .rempty(intf.rempty),
            .winc(intf.winc),

            .rinc(intf.rinc),
            .wclk(intf.wclk),
            .rclk(intf.rclk),
            .rrst(intf.rrst),
            .wrst(intf.wrst),
            .rdata(intf.rdata),
	    .half_full(intf.half_full),
	    .half_empty(intf.half_empty)
			);
 
  
initial begin
	uvm_config_db#(virtual intf)::set(null, "*","vif", intf);
	`uvm_info("tb_top","uvm_config_db set for uvm_tb_top", UVM_LOW);
end

initial begin
 	
run_test("fifo_base_test");
//run_test("fifo_full_test");
//run_test("fifo_random_test");
//run_test("fifo_halffull_test");
//run_test("fifo_halfempty_test");

end


initial begin
wclk=0;
rclk=0;
wrst =0;
rrst=0;
intf.rinc=0;
intf.winc=0;
#1;
rrst =1;
wrst=1;
end

//******Coverage********
  `include "coverage.sv"
  FIFO_coverage fifo_coverage_inst;
  initial begin
    fifo_coverage_inst = new();
    forever begin @(posedge wclk or posedge rclk)
      fifo_coverage_inst.sample();
    end
  end 


endmodule
