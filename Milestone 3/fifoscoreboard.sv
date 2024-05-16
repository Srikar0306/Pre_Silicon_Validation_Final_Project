import fifo_pkg::*;

class scoreboard;

  logic [7:0] hold_wData[$];
  logic [7:0] verif_wData;

  logic [7:0] hold_rData[$];
  logic [7:0] verif_rData;
  
  logic detect_rEmpty, detect_wfull, detect_half_full, detect_half_empty;

int trans_count_write =0;
int trans_count_read=0;
int w_count=0;
int r_count=0;
 

mailbox mon2scb_write;
mailbox mon2scb_read;
  
 
function new(mailbox mon2scb_write, mailbox mon2scb_read);
   this.mon2scb_write = mon2scb_write;
   this.mon2scb_read = mon2scb_read;
endfunction



  
 task score_write;
    transaction_write trans_w; 
    trans_w = new(); 
    mon2scb_write.get(trans_w);
    
   
    $display("\t scoreboard winc = %0h \t wdata = %0h", trans_w.winc,trans_w.wdata);

    hold_wData.push_back(trans_w.wdata);
   $display("\t scoreboard write push: wdata = %0h \t", trans_w.wdata);
    w_count++; 
   if (trans_w.wfull == 1)
    detect_wfull = 1;

    if (trans_w.half_full == 1)
	    detect_half_full = 1;
   
endtask

task score_read;
    transaction_read trans_r;
    trans_r = new(); 
    mon2scb_read.get(trans_r);  
  	hold_rData.push_back(trans_r.rdata);
    $display("\t scoreboard read push: rdata = %0h \t", trans_r.rdata);
    r_count++; 
  
endtask
  

task main();
    repeat (trans_count_write) begin
        wait (mon2scb_write.num() > 0);
        score_write();
    end

    repeat (trans_count_read) begin
        wait (mon2scb_read.num() > 0);
        score_read();
    end
endtask


 task check();
   transaction_read trans_r;
   transaction_write trans_w;
   trans_r = new();
   trans_w = new(); 
   mon2scb_read.get(trans_r.rempty);
   mon2scb_read.get(trans_r.half_empty);
   mon2scb_write.get(trans_w.wfull);
   mon2scb_read.get(trans_w.half_full);


   for (integer i=0; i < hold_wData.size; i++) begin
     verif_wData = hold_wData[i];
     verif_rData = hold_rData[i];
    

     $display("scoreboard :: expected wData = %h, rData = %h", verif_wData, verif_rData);
      if (verif_wData != verif_rData)
        $error("scoreboard check failed :: expected wData = %0h, rData = %0h", verif_wData,verif_rData);
   end

   if (trans_w.wfull == 1)
     $display("FIFO IS FULL");
   else $display("FIFO IS NOT FULL");
   
   if (trans_r.rempty == 1)
     $display("FIFO IS EMPTY");
   else $display("FIFO IS NOT EMPTY");

   if (trans_w.half_full == 1)
	   $display("FIFO IS HALF FULL");

	else
		$display("FIFO IS NOT HALF FULL");

  if(trans_r.half_empty == 1)
	  $display("FIFO IS HALF EMPTY");
	  else
		  $display("FIFO IS NOT HALF EMPTY");
		  
   
endtask 

endclass
