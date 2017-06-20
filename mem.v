// External unified memory used by MIPS multicycle processor.
module mem(clk, we, a, wd, rd);
  input clk, we;
  input [31:0] a, wd;
  output [31:0] rd;
  
  reg [31:0] RAM[1048575:0];

  assign rd = RAM[a[31:2]]; // word aligned

  always @ (negedge clk) begin
    if (we)
      RAM[a[31:2]] <= wd;
  end

endmodule