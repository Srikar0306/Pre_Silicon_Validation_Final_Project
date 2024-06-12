covergroup FIFO_coverage;
  //option.per_instance = 1;

  // Coverpoints for wdata
  coverpoint intf.wdata {
    bins data_bin1[1] = {[0:1]};// Assuming 8-bit data size
    bins data_bin2[1] = {[2:3]};
    bins data_bin3[1] = {[4:7]};
    bins data_bin4[1] = {[8:15]};
    bins data_bin5[1] = {[16:31]};
    bins data_bin6[1] = {[32:63]};
    bins data_bin7[1] = {[64:127]};
    bins data_bin8[1] = {[128:255]};

  }

  // Coverpoints for rdata
  coverpoint intf.rdata {
    bins data_bin1[1] = {[0:1]}; // Assuming 8-bit data size
    bins data_bin2[1] = {[2:3]};
    bins data_bin3[1] = {[4:7]};
    bins data_bin4[1] = {[8:15]};
    bins data_bin5[1] = {[16:31]};
    bins data_bin6[1] = {[32:63]};
    bins data_bin7[1] = {[64:127]};
    bins data_bin8[1] = {[128:255]};
  }

  // Coverpoints for wfull flag
  coverpoint intf.wfull {
    bins full_bin[] = {0, 1};
  }

  // Coverpoints for rempty flag
  coverpoint intf.rempty {
    bins empty_bin[] = {0, 1};
  }

  //coverpoints for half_full flag
  
  coverpoint intf.half_full {
    bins half_full_bin[] = {0, 1};
  }

  //coverpoints for half_empty flag
  coverpoint intf.half_empty {
    bins half_empty_bin[] = {0, 1};
  }

  //coverpoints for winc flag
  coverpoint intf.winc {
    bins winc[] = {0, 1};
  }

  //coverpoints for rinc flag
  coverpoint intf.rinc {
    bins winc[] = {0, 1};
  }

  //coverpoints for rclk flag
  coverpoint intf.rclk {
    bins rclk[] = {0, 1};
  }

  //coverpoints for wclk flag
  coverpoint intf.wclk {
    bins wclk[] = {0, 1};
  }

  //coverpoints for rrst flag
  coverpoint intf.rrst {
    bins rrst[] = {0, 1};
  }

  //coverpoints for wrst flag
  coverpoint intf.wrst {
    bins wrst[] = {0, 1};
  }

endgroup



