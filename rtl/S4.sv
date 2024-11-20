module S4 (
	input logic [5:0] iword,
	output logic [1:0] oword
);


logic [0:63][1:0] S_box  = {2'd1, 2'd3, 2'd3, 2'd2, 2'd2, 2'd3, 2'd1, 2'd1, 
2'd0, 2'd0, 2'd0, 2'd3, 2'd3, 2'd0, 2'd2, 2'd1, 
2'd1, 2'd0, 2'd0, 2'd1, 2'd2, 2'd0, 2'd1, 2'd2,
2'd3, 2'd1, 2'd2, 2'd2, 2'd0, 2'd2, 2'd3, 2'd3,

2'd2, 2'd1, 2'd0, 2'd3, 2'd3, 2'd0, 2'd0, 2'd0, 
2'd2, 2'd2, 2'd3, 2'd1, 2'd1, 2'd3, 2'd3, 2'd2,
2'd3, 2'd3, 2'd1, 2'd0, 2'd1, 2'd1, 2'd2, 2'd3, 
2'd1, 2'd2, 2'd0, 2'd1, 2'd2, 2'd0, 2'd0, 2'd2};

assign oword = S_box[iword];

endmodule
