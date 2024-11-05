`timescale 1ns / 1ns

module tb_Sn;
    logic [5:0] input_data;
    logic [1:0] output_s1, output_s2, output_s3, output_s4, output_s5, output_s6, output_s7, output_s8;
    parameter MAX_INPUT_VALUE_TO_S_BOX = 63;

initial begin
	$dumpfile("work/wave.ocd");
	$dumpvars(0, tb_Sn);
end

logic [0:63][1:0] s1 = {
    2'b10, 2'b00, 2'b00, 2'b11, 2'b11, 2'b01, 2'b01, 2'b00, 
    2'b00, 2'b10, 2'b11, 2'b00, 2'b11, 2'b11, 2'b10, 2'b01,
    2'b01, 2'b10, 2'b10, 2'b00, 2'b00, 2'b10, 2'b10, 2'b11,
    2'b01, 2'b11, 2'b11, 2'b01, 2'b00, 2'b01, 2'b01, 2'b10,
    2'b00, 2'b11, 2'b01, 2'b10, 2'b10, 2'b10, 2'b10, 2'b00,
    2'b11, 2'b00, 2'b00, 2'b11, 2'b00, 2'b01, 2'b11, 2'b01,
    2'b11, 2'b01, 2'b10, 2'b11, 2'b11, 2'b01, 2'b01, 2'b10,
    2'b01, 2'b10, 2'b10, 2'b00, 2'b01, 2'b00, 2'b00, 2'b11
};

logic [0:63][1:0] s2 = {
    2'b11, 2'b01, 2'b01, 2'b11, 2'b10, 2'b00, 2'b10, 2'b01,
    2'b00, 2'b11, 2'b11, 2'b00, 2'b01, 2'b10, 2'b00, 2'b10,
    2'b11, 2'b10, 2'b01, 2'b00, 2'b00, 2'b01, 2'b11, 2'b10,
    2'b10, 2'b00, 2'b00, 2'b11, 2'b01, 2'b11, 2'b10, 2'b01,
    2'b00, 2'b11, 2'b10, 2'b10, 2'b01, 2'b10, 2'b11, 2'b01,
    2'b10, 2'b01, 2'b00, 2'b11, 2'b11, 2'b00, 2'b01, 2'b00,
    2'b01, 2'b11, 2'b10, 2'b00, 2'b10, 2'b01, 2'b00, 2'b10,
    2'b11, 2'b00, 2'b01, 2'b01, 2'b00, 2'b10, 2'b11, 2'b11 
};

logic [0:63][1:0] s3 = {
    2'b10, 2'b11, 2'b00, 2'b01, 2'b11, 2'b00, 2'b10, 2'b11, 
    2'b00, 2'b01, 2'b01, 2'b00, 2'b11, 2'b00, 2'b01, 2'b10, 
    2'b01, 2'b00, 2'b11, 2'b10, 2'b10, 2'b01, 2'b01, 2'b10, 
    2'b11, 2'b10, 2'b00, 2'b11, 2'b00, 2'b11, 2'b10, 2'b01, 
    2'b11, 2'b01, 2'b00, 2'b10, 2'b00, 2'b11, 2'b11, 2'b00, 
    2'b10, 2'b00, 2'b11, 2'b11, 2'b01, 2'b10, 2'b00, 2'b01, 
    2'b11, 2'b00, 2'b01, 2'b11, 2'b00, 2'b10, 2'b10, 2'b01, 
    2'b01, 2'b11, 2'b10, 2'b01, 2'b10, 2'b00, 2'b01, 2'b10
};

logic [0:63][1:0] s4 = {
    2'b01, 2'b11, 2'b11, 2'b10, 2'b10, 2'b11, 2'b01, 2'b01, 
    2'b00, 2'b00, 2'b00, 2'b11, 2'b11, 2'b00, 2'b10, 2'b01, 
    2'b01, 2'b00, 2'b00, 2'b01, 2'b10, 2'b00, 2'b01, 2'b10, 
    2'b11, 2'b01, 2'b10, 2'b10, 2'b00, 2'b10, 2'b11, 2'b11, 
    2'b10, 2'b01, 2'b00, 2'b11, 2'b11, 2'b00, 2'b00, 2'b00, 
    2'b10, 2'b10, 2'b11, 2'b01, 2'b01, 2'b11, 2'b11, 2'b10, 
    2'b11, 2'b11, 2'b01, 2'b00, 2'b01, 2'b01, 2'b10, 2'b11, 
    2'b01, 2'b10, 2'b00, 2'b01, 2'b10, 2'b00, 2'b00, 2'b10
};

logic [0:63][1:0] s5 = {
    2'b00, 2'b10, 2'b10, 2'b11, 2'b00, 2'b00, 2'b01, 2'b10, 
    2'b01, 2'b00, 2'b10, 2'b01, 2'b11, 2'b11, 2'b00, 2'b01, 
    2'b10, 2'b01, 2'b01, 2'b00, 2'b01, 2'b11, 2'b11, 2'b10, 
    2'b11, 2'b01, 2'b00, 2'b11, 2'b10, 2'b10, 2'b11, 2'b00, 
    2'b00, 2'b11, 2'b00, 2'b10, 2'b01, 2'b10, 2'b11, 2'b01, 
    2'b10, 2'b01, 2'b11, 2'b10, 2'b01, 2'b00, 2'b10, 2'b11, 
    2'b11, 2'b00, 2'b11, 2'b11, 2'b10, 2'b00, 2'b01, 2'b11, 
    2'b00, 2'b10, 2'b01, 2'b00, 2'b00, 2'b01, 2'b10, 2'b01    
};

logic [0:63][1:0] s6 = {
    2'b10, 2'b10, 2'b01, 2'b11, 2'b10, 2'b00, 2'b11, 2'b00, 
    2'b11, 2'b01, 2'b00, 2'b10, 2'b00, 2'b11, 2'b10, 2'b01, 
    2'b00, 2'b00, 2'b11, 2'b01, 2'b01, 2'b11, 2'b00, 2'b10, 
    2'b10, 2'b00, 2'b01, 2'b11, 2'b01, 2'b01, 2'b11, 2'b10, 
    2'b11, 2'b00, 2'b10, 2'b01, 2'b11, 2'b00, 2'b01, 2'b10, 
    2'b00, 2'b11, 2'b10, 2'b01, 2'b10, 2'b11, 2'b01, 2'b10, 
    2'b01, 2'b11, 2'b00, 2'b10, 2'b00, 2'b01, 2'b10, 2'b01, 
    2'b01, 2'b00, 2'b11, 2'b00, 2'b11, 2'b10, 2'b00, 2'b11
};

logic [0:63][1:0] s7 = {
    2'b00, 2'b11, 2'b11, 2'b00, 2'b00, 2'b11, 2'b10, 2'b01, 
    2'b11, 2'b00, 2'b00, 2'b11, 2'b10, 2'b01, 2'b11, 2'b10, 
    2'b01, 2'b10, 2'b10, 2'b01, 2'b11, 2'b01, 2'b01, 2'b10, 
    2'b01, 2'b00, 2'b10, 2'b11, 2'b00, 2'b10, 2'b01, 2'b00, 
    2'b01, 2'b00, 2'b00, 2'b11, 2'b11, 2'b11, 2'b11, 2'b10, 
    2'b10, 2'b01, 2'b01, 2'b00, 2'b01, 2'b10, 2'b10, 2'b01, 
    2'b10, 2'b11, 2'b11, 2'b01, 2'b00, 2'b00, 2'b10, 2'b11, 
    2'b00, 2'b10, 2'b01, 2'b00, 2'b11, 2'b01, 2'b00, 2'b10
};

logic [0:63][1:0] s8 = {
    2'b11, 2'b01, 2'b00, 2'b11, 2'b10, 2'b11, 2'b00, 2'b10, 
    2'b00, 2'b10, 2'b11, 2'b01, 2'b11, 2'b01, 2'b01, 2'b00, 
    2'b10, 2'b10, 2'b11, 2'b01, 2'b01, 2'b00, 2'b10, 2'b11, 
    2'b01, 2'b00, 2'b00, 2'b10, 2'b10, 2'b11, 2'b01, 2'b00, 
    2'b01, 2'b00, 2'b11, 2'b01, 2'b00, 2'b10, 2'b01, 2'b01, 
    2'b11, 2'b00, 2'b10, 2'b10, 2'b10, 2'b10, 2'b00, 2'b11, 
    2'b00, 2'b11, 2'b00, 2'b10, 2'b10, 2'b11, 2'b11, 2'b00, 
    2'b11, 2'b01, 2'b01, 2'b01, 2'b01, 2'b00, 2'b10, 2'b11
};

initial begin 
    for (int i = 0; i <= MAX_INPUT_VALUE_TO_S_BOX; i++)
    begin
        input_data = i; #1;
        if (output_s1 != s1[i]) $error("S1 box was failed: input: %b, rtl_output:%b, model_output: %b", input_data, output_s1, s1[i]);
        if (output_s2 != s2[i]) $error("S2 box was failed: input: %b, rtl_output:%b, model_output: %b", input_data, output_s2, s2[i]);
        if (output_s3 != s3[i]) $error("S3 box was failed: input: %b, rtl_output:%b, model_output: %b", input_data, output_s3, s3[i]);           
        if (output_s4 != s4[i]) $error("S4 box was failed: input: %b, rtl_output:%b, model_output: %b", input_data, output_s4, s4[i]);
        if (output_s5 != s5[i]) $error("S5 box was failed: input: %b, rtl_output:%b, model_output: %b", input_data, output_s5, s5[i]);
        if (output_s6 != s6[i]) $error("S6 box was failed: input: %b, rtl_output:%b, model_output: %b", input_data, output_s6, s6[i]);
        if (output_s7 != s7[i]) $error("S7 box was failed: input: %b, rtl_output:%b, model_output: %b", input_data, output_s7, s7[i]);
        if (output_s8 != s8[i]) $error("S8 box was failed: input: %b, rtl_output:%b, model_output: %b", input_data, output_s8, s8[i]);        
    end
$finish;
end


S1 dut1 (
    .iword(input_data),
    .oword(output_s1)
);

S2 dut2 (
    .iword(input_data),
    .oword(output_s2)
);

S3 dut3 (
    .iword(input_data),
    .oword(output_s3)
);

S4 dut4 (
    .iword(input_data),
    .oword(output_s4)
);

S5 dut5 (
    .iword(input_data),
    .oword(output_s5)
);

S6 dut6 (
    .iword(input_data),
    .oword(output_s6)
);

S7 dut7 (
    .iword(input_data),
    .oword(output_s7)
);

S8 dut8 (
    .iword(input_data),
    .oword(output_s8)
);

endmodule