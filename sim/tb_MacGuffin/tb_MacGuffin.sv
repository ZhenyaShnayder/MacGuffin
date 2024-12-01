`timescale 1ns / 1ns

module tb_MacGuffin;
	logic rst = 0;
    logic clk = 0;
    logic [127:0] key;
  
	logic [63:0] idata;
	logic in_tvalid;
	logic in_tready;

	logic [63:0] odata;
	logic out_tvalid;
	logic out_tready;

initial begin
	$dumpfile("work/wave.ocd");
	$dumpvars(0, tb_MacGuffin);
end

logic [63:0] fodata;
integer file, f;

initial begin
    file = $fopen("tests.bin", "r");
	if (file == 0) begin
		$error("File was NOT opened");
		$finish;
	end
		
	f = $fread(key, file);
	if (f == 0) begin
		$error("Key is empty");
		$finish;
	end

	for(int i = 0; i < 100; i = i + 1) begin
		@(posedge clk); #9;
		rst = 1'b1;
		@(posedge clk); #9;
		rst = 1'b0;

		/*f = $fread(key, file);
		if (f == 0) begin
			$error("Key is empty");
			$finish;
		end*/

		f = $fread(idata, file);
		if (f == 0) begin
			$error("Input data is empty");
			$finish;
		end
	
		while(out_tvalid == 0) begin
			@(posedge clk);
		end

		f = $fread(fodata, file);
		if (f == 0) begin
			$error("Output data is empty");
			$finish;
		end

		if(odata == fodata)
			$display("SUCCESS: input_data: %h \n   key: %h \n  odata_file: %h \n  odata_MacG: %h", idata, key, fodata, odata);
		else 
			$display("ERROR: input_data: %h \n   key: %h \n  odata_file: %h \n  odata_MacG: %h", idata, key, fodata, odata);

	end		
    $fclose(file); 
	$finish;
end

always #5 clk = ~clk;

MacGuffin MacGuffin_instance(
	.rst(rst),
	.clk(clk),
	.key(key),
	.s_axis_tdata(idata),
	.s_axis_tvalid(in_tvalid),
	.s_axis_tready(in_tready),
	.m_axis_tdata(odata),
	.m_axis_tvalid(out_tvalid),
	.m_axis_tready(out_tready)
);

endmodule
