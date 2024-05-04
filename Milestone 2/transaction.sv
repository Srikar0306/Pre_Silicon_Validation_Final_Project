class transaction_write;
    	rand bit [7:0] wdata;
        rand bit winc;
	bit wfull;
	bit half_full;
	 
endclass

class transaction_read;
       	rand bit rinc;

     	logic [7:0] rdata;
		bit rempty;
		bit half_empty;
	  
endclass
