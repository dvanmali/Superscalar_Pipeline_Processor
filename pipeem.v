module pipeem(clk,writerege,writerege2,aluoute,aluoute2,writedatae,writedatae2,memwritee,memwritee2,
	      regwritee,regwritee2,memtorege,memtorege2,regwritem,regwritem2,memtoregm,memtoregm2,
              memwritem,memwritem2,writeregm,writeregm2,aluoutm,aluoutm2,writedatam,writedatam2,stallm,stallm2);
  input clk;
  input [4:0]  writerege,writerege2;
  input [31:0] aluoute,writedatae,aluoute2,writedatae2;
  input memwritee,memwritee2,regwritee,regwritee2,memtorege,memtorege2,stallm,stallm2;
  output reg regwritem,memtoregm,memwritem,regwritem2,memtoregm2,memwritem2;
  output reg [4:0] writeregm, writeregm2;
  output reg [31:0] aluoutm,writedatam,aluoutm2,writedatam2;
  
  always @ (posedge clk) begin
    if (!stallm) begin
      regwritem<=regwritee;
      memtoregm<=memtorege;
      memwritem<=memwritee;
      aluoutm<=aluoute;
      writedatam<=writedatae;
      writeregm<=writerege;
      regwritem2<=regwritee2;
      memtoregm2<=memtorege2;
      memwritem2<=memwritee2;
      aluoutm2<=aluoute2;
      writedatam2<=writedatae2;
      writeregm2<=writerege2;
    end
  end
endmodule
