`include "fifoenvironment.sv"

program test(intf in);
  environment env;
  logic [5:0] read_request;
  logic [5:0] write_request;
  initial begin
    $display("TEST START");
    read_request = 50;
    write_request = 50;
    
    env = new(in);
    env.gen.tx_count_read = 50;
    env.gen.tx_count_write = 50;
    
    env.driv.trans_count_rd= 50;
    env.driv.trans_count_wr= 50;
    
    env.mon.trans_count_write= 50;
    env.mon.trans_count_read= 50;
    
    env.scb.trans_count_write= 50;
    env.scb.trans_count_read= 50;

    env.run();
    $display("TEST FINISH");
    $finish;
  end
endprogram
