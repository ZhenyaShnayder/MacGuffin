module round_F (
	input logic [47:0] F_input,
	output logic [15:0] F_output
);

logic [47:0] permutation;
P_box dutP (
  .data(F_input),
  .permutation(permutation)
);


logic [5:0] S_input;

assign S_input[5:0] = permutation[47:42];
logic [1:0] S_output1;
S1 dutS1 (
  .iword(S_input),
  .oword(S_output1)
);
assign F_output[15:14]=S_output1[1:0];

assign S_input[5:0] = permutation[41:36];
logic [1:0] S_output2;
S2 dutS2 (
  .iword(S_input),
  .oword(S_output2)
);
assign F_output[13:12]=S_output2[1:0];


assign S_input[5:0] = permutation[35:30];
logic [1:0] S_output3;
S3 dutS3 (
  .iword(S_input),
  .oword(S_output3)
);
assign F_output[11:10]=S_output3[1:0];

assign S_input[5:0] = permutation[29:24];
logic [1:0] S_output4;
S4 dutS4 (
  .iword(S_input),
  .oword(S_output4)
);
assign F_output[9:8]=S_output4[1:0];


assign S_input[5:0] = permutation[23:18];
logic [1:0] S_output5;
S5 dutS5 (
  .iword(S_input),
  .oword(S_output5)
);
assign F_output[7:6]=S_output5[1:0];

assign S_input[5:0] = permutation[17:12];
logic [1:0] S_output6;
S6 dutS6 (
  .iword(S_input),
  .oword(S_output6)
);
assign F_output[5:4]=S_output6[1:0];


assign S_input[5:0] = permutation[11:6];
logic [1:0] S_output7;
S7 dutS7 (
  .iword(S_input),
  .oword(S_output7)
);
assign F_output[3:2]=S_output7[1:0];

assign S_input[5:0] = permutation[5:0];
logic [1:0] S_output8;
S8 dutS8 (
  .iword(S_input),
  .oword(S_output8)
);
assign F_output[1:0]=S_output8[1:0];

endmodule