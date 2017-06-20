module decode(clk, regwritew,regwritew2, forwardad,forwardad2, forwardbd,forwardbd2, instrd,instrd2, resultw,resultw2, writeregw, writeregw2,aluoutm, aluoutm2,pcplus4d,pcplus4d2,
              pcbranchd, pcbranchd2,equald,equald2, mux1out, mux1out2,mux2out, mux2out2,rsd,rsd2, rtd, rtd2,rdd,rdd2, signimmd,signimmd2,signextd,signextd2);
               
  input         clk, regwritew,regwritew2;
  input  [1:0]  forwardad, forwardad2,forwardbd,forwardbd2; 
  input  [31:0] instrd,instrd2, resultw,resultw2, aluoutm, aluoutm2,pcplus4d,pcplus4d2;
  input  [4:0]  writeregw,writeregw2;
  output [31:0] pcbranchd,pcbranchd2;
  output reg    equald,equald2;
  output [31:0] mux1out,mux1out2, mux2out,mux2out2;
  output reg [4:0] rsd,rsd2, rtd,rtd2, rdd,rdd2;
  output [31:0] signimmd, signimmd2,signextd,signextd2;
                
  wire [31:0] rd1,rd1_2, rd2, rd2_2,signimmsll2,signimmsll2_2;
  wire [25:0] signssl,signssl2;

  assign signextd = {pcplus4d[31:26], signssl};
  assign signextd2 ={pcplus4d[31:26], signssl2};

  initial begin
    equald <= 0;
    rsd <= 0;
    rtd <= 0;
    rdd <= 0;
  end

  // Decode - Cycle 2
  // Reg File, Sign Ext, Shift Left, ALU
  regfile rf(clk, regwritew,regwritew2, instrd[25:21],instrd2[25:21], instrd[20:16],instrd2[20:16],
             writeregw,writeregw2, resultw,resultw2, rd1,rd1_2, rd2,rd2_2);
  signext se(instrd[15:0], signimmd);
  sl2     sll2(signimmd, signimmsll2);
  sl226   sel2(instrd[25:0],signssl);
  adder   addersl2pcplus4(signimmsll2, pcplus4d-32'h4, pcbranchd);
  signext se2(instrd2[15:0], signimmd2);
  sl2     sll2_2(signimmd2, signimmsll2_2);
  sl226   sel2_2(instrd2[25:0],signssl2);
  adder   addersl2pcplus4_2(signimmsll2_2, pcplus4d-32'h4, pcbranchd2);
  
  mux3 #(32)  muxrd1(rd1, aluoutm, aluoutm2, forwardad, mux1out);
  mux3 #(32)  muxrd2(rd2, aluoutm, aluoutm2, forwardbd, mux2out);
  mux3 #(32)  muxrd1_2(rd1_2, aluoutm2, aluoutm, forwardad2, mux1out2);
  mux3 #(32)  muxrd2_2(rd2_2, aluoutm2, aluoutm, forwardbd2, mux2out2);
  
  always @(*) begin
    equald = (mux1out==mux2out) ? 1:0;
    rsd = instrd[25:21];
    rtd = instrd[20:16];
    rdd = instrd[15:11];
    equald2 = (mux1out2==mux2out2)?1:0;
    rsd2 = instrd2[25:21];
    rtd2 = instrd2[20:16];
    rdd2 = instrd2[15:11];  
  end      
  
endmodule