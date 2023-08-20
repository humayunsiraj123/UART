module uart_rx (
  input              clk_t   ,
  input              srst    ,
  input              rx      ,
  output logic       busy    ,
  output logic [7:0] data_out
);


  typedef enum logic[3:0]{IDLE =0 ,START=1,RECIEVE=2,STOP=3,CHK_SUM=4} state_e;

  logic   end_rx    = 0   ;
  state_e cur_state = IDLE; //initial idle state
  state_e nxt_state       ;

  logic [8:0] rx_pack   ; //8data bit and 1 parity bit
  logic       parity_bit;
  logic [3:0] cnt       ; // to keep record of bit transmitted;

  always_comb begin : proc_parity_generator
    //  parity_bit = ^data_in; //parity bit generate
    busy = (cur_state == STOP);
  end


// always_ff @(posedge clk_t) begin
//  if(srst) begin
//    cnt<=0;
//    cur_state <= START;
//  end else begin
//    cur_state <= cur_state ;
//  end
// end


  always_ff @(posedge clk_t) begin : proc_main_fsm
    end_rx <= 0;
    case(cur_state)
      IDLE : begin
        if(srst)
          begin
            cur_state <= IDLE;
            rx_pack   <= 0;
            cnt       <= 0;
          end
        else
          cur_state <= START;
      end

      START : begin
        if(rx==1'b0) begin//start reciving
          cnt       <= 0;
          cur_state <= RECIEVE;
          rx_pack <=0;
        end
        else
          begin
            cur_state <= START;//stays in the same state
          end
      end
      RECIEVE :
        begin//CNT IS INC AFTER recieve bit BIT
          rx_pack <= {rx,rx_pack[8:1]};// serial in rx bit and shift the data
          //rx_pack    <= rx_pack>>1;
          cnt        <= cnt+1;
          if(cnt==8)
            cur_state <= CHK_SUM;
        end
      CHK_SUM :
        begin
          parity_bit<= rx_pack[8:1];//8bit of data as mbs of rx_pack updated in that cycle and last bit is not shifted
          if(rx == ^rx_pack[8:1])// checking if parity bit matches if matches data_out is assing to rx_pack[7:0] that carries 8 bit data byte
            begin
              data_out <= rx_pack[7:0];
            end
          else
              data_out <= 'x;
          rx_pack[8] <= rx;
          cur_state <= STOP;
        end
      STOP :
        begin// just staying state where stop bit is reciv
          cur_state <= START;
          end_rx    <= 1;
        end
      default : cur_state <=IDLE;
    endcase // cur_state
  end


endmodule