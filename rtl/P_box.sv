module P_box (
	input logic [47:0] data,
	output logic [47:0] permutation
);

  assign permutation[47] = data[45];//s1   //в таблице это а2
  assign permutation[46] = data[42];//в таблице это а5
  assign permutation[45] = data[25];//в таблице это в6
  assign permutation[44] = data[22];
  assign permutation[43] = data[4];
  assign permutation[42] = data[2];

  assign permutation[41] = data[46];//s2
  assign permutation[40] = data[43];
  assign permutation[39] = data[24];
  assign permutation[38] = data[21];
  assign permutation[37] = data[7];
  assign permutation[36] = data[1];

  assign permutation[35] = data[44];//s3
  assign permutation[34] = data[41];
  assign permutation[33] = data[23];
  assign permutation[32] = data[18];
  assign permutation[31] = data[15];
  assign permutation[30] = data[0];

  assign permutation[29] = data[35];//s4
  assign permutation[28] = data[33];
  assign permutation[27] = data[30];
  assign permutation[26] = data[29];
  assign permutation[25] = data[11];
  assign permutation[24] = data[5];

  assign permutation[23] = data[47];//s5
  assign permutation[22] = data[37];
  assign permutation[21] = data[28];
  assign permutation[20] = data[17];
  assign permutation[19] = data[9];
  assign permutation[18] = data[3];

  assign permutation[17] = data[40];//s6
  assign permutation[16] = data[39];
  assign permutation[15] = data[19];
  assign permutation[14] = data[16];
  assign permutation[13] = data[14];
  assign permutation[12] = data[10];

  assign permutation[11] = data[38];//s7
  assign permutation[10] = data[32];
  assign permutation[9] = data[26];
  assign permutation[8] = data[20];
  assign permutation[7] = data[13];
  assign permutation[6] = data[8];

  assign permutation[5] = data[36];//s8
  assign permutation[4] = data[34];
  assign permutation[3] = data[31];
  assign permutation[2] = data[27];
  assign permutation[1] = data[12];
  assign permutation[0] = data[6];

endmodule
