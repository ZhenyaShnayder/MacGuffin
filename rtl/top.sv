module top (
  input logic rst_n,
  input logic clk,

  input logic rxd,
  output logic txd
);
  parameter [47:0]initial_key = 48'h0;
  logic my_clk, my_rst, inv_rst;
  logic [63:0] crypt_s_axis_tdata, crypt_m_axis_tdata;
  logic crypt_s_axis_tvalid, crypt_s_axis_tready;
  logic crypt_m_axis_tvalid, crypt_m_axis_tready;
  logic [7:0] uart_s_axis_tdata, uart_m_axis_tdata;
  logic uart_s_axis_tvalid, uart_s_axis_tready;
  logic uart_m_axis_tvalid, uart_m_axis_tready;


  synchronizer #(
    .STAGES(5)
  ) rst_synchr (
    .rst(0),
    .clk(my_clk),
    .d(rst_n),
    .q(inv_rst)
  );
  assign my_rst = ~inv_rst;

  Gowin_rPLL rPLL_instance( //
    .clkout(my_clk), //output clkout
    .reset(my_rst),     //input reset
    .clkin(clk)      //input clkin
  );

  uart uart_instance( //
    .clk(my_clk),
    .rst(my_rst),

    .s_axis_tdata(uart_s_axis_tdata),
    .s_axis_tvalid(uart_s_axis_tvalid),
    .s_axis_tready(uart_s_axis_tready),

    .m_axis_tdata(uart_m_axis_tdata),
    .m_axis_tvalid(uart_m_axis_tvalid),
    .m_axis_tready(uart_m_axis_tready),

    .rxd(rxd),
    .txd(txd),

    .prescale(100_000_000/(115200*8))
  );

  MacGuffin encoder( //
    .clk(my_clk),
    .rst(my_rst),
    .key(initial_key),

    .s_axis_tdata(crypt_s_axis_tdata),
    .s_axis_tvalid(crypt_s_axis_tvalid),
    .s_axis_tready(crypt_s_axis_tready),

    .m_axis_tdata(crypt_m_axis_tdata),
    .m_axis_tvalid(crypt_m_axis_tvalid),
    .m_axis_tready(crypt_m_axis_tready)
  );

  axis_fifo_adapter #(
    .DEPTH(8),
    .S_DATA_WIDTH(8),
    .M_DATA_WIDTH(64),
    .S_KEEP_ENABLE(0),
    .M_KEEP_ENABLE(0),
    .USER_ENABLE(0),
    .RAM_PIPELINE(1)
  ) crypt_IN (
    .rst(my_rst),
    .clk(my_clk),

    .s_axis_tdata(uart_m_axis_tdata),
    .s_axis_tvalid(uart_m_axis_tvalid),
    .s_axis_tready(uart_m_axis_tready),

    .m_axis_tdata(crypt_s_axis_tdata),
    .m_axis_tvalid(crypt_s_axis_tvalid),
    .m_axis_tready(crypt_s_axis_tready)
  );

  axis_fifo_adapter #(
    .DEPTH(8),
    .S_DATA_WIDTH(64),
    .M_DATA_WIDTH(8),
    .S_KEEP_ENABLE(0),
    .M_KEEP_ENABLE(0),
    .USER_ENABLE(0),
    .RAM_PIPELINE(1)
  ) crypt_OUT (
    .rst(my_rst),
    .clk(my_clk),

    .s_axis_tdata(crypt_m_axis_tdata),
    .s_axis_tvalid(crypt_m_axis_tvalid),
    .s_axis_tready(crypt_m_axis_tready),

    .m_axis_tdata(uart_s_axis_tdata),
    .m_axis_tvalid(uart_s_axis_tvalid),
    .m_axis_tready(uart_s_axis_tready)
  );

endmodule;