interface intf(input logic wclk,rclk,wrst,rrst);
logic [7:0] wdata;
logic winc;
logic rinc;
    
logic [7:0] rdata;
logic rempty;
logic wfull;
logic half_full;
logic half_empty;
   
endinterface
