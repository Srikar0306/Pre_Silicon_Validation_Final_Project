import fifo_pkg::*;

class driver;
int trans_count_rd;
int trans_count_wr;

   
virtual intf intf_vi;
   	
mailbox gen2driv_wr;
mailbox gen2driv_rd;


   
function new(virtual intf intf_vi, mailbox gen2driv_wr,mailbox gen2driv_rd);
        
	this.intf_vi = intf_vi;
        this.gen2driv_wr = gen2driv_wr;
	this.gen2driv_rd = gen2driv_rd;
   
endfunction

     
task reset;
       
	$display("Driver Reset Started");
	
        intf_vi.wdata = 0;
        intf_vi.winc = 0;
      
		intf_vi.rinc = 0;

        $display("Driver Reset is Done");
   
endtask
  

  
task drive_write();

     	transaction_write txw;
		txw=new();
  
      	gen2driv_wr.get(txw);
	
	
  	intf_vi.winc = txw.winc;
    intf_vi.wdata = txw.wdata;;
     @(posedge intf_vi.wclk);
  	 @(posedge intf_vi.wclk);
  
  
           
endtask
       
    
task drive_read();
    
     transaction_read txr;
	 txr=new();
  
     gen2driv_rd.get(txr);
     	
	intf_vi.rinc = txr.rinc;
  	@(posedge intf_vi.rclk);
  	@(posedge intf_vi.rclk);

	
  
endtask   

     
task  main();

	fork
		begin
          repeat(50) @(posedge intf_vi.wclk);
          for (integer i = 0; i < trans_count_wr ; i++) begin
            $display("Write transaction count= %0d*******************",i+1); 	
            
            drive_write();
            
            
    			end
				intf_vi.winc=0;
				intf_vi.wdata=0;

        	end


		begin
			repeat(50) @(posedge intf_vi.rclk);
          for (integer j = 0; j < trans_count_rd ; j++) begin
            $display("Read transaction count= %0d*******************",j+1);
				drive_read(); 
    			end
			intf_vi.rinc=0;

        	end

	join

		


endtask
         
endclass
