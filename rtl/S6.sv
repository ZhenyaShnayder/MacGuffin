module S6 (
	input logic [5:0] iword,
	output logic [1:0] oword
);


logic [1:0] S_box [0:63] = '{2'd2, 2'd2, 2'd1, 2'd3, 2'd2, 2'd0, 2'd3, 2'd0, 
2'd3, 2'd1, 2'd0, 2'd2, 2'd0, 2'd3, 2'd2, 2'd1, 
2'd0, 2'd0, 2'd3, 2'd1, 2'd1, 2'd3, 2'd0, 2'd2,
2'd2, 2'd0, 2'd1, 2'd3, 2'd1, 2'd1, 2'd3, 2'd2,

2'd3, 2'd0, 2'd2, 2'd1, 2'd3, 2'd0, 2'd1, 2'd2, 
2'd0, 2'd3, 2'd2, 2'd1, 2'd2, 2'd3, 2'd1, 2'd2,
2'd1, 2'd3, 2'd0, 2'd2, 2'd0, 2'd1, 2'd2, 2'd1, 
2'd1, 2'd0, 2'd3, 2'd0, 2'd3, 2'd2, 2'd0, 2'd3};

assign oword = S_box[iword];

endmodule