`timescale 1ns / 1ns

module tb_MacGuffin;
	logic rst = 0;
    logic clk = 0;
    logic [127:0] key;
  
  logic [63:0] s_axis_tdata;
  logic s_axis_tvalid;
  logic s_axis_tready;

  logic [63:0] m_axis_tdata;
  logic m_axis_tvalid;
  logic m_axis_tready;

initial begin
	$dumpfile("work/wave.ocd");
	$dumpvars(0, tb_MacGuffin);
end

	logic [63:0] data;
	integer file, f, count;


initial begin
    file = $fopen("cipher_test1.bin", "r");
	if (file == 0) begin
		$error("File was NOT opened");
		$finish;
	end

	//for(int i = 0; i < 10; i = i + 1) begin

	@(posedge clk); #9;
		rst = 1'b1;
	@(posedge clk); #9;
		rst = 1'b0;
		
		f = $fread(key, file);
		if (f == 0) begin
			$error("Key is empty");
			$finish;
		end
		f = $fread(s_axis_tdata, file);
		if (f == 0) begin
			$error("Input data is empty");
			$finish;
		end
		f = $fread(data, file);
		if (f == 0) begin
			$error("Output data is empty");
			$finish;
		end

		while(m_axis_tvalid == 0) begin
			@(posedge clk);
			count = 1;
		end
		if(m_axis_tdata == data)
			$display("SUCCESS: %d \n   key: %d \n  data: %d \n  data_M: %d", s_axis_tdata, key, data, m_axis_tdata);
		else 
			$error("Im bored: %d \n   key: %d \n  data: %d \n  data_M: %d", s_axis_tdata, key, data, m_axis_tdata);
			
    $fclose(file); 
	$finish;
end

always #5 clk = ~clk;

MacGuffin MacGuffin_instance(
	.rst(rst),
	.clk(clk),
	.key(key),
	.s_axis_tdata(s_axis_tdata),
	.s_axis_tvalid(s_axis_tvalid),
	.s_axis_tready(s_axis_tready),
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tvalid(m_axis_tvalid),
	.m_axis_tready(m_axis_tready)
);

endmodule