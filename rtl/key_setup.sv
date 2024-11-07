module key_setup
# (
  parameter round_num = 32,
  parameter block_size = 64
  )
  (
  input logic rst,
  input logic clk,
  input logic [block_size*2-1:0] key,
  
  input logic [block_size-1:0] s_axis_tdata,
  input logic s_axis_tvalid,
  output logic s_axis_tready,
  
  output logic [block_size-1:0] m_axis_tdata,
  output logic m_axis_tvalid,
  input logic m_axis_tready,

  output logic [block_size*3/4-1:0] round_keys [round_num],
  output logic key_ready
  
);
  
  localparam [2:0]START = 3'b000, EXP1 = 3'b001, INTER=3'b010, EXP2 = 3'b011, READY = 3'b100;
  logic [2:0] state = START, next_state = EXP1; // вероятно проблемы с next_state
  logic [block_size-1:0]block;
  logic [$clog2(round_num)-1:0] counter = '0;
  logic [block_size*3/4-1:0] K [round_num];
  
  logic last;
  assign last = &counter;
  
  always @(posedge clk) begin
    if (rst) state <= START;
    else state <= next_state;
  end
  
  always @(*) begin
    case (state) 
      START: next_state = EXP1;
      EXP1: if(last) next_state = INTER;
        else next_state = EXP1;
      INTER: next_state = EXP2;
      EXP2: if(last) next_state = READY;
        else next_state = EXP2;
      READY: next_state = READY;
      default: next_state = START;
    endcase
  end
  
      
      
  
  always @(posedge clk) begin
    if (rst) begin
      counter <= '0;
      block <= '0;
      // обнулить раундовый ключ
    end else begin
      case (state)
        START: begin
          counter <= '0; // подумать над двойным обнулением
          block <= key[block_size*2-1:block_size];
          m_axis_tvalid <= 1;
          s_axis_tready <= 0;
        end
        EXP1: begin
          if (m_axis_tready && m_axis_tvalid) begin
            m_axis_tvalid <= 0;
            s_axis_tready <= 1;
          end
          if (s_axis_tvalid) begin
            counter <= counter + '1;
            block <= s_axis_tdata;
            m_axis_tvalid <= 1;
            s_axis_tready <= 0;
            K[counter] <= {s_axis_tdata[block_size/4-1:0], s_axis_tdata[block_size-1:block_size/2]};
          end
        end
        INTER: begin
          counter <= '0;
          block <= key[block_size-1:0];
          m_axis_tvalid <= 1;
          s_axis_tready <= 0;
        end
        EXP2: begin
          if (m_axis_tready) begin
            m_axis_tvalid <= 0;
            s_axis_tready <= 1;
          end
          if (s_axis_tvalid) begin
            counter <= counter + '1;
            block <= s_axis_tdata;
            K[counter] <= K[counter] ^ {s_axis_tdata[block_size/4-1:0], s_axis_tdata[block_size-1:block_size/2]};
          end
        end
        READY: begin
          m_axis_tvalid <= 0;
          s_axis_tready <= 0;
        end
      endcase
    end
  end
        
            
          
          
          
  assign m_axis_tdata = block;
  assign round_keys = K;
  assign key_ready = (state == READY);
  
endmodule
