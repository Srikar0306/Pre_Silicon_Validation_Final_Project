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
