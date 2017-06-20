module mips_test3();
  reg clk;
  reg reset;
  wire memwrite;
  wire [31:0] writedata, dataadr;

  // instantiate device to be tested
  mipspipeline DUT(clk, reset, memwrite, dataadr, writedata);
  
  // initialize test
  initial begin
    reset <= 1;
    #22;
    reset <= 0;
  end
  
  // generate clock to sequence tests
  always begin
    clk <= 1;
    #5;
    clk <= 0;
    # 5;
  end
  
  // check results
  always @(negedge clk) begin
    if (memwrite) begin
      if (dataadr === 84 & writedata === 7) begin
        $display("Simulation succeeded");
        $stop;
      end
/*
      else begin
        $display("Simulation failed");
        $stop;
      end
*/
    end
  end
endmodule
