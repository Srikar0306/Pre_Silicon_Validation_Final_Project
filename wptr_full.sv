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
  
  assign half_full = wq2_rptr >= 114;
  
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
	
      wfull <= 1'b0;
	  
    else
      wfull <= write_full_val;
  end
  
endmodule
