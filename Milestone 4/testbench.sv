import uvm_pkg::*;
`include "uvm_macros.svh"
`include "async_interface.sv"
`include "async_basetest.sv"

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

endmodule
