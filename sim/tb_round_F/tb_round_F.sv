`timescale 1ns / 1ns

module tb_round_F;
    logic [47:0] idata;
    logic [15:0] tb_odata;
    logic [15:0] odata;

parameter COUNT_RANDOM_TESTCASES = 100;
initial begin
    $dumpfile("work/wave.ocd");
    $dumpvars(0, tb_round_F);
end

initial begin
    int count_read_bytes;
    reg [31:0] file;
    file = $fopen("testcases.bin", "r");
    if (file)
        $display("File was opened successfully");
    else begin      
        $display("File was NOT opened successfully");
        $finish;
    end
    for(int  i = 0; i < COUNT_RANDOM_TESTCASES; i++) begin
        count_read_bytes = $fread(idata, file);
        count_read_bytes = $fread(tb_odata, file);
        #1;
        if (odata != tb_odata) begin
            $display("F was failed:\n    input: %b, \n   tb_out: %b, \n  rtl_out: %b", idata, tb_odata, odata);
            $display("different: %b\n\n", tb_odata^odata);
        end
    end
    $fclose(file);

$finish;
end

round_F dut (
    .F_input(idata),
    .F_output(odata)
);

endmodule