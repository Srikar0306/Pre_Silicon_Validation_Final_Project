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
