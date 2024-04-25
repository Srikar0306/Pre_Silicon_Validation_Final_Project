module async_fifo_tb;

  parameter DATA_LINES = 8;
  parameter ADDR_LINES = 8;

  reg winc, wclk, wrst;
  reg rinc, rclk, rrst;
  reg [DATA_LINES-1:0] wdata;
  wire [DATA_LINES-1:0] rdata;
  wire wfull, rempty,half_full,half_empty;
  reg [DATA_LINES-1:0] data_q[$];
  reg [DATA_LINES-1:0] write_data;


  Async_FIFO #(DATA_LINES, ADDR_LINES) async_fifo (.*);

  initial begin
    wclk = 1'b0;
    rclk = 1'b0;

    fork
      forever #4.166ns wclk = ~wclk;
      forever #7.5ns rclk = ~rclk;
    join
  end

 initial 
  begin
    winc = 1'b0;
    wdata = '0;
    wrst = 1'b0;
    repeat(10) @(posedge wclk);
    wrst = 1'b1;

  for(int j=0; j<2; j++) 
	begin
      for (int i=0; i<250; i++) 
	  begin
        @(posedge wclk iff !wfull);
        winc = (i%2 == 0)? 1'b1 : 1'b0;
        if (winc) 
		begin
          wdata = $urandom;
          data_q.push_front(wdata);
        end
      end
      #1us;
    end
 end

 initial 
  begin
    {rinc,rrst} = 2'b0;
    repeat(10) @(posedge rclk);
    rrst = 1'b1;

  for (int j=0; j<2; j++) 
	begin
      for (int i=0; i<250; i++) 
	  begin
        @(posedge rclk iff !rempty)
        rinc = (i%2 == 0)? 1'b1 : 1'b0;
        if (rinc) 
		begin
          write_data = data_q.pop_back();
		  
          $display("Checking read_data: Data Matching! expected write_data = %h, read_data = %h",write_data, rdata);
		  
          assert(rdata === write_data) else $error("Checking read_data: Data Mismatched! expected write_data = %h, read_data = %h",write_data, rdata);
        end
      end
    end
    $finish;
  end

  initial
      begin
        $dumpfile("dump.vcd");
        $dumpvars;  
      end


endmodule
