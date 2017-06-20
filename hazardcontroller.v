module hazardcontroller(clk,rsd,rsd2,rtd,rtd2,rse,rse2,rte,rte2,branchd,branchd2,regwritee,regwritee2,memtorege,memtorege2,regwritem,regwritem2,
                        memtoregm,memtoregm2,regwritew,regwritew2,writerege,writerege2,writeregm,writeregm2,writeregw,writeregw2,stalld,stalld2,
                        stallf,stallf2,stalle,stalle2,stallm,stallm2,stallw,stallw2,flushe,flushe2,forwardad,forwardad2,forwardbd,forwardbd2,forwardae,forwardae2,forwardbe,forwardbe2,
                        memwritem,memwritem2,memwritee,memwritee2,hit,hit2,miss,miss2,dirty,dirty2,we2,we2_2,we3,we3_2,multen,multen2,multready,multready2,swstalle,lwstalle,branchstalld);

  input             clk,branchd,regwritee,regwritem,regwritew,memtorege,memtoregm,hit,miss,dirty,memwritem,memwritee,multen,multready;
  input             clk,branchd2,regwritee2,regwritem2,regwritew2,memtorege2,memtoregm2,hit2,miss2,dirty2,memwritem2,memwritee2,multen2,multready2;
  input   [4:0]     rsd,rtd,rse,rte,writerege,writeregm,writeregw;
  input   [4:0]     rsd2,rtd2,rse2,rte2,writerege2,writeregm2,writeregw2;
  output reg        stallf,stalld,stalle,stallm,stallw,flushe,we2,we3;
  output reg        stallf2,stalld2,stalle2,stallm2,stallw2,flushe2,we2_2,we3_2;
  output reg [1:0]  forwardad,forwardbd;
  output reg [1:0]  forwardad2,forwardbd2;
  output reg [2:0]  forwardae,forwardbe;
  output reg [2:0]  forwardae2,forwardbe2;
  output reg        swstalle,lwstalle,branchstalld;
  reg		    lwstalld;

  reg[5:0] count = 6'd20; // Used for 20 cycle main memory stall count

  initial begin
    count<=6'd20;
    lwstalld <= 1'b0;
    branchstalld <= 1'b0;
    flushe <= 1'b0;
    stalld <= 1'b0;
    stallf <= 1'b0;
    stalle <= 1'b0;
    stallm <= 1'b0;
    stallw <= 1'b0;
    lwstalle <= 1'b0;
    swstalle <= 1'b0;
    we2    <= 1'b0;
    we3    <= 1'b0;
    forwardad <= 2'b0;
    forwardbd <= 2'b0;
    forwardae <= 3'b00;
    forwardbe <= 3'b00; 
    flushe2 <= 1'b0;
    stalld2 <= 1'b0;
    stallf2 <= 1'b0;
    stalle2 <= 1'b0;
    stallm2 <= 1'b0;
    stallw2 <= 1'b0;
    we2_2    <= 1'b0;
    we3_2    <= 1'b0;
    forwardad2 <= 2'b0;
    forwardbd2 <= 2'b0;
    forwardae2 <= 3'b00;
    forwardbe2 <= 3'b00;    
  end

 // forwarding sources to D stage (branch equality)
  always @( rsd, rsd2, rtd, rtd2, writeregm, regwritem, writeregm2, regwritem2 ) begin
    forwardad <= 2'b00; forwardbd <= 2'b00;
    forwardad2 <= 2'b00; forwardbd2 <= 2'b00;

    if (rsd !=0 & (rsd == writeregm) & regwritem)		// 1-->5
      forwardad <= 2'b01;
    else if (rtd !=0 & (rtd == writeregm) & regwritem)		// 1-->5
      forwardbd <= 2'b01;
    if (rsd !=0 & (rsd == writeregm2) & regwritem2)		// 1-->6
      forwardad <= 2'b10;
    else if (rtd !=0 & (rtd == writeregm2) & regwritem2)	// 1-->6
      forwardbd <= 2'b10;

    if (rsd2 !=0 & (rsd2 == writeregm) & regwritem)		// 2-->5
      forwardad2 <= 2'b10;
    else if (rtd2 !=0 & (rtd2 == writeregm) & regwritem)	// 2-->5
      forwardbd2 <= 2'b10;
    if (rsd2 !=0 & (rsd2 == writeregm2) & regwritem2)		// 2-->6
      forwardad2 <= 2'b01;
    else if (rtd2 !=0 & (rtd2 == writeregm2) & regwritem2)	// 2-->6
      forwardbd2 <= 2'b01;
  end

 // forwarding sources to E stage (ALU)
 always @( rse, rse2, rte, rte2, writeregm, regwritem, writeregw, regwritew, regwritee ) begin
     forwardae <= 2'b00; forwardbe <= 2'b00;
     forwardae2 <= 2'b00; forwardbe2 <= 2'b00;
     //if (rse != 0) begin
       if ((rse == writeregm2) & regwritem2)		// 4-->1
         forwardae  <= 3'b011;
       else if ((rse == writeregm)  & regwritem)	// 3-->1
         forwardae  <= 3'b010;
       else if ((rse == writeregw2) & regwritew2)	// 6-->1
         forwardae  <= 3'b100;
       else if ((rse == writeregw)  & regwritew)	// 5-->1
         forwardae  <= 3'b001;
       if ((rse2 == writerege) & regwritee)		// 1-->2
         forwardae2 <= 3'b011;
       else if ((rse2 == writeregm2) & regwritem2)	// 4-->2
         forwardae2 <= 3'b010;
       else if ((rse2 == writeregm)  & regwritem)	// 3-->2
         forwardae2  <= 3'b100;
       else if ((rse2 == writeregw2) & regwritew2)	// 6-->2
         forwardae2 <= 3'b001;
       else if ((rse2 == writeregw)  & regwritew)	// 5-->2
         forwardae2  <= 3'b101;
     //end
     //if (rte != 0) begin
       if ((rte == writeregm2) & regwritem2)		// 4-->1
         forwardbe  <= 3'b011;
       else if ((rte == writeregm)  & regwritem)	// 3-->1
         forwardbe  <= 3'b010;
       else if ((rte == writeregw2) & regwritew2)	// 6-->1
         forwardbe  <= 3'b100;
       else if ((rte == writeregw)  & regwritew)	// 5-->1
         forwardbe  <= 3'b001;
       if ((rte2 == writerege) & regwritee)		// 1-->2
         forwardbe2 <= 3'b011;
       else if ((rte2 == writeregm2) & regwritem2)	// 4-->2
         forwardbe2 <= 3'b010;
       else if ((rte2 == writeregm)  & regwritem)	// 3-->2
         forwardbe2  <= 3'b100;
       else if ((rte2 == writeregw2) & regwritew2)	// 6-->2
         forwardbe2 <= 3'b001;
       else if ((rte2 == writeregw)  & regwritew)	// 5-->2
         forwardbe2  <= 3'b101;
     //end
 end

  // stall for cache
  always @(posedge clk, memtoregm, memwritem) begin
    if ((memtoregm || memwritem) && count>6'd19) begin
      stallm = 1'b1;
      count = count - 1;
    end
    else if ((memtoregm || memwritem) && count>6'd0) begin // Need to wait 1 cycle before valid dirty, hit, miss
      if ((((miss || miss2) && dirty) || count>6'd18) || ((!hit || !hit2) && dirty && memtoregm)) begin
        stallm = 1'b1;
        count  = count - 6'b1;
      end
      else if ((miss || miss2) && count==6'd1) begin
        we2    = 1'b1;
        count  = count - 6'd1;
      end
      else if ((!hit || !hit2) && count==6'd1) begin
        we3    = 1'b1;
        count  = count - 6'd1;
      end
      else if ((miss || miss2) || (!hit || !hit2))
        count  = 6'd0; // No write to main memory needed, just read, so no 20 cycles
    end
    else begin
      we2    = 1'b0;
      we3    = 1'b0;
      stallm = 1'b0;
      count  = 6'd20;
    end
  end

 // stalls
  always @( memtorege, memwritee, rte, rse, rte, rtd, branchd, regwritee, writerege, rsd, memtoregm, writeregm, stallm,
            memtorege2, memwritee2, rte2, rse2, rte2, rtd2, branchd2, regwritee2, writerege2, rsd2, memtoregm2, writeregm2, stallm2) begin
    lwstalld = (memtorege && ((rte == rsd) || (rte == rtd))) || (memtorege2 && ((rte2 == rsd2) || (rte2 == rtd2)));

    lwstalle = (memtorege && memtorege2 && !memtoregm);
    swstalle = (memwritee && memwritee2 && !memwritem);

    branchstalld = (branchd  && (regwritee  && ( (writerege  == rsd)  || (writerege  == rtd)  ))) ||
		   (branchd  && (regwritee2 && ( (writerege2 == rsd)  || (writerege2 == rtd)  ))) ||
		   (branchd2 && (regwritee  && ( (writerege ==  rsd2) || (writerege  == rtd2) ))) ||
		   (branchd2 && (regwritee2 && ( (writerege2 == rsd2) || (writerege2 == rtd2) )));

    stalle = lwstalle || swstalle || stallm || (multen && !multready);
    stallw = stallm;
    stalld = lwstalld || branchstalld || stalle;
    stallf = stalld; // stalling D stalls all previous stages
    flushe = branchstalld; // stalling D flushes next stage
  end

endmodule
