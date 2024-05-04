import fifo_pkg::*;

class environment;
    bit rempty;
    bit wfull;
    bit half_full;
    bit half_empty;
    generator gen;
    driver driv;
    monitor mon;
    scoreboard scb;
  
    mailbox gen2driv_read;
    mailbox gen2driv_write;

    mailbox mon2scb_read;
    mailbox mon2scb_write;

  
virtual intf vif;

   
function new(virtual intf vif);
    this.vif = vif;
    gen2driv_read = new();
    gen2driv_write = new();

    mon2scb_read = new();
    mon2scb_write = new();

    gen = new(gen2driv_write, gen2driv_read);
    driv = new (vif,gen2driv_write,gen2driv_read);
    mon = new (vif, mon2scb_read,mon2scb_write);
    scb = new (mon2scb_write, mon2scb_read);
endfunction
  
     
  task pre_test();
	
            
	driv.reset();
 
  
        
    
endtask
    
    

task test();


  $display("******Write Bursts requested %0d*******",gen.tx_count_write);
  $display("******Read Bursts requested %0d********",gen.tx_count_read);

    gen.main();
    
   fork

	 begin 
      $display("DRIVER STARTED");
  		 driv.main();
      
	end 

	begin
      $display("MONITOR STARTED");
  		mon.main();
      
	end
	
	begin
      $display("SCOREBOARD STARTED");
        scb.main();
      
	end

   join
  
  $display("Data Check STARTED");
      scb.check();
  $display("Data Check COMPLETED");
      
  endtask

  task run();
    
   pre_test();  	  
   test(); 
	
 endtask
        
endclass
