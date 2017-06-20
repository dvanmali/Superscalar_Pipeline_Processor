module branchhistory_test();
  reg         clk;
  reg  [1:0]  pcsrcd;
  reg  [31:0] originalpc, pcbranchd, pcd;
  wire [31:0] pcnext;
  wire        clrbp;

  // test
   globalbranchpredictor DUT(clk,pcsrcd,pcd,pcbranchd,originalpc,pcnext,clrbp);

  // generate clock to sequence tests
  always begin
    clk <= 1;
    #5;
    clk <= 0;
    # 5;
  end

  // check results
  initial begin
    // No -> No: Regular instruction
    originalpc <= 32'h1;
    #10;
    pcd <= 32'h1;
    originalpc <= 32'h2;
    pcsrcd <= 2'b00;
    #10;

    // No -> Yes: Normal, non-existing in buffer, place originalpc values into buffer[0]
    pcd <= 32'h2;
    originalpc <= 32'h3;
    pcsrcd<=2'b00;
    #10;
    pcd <= 32'h3;
    originalpc <= 32'h4;
    pcbranchd <= 32'h50;
    pcsrcd <= 2'b01;
    #10;


    // No -> Yes: Normal, non-existing in buffer, place originalpc values into buffer[1]
    pcd <= 32'h4;
    originalpc <= 32'h50;
    pcsrcd     <= 2'b00;
    #10;
    pcd = 32'h50;
    originalpc <= 32'h51;
    pcbranchd <= 32'h10;
    pcsrcd <= 2'b01;
    #10;

    // Yes -> No: Existing in buffer, pcsrcd[0] is false
    pcd <= 32'h51;
    originalpc <= 32'h3;
    pcsrcd <=2'b00;
    #10;
    pcsrcd <= 2'b00;     // clrbp should be generated, originalpc comes back and is pcnext

    // Yes -> Yes: Existing in buffer, pcsrcd[0] is true
    pcd = 32'h3;
    originalpc <= 32'h23;
    pcsrcd<=2'b00;
    #10;
    pcsrcd <= 2'b01;
    pcd <= 32'h23;
    originalpc <= 32'h24;
    #10;
    pcd <=32'h24;
    originalpc <=32'h23;
    pcsrcd<=2'b00;
    #10;
    pcd <=32'h24;
    pcsrcd<=2'b01;
    originalpc <=32'h25;
    #10;
    pcsrcd<=2'b00;
    originalpc <= 32'h23;
    pcd<=32'h24;
    #10
    pcsrcd<=2'b01;
    originalpc<=32'h88;
    pcd<=32'h23;
    #10
    pcsrcd<=2'bx;
    originalpc<=32'hx;
    pcd<=32'hx;
    pcbranchd<=32'hx;
    



  end

endmodule
