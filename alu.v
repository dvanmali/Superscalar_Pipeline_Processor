 module alu(a, b, sign, f, y, zero);
 input [31:0] a, b;
 input       sign;
 input [2:0] f;
 output reg [31:0] y;
 output reg zero;

 always @(*) begin
  if (sign) begin
    case (f)
      0: y <= $signed(a) & $signed(b);
      1: y <= $signed(a) | $signed(b);
      2: y <= $signed(a) + $signed(b);
      3: y <= $signed(a) ^ $signed(b);  // XOR
      4: y <= $signed(a) & ~$signed(b);
      5: y <= $signed(a) | ~$signed(b);
      6: y <= $signed(a) + ~$signed(b) + 1;
      7: y <= ($signed(a)<$signed(b)) ? 1:0;
     default: y <= 0;
    endcase
  end
  else begin 
    case (f)
      0: y <= $unsigned(a) & $unsigned(b);
      1: y <= $unsigned(a) | $unsigned(b);
      2: y <= $unsigned(a) + $unsigned(b);
      3: y <= $unsigned(a) ^ $unsigned(b);
      4: y <= $unsigned(a) & ~$unsigned(b);
      5: y <= $unsigned(a) | ~$unsigned(b);
      6: y <= $unsigned(a) + ~$unsigned(b) + 1;
      7: y <= ($unsigned(a)<$unsigned(b)) ? 1:0;
     default: y <= 0;
    endcase
  end
  zero <= (y==8'h0) ? 1:0;
 end
endmodule