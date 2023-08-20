module tb_UART_top();

parameter BAUD_RATE=24;

	logic clk=0;
	logic srst=0;
	logic [7:0] data_in;
	logic start;
	logic [7:0] data_out=0;


always #1 clk=~clk;



UART_top #(.BAUD_RATE(BAUD_RATE)) i_UART_top (
	.clk     (clk     ),
	.srst    (srst    ),
	.data_in (data_in ),
	.start   (start   ),
	.data_out(data_out)
);



initial begin
srst = 0 ;
repeat(100) @(posedge clk);
start = 1;
data_in = 'hff;

repeat(2)@(posedge i_UART_top.clk_t);
start=0;

wait(i_UART_top.end_rx);
@(posedge i_UART_top.clk_t);
repeat(10) @(posedge clk);

$stop();
end

endmodule : tb_UART_top