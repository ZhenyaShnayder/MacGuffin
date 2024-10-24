module encryption(
  input logic rst,
  input logic clk,
  input logic [47:0] round_keys [32],
  
  input logic [63:0] s_axis_tdata,
  input logic s_axis_tvalid,
  output logic s_axis_tready,
  
  
  output logic [63:0] m_axis_tdata,
  output logic m_axis_tvalid,
  input logic m_axis_tready
);

  logic [63:0] block [64];
  logic valid [32];
  logic [63:0] encr_block [64];

  generate
    for (genvar i =0; i<32; i++) begin
      round round_inst(
        .idata(block[i]),
        .key(round_keys[i]),
        .odata(encr_block[i])
      );
      
      always @(posedge clk) begin
        if (rst) begin
          valid[i] <= 1'b0;
          block[i] <= '0;
        end else if (m_axis_tready) begin
          if (i==0) begin
            valid[i] <= s_axis_tvalid;
            block[i] <= s_axis_tdata;
          end else begin
            valid[i] <= valid[i-1];
            block[i] <= encr_block[i-1];
          end
        end
      end
    end
  endgenerate
  
  always @(posedge clk)begin
    if (rst) begin
      m_axis_tdata <= '0;
      m_axis_tvalid <= 1'b0;
    end else begin
      m_axis_tdata <= encr_block[31];
      m_axis_tvalid <= valid[31];
    end
  end
  
  //assign s_axis_tready = m_axis_tready;
  assign s_axis_tready = ~valid[31];
  
endmodule
