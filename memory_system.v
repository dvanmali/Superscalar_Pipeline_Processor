module memory_system(clk, re,re2, we,we_2, we2, we2_2,we3,we3_2, address, address2,writedata, writedata2,readdatacache,readdatacache2, hit,hit2, miss,miss2, dirty);
  input         clk, we,we_2, we2,we2_2, we3, we3_2,re,re2;
  input [31:0]  address,address2, writedata,writedata2;
  output [31:0] readdatacache,readdatacache2;
  output        hit,hit2, miss,miss2, dirty;

  wire [127:0]  writeback;
  wire [127:0]  readdatamemory,readmisswritetomemory,readmisswritetocache;
  wire [19:0]   writetag;


  // instantiate device to be tested
  cache_wb cw(clk,we,we_2,we2,we2_2,we3,we3_2,re,re2,address,address2,writedata,writedata2,writeback,hit,hit2,miss,miss2,readdatacache,readdatacache2,readdatamemory,writetag,readmisswritetomemory,readmisswritetocache,dirty);

  mainmem  mm(clk, hit, hit2,address,address2, miss, miss2,re, writetag, writeback, readdatamemory, readmisswritetomemory, readmisswritetocache, dirty);

endmodule