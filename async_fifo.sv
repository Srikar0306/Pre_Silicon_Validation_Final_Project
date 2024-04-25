module Async_FIFO  #( parameter DATA_LINES = 8,parameter ADDR_LINES = 8 ) (rdata,wfull,rempty,half_full,half_empty,wdata,rinc,rclk,rrst,winc,wclk,wrst );
 
  input  logic  winc, wclk, wrst,rinc, rclk, rrst;
  input   logic [DATA_LINES-1:0] wdata;
  output  logic [DATA_LINES-1:0] rdata;
  output  logic wfull,rempty,half_full,half_empty;


  wire [ADDR_LINES-1:0] waddr, raddr;
  wire [ADDR_LINES:0] wq2_rptr, rq2_wptr;
  wire [ADDR_LINES:0] wptr, rptr;

  sync_r2w sync_r2w (wclk, wrst, rptr,wq2_rptr);
  
  sync_w2r sync_w2r (rclk, rrst,wptr,rq2_wptr );
  
  FIFO_memory #(DATA_LINES, ADDR_LINES) FIFO_mem(winc, wfull, wclk,waddr, raddr,wdata,rdata);
  
  rptr_empty #(ADDR_LINES) rptr_empty (rinc, rclk, rrst, rq2_wptr,rempty,raddr,rptr,half_empty);
  
  wptr_full #(ADDR_LINES) wptr_full (winc, wclk, wrst, wq2_rptr, wfull, waddr, wptr,half_full);
  

endmodule
