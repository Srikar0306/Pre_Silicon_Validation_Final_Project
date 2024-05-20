module FIFO_memory #( parameter DATA_LINES = 8, parameter ADDR_LINES = 8) (winc, wfull, wclk,waddr, raddr,wdata,rdata);

  input   winc, wfull, wclk;
  input   [ADDR_LINES-1:0] raddr,waddr ;
  input   [DATA_LINES-1:0] wdata;
  output  [DATA_LINES-1:0] rdata;


  localparam DEPTH = 1 <<  ADDR_LINES;

  logic [DATA_LINES-1:0] mem [0:DEPTH-1];

  assign rdata = mem[raddr];

  always_ff @(posedge wclk)
  
    if (winc && !wfull)
	
      mem[waddr] <= wdata;

endmodule
