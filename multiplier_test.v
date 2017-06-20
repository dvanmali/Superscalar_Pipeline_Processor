module multiplier_test();
   reg         clk, sign, enable;
   reg  [31:0] multi_1, multi_2;
   wire [63:0] product;
   wire        multready;
  
  // instantiate device to be tested
  multiplier DUT(clk, sign, enable, multi_1, multi_2, product, multready);

  // generate clock to sequence tests
 always begin
    clk <= 1;
    #5;
    clk <= 0;
    # 5;
  end

  // check results
  initial begin
    // Initialize
    multi_1 <= 32'b0;
    multi_2 <= 32'b0;
    enable  <= 1'b0;
    sign    <= 1'b0;
    clk     <= 1'b0;

    // Test Cases
    enable <= 1'b0;
    #10;
    enable <= 1'b1;
    multi_1 <= 32'd3;
    multi_2 <= 32'd2;
    sign <= 1'b0;
    #320;

    // pos * zero
    enable <= 1'b0;
    #10;
    enable <= 1'b1;
    multi_1 <= 32'd0;
    multi_2 <= 32'd80;
    sign <= 1'b1;
    #320;

    // neg * zero
    enable <= 1'b0;
    #10;
    enable <= 1'b1;
    multi_1 <= 32'hffffffff;
    multi_2 <= 32'd0;
    sign <= 1'b1;
    #320;

    // neg * pos
    enable <= 1'b0;
    #10;
    enable <= 1'b1;
    multi_1 <= 32'hfffffff8;
    multi_2 <= 32'd2;
    sign <= 1'b1;
    #320;

    // pos * neg
    enable <= 1'b0;
    #10;
    enable <= 1'b1;
    multi_2 <= 32'hfffffff8;
    multi_1 <= 32'd2;
    sign <= 1'b1;
    #320;

    // neg * neg
    enable <= 1'b0;
    #10;
    enable <= 1'b1;
    multi_2 <= 32'hfffffff8;
    multi_1 <= 32'hfffffff2;
    sign <= 1'b1;
    #320;

  end

endmodule
