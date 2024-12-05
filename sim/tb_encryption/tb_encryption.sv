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

    logic qu [$];
    logic s_tvalid = 0;

    parameter bubbles = 32'b10100100001000000001000000000001;
    int bubbles_size = 0;

    initial begin
        $dumpfile("work/wave.ocd");
        $dumpvars(0, tb_encryption);
    end

    int count_read_bytes = 1;
    int count_read_f_cipher_text = 1;
    int count = 0;
    reg [31:0] f_round_keys;
    reg [31:0] f_plain_text;
    reg [31:0] f_cipher_text;
    int i;

    initial begin

        f_round_keys = $fopen("round_keys.bin", "r");
        if (f_round_keys)
            $display("SUCCESS: File round_keys was opened.");
        else begin      
            $display("FAILURE: File round_keys was NOT opened.");
            $finish;
        end

        f_plain_text = $fopen("plain_text.bin", "r");
        if (f_plain_text)
            $display("SUCCESS: File plain_text was opened.");
        else begin      
            $display("FAILURE: File plain_text was NOT opened.");
            $finish;
        end

        f_cipher_text = $fopen("cipher_text.bin", "r");
        if (f_cipher_text)
            $display("SUCCESS: File cipher_text was opened.");
        else begin      
            $display("FAILURE: File cipher_text was NOT opened.");
            $finish;
        end

      m_axis_tready = 0;
      s_axis_tvalid = 0;
      s_axis_tdata = 0;

        @(posedge clk); #1;
		    rst = 1'b1;
	    @(posedge clk); #1;
		    rst = 1'b0;
        //посмотреть в wave значения m_axis_tvalid и s_axis_tready после сброса

        m_axis_tready <= 1'b1;

        count_read_bytes = $fread(round_keys, f_round_keys); //считываем с файла 32 раундовых 48-битных ключа

        //проверка продолжительности шифрования блока
        s_axis_tdata = {32'b1, 32'b0}; //считываем блок ОТ (64 бита)
        s_axis_tvalid = 1'b1;
        while (!m_axis_tvalid) begin
            @(posedge clk);    
            count = count + 1;
        end
        $display("Шифрование одного блока занимает %2d такта(-ов)\n", count - 1);

        //проверка быстроты обновления s_axis_tready
        m_axis_tready = 1'b0; #1;
        count = 0;
        while (s_axis_tready != 0) begin
            @(posedge clk);
            count = count + 1;
        end
        $display("От обновления m_axis_tready до обновления s_axis_tready проходит %2d такта(-ов)\n", count);

        //проверка соответствия последовательностей s_axis_tvalid и m_axis_tvalid
        m_axis_tready = 1'b1;
        count = 0;

        @(posedge clk);

        while (s_axis_tready & count < 30) begin
            @(posedge clk) begin
                #1;
                s_axis_tdata =  {$urandom, $urandom };
                #1;
                s_axis_tvalid = $urandom_range(1);
                qu.push_back(s_axis_tvalid);
                count = count + 1;
            end
        end

        @(m_axis_tdata) begin
            while(qu.size()) begin
                @(posedge clk);
                s_tvalid = qu.pop_front();
                if (s_tvalid != m_axis_tvalid)
                $write("%d-%d\n", s_tvalid, m_axis_tvalid);
            end
        end

    //проверка на схлопывание пузырьков
        m_axis_tready = 0;
        s_axis_tvalid = 0;
        s_axis_tdata = 0;

        @(posedge clk); #1;
		    rst = 1'b1;
	    @(posedge clk); #1;
		    rst = 1'b0;

      m_axis_tready = 1'b0;

        for(int k = 0; k < 32; k++) begin
            @(posedge clk);
            s_axis_tdata <= k;
            if ((bubbles>>k)&1) begin
                bubbles_size = bubbles_size + 1;
                s_axis_tvalid <= 1;
            end
            else
                s_axis_tvalid <= 0;

        end
        for(int n = 0; n < 32; n++) begin
            @(posedge clk);
        end
        m_axis_tready = 1'b1; //и наблюдаем на выходе только valid блоки
        for(int k = 0; k < bubbles_size; k++) begin
            @(posedge clk);
        end

        //проверка корректной работы модуля encryption
        m_axis_tready = 0;
        s_axis_tvalid = 0;
        s_axis_tdata = 0;

        @(posedge clk); #1;
		    rst = 1'b1;
	    @(posedge clk); #1;
		    rst = 1'b0;

        m_axis_tready = 1;
        s_axis_tvalid = 1;

        for(i = 0; (i < 31) && count_read_bytes; i++) begin
            @(posedge clk);
            count_read_bytes <= $fread(s_axis_tdata, f_plain_text); #1;
            s_axis_tvalid <= 1; #1;
        end
        while (count_read_f_cipher_text) begin
        if (count_read_bytes)
            count_read_bytes <= $fread(s_axis_tdata, f_plain_text); #1;
        s_axis_tvalid <= 1; #1;
        @(posedge clk);
        count_read_f_cipher_text <= $fread(tb_odata, f_cipher_text); #1;
        if (m_axis_tdata != tb_odata)
            $display("FAILED");
        end

        $fclose(f_round_keys);
        $fclose(f_cipher_text);
        $fclose(f_plain_text);
        $finish;
    end


always #5 clk = ~clk;

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