module branchhistorytable(clk,pcsrcd,pcd,pcbranchd,originalpc,pcnext,clrbp);
        input             clk;
	input      [1:0]  pcsrcd;
	input      [31:0] originalpc, pcbranchd, pcd;
	output reg [31:0] pcnext;
	output reg        clrbp;
	reg [65:0] branchtargetbuffer[127:0];
	reg [31:0] pcstorage;
	//66 bits, first 32 bits address, next 32 bits predicted address, 2 bits T/NT
	
	integer i;
	reg foundflag;
  	initial begin
		for (i=0; i<128; i=i+1) begin
        	        branchtargetbuffer[i] = 66'b0;
		end
  	end

	integer j=0;
	integer count=0;
	integer recorder;

	always @(*) begin
		// IF Stage
		foundflag = 1'b0;
		for (i=0; i<128; i=i+1) begin
			if (originalpc==branchtargetbuffer[i][65:34] ) begin
				if (!branchtargetbuffer[i][1]) begin
				  pcstorage = originalpc;
				  pcnext = branchtargetbuffer[i][33:2];
				end
				foundflag = 1'b1;
				recorder = i;
			end
		end

		// ID and EX Stages
		// found? - Yes
		if (foundflag) begin
			if (pcsrcd[0]) begin//branch taken
				clrbp = 1'b0;
				// Update the existing buffer to a higher taken
				case(branchtargetbuffer[recorder][1:0])
      					2'b00: branchtargetbuffer[recorder][1:0] = 2'b00;
      					2'b01: branchtargetbuffer[recorder][1:0] = 2'b00;
      					2'b10: branchtargetbuffer[recorder][1:0] = 2'b01;
      					2'b11: branchtargetbuffer[recorder][1:0] = 2'b10;
    				endcase
			end
			else begin//branch not taken
				// Put back old count and issue a clr signal to pipefd
				clrbp = 1'b1;
				pcnext = pcstorage;
				// Update the existing buffer to a lower taken
				case(branchtargetbuffer[recorder][1:0])
      					2'b00: branchtargetbuffer[recorder][1:0] = 2'b01;
      					2'b01: branchtargetbuffer[recorder][1:0] = 2'b10;
      					2'b10: branchtargetbuffer[recorder][1:0] = 2'b11;
      					2'b11: branchtargetbuffer[recorder][1:0] = 2'b11;
    				endcase
			end
		end
		// found? - No
		else begin
			if (pcsrcd[0]) begin//branch taken
				// Write into buffer at next available spot
				branchtargetbuffer[count][1:0]   = 2'b00;
				branchtargetbuffer[count][33:2]  = pcbranchd;
				branchtargetbuffer[count][65:34] = pcd;
				pcnext = pcbranchd;
				clrbp = 1'b0;
				count = count + 1;
				if (count > 127)
					count = 0;
			end
			else begin//branch not taken
				clrbp = 1'b0;
				pcnext = originalpc;
			end
		end
	end
endmodule
