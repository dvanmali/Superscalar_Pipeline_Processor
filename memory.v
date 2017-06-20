module memory(clk,memtoregm,memtoregm2,memwritem,memwritem2,we2,we2_2,we3,we3_2,aluoutm,aluoutm2,writedatam,writedatam2,readdatam,readdatam2,hit,hit2,miss,miss2,dirty);
  input clk,memtoregm,memwritem,we2,we3,memtoregm2,memwritem2,we2_2,we3_2;
  input  [31:0] aluoutm,aluoutm2,writedatam,writedatam2;
  output [31:0] readdatam,readdatam2;
  output        hit,hit2,miss,miss2,dirty;
  
  //mem datamem(clk, memwritem, aluoutm, writedatam, readdatam);
  memory_system mem(clk,memtoregm,memtoregm2,memwritem,memwritem2,we2,we2_2,we3,we3_2,aluoutm,aluoutm2,writedatam,writedatam2,
                  readdatam,readdatam2,hit,hit2,miss,miss2,dirty);

endmodule
