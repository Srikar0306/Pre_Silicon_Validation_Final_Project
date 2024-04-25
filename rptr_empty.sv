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
  
  assign half_empty = (rq2_wptr >= 114);

  always_ff @(posedge rclk or negedge rrst)
    if (!rrst)
      rempty <= 1'b1;
    else
      rempty <= rempty_val;

endmodule
