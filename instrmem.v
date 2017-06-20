// External unified memory used by MIPS multicycle processor.
module instrmem(a, rd,rd2);
  input [31:0] a;
  output [31:0] rd,rd2;
   
  reg [31:0] RAM[63:0];

  integer i;

  initial begin
    for (i=21; i<64; i=i+1)  // CHANGE START VALUE WHENEVER YOU CHANGE RAM VALUES
      RAM[i] = 32'b0;
    $readmemh("memfile.dat",RAM); // "memfile.dat" contains your instructions in hex
  end

  assign rd = {RAM[a[31:2]]}; // word aligned
  assign rd2 ={RAM[a[31:2]+30'h1]};
endmodule