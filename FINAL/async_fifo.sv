module sync_r2w #( parameter ADDR_LINES = 8 )(wclk, wrst, rptr,wq2_rptr);

  input   wclk, wrst;
  input   [ADDR_LINES:0] rptr;
  output reg  [ADDR_LINES:0] wq2_rptr;
  reg [ADDR_LINES:0] wq1_rptr;

  always_ff @(posedge wclk or negedge wrst)
  begin
    if (!wrst) 
    {wq2_rptr,wq1_rptr} <= 0;
    else 
	{wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
  end

endmodule

module sync_w2r #( parameter ADDR_LINES = 8 )(rclk, rrst,wptr,rq2_wptr );
  input   rclk, rrst;
  input   [ADDR_LINES:0] wptr;
  output reg [ADDR_LINES:0] rq2_wptr;
  reg [ADDR_LINES:0] rq1_wptr;

  always_ff @(posedge rclk or negedge rrst)
  begin
    if (!rrst)
    {rq2_wptr,rq1_wptr} <= 0;
    else
    {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
 end
endmodule

module FIFO_memory #( parameter DATA_LINES = 8, parameter ADDR_LINES = 8) (winc, wfull, wclk,waddr, raddr,wdata,rdata);

  input   winc, wfull, wclk;
  input   [ADDR_LINES-1:0] raddr,waddr ;
  input   [DATA_LINES-1:0] wdata;
  output  [DATA_LINES-1:0] rdata;
  logic [DATA_LINES-1 : 0] rdata_temp1,rdata_temp2;


  localparam DEPTH = 1 <<  ADDR_LINES;

  logic [DATA_LINES-1:0] mem [0:DEPTH-1];

 always_ff @(posedge intf.rclk)
 begin
    if (intf.rinc && !intf.rempty)
	
      intf.rdata <= mem[raddr]; //read operation
 end

  always_ff @(posedge wclk)
  begin
  
    if (winc && !wfull)
	
      mem[waddr] <= wdata; //write operation
  end



  
endmodule

module rptr_empty #( parameter ADDR_LINES = 8 ) (rinc, rclk, rrst, rq2_wptr,rempty,raddr,rptr,half_empty);

  input   [ADDR_LINES :0] rq2_wptr;
  input   rinc, rclk, rrst;
   
  output  [ADDR_LINES-1:0] raddr;
  output reg  rempty;
  output reg [ADDR_LINES :0] rptr;
  output reg half_empty;

  reg [ADDR_LINES:0] rbin;
  wire [ADDR_LINES:0] rgraynext, rbinnext;
  wire rempty_val;

   always_ff @(posedge rclk or negedge rrst)
    if (!rrst)
      {rbin, rptr} <= '0;
    else
      {rbin, rptr} <= {rbinnext, rgraynext};


  assign raddr = rbin[ADDR_LINES-1:0];
  
  assign rbinnext = rbin + (rinc & ~rempty);
  
  assign rgraynext = (rbinnext>>1) ^ rbinnext;
  
  assign rempty_val = (rgraynext == rq2_wptr);
  
  assign half_empty_val = (rq2_wptr >= 128);

  always_ff @(posedge rclk or negedge rrst)
  begin
    if (!rrst)
	    begin
	    
	    `ifdef EMPTY_BUG
	    	rempty <= 1'b0;
	     `else

      		rempty <= 1'b1;
	     `endif
	     end
    else
      rempty <= rempty_val;

  end

  property EMPTY_BUG_P;//property and assertion to detect empty bug
  	@(posedge rclk) !rrst |-> rempty == 1;
  endproperty

  EMPTY_BUG_A : assert property(EMPTY_BUG_P)
  else
	  $fatal("###############rempty flag is not deasserted even when rrst is Asserted!###############");


  always_ff @(posedge rclk or negedge rrst)
  begin

  	if (!rrst)
		half_empty <= 1'b1;
	else
		half_empty <= half_empty_val;

end


endmodule

module wptr_full #( parameter ADDR_LINES = 8 ) (winc, wclk, wrst, wq2_rptr, wfull, waddr, wptr,half_full);

  input   [ADDR_LINES :0] wq2_rptr;
  input   winc, wclk, wrst;
  output  [ADDR_LINES-1:0] waddr;
  output logic  wfull;
  output logic [ADDR_LINES :0] wptr;
  output logic half_full;

  logic [ADDR_LINES:0] wbin;
  wire [ADDR_LINES:0] wgraynext, wbinnext;

  wire write_full_val;
   
  assign waddr = wbin[ADDR_LINES-1:0];
  
  assign wbinnext = wbin + (winc & ~wfull);
  
  assign wgraynext = ( wbinnext >> 1 ) ^ wbinnext;

  assign write_full_val = (wgraynext=={~wq2_rptr[ADDR_LINES:ADDR_LINES-1], wq2_rptr[ADDR_LINES-2:0]});
  
  assign half_full_val = wq2_rptr >= 128;
  
  always_ff @(posedge wclk or negedge wrst)
  begin
    if (!wrst)
      {wbin, wptr} <= '0;
    else
      {wbin, wptr} <= {wbinnext, wgraynext};
  end

  always_ff @(posedge wclk or negedge wrst)
  begin
    if (!wrst)

	    begin
	    
	    `ifdef FULL_BUG
	    	wfull <= 1'b0;
	     `else

      		wfull <= 1'b1;
	     `endif

	     end
	  
    else
      wfull <= write_full_val;
  end

  property FULL_BUG_P;//property and assertion to detect full bug
  	@(posedge wclk) !wrst |-> wfull == 1;
  endproperty

  FULL_BUG_A : assert property(FULL_BUG_P)
  else
	  $fatal("###############wfull flag is not deasserted even when wrst is Asserted!###############");




  always_ff @(posedge wclk or negedge wrst)
  begin
  	if (!wrst)

		half_full <= 1'b0;
	else
		half_full <= half_full_val;

  end

		
  
endmodule



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
