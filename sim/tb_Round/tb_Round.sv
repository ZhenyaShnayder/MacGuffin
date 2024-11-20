`timescale 1ns / 1ns

module tb_Round;
	logic [63:0] idata;
	logic [47:0] key;
	logic [63:0] odata;

initial begin
	$dumpfile("work/wave.ocd");
	$dumpvars(0, tb_Round);
end

	//logic[63:0] tb_odata;
	
initial begin
	// Открытие файла "tests.txt" для чтения
    	file = $fopen("tests.txt", "r");
    	// Проверка, что файл был открыт успешно
	if (file == 0) begin
		$error("Не удалось открыть файл");
		$finish;
	end
	for(int j=0; j<320; j++) begin
		// Чтение строки из файла
		key = $fgets(file);
		idata = $fgets(file);
		if(odata != $fgets(file))
			$error("Round was failed: plaintext -%b, tb_output -%b, output -%b", idata, tb_odata, odata);
	end
	// Закрытие файла
        $fclose(file);	
$finish;
end

Round dut (
	.idata(idata),
	.odata(odata),
	.key(key)
);

endmodule
