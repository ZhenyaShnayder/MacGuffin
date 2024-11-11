`timescale 1ns / 1ns

module tb_key_setup;
	logic rst = 0;
	logic clk = 0;
	logic [127:0] key;
	logic [63:0] encryption_tdata;
	logic encryption_tvalid;
	logic encryption_tready;
	logic [63:0] key_setup_tdata;
	logic key_setup_tvalid;
	logic key_setup_tready;
	logic [32][47:0] round_keys ;
	logic key_ready;

initial begin
	$dumpfile("work/wave.ocd");
	$dumpvars(0, tb_key_setup);
end

	logic [32][47:0] tb_round_keys ;
	integer file, count;
initial begin
	// Открытие файла "tests.txt" для чтения
    	file = $fopen("keys", "r");
    	// Проверка, что файл был открыт успешно
	if (file == 0) begin
		$error("Не удалось открыть файл");
		$finish;
	end
	for(int j=0; j<1; j=j+1) begin
		@(posedge clk); #9;
			rst = 1'b1;
		@(posedge clk); #9;
			rst = 1'b0;
		
		// Чтение изначального ключа
		count = $fread(key, file);
		if (count == 0) begin
			$display("Key is empty ");
			$finish;
		end


		while(key_ready == 0) begin
			@(posedge clk);
		end
		
		//Чтение раундовых ключей
		count = $fread(tb_round_keys, file); 
		if (count == 0) begin
			$display("Round keys are empty ");
			$finish;
		end
		
		//$display(key);
		for(int i=0; i<32; i=i+1) begin
			//$display(tb_round_keys[i], "		", round_keys[i]);
			if(round_keys[i] != tb_round_keys[i])
				$error("Key_setup was failed: \nkey -%b, \ni key: -%b, \nround keys: -%b, tb_round keys: -%b", key, i, round_keys[i], tb_round_keys[i]);
				
		end
	end
	// Закрытие файла
        $fclose(file);	
$finish;
end

always #5 clk = ~clk;

encryption encryption_instance (
	.s_axis_tdata(key_setup_tdata),
	.s_axis_tvalid(key_setup_tvalid),
	.s_axis_tready(key_setup_tready),
	.m_axis_tdata(encryption_tdata),
	.m_axis_tvalid(encryption_tvalid),
	.m_axis_tready(encryption_tready),
	.round_keys(round_keys),
	.rst(rst),
	.clk(clk)
);


key_setup key_setup_instance (
	.s_axis_tdata(encryption_tdata),
	.s_axis_tvalid(encryption_tvalid),
	.s_axis_tready(encryption_tready),
	.m_axis_tdata(key_setup_tdata),
	.m_axis_tvalid(key_setup_tvalid),
	.m_axis_tready(key_setup_tready),
	.round_keys(round_keys),
	.key_ready(key_ready),
	.key(key),
	.rst(rst),
	.clk(clk)
);

endmodule
