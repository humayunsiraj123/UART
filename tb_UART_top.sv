module tb_UART_top ();

	parameter BAUD_RATE = 24;

	logic       clk      = 0;
	logic       srst     = 0;
	logic [7:0] data_in     ;
	logic       start       ;
	logic [7:0] data_out = 0;


	always #1 clk=~clk;

	logic [7:0] in_q    [$]    ;
	logic [7:0] out_q   [$]    ;
	logic [7:0] data_in_x        ;
	logic [7:0] data_out_x       ;
	int         pass        = 0;
	int         fail        = 0;

	int test_count = 0;
	UART_top #(.BAUD_RATE(BAUD_RATE)) i_UART_top (
		.clk     (clk     ),
		.srst    (srst    ),
		.data_in (data_in ),
		.start   (start   ),
		.data_out(data_out)
	);




	initial begin
		srst = 0 ;


		repeat(10) @(posedge clk);
		start = 1;
		data_in = 'hc;

		repeat(2)@(posedge i_UART_top.clk_t);
		start=0;

		wait(i_UART_top.end_rx);

//@(posedge i_UART_top.clk_t);
		repeat(10) @(posedge clk);



		repeat(20) begin
			repeat(10) @(posedge clk);
			start = 1;
			data_in = $random();
			in_q.push_front(data_in);

			repeat(2)@(posedge i_UART_top.clk_t);
			start=0;

			wait(i_UART_top.end_rx);
			out_q.push_front(data_out);
//@(posedge i_UART_top.clk_t);
			repeat(2) @(posedge clk);
		end
		$display("in_q %p",in_q);
		$display("out_q %p",out_q);

		foreach(in_q[i]) begin
			data_in_x= in_q.pop_front();
			data_out_x= out_q.pop_front();
			if(data_in===data_out)
				pass++;
			else
				fail++;
			end

			$display(" Result  Pass %d  fail  %d ",pass,fail);
			$stop();
		end

	endmodule : tb_UART_top