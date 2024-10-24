module key_setup(
  input logic rst,
  input logic clk,
  input logic [127:0] key,
  
  input logic [63:0] s_axis_tdata,
  input logic s_axis_tvalid,
  
  output logic [63:0] m_axis_tdata,

  output logic [47:0] round_keys [32],
  output logic key_ready
  
);
  
  parameter [1:0]START = 2'b00, EXP1 = 2'b01, INTER=2'b10, EXP2 = 2'b11;
  logic [1:0] state = START, next_state;
  logic [63:0]block;
  logic [4:0] counter = 5'b0;
  logic [47:0] K [32];
  
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
      INTER: next_state = EXP2;
      EXP2: next_state = EXP2;
      default: next_state = START;
    endcase
  end
  
      
      
  
  always @(posedge clk) begin
    if (rst) begin
      counter <= 5'b0;
      block <= '0;
    end else begin
      case (state)
        START: begin
          counter <= 5'b0;
          block <= key[127:64];
        end
        EXP1:
          if (s_axis_tvalid) begin
            counter <= counter + 1;
            block <= s_axis_tdata;
            K[counter] <= {s_axis_tdata[15:0], s_axis_tdata[63:32]};
          end
        INTER: begin
          counter <= 5'b0;
          block <= key[63:0];
        end
        EXP2:
          if (s_axis_tvalid) begin
            counter <= counter + 1;
            block <= s_axis_tdata;
            K[counter] <= K[counter] ^ {s_axis_tdata[15:0], s_axis_tdata[63:32]};
          end
      endcase
    end
  end
        
            
          
          
          
  assign m_axis_tdata = block;
  assign round_keys = K;
  assign key_ready = (state == EXP2) & last;
  
endmodule
