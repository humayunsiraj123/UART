module UART_top #(parameter BAUD_RATE=2400) (
  input              clk     ,
  input              srst    ,
  input        [7:0] data_in ,
  input              start   ,
  output logic [7:0] data_out
);

  logic clk_t  ;
  logic tx     ;
  logic busy   ;
  logic busy_rx;

  logic rx;

// buad_rate_generator modules
  baud_generator #(.BAUD_RATE(BAUD_RATE)) i_baud_generator (
    .clk  (clk  ),
    .srst (srst ),
    .clk_t(clk_t)
  );

  logic end_tx;
  logic end_rx;

// transmitter module
  uart_tx i_uart_tx (
    .clk_t  (clk_t  ),
    .srst   (srst   ),
    .start  (start  ),
    .data_in(data_in),
    .tx     (tx     ),
    .busy   (busy   )
  );

//reciver module
  uart_rx i_uart_rx (
    .clk_t   (clk_t   ),
    .srst    (srst    ),
    .rx      (tx      ),
    .busy    (busy_rx ),
    .data_out(data_out)
  );

  assign end_tx = i_uart_tx.end_tx;// sigonly use for tb;
  assign end_rx = i_uart_rx.end_rx;// sigonly use for tb;


endmodule : UART_top