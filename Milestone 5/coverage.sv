covergroup FIFO_coverage;
  //option.per_instance = 1;

  // Coverpoints for wdata
  coverpoint intf.wdata {
    bins data_bin[] = {[0:255]}; // Assuming 8-bit data size
  }

  // Coverpoints for rdata
  coverpoint intf.rdata {
    bins data_bin[] = {[0:255]}; // Assuming 8-bit data size
  }

  // Coverpoints for wfull flag
  coverpoint intf.wfull {
    bins full_bin[] = {0, 1};
  }

  // Coverpoints for rempty flag
  coverpoint intf.rempty {
    bins empty_bin[] = {0, 1};
  }

  // Cross coverage between wdata and rdata
  cross intf.wdata, intf.rdata;
	
  // Cross coverage between wdata and wfull
  cross intf.wdata, intf.wfull;

  // Cross coverage between rdata and rempty
  cross intf.rdata, intf.rempty;


endgroup



