`timescale 1ns / 1ns

module tb_encryption;
    logic rst = 0;
    logic clk = 1;
    logic [32][47:0] round_keys;

    //slave AXI4-Stream
    logic [63:0] s_axis_tdata;
    logic s_axis_tvalid;
    logic s_axis_tready;

    //master AXI4-Stream
    logic [63:0] m_axis_tdata;
    logic m_axis_tvalid;
    logic m_axis_tready;

    logic [63:0] tb_odata;

    parameter COUNT_RANDOM_TESTCASES = 100;
    initial begin
        $dumpfile("work/wave.ocd");
        $dumpvars(0, tb_encryption);
    end

    always@(posedge clk) begin
        s_axis_tvalid <= 1;
        m_axis_tready <= 1;
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

        count_read_bytes = $fread(round_keys, file);
        for(int  i = 0; i < COUNT_RANDOM_TESTCASES; i = i + 1) begin
            count_read_bytes = $fread(s_axis_tdata, file);
            count_read_bytes = $fread(tb_odata, file);
            #64;
            if (m_axis_tvalid) begin
                if (m_axis_tdata != tb_odata) begin
                    $display("FAILED:\n    input: %b \n   tb_out: %b \n  rtl_out: %b", s_axis_tdata, tb_odata, m_axis_tdata);
                    $display("different: %b\n\n", tb_odata^m_axis_tdata);
                end
/*                else begin
                    $display("SUCCESS:\n    input: %b \n   tb_out: %b \n  rtl_out: %b", s_axis_tdata, tb_odata, m_axis_tdata);
                    $display("different: %b\n\n", tb_odata^m_axis_tdata);                
                end
*/
            end
        end
        $fclose(file);

    $finish;
    end

always #1 clk = ~clk;

encryption dut (
    .rst(rst),
    .clk(clk),
    .round_keys(round_keys),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tready(s_axis_tready),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready)
);

endmodule