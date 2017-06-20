module globalbranchpredictor(clk,pcsrcd,pcsrcd2,pcd,pcbranchd,pcbranchd2,originalpc,pcnext,clrbp);
        input             clk;
	input      [1:0]  pcsrcd,pcsrcd2;
	input      [63:0] originalpc;
	input      [31:0] pcbranchd,pcbranchd2, pcd;
	output reg [31:0] pcnext;
	output reg        clrbp;
	reg [71:0] branchtargetbuffer[127:0];
	reg [31:0] pcstorage;
	reg [1:0]  global;
	//66 bits, first 32 bits address, next 32 bits predicted address, 2 bits T/NT
	
	integer i;
	reg foundflag, pcdfoundflag; // foundflag for Prediction, pcdfoundflag for mispredictions
  	initial begin
		global = 2'b00;
		for (i=0; i<128; i=i+1) begin
        	        branchtargetbuffer[i] = 72'bx;
		end
  	end

	integer j=0;
	integer count=0;
	integer recorder;

	always @(negedge clk) begin
		// IF Stage
		foundflag = 1'b0;
		pcdfoundflag = 1'b0;
		for (i=0; i<128; i=i+1) begin
			if (pcd==branchtargetbuffer[i][71:40]) begin
				pcdfoundflag = 1'b1;
				recorder     = i;
			end
			if (originalpc[63:32]==branchtargetbuffer[i][71:40] ) begin
				case(global)
				  2'b00: begin
					   if (!branchtargetbuffer[i][7]) begin
					     pcstorage = originalpc[63:32];
					     pcnext = branchtargetbuffer[i][39:8];
					   end				 
				         end
				  2'b01: begin
					   if (!branchtargetbuffer[i][5]) begin
					     pcstorage = originalpc[63:32];
					     pcnext = branchtargetbuffer[i][39:8];
					   end
				         end
				  2'b10: begin
					   if (!branchtargetbuffer[i][3]) begin
					     pcstorage = originalpc[63:32];
					     pcnext = branchtargetbuffer[i][39:8];
					   end
				         end
				  2'b11: begin
					   if (!branchtargetbuffer[i][1]) begin
					     pcstorage = originalpc[63:32];
					     pcnext = branchtargetbuffer[i][39:8];
					   end
				         end
				endcase
				foundflag = 1'b1;
				recorder = i;
			end
			else if (originalpc[31:0]==branchtargetbuffer[i][71:40] ) begin
				case(global)
				  2'b00: begin
					   if (!branchtargetbuffer[i][7]) begin
					     pcstorage = originalpc[31:0];
					     pcnext = branchtargetbuffer[i][39:8];
					   end				 
				         end
				  2'b01: begin
					   if (!branchtargetbuffer[i][5]) begin
					     pcstorage = originalpc[31:0];
					     pcnext = branchtargetbuffer[i][39:8];
					   end
				         end
				  2'b10: begin
					   if (!branchtargetbuffer[i][3]) begin
					     pcstorage = originalpc[31:0];
					     pcnext = branchtargetbuffer[i][39:8];
					   end
				         end
				  2'b11: begin
					   if (!branchtargetbuffer[i][1]) begin
					     pcstorage = originalpc[31:0];
					     pcnext = branchtargetbuffer[i][39:8];
					   end
				         end
				endcase
				foundflag = 1'b1;
				recorder = i;
			end
		end

		// ID and EX Stages
		// found? - Yes
		if (foundflag) begin
			clrbp = 1'b0;
			// Update the existing buffer to a higher taken
			case(global)
     				2'b00: begin  
					 global = 2'b00;
					 case(branchtargetbuffer[recorder][7:6])
						2'b00: branchtargetbuffer[recorder][7:6] = 2'b00;
						2'b01: branchtargetbuffer[recorder][7:6] = 2'b00;
						2'b10: branchtargetbuffer[recorder][7:6] = 2'b01;
						2'b11: branchtargetbuffer[recorder][7:6] = 2'b10;
					 endcase	
				       end
				2'b01: begin 
					global = 2'b00;
					 case(branchtargetbuffer[recorder][5:4])
						2'b00: branchtargetbuffer[recorder][5:4] = 2'b00;
						2'b01: branchtargetbuffer[recorder][5:4] = 2'b00;
						2'b10: branchtargetbuffer[recorder][5:4] = 2'b01;
						2'b11: branchtargetbuffer[recorder][5:4] = 2'b10;
					 endcase	
				       end
				2'b10: begin
					global = 2'b01;
					 case(branchtargetbuffer[recorder][3:2])
						2'b00: branchtargetbuffer[recorder][3:2] = 2'b00;
						2'b01: branchtargetbuffer[recorder][3:2] = 2'b00;
						2'b10: branchtargetbuffer[recorder][3:2] = 2'b01;
						2'b11: branchtargetbuffer[recorder][3:2] = 2'b10;
					 endcase	
				       end
				2'b11: begin 
					global = 2'b10;
					 case(branchtargetbuffer[recorder][1:0])
						2'b00: branchtargetbuffer[recorder][1:0] = 2'b00;
						2'b01: branchtargetbuffer[recorder][1:0] = 2'b00;
						2'b10: branchtargetbuffer[recorder][1:0] = 2'b01;
						2'b11: branchtargetbuffer[recorder][1:0] = 2'b10;
					 endcase	
				       end
    			endcase
		end
		// Misprediction
		else if (!pcsrcd[0] && pcdfoundflag) begin
			// Put back old count and issue a clr signal to pipefd
			clrbp = 1'b1;
			pcnext = pcstorage;
			// Update the existing buffer to a lower taken
			case(global)
      				2'b00: begin  
					 global = 2'b01;
					 case(branchtargetbuffer[recorder][7:6])
      						2'b00: branchtargetbuffer[recorder][7:6] = 2'b01;
      						2'b01: branchtargetbuffer[recorder][7:6] = 2'b10;
      						2'b10: branchtargetbuffer[recorder][7:6] = 2'b11;
      						2'b11: branchtargetbuffer[recorder][7:6] = 2'b11;
    					 endcase	
				       end
      				2'b01: begin 
					global = 2'b11;
					 case(branchtargetbuffer[recorder][5:4])
      						2'b00: branchtargetbuffer[recorder][5:4] = 2'b01;
      						2'b01: branchtargetbuffer[recorder][5:4] = 2'b10;
      						2'b10: branchtargetbuffer[recorder][5:4] = 2'b11;
      						2'b11: branchtargetbuffer[recorder][5:4] = 2'b11;
    					 endcase	
      				       end
				2'b10: begin
					global = 2'b01;
					 case(branchtargetbuffer[recorder][3:2])
      						2'b00: branchtargetbuffer[recorder][3:2] = 2'b01;
      						2'b01: branchtargetbuffer[recorder][3:2] = 2'b10;
      						2'b10: branchtargetbuffer[recorder][3:2] = 2'b11;
      						2'b11: branchtargetbuffer[recorder][3:2] = 2'b11;
    					 endcase	
      				       end
				2'b11: begin 
					global = 2'b11;
					 case(branchtargetbuffer[recorder][1:0])
      						2'b00: branchtargetbuffer[recorder][1:0] = 2'b01;
      						2'b01: branchtargetbuffer[recorder][1:0] = 2'b10;
      						2'b10: branchtargetbuffer[recorder][1:0] = 2'b11;
      						2'b11: branchtargetbuffer[recorder][1:0] = 2'b11;
    					 endcase	
				       end
    			endcase
		end

		//found? - No
		else begin
			if (pcsrcd[0]) begin//branch taken
				// Write into buffer at next available spot
				branchtargetbuffer[count][7:0]   = 8'b0;
				branchtargetbuffer[count][39:8]  = pcbranchd;
				branchtargetbuffer[count][71:40] = pcd;
				pcnext = pcbranchd;
				clrbp = 1'b0;
				count = count + 1;
				if (count > 127)
					count = 0;
			case(global)
				2'b00: global=2'b00;
				2'b01: global=2'b10;
				2'b10: global=2'b00;
				2'b11: global=2'b10;
			endcase
			end
			else if (pcsrcd2[0]) begin//branch taken
				// Write into buffer at next available spot
				branchtargetbuffer[count][7:0]   = 8'b0;
				branchtargetbuffer[count][39:8]  = pcbranchd2;
				branchtargetbuffer[count][71:40] = pcd;
				pcnext = pcbranchd2;
				clrbp = 1'b0;
				count = count + 1;
				if (count > 127)
					count = 0;
			case(global)
				2'b00: global=2'b00;
				2'b01: global=2'b10;
				2'b10: global=2'b00;
				2'b11: global=2'b10;
			endcase
			end
			else begin//branch not taken
				clrbp = 1'b0;
				pcnext = originalpc[63:32];
				case(global)
					2'b00: global=2'b01;
					2'b01: global=2'b11;
					2'b10: global=2'b01;
					2'b11: global=2'b11;
				endcase
			end
		end
	end
endmodule