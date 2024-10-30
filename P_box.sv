module P_box (
	input logic [47:0] data,
	output logic [47:0] permutation
);

  permutation[47] <= data[45];//s1   //в таблице это а2
  permutation[46] <= data[42];//в таблице это а5
  permutation[45] <= data[25];//в таблице это в6
  permutation[44] <= data[22];
  permutation[43] <= data[4];
  permutation[42] <= data[2];

  permutation[41] <= data[46];//s2
  permutation[40] <= data[43];
  permutation[39] <= data[24];
  permutation[38] <= data[21];
  permutation[37] <= data[7];
  permutation[36] <= data[1];

  permutation[35] <= data[44];//s3
  permutation[34] <= data[41];
  permutation[33] <= data[23];
  permutation[32] <= data[18];
  permutation[31] <= data[15];
  permutation[30] <= data[0];

  permutation[29] <= data[35];//s4
  permutation[28] <= data[33];
  permutation[27] <= data[30];
  permutation[26] <= data[29];
  permutation[25] <= data[11];
  permutation[24] <= data[5];

  permutation[23] <= data[47];//s5
  permutation[22] <= data[37];
  permutation[21] <= data[28];
  permutation[20] <= data[17];
  permutation[19] <= data[9];
  permutation[18] <= data[3];

  permutation[17] <= data[40];//s6
  permutation[16] <= data[39];
  permutation[15] <= data[19];
  permutation[14] <= data[16];
  permutation[13] <= data[14];
  permutation[12] <= data[10];

  permutation[11] <= data[38];//s7
  permutation[10] <= data[32];
  permutation[9] <= data[26];
  permutation[8] <= data[20];
  permutation[7] <= data[13];
  permutation[6] <= data[8];

  permutation[5] <= data[36];//s8
  permutation[4] <= data[34];
  permutation[3] <= data[31];
  permutation[2] <= data[27];
  permutation[1] <= data[12];
  permutation[0] <= data[6];

endmodule
