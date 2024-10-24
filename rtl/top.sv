module top(
  input logic rst,
  input logic clk,
  input logic [127:0] key,
  
  input logic [63:0] s_axis_tdata,
  input logic s_axis_tvalid,
  output logic s_axis_tready,

  output logic [63:0] m_axis_tdata,
  output logic m_axis_tvalid,
  input logic m_axis_tready
);
  
  logic [47:0] round_keys [32];
  logic [63:0] plain_text, cipher_text, key_to_encr;
  logic key_ready, iencr_valid, oencr_valid, iencr_ready, oencr_ready;
  
  encryption encr_inst(
    .rst(rst),
    .clk(clk),
    .round_keys(round_keys),
    
    .s_axis_tdata(plain_text),
    .s_axis_tvalid(iencr_valid),
    .s_axis_tready(oencr_ready),
  
    .m_axis_tdata(cipher_text),
    .m_axis_tvalid(oencr_valid),
    .m_axis_tready(iencr_ready)
  );
  
  key_setup key_setup_inst(
    .rst(rst),
    .clk(clk),
    .key(key),
  
    .s_axis_tdata(cipher_text),
    .s_axis_tvalid(oencr_valid),
  
    .m_axis_tdata(key_to_encr),

    .round_keys(round_keys),
    .key_ready(key_ready)
  );
  
  always @(*) begin
     if(key_ready) begin
       iencr_valid <= s_axis_tvalid;
       plain_text <= s_axis_tdata;
       iencr_ready <= m_axis_tready;
     end else begin 
       iencr_valid <= ~key_ready;
       plain_text <= key_to_encr;
       iencr_ready <= 1'b1; //?
  end
end
  //always @(posedge clk) begin
    
      
  
  assign m_axis_tdata = cipher_text;
  assign m_axis_tvalid = oencr_valid & key_ready;
  assign s_axis_tready = key_ready & ~oencr_valid;
  //assign s_axis_tready = key_ready & oencr_ready;
  
endmodule
