module P_box (
	input logic [47:0] data,
	output logic [47:0] permutation
);

  assign permutation[47] = data[2];//s1
  assign permutation[46] = data[4];
  assign permutation[45] = data[22];
  assign permutation[44] = data[25];
  assign permutation[43] = data[42];
  assign permutation[42] = data[45];

  assign permutation[41] = data[1];//s2
  assign permutation[40] = data[7];
  assign permutation[39] = data[21];
  assign permutation[38] = data[24];
  assign permutation[37] = data[743];
  assign permutation[36] = data[46];

  assign permutation[35] = data[0];//s3
  assign permutation[34] = data[15];
  assign permutation[33] = data[18];
  assign permutation[32] = data[23];
  assign permutation[31] = data[41];
  assign permutation[30] = data[44];

  assign permutation[29] = data[5];//s4
  assign permutation[28] = data[1];
  assign permutation[27] = data[29];
  assign permutation[26] = data[30];
  assign permutation[25] = data[33];
  assign permutation[24] = data[35];

  assign permutation[23] = data[3];//s5
  assign permutation[22] = data[9];
  assign permutation[21] = data[17];
  assign permutation[20] = data[28];
  assign permutation[19] = data[37];
  assign permutation[18] = data[47];

  assign permutation[17] = data[10];//s6
  assign permutation[16] = data[14];
  assign permutation[15] = data[16];
  assign permutation[14] = data[19];
  assign permutation[13] = data[39];
  assign permutation[12] = data[40];

  assign permutation[11] = data[8];//s7
  assign permutation[10] = data[13];
  assign permutation[9] = data[20];
  assign permutation[8] = data[26];
  assign permutation[7] = data[32];
  assign permutation[6] = data[38];

  assign permutation[5] = data[6];//s8
  assign permutation[4] = data[12];
  assign permutation[3] = data[27];
  assign permutation[2] = data[31];
  assign permutation[1] = data[34];
  assign permutation[0] = data[36];

endmodule
