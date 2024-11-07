module encryption
#(
  parameter round_num = 32, 
  parameter block_size = 64
)
(
  input logic rst,
  input logic clk,
  input logic [block_size*3/4-1:0] round_keys [round_num],
  
  input logic [block_size-1:0] s_axis_tdata,
  input logic s_axis_tvalid,
  output logic s_axis_tready,
  
  
  output logic [block_size-1:0] m_axis_tdata,
  output logic m_axis_tvalid,
  input logic m_axis_tready
);

  logic [block_size-1:0] block [round_num];
  logic [block_size-1:0] encr_block [round_num];
  logic valid [round_num];
  logic move [round_num];

  generate
    for (genvar i = 0; i < round_num; i++) begin : idk
      round round_inst(
        .idata(block[i]),
        .key(round_keys[i]),
        .odata(encr_block[i])
      );
      
      always @(posedge clk) begin
        if (rst) begin
          valid[i] <= 1'b0;
          block[i] <= '0;
        end else if (move[i]) begin
          if (i == 0) begin
            valid[i] <= s_axis_tvalid;
            block[i] <= s_axis_tdata;
          end else begin
            valid[i] <= valid[i-1];
            block[i] <= encr_block[i-1];
          end
        end
      end
      
      always @(*) begin
        if (i == round_num - 1) begin
          if (valid[i] == 0 || m_axis_tready)
            move[i] <= 1;
          else
            move[i] = 0;
        end else begin
          if (move [i+1] || valid[i] == 0)
            move[i] <= 1;
          else
            move[i] <= 0;
        end
      end
    end
  endgenerate
  
 
    
  //assign ready[32] = m_axis_tready;
  assign s_axis_tready = ~valid[round_num - 1];
  assign m_axis_tdata = encr_block[round_num-1];
  assign m_axis_tvalid = valid[round_num-1];
 
endmodule
