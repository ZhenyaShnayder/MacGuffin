module round_F (
	input logic [47:0] F_input,
	output logic [15:0] F_output
);

logic [47:0] permutation;
P_box dutP (
  .data(F_input),
  .permutation(permutation)
);

S1 dutS1 (
  .iword(permutation[47:42]),
  .oword(F_output[15:14])
);

S2 dutS2 (
  .iword(permutation[41:36]),
  .oword(F_output[13:12])
);


S3 dutS3 (
  .iword(permutation[35:30]),
  .oword(F_output[11:10])
);

S4 dutS4 (
  .iword(permutation[29:24]),
  .oword(F_output[9:8])
);


S5 dutS5 (
  .iword(permutation[23:18]),
  .oword(F_output[7:6])
);

S6 dutS6 (
  .iword(permutation[17:12]),
  .oword(F_output[5:4])
);


S7 dutS7 (
  .iword(permutation[11:6]),
  .oword(F_output[3:2])
);

S8 dutS8 (
  .iword(permutation[5:0]),
  .oword(F_output[1:0])
);

endmodule