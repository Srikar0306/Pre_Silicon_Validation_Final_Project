import fifo_pkg::*;
class generator;
    rand transaction_write txw;
    rand transaction_read txr;
    int tx_count_write;
    int tx_count_read;
 	
  
   mailbox gen2driv_write;
   mailbox gen2driv_read;

  function new(mailbox gen2driv_write, mailbox gen2driv_read); 
        this.gen2driv_write = gen2driv_write;
	this.gen2driv_read = gen2driv_read;
  endfunction

  task main();
	   
  repeat (tx_count_write) begin

    	  txw = new(); 
	
        if(!txw.randomize() with {txw.winc ==1;}) $fatal ("Generator: transaction randomization Failed");

        gen2driv_write.put(txw);

  
    			    end
  

    repeat (tx_count_read) begin 
      
			txr = new();

  
	if(!txr.randomize() with {txr.rinc ==1;}) $fatal ("Generator:: transaction randomization Failed");
	
	gen2driv_read.put(txr);

  
    end
    
   
    endtask
endclass
