module pipefd(clk, clrbp, stalld, stalld2, pcsrcd, pcsrcd2, instrf,instrf2, pcplus4f, pcf, instrd,instrd2, pcplus4d, pcd);
  input clk, stalld,stalld2, clrbp;
  input [1:0] pcsrcd, pcsrcd2;
  input [31:0] pcplus4f, pcf;
  input [31:0] instrf,instrf2;
  output reg [31:0] pcplus4d, pcd;
  output reg [31:0] instrd,instrd2;
  
  wire clr;
  assign clr = (pcsrcd2[1:1] || pcsrcd2[0:0] || pcsrcd[1:1] || pcsrcd[0:0] || clrbp);
  
  always @ (posedge clk) begin
    if (clr & !stalld) begin
      pcplus4d = 32'b0;
      instrd   = 32'b0;
      instrd2   = 32'b0;
      pcd      = 32'b0;
    end
    else if (!stalld & !clr) begin
      pcplus4d = pcplus4f;
      instrd   = instrf;
      instrd2   = instrf2;
      pcd      = pcf;
    end
  end
  
endmodule