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

integer file, f;
logic [63:0] fodata;

initial begin
	s_axis_tvalid = 1'b0;
	s_axis_tdata = 1'b0;
	m_axis_tready = 1'b0;
    file = $fopen("tests.bin", "r");
	if (file == 0) begin
		$error("File was NOT opened");
		$finish;
	end

//Проверка на корректность зашифрования
	f = $fread(key, file);
	if (f == 0) begin
		$error("Key is empty");
		$finish;
	end

	@(posedge clk); #1;
	rst = 1'b1;
	@(posedge clk); #1;
	rst = 1'b0;

	@(s_axis_tready);//подготовка раундовых ключей

	for(int i = 0; i < 100; i = i + 1) begin
		s_axis_tvalid = 1'b0;#1;
		m_axis_tready = 1'b0;#1;
		@(posedge clk);#1;

		f = $fread(s_axis_tdata, file);#1;
		if (f == 0) begin
			$error("Input data is empty");
			$finish;
		end
		
		s_axis_tvalid = 1'b1;
		m_axis_tready = 1'b1;
		@(posedge clk);#1;
		s_axis_tvalid = 1'b0;
		
		@(m_axis_tvalid);
		#1;
		
		f = $fread(fodata, file);#1;
		if (f == 0) begin
			$error("Output data is empty");
			$finish;
		end

			if(m_axis_tdata == fodata)
				$display("SUCCESS: input_data: %h \n   odata_file: %h \n  odata_MacG: %h", s_axis_tdata, fodata, m_axis_tdata);
			else 
				$display("ERROR: input_data: %h \n   odata_file: %h \n  odata_MacG: %h", s_axis_tdata, fodata, m_axis_tdata);
		m_axis_tready = 1'b1;
		@(posedge clk);#1;
	end

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
