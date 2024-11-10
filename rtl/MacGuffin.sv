module MacGuffin
# (
  parameter round_num = 2, // 32
  parameter block_size = 4 // 64
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
  input logic m_axis_tready
);
  
  logic [block_size*3/4-1:0] round_keys [round_num];
  logic [block_size-1:0] encr_s_tdata, encr_m_tdata, key_m_tdata;
  logic key_ready;
  logic encr_s_tvalid, encr_m_tvalid, encr_s_tready, encr_m_tready;
  logic key_s_tvalid, key_m_tvalid, key_s_tready, key_m_tready;
  
  // экземпляр модуля зашифрования
  encryption 
  # (
    .round_num(round_num),
    .block_size(block_size)
    )
    encryption_instance
    (
    .rst(rst),
    .clk(clk),
    .round_keys(round_keys),
    
    .s_axis_tdata(encr_s_tdata),
    .s_axis_tvalid(encr_s_tvalid),
    .s_axis_tready(encr_s_tready),
  
    .m_axis_tdata(encr_m_tdata),
    .m_axis_tvalid(encr_m_tvalid),
    .m_axis_tready(encr_m_tready)
  );
  
  // экземпляр модуля расширения ключа
  key_setup 
  # ( 
    .round_num(round_num),
    .block_size(block_size)
    )
    key_setup_inst
    (
    .rst(rst),
    .clk(clk),
    .key(key),
  
    .s_axis_tdata(encr_m_tdata),
    .s_axis_tvalid(key_s_tvalid),
    .s_axis_tready(key_s_tready),
  
    .m_axis_tdata(key_m_tdata),
    .m_axis_tvalid(key_m_tvalid),
    .m_axis_tready(key_m_tready),

    .round_keys(round_keys),
    .key_ready(key_ready)
  );
  
  // логика динамической разводки входов-выходов модуля зашифрования
  always @(*) begin
     if(key_ready) begin
       encr_s_tdata = s_axis_tdata;
       encr_s_tvalid = s_axis_tvalid;
       encr_m_tready = m_axis_tready;
     end else begin 
       encr_s_tdata = key_m_tdata;
       encr_s_tvalid = key_m_tvalid;
       encr_m_tready = key_s_tready;
  end
end
    
  assign m_axis_tdata = encr_m_tdata;
  assign m_axis_tvalid = encr_m_tvalid & key_ready;
  assign s_axis_tready = encr_s_tready & key_ready;

  assign key_m_tready = ~key_ready & encr_s_tready;
  assign key_s_tvalid = ~key_ready & encr_m_tvalid;
endmodule
