module synchronizer #(
  parameter STAGES = 2
)(
  input rst,
  input clk,

  input   d,
  output  q
);

  logic pipeline [STAGES];

  generate
    for (genvar i = 0; i < STAGES; i++) begin
      always @(posedge clk) begin
        if (rst) pipeline[i] <= 1'b0; // fill all bits with zeros
        else if (i == 0) pipeline[i] <= d;
        else pipeline[i] <= pipeline[i-1];
      end
    end
  endgenerate

  assign q = pipeline[STAGES-1];

endmodule
