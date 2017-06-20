module mux5 #(parameter WIDTH = 8) (d0, d1, d2, d3, d4, s, y);
  input [WIDTH-1:0] d0, d1, d2, d3, d4;
  input [2:0] s;
  output reg [WIDTH-1:0] y;

  always @(*)
    case(s)
      3'b000: y <= d0;
      3'b001: y <= d1;
      3'b010: y <= d2;
      3'b011: y <= d3;
      3'b100: y <= d4;
    endcase
endmodule