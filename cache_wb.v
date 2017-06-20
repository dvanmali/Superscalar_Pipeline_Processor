module cache_wb(clk,we,we_2,we2,we2_2,we3,we3_2,re,re2,address,address2,writedata,writedata2,writeback,hit,hit2,miss,miss2,readdatacache,readdatacache2,readdatamemory,writetag,readmisswritetomemory,readmisswritetocache,dirty);
  input clk, we,we_2,we2,we2_2,we3,we3_2,re,re2;
  input [31:0] address, address2, writedata,writedata2;
  input [127:0] readdatamemory; // data from Main Memory
  input [127:0] readmisswritetocache;
  output reg hit,hit2, miss,miss2, dirty; // hit is for read, miss is for write
  output reg [31:0] readdatacache,readdatacache2;
  output reg [127:0] writeback; // Miss is called and sends out old data
  output reg [19:0]  writetag;
  output reg [127:0] readmisswritetomemory;
    
  //2-way associative, 2048 4-word block, 8192 slots, 1024 sets, in total 32KB Bytes
  //address: 20 bits tag, 10bits index, 2 bits offset

  // Each set in cache contains:
  // 	2 dirty bit(change only if written to save 20-cycle time) (first one is way 1, second is way 2), 1 least recently used bit
  // 	Way 1: 1 valid bit, 18 tag bits, 128 bits data (4 blocks of 32 bits)
  // 	Way 2: 1 valid bit, 18 tag bits, 128 bits data (4 blocks of 32 bits)

  reg [300:0] set[1023:0];
  reg [300:0] index;
  reg [300:0] index2;
  reg         valid1,valid2,comparator1,comparator2, and1, and2, used;
  reg [19:0]  tag1,tag2;
  reg [31:0]  data1_0,data1_1, data1_2, data1_3, data2_0,data2_1, data2_2, data2_3;
  reg [31:0]  mux_in0,mux_in1,mux_in2,mux_in3;

  integer i;
  initial begin
    hit = 1'b0;
    miss = 1'b0;
    hit2 = 1'b0;
    miss2= 1'b0;
    dirty = 1'b0;
    for (i=0; i<1024; i=i+1) begin
      set[i] = 301'b0;
    end
  end

  always @(*) begin
    index   = set[address[11:2]];
    index2  = set[address2[11:2]];
  end

  //read
  always @(posedge clk) begin
    if (re) begin
      //dirty1  = index[300];
      //dirty2  = index[299];
      //used    = index[298];
      valid1  = index[297];
      valid2  = index[148];
      tag1    = index[296:277];
      tag2    = index[147:128];
      data1_0 = index[276:245];
      data1_1 = index[244:213];
      data1_2 = index[212:181];
      data1_3 = index[180:149];
      data2_0 = index[127:96];
      data2_1 = index[95:64];
      data2_2 = index[63:32];
      data2_3 = index[31:0];

      comparator1 = (tag1 == address[31:12]) ? 1:0;
      comparator2 = (tag2 == address[31:12]) ? 1:0;
      and1        = comparator1 & valid1;
      and2        = comparator2 & valid2;

      if (and1) begin
        mux_in0 = data1_0;
        mux_in1 = data1_1;
        mux_in2 = data1_2;
        mux_in3 = data1_3;
      end
      if (and2) begin
        mux_in0 = data2_0;
        mux_in1 = data2_1;
        mux_in2 = data2_2;
        mux_in3 = data2_3;
      end  

    case(address[1:0])
      2'b00: readdatacache <= mux_in0;
      2'b01: readdatacache <= mux_in1;
      2'b10: readdatacache <= mux_in2;
      2'b11: readdatacache <= mux_in3;
    endcase

     hit         = and1 | and2;
     // if hit, change used bit accordingly
     if (hit) begin
       if (comparator1 == 1'b1)
         set[address[11:2]][298] = 1'b1;
       else if (comparator2 == 1'b1)
         set[address[11:2]][298] = 1'b0;
     end

     // if not hit, ask data from memory
     if (!hit) begin
       dirty =  set[address[11:2]][299] | set[address[11:2]][300];
       if (index[298]==1'b1)  begin
	  readmisswritetomemory=set[address[11:2]][127:0];
       end
       else begin
	  readmisswritetomemory=set[address[11:2]][276:149];
       end
     end

    end
    if (re2) begin
      //dirty1  = index[300];
      //dirty2  = index[299];
      //used    = index[298];
      valid1  = index2[297];
      valid2  = index2[148];
      tag1    = index2[296:277];
      tag2    = index2[147:128];
      data1_0 = index2[276:245];
      data1_1 = index2[244:213];
      data1_2 = index2[212:181];
      data1_3 = index2[180:149];
      data2_0 = index2[127:96];
      data2_1 = index2[95:64];
      data2_2 = index2[63:32];
      data2_3 = index2[31:0];

      comparator1 = (tag1 == address2[31:12]) ? 1:0;
      comparator2 = (tag2 == address2[31:12]) ? 1:0;
      and1        = comparator1 & valid1;
      and2        = comparator2 & valid2;

      if (and1) begin
        mux_in0 = data1_0;
        mux_in1 = data1_1;
        mux_in2 = data1_2;
        mux_in3 = data1_3;
      end
      if (and2) begin
        mux_in0 = data2_0;
        mux_in1 = data2_1;
        mux_in2 = data2_2;
        mux_in3 = data2_3;
      end  

    case(address2[1:0])
      2'b00: readdatacache2 <= mux_in0;
      2'b01: readdatacache2 <= mux_in1;
      2'b10: readdatacache2 <= mux_in2;
      2'b11: readdatacache2 <= mux_in3;
    endcase

     hit2         = and1 | and2;
     // if hit, change used bit accordingly
     if (hit2) begin
       if (comparator1 == 1'b1)
         set[address2[11:2]][298] = 1'b1;
       else if (comparator2 == 1'b1)
         set[address2[11:2]][298] = 1'b0;
     end

     // if not hit, ask data from memory
     if (!hit2) begin
       dirty =  set[address2[11:2]][299] | set[address2[11:2]][300];
       if (index[298]==1'b1)  begin
	  readmisswritetomemory=set[address2[11:2]][127:0];
       end
       else begin
	  readmisswritetomemory=set[address2[11:2]][276:149];
       end
     end

    end
  end

  //write
  always @(negedge clk) begin
    miss = 1'b0;
    tag1    = index[296:277];
    tag2    = index[147:128];
    if (we) begin
      if (tag1==address[31:12]) begin
        set[address[11:2]][300] = 1'b1;
	set[address[11:2]][298] = 1'b1;
        set[address[11:2]][297] = 1'b1;
        case(address[1:0])
        	2'b00 : set[address[11:2]][276:245] = writedata;
		2'b01 : set[address[11:2]][244:213] = writedata;
		2'b10 : set[address[11:2]][212:181] = writedata;
		2'b11 : set[address[11:2]][180:149] = writedata;
        endcase
      end
      else if (tag2==address[31:12]) begin
	set[address[11:2]][299] = 1'b1;
	set[address[11:2]][298] = 1'b0;
        set[address[11:2]][148] = 1'b1;
        case(address[1:0])
        	2'b00 : set[address[11:2]][127:96] = writedata;
		2'b01 : set[address[11:2]][95:64]  = writedata;
		2'b10 : set[address[11:2]][63:32]  = writedata;
		2'b11 : set[address[11:2]][31:0]   = writedata;
        endcase
      end
      else begin
        dirty =  set[address[11:2]][299] | set[address[11:2]][300];
        if (index[298]==1'b0) begin // Change way 1
	  miss = 1'b1;
          writeback = set[address[11:2]][276:149];
	  writetag  = set[address[11:2]][296:277];
        end
        else begin                  // Change way 2
          miss = 1'b1;
          writeback = set[address[11:2]][127:0];
	  writetag  = set[address[11:2]][147:128];
        end
      end    
    end
    if (we_2) begin
      if (tag1==address2[31:12]) begin
        set[address2[11:2]][300] = 1'b1;
	set[address2[11:2]][298] = 1'b1;
        set[address2[11:2]][297] = 1'b1;
        case(address2[1:0])
        	2'b00 : set[address2[11:2]][276:245] = writedata2;
		2'b01 : set[address2[11:2]][244:213] = writedata2;
		2'b10 : set[address2[11:2]][212:181] = writedata2;
		2'b11 : set[address2[11:2]][180:149] = writedata2;
        endcase
      end
      else if (tag2==address2[31:12]) begin
	set[address2[11:2]][299] = 1'b1;
	set[address2[11:2]][298] = 1'b0;
        set[address2[11:2]][148] = 1'b1;
        case(address2[1:0])
        	2'b00 : set[address2[11:2]][127:96] = writedata2;
		2'b01 : set[address2[11:2]][95:64]  = writedata2;
		2'b10 : set[address2[11:2]][63:32]  = writedata2;
		2'b11 : set[address2[11:2]][31:0]   = writedata2;
        endcase
      end
      else begin
        dirty =  set[address2[11:2]][299] | set[address2[11:2]][300];
        if (index[298]==1'b0) begin // Change way 1
	  miss2 = 1'b1;
          writeback = set[address2[11:2]][276:149];
	  writetag  = set[address2[11:2]][296:277];
        end
        else begin                  // Change way 2
          miss2 = 1'b1;
          writeback = set[address2[11:2]][127:0];
	  writetag  = set[address2[11:2]][147:128];
        end
      end    
    end
  end

  //writeback
   always @(posedge we2) begin
     if (index[294]==0) begin
	set[address[11:2]][300] = 1'b1;
	set[address[11:2]][298] = 1'b1;
	set[address[11:2]][297] = 1'b1;
     	set[address[11:2]][276:149] = readdatamemory;
	set[address[11:2]][296:277] = address[31:12];
	case(address[1:0])
        	2'b00 : set[address[11:2]][276:245] = writedata;
		2'b01 : set[address[11:2]][244:213] = writedata;
		2'b10 : set[address[11:2]][212:181] = writedata;
		2'b11 : set[address[11:2]][180:149] = writedata;
	endcase
     end
     else begin
	set[address[11:2]][299] = 1'b1;
  	set[address[11:2]][298] = 1'b0;
	set[address[11:2]][148] = 1'b1;
	set[address[11:2]][127:0]   = readdatamemory;
	set[address[11:2]][147:128] = address[31:12];
        case(address[1:0])
        	2'b00 : set[address[11:2]][127:96] =  writedata;
		2'b01 : set[address[11:2]][95:64]  =  writedata;
		2'b10 : set[address[11:2]][63:32]  =  writedata;
		2'b11 : set[address[11:2]][31:0]   =  writedata;
        endcase
     end
   end
   
    always @(posedge we2_2) begin
     if (index[294]==0) begin
	set[address2[11:2]][300] = 1'b1;
	set[address2[11:2]][298] = 1'b1;
	set[address2[11:2]][297] = 1'b1;
     	set[address2[11:2]][276:149] = readdatamemory;
	set[address2[11:2]][296:277] = address[31:12];
	case(address2[1:0])
        	2'b00 : set[address2[11:2]][276:245] = writedata2;
		2'b01 : set[address2[11:2]][244:213] = writedata2;
		2'b10 : set[address2[11:2]][212:181] = writedata2;
		2'b11 : set[address2[11:2]][180:149] = writedata2;
	endcase
     end
     else begin
	set[address2[11:2]][299] = 1'b1;
  	set[address2[11:2]][298] = 1'b0;
	set[address2[11:2]][148] = 1'b1;
	set[address2[11:2]][127:0]   = readdatamemory;
	set[address2[11:2]][147:128] = address2[31:12];
        case(address2[1:0])
        	2'b00 : set[address2[11:2]][127:96] =  writedata2;
		2'b01 : set[address2[11:2]][95:64]  =  writedata2;
		2'b10 : set[address2[11:2]][63:32]  =  writedata2;
		2'b11 : set[address2[11:2]][31:0]   =  writedata2;
        endcase
     end
   end

   // readmissdata
   always @(posedge we3) begin
	if (index[294]==1'b0)  begin
          set[address[11:2]][299] = 1'b0;
	  set[address[11:2]][298] = 1'b0;
          set[address[11:2]][148] = 1'b1;
	  set[address[11:2]][127:0]=readmisswritetocache;
          set[address[11:2]][147:128]=address[31:12];
       end
       else begin
	  set[address[11:2]][300] = 1'b0;
	  set[address[11:2]][298] = 1'b1;
          set[address[11:2]][297] = 1'b1;
	  set[address[11:2]][276:149]=readmisswritetocache;
	  set[address[11:2]][296:277]=address[31:12];
       end     
   end
   
   always @(posedge we3_2) begin
	if (index[294]==1'b0)  begin
          set[address2[11:2]][299] = 1'b0;
	  set[address2[11:2]][298] = 1'b0;
          set[address2[11:2]][148] = 1'b1;
	  set[address2[11:2]][127:0]=readmisswritetocache;
          set[address2[11:2]][147:128]=address2[31:12];
       end
       else begin
	  set[address2[11:2]][300] = 1'b0;
	  set[address2[11:2]][298] = 1'b1;
          set[address2[11:2]][297] = 1'b1;
	  set[address2[11:2]][276:149]=readmisswritetocache;
	  set[address2[11:2]][296:277]=address2[31:12];
       end     
   end
   
   always @(negedge we3) begin
     case(address[1:0])
        2'b00 : #5 readdatacache= readmisswritetocache[127:96];
	2'b01 : #5 readdatacache= readmisswritetocache[95:64];
	2'b10 : #5 readdatacache= readmisswritetocache[63:32];
	2'b11 : #5 readdatacache= readmisswritetocache[31:0];
     endcase
   end

    always @(negedge we3_2) begin
     case(address2[1:0])
        2'b00 : #5 readdatacache2= readmisswritetocache[127:96];
	2'b01 : #5 readdatacache2= readmisswritetocache[95:64];
	2'b10 : #5 readdatacache2= readmisswritetocache[63:32];
	2'b11 : #5 readdatacache2= readmisswritetocache[31:0];
     endcase
   end  
endmodule