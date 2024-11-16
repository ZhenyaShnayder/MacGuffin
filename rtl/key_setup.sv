module key_setup
# (
  parameter round_num = 32,
  parameter block_size = 64
  )
  (
  input logic rst,
  input logic clk,
  input logic [block_size*2-1:0] key,
  
  //slave AXI4-Stream
  input logic [block_size-1:0] s_axis_tdata,
  input logic s_axis_tvalid,
  output logic s_axis_tready,
  
  //master AXI4-Stream
  output logic [block_size-1:0] m_axis_tdata,
  output logic m_axis_tvalid,
  input logic m_axis_tready,

  output logic [0:round_num-1][block_size*3/4-1:0] round_keys ,
  output logic key_ready
  
);
  
  //Finite state machine states
  localparam [2:0]START = 3'b000, DATA_READY1 = 3'b001, PROCESS1 = 3'b010,  INSERT = 3'b011, DATA_READY2 = 3'b100, PROCESS2 = 3'b101, READY = 3'b110;
  logic [2:0] state = START, next_state = DATA_READY1; // вероятно проблемы с next_state, надо по вейвформе смотреть
  logic [block_size-1:0]block;
  logic [$clog2(round_num)-1:0] counter = '0;
  
  logic last;
  assign last = (&counter) & s_axis_tvalid;
    
  // механизм изменения состояний
  always @(posedge clk) begin
    if (rst) state <= START;
    else state <= next_state;
  end
  
  // логика следующего состояния
  always @(*) begin
    case (state) 
      START: next_state = DATA_READY1;
      DATA_READY1: begin
        if (m_axis_tready) next_state = PROCESS1;
        else next_state = DATA_READY1;
      end
      PROCESS1: begin
        if (s_axis_tvalid) begin
          if (last) next_state = INSERT;
          else next_state = DATA_READY1;
        end else next_state = PROCESS1;
      end
      INSERT: next_state = DATA_READY2;
      DATA_READY2: begin
        if (m_axis_tready) next_state = PROCESS2;
        else next_state = DATA_READY2;
      end
      PROCESS2: begin
        if (s_axis_tvalid) begin
          if (last) next_state = READY;
          else next_state = DATA_READY2;
        end else next_state = PROCESS2;
      end
      READY: next_state = READY;
      default: next_state = START;
    endcase
  end
  
  // механизм генерации ключа
  always @(posedge clk) begin
    if (rst) begin
      counter <= '0;
      block <= '0;
      m_axis_tvalid <= 0;
      s_axis_tready <= 0;
      round_keys <= '0;
    end else begin
      case (state)
        START: begin
          counter <= '0; // подумать над двойным обнулением
          block <= key[block_size*2-1:block_size];
          m_axis_tvalid <= 1;
          s_axis_tready <= 0;
        end
        DATA_READY1: begin
          if (m_axis_tready) begin
            m_axis_tvalid <= 0;
            s_axis_tready <= 1;
          end
        end
        PROCESS1: begin
          if (s_axis_tvalid) begin
            s_axis_tready <= 0;
            counter <= counter + 5'b1;
            block <= s_axis_tdata;
            round_keys[counter] <= s_axis_tdata[block_size-1:block_size/4];
            if(!last)
              m_axis_tvalid <= 1;
          end
        end
        INSERT: begin
          counter <= '0;
          block <= key[block_size-1:0];
          m_axis_tvalid <= 1;
          s_axis_tready <= 0;
        end
        DATA_READY2: begin
          if (m_axis_tready) begin
            m_axis_tvalid <= 0;
            s_axis_tready <= 1;
          end
        end
        PROCESS2: begin 
          if (s_axis_tvalid) begin
            s_axis_tready <= 0;
            counter <= counter + 5'b1;
            block <= s_axis_tdata;
            round_keys[counter] <= round_keys[counter] ^ s_axis_tdata[block_size - 1:block_size/4];
            if(!last)
              m_axis_tvalid <= 1;
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
  assign key_ready = (state == READY);
  
endmodule
