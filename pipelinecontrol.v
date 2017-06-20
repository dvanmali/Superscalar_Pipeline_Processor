module pipelinecontrol(instrd, equald, memtoregd, regwrited, memwrited, alucontrold, alusrcd, regdstd, pcsrcd, branchd, bned, signd, multseld);
  input [31:0] instrd;
  input equald;
  output memtoregd, regwrited, memwrited, branchd, bned, signd;
  output [2:0] alucontrold;
  output alusrcd, multseld;
  output regdstd;
  output [1:0] pcsrcd;
  reg pc0;
  wire [5:0] op, funct;
  wire [3:0] aluop;

  assign op    = instrd[31:26];
  assign funct = instrd[5:0];
  

  pipelinedec pd(op, regwrited, memtoregd, memwrited, aluop, alusrcd, regdstd, branchd, bned, jumpd);
  aludec      ad(funct, aluop, alucontrold, signd, multseld);
  
  always @(*) begin
     pc0 <= (equald & branchd) | (~equald & bned);
  end
  assign pcsrcd = {jumpd, pc0};

endmodule
