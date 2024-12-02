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

    logic [63:0] tb_o;
    logic [63:0] popf;
    logic [63:0] tb_odata [$];

    logic qu [$];
    logic s_tvalid = 0;

    parameter COUNT_RANDOM_TESTCASES = 100; //не более 100 (в файле 100 тесткейсов)
    parameter bubbles = 32'b10100100001000000001000000000001;
    int bubbles_size = 0;

    initial begin
        $dumpfile("work/wave.ocd");
        $dumpvars(0, tb_encryption);
    end

    int count_read_bytes;
    int count = 0;
    reg [31:0] file;

    initial begin

        file = $fopen("testcases2.bin", "r");
        if (file)
            $display("File was opened successfully");
        else begin      
            $display("File was NOT opened successfully");
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

        count_read_bytes = $fread(round_keys, file); //считываем с файла 32 раундовых 48-битных ключа

        //проверка продолжительности шифрования блока
        s_axis_tdata = {32'b1, 32'b0}; //считываем блок ОТ (64 бита)
        s_axis_tvalid = 1'b1;
        while (!m_axis_tvalid) begin
            @(posedge clk);    
            count = count + 1;
        end
        $display("Шифрование одного блока занимает %2d такта(-ов)\n", count - 1);

        //проверка быстроты обновления s_axis_tready
        m_axis_tready = 1'b0;
        count = 0;
        while (s_axis_tready != 0) begin
            @(posedge clk);    
            count = count + 1;
        end
        $display("От обновления m_axis_tready до обновления s_axis_tready проходит %2d такта(-ов)\n", count - 1);

        //проверка соответствия последовательностей s_axis_tvalid и m_axis_tvalid
        m_axis_tready = 1'b1;
        count = 0;

        #320;

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
//            $display("%h", m_axis_tdata);
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
        for(int  i = 0; i < COUNT_RANDOM_TESTCASES; i++) begin
                @(posedge clk);
                count_read_bytes = $fread(s_axis_tdata, file); #1;
                s_axis_tvalid <= 1; #1;
                tb_odata.push_back(tb_o); #1;
                count_read_bytes = $fread(tb_o, file); #1;
            if (i > 29) begin
                popf = tb_odata.pop_front();
                if (m_axis_tdata != popf)
                    $display("FAILED %1d", i);
            end
        end
        while(tb_odata.size()) begin
            @(posedge clk); #1;
            popf = tb_odata.pop_front();
            if (m_axis_tdata != popf)
                $display("FAILED");
        end
        $fclose(file);
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