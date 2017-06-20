module regfile(clk, we3,we3_2, ra1,ra1_2, ra2,ra2_2, wa3,wa3_2, wd3,wd3_2, rd1,rd1_2, rd2,rd2_2);
  
  input clk, we3,we3_2;
  input [4:0] ra1, ra2, wa3,ra1_2,ra2_2,wa3_2;
  input [31:0] wd3,wd3_2;
  output [31:0] rd1, rd2,rd1_2,rd2_2;
  
  reg [31:0] rf[31:0];
  integer i;
  // three posrted register file
  // read two ports combinationally
  // write third port on rising edge of clk
  // register 0 hardwired to 0
  // note: for pipelined processor, write third port
  // on falling edge of clk
  initial begin
  	for (i=0;i<32;i=i+1) 
	rf[i] <= 32'b0;
  end
  always @ (!clk) begin
    if (we3)
      rf[wa3] <= wd3;
    if (we3_2)
      rf[wa3_2] <= wd3_2;
  end
 
  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
  assign rd1_2 = (ra1_2 != 0) ? rf[ra1_2] : 0;
  assign rd2_2 = (ra2_2 != 0) ? rf[ra2_2] : 0;
  
endmodule