module UART_top #(parameter BAUD_RATE=2400) (
  input              clk     ,
  input              srst    ,
  input        [7:0] data_in ,
  input              start   ,
  output logic [7:0] data_out
);

//buad_rate generator
  logic clk_t;
  logic tx  ;
  logic busy;

  baud_generator #(.BAUD_RATE(BAUD_RATE)) i_baud_generator (
    .clk  (clk  ),
    .srst (srst ),
    .clk_t(clk_t)
  );

logic end_tx;

  
  uart_tx i_uart_tx (
    .clk_t  (clk_t  ),
    .srst   (srst   ),
    .start  (start  ),
    .data_in(data_in),
    .tx     (tx     ),
    .busy   (busy   )
  );

assign end_tx = i_uart_tx.end_tx;// sigonly use for tb;


endmodule : UART_top