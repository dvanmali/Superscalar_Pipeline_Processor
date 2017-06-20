module sl226(a, y);
  input [25:0] a;
  output [25:0] y;

  // shift left by 2
  assign y = {a[23:0], 2'b00};
endmodule
