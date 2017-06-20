module adder (a, b, cout);
  input [31:0] a, b;
  output reg [31:0] cout;
  
  always @(*) begin
    if ($signed(a) + $signed(b) > 32'hFFFFFFFF)
      cout <= 32'h0;
    else
      cout <= $signed(a) + $signed(b);
  end
  
endmodule
