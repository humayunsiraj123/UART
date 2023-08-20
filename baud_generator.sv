
module baud_generator #(parameter BAUD_RATE=2400) (
	input  clk ,
	input  srst,
	output  logic clk_t
);

	parameter FREQ = 1000000; //1Mhz;
	parameter baud = FREQ/BAUD_RATE;

	logic [31:0] count = 0;

	always_ff @(posedge clk ) begin
		if(srst)
			count <= 0;
		else if(count>=baud) 			
			count <= 0;
		else 
			count <= count + 1  ;
		
	end



	always_comb begin : proc_
		clk_t = count == baud;

	end
endmodule : baud_generator
