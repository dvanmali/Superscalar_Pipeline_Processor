module mainmem(clk, hit,hit2, address, address2,miss,miss2, re, writetag, writeback, readdatamemory, readmisswritetomemory, readmisswritetocache, dirty);
   input clk, miss,miss2, hit,hit2, re, dirty;
   input [31:0] address,address2;
   input [127:0] writeback;
   input [19:0] writetag;
   input [127:0] readmisswritetomemory;
   output reg [127:0] readdatamemory;
   output reg [127:0] readmisswritetocache;
   reg temp;

   reg [127:0] memory[1048575:0];
   reg [1:0] offset;
   reg [127:0] index;

   integer i;
   initial begin
    for (i=0; i<262144; i=i+1) begin
      memory[i] = 128'hffffffffffffffffffffffffffffffff;
    end
   end

  //if a read miss happens
  /* 
  always @(!hit) begin
	case (address[1:0])
        	2'b00 : readmissdata = index[127:96];
		2'b01 : readmissdata = index[95:64];
		2'b10 : readmissdata = index[63:32];
		2'b11 : readmissdata = index[31:0];
	endcase
   end*/

   always @(posedge !hit, miss) begin
     if (!hit)
       readmisswritetocache = memory[address[31:14]];
     if (miss)
       readdatamemory = memory[address[31:14]];
   end

   always @(negedge !hit, miss) begin
     if (!hit & dirty)
       memory[address[31:14]] = readmisswritetomemory;
     if (miss & dirty)
       memory[writetag] = writeback;
   end

   always @(posedge !hit2, miss2) begin
     if (!hit2)
       readmisswritetocache = memory[address2[31:14]];
     if (miss2)
       readdatamemory = memory[address2[31:14]];
   end

   always @(negedge !hit2, miss2) begin
     if (!hit2 & dirty)
       memory[address2[31:14]] = readmisswritetomemory;
     if (miss2 & dirty)
       memory[writetag] = writeback;
   end

   //if a write miss happens
/*
   always @(miss) begin
	memory[writetag] = writeback;
	readdatamemory = memory[address[31:14]];
   end
*/
endmodule
