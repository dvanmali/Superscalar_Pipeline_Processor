module testcache();
  reg         clk;
  reg         re, we, we2, we3;
  reg  [31:0] address, writedata;
  wire [31:0] readdatacache,readmissdata;
  wire        hit, miss, dirty;

  // test
  memory_system DUT(clk, re, we, we2, we3, address, writedata, readdatacache, hit, miss, dirty);

  // generate clock to sequence tests
  always begin
    clk <= 1;
    #5;
    clk <= 0;
    # 5;
  end

  // check results
  initial begin
/*
    re <= 1'b0;
    we <= 1'b0;
    we2 <=1'b0;
    we3 <= 1'b0;
    address <= 32'h0;
    writedata <= 32'b0;
    #10;

    // Write Hit: if in cache, write in cache
    re  <= 1'b0;
    we  <= 1'b1;
    we2 <= 1'b0;
    we3 <= 1'b0;
    address <= 32'h50;
    writedata <= 32'h7;
    #10;
    we  <= 1'b0;
    #10;

    // Read Hit: Hit generated, no need to go to main memory, read out of cache valid
    re  <= 1'b1;
    we  <= 1'b0;
    we2 <= 1'b0;
    we3 <= 1'b0;
    address <= 32'h50;
    writedata <= 32'hxxxxxxxx;
    #10;
    re  <= 1'b0;
    #10;

    // Write Hit: if in cache, write in cache
    re  <= 1'b0;
    we  <= 1'b1;
    we2 <= 1'b0;
    we3 <= 1'b0;
    address <= 32'h54;
    writedata <= 32'h7;
    #10;
    we  <= 1'b0;
    #200;
*/


    // Write Miss: Miss generated, gets main memory, write this data to this cache value
    re  <= 1'b0;
    we  <= 1'b1;
    we2 <= 1'b0;
    we3 <= 1'b0;
    address <= 32'h00004012;
    writedata <= 32'h12345678;
    #10;
    we  <= 1'b0;
    #200;
    we2 <= 1'b1;
    #5;
    we2 <= 1'b0;
    #5;

    // Read Hit: Hit generated, no need to go to main memory, read out of cache valid
    re  <= 1'b1;
    we  <= 1'b0;
    we2 <= 1'b0;
    we3 <= 1'b0;
    address <= 32'h00004012;
    writedata <= 32'hxxxxxxxx;
    #10;
    re  <= 1'b0;
    #10;

    // Read Miss: !Hit generated, gets main memory, read out of cache is initialized mainmemory value after writing new cache value
    re  <= 1'b1;
    we  <= 1'b0;
    we2 <= 1'b0;
    we3 <= 1'b0;
    address <= 32'h00008012;
    writedata <= 32'hxxxxxxxx;
    #10;
    re <= 1'b0;
    #200;
    we3 <= 1'b1;
    #5;
    we3 <= 1'b0;
    #20;

	
    // Write Hit: if in cache, write in cache
    re  <= 1'b0;
    we  <= 1'b1;
    we2 <= 1'b0;
    we3 <= 1'b0;
    address <= 32'h00008011;
    writedata <= 32'h87654321;
    #10;
    we  <= 1'b0;
    #200;

    // Write Hit: if in cache, write in cache
    re  <= 1'b0;
    we  <= 1'b1;
    we2 <= 1'b0;
    we3 <= 1'b0;
    address <= 32'h00008010;
    writedata <= 32'h01010101;
    #10;
    we  <= 1'b0;
    #200;



  end

endmodule