module tb_UART_top();

parameter BAUD_RATE=2400;

	logic clk=0;
	logic srst=0;
	logic [7:0] data_in;
	logic start;
	logic [7:0] data_out;



UART_top #(.BAUD_RATE(BAUD_RATE)) i_UART_top (
	.clk     (clk     ),
	.srst    (srst    ),
	.data_in (data_in ),
	.start   (start   ),
	.data_out(data_out)
);



endmodule : tb_UART_top