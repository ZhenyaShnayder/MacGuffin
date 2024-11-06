module Round (
	input logic [63:0] idata,
  input logic [47:0] key,
	output logic [63:0] odata
);

logic [47:0] abc_key;
assign abc_key[47:0] = idata[47:0] ^ key[47:0];

logic [15:0] F_abc_key;
round_F dutF(
  .F_input(abc_key),
  .F_output(F_abc_key)
);

assign odata[15:0] = idata[63:48] ^ F_abc_key [15:0];
assign odata[63:16] = idata[47:0];
  
endmodule
