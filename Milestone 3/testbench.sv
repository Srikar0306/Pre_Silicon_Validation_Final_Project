`include "interface.sv"
`include "fifotest.sv"


module tb_top;
  bit rclk,wclk,rrst,wrst;
  always #4 wclk = ~wclk;
  always #10 rclk = ~rclk;
  
  intf in (wclk,rclk,wrst,rrst);
  test t1 (in);

  Async_FIFO DUT (.wdata(in.wdata),
            .wfull(in.wfull),
            .rempty(in.rempty),
            .winc(in.winc),

            .rinc(in.rinc),
            .wclk(in.wclk),
            .rclk(in.rclk),
            .rrst(in.rrst),
            .wrst(in.wrst),
            .rdata(in.rdata),
			.half_full(in.half_full),
			.half_empty(in.half_empty)
			);
  
  

   initial begin
    wclk =0;
    rclk=0;
    wrst =0;
    rrst=0;
    in.rinc=0;
    in.winc=0;
    #1
    rrst =1;
    wrst=1;


    

   end

  //coverage start
 covergroup async_fifo_cover;
  option.per_instance = 1;

  // Coverpoints for the data inputs and outputs
  WRITE_DATA : coverpoint in.wdata{
		option.comment = "write data ";
	        bins low_range  = {[1:511]};
	        bins mid_range  = {[512:1023]};
	        bins high_range = {[1023:2048]};	
	}
  // Coverpoints for the flags
	FULL : coverpoint in.wfull {
		option.comment = "FULL_FLAG";
		bins full_c   = ( 0 => 1 );
		bins full_c1  = ( 1 => 0 );
	}

	EMPTY: coverpoint in.rempty {
		option.comment = "WHEN RESET IS OFF check EMPTY";
		bins empty_c  = (0 => 1);
		bins empty_c1 = (1 => 0);
	}

  READ_DATA : coverpoint in.rdata{
		option.comment = "read data ";
	        bins low_range  = {[1:511]};
	        bins mid_range  = {[512:1023]};
	        bins high_range = {[1023:2048]};	
	}


  // Coverpoints for the increment signals
  WRITE_INC : coverpoint in.winc{
  bins incr_s = (0 => 1);
  bins incr_s1 = (1 => 0);
  }

  READ_INC : coverpoint in.rinc{
  bins incr_sr = (0 => 1);
  bins incr_s1r = (1 => 0);
  }


// Coverpoints for the reset signals
  WRITE_RESET: coverpoint in.wrst {
    option.comment = "write reset signal";
    bins reset_low_to_high = (0 =>1);
    bins reset_high_to_low = (1 =>0);

  }

  READ_RESET: coverpoint in.rrst {
    option.comment = "read reset signal";
    bins reset_low_to_high = (0 =>1);
    bins reset_high_to_low = (1 =>0);
  }


// Coverpoints for the clock signals
WRITE_CLK: coverpoint in.wclk {
  option.comment = "write clock signal";
  bins clk_low_to_high = (0 => 1);
  bins clk_high_to_low = (1 => 0);
}

READ_CLK: coverpoint in.rclk {
  option.comment = "read clock signal";
  bins clk_low_to_high = (0 => 1);
  bins clk_high_to_low = (1 => 0);
}

WRITExADDxDATA : cross WRITE_CLK,WRITE_INC,WRITE_DATA;
READxADDxDATA  : cross READ_CLK, READ_INC, READ_DATA;
READxWRITE     : cross  WRITE_DATA,READ_DATA;
RESETxWRITE    : cross WRITE_RESET, WRITE_DATA;
RESETxREAD     : cross READ_RESET , READ_DATA;

endgroup


  async_fifo_cover async_fifo_cov_inst;
  initial begin 
    async_fifo_cov_inst = new();
    forever begin @(posedge wclk or posedge rclk)
      async_fifo_cov_inst.sample();
    end
  end


endmodule

