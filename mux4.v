module mux4 #(parameter WIDTH = 8) (d0, d1, d2, d3, s, y);
  input [WIDTH-1:0] d0, d1, d2, d3;
  input [1:0] s;
  output reg [WIDTH-1:0] y;

  always @(*)
    case(s)
      2'b00: y <= d0;
      2'b01: y <= d1;
      2'b10: y <= d2;
      2'b11: y <= d3;
    endcase
endmodule