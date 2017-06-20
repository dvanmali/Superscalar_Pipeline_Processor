module pipelinedec(op, regwrited, memtoregd, memwrited, aluop, alusrcd, regdstd, branchd, bned, jumpd);
  input [5:0] op;
  output  reg memtoregd, regwrited, memwrited;
  output  reg [3:0] aluop;
  output  reg alusrcd, regdstd, branchd, bned, jumpd;
  
  reg [11:0] controls;


  // Opcodes
  parameter LW    = 6'b100011;  // Opcode for lw
  parameter SW    = 6'b101011;  // Opcode for sw
  parameter RTYPE = 6'b000000;  // Opcode for R-type
  parameter BEQ   = 6'b000100;  // Opcode for beq
  parameter BNE   = 6'b000101;  // Opcode for bne
  parameter ADDI  = 6'b001000;  // Opcode for addi
  parameter ADDIU = 6'b001001;  // Opcode for addiu
  parameter ANDI  = 6'b001100;  // Opcode for andi
  parameter ORI   = 6'b001101;  // Opcode for ori
  parameter XORI  = 6'b001110;  // Opcode for xori
  parameter SLTI  = 6'b001010;  // Opcode for slti
  parameter SLTIU = 6'b001011;  // Opcode for sltiu
  parameter J     = 6'b000010;  // Opcode for j

  initial begin
		regwrited = 1'b0;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0000;
                alusrcd   = 1'b0;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      

  // Pipeline Controller
  //assign {regwrited, memtoregd, memwrited, aluop, alusrcd, regdstd, branchd, bned, jumpd} = controls;
  
  always @(op) begin
    case (op)
      LW: begin
		regwrited = 1'b1;
                memtoregd = 1'b1;
                memwrited = 1'b0;
		aluop     = 4'b0000;
                alusrcd   = 1'b1;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end

      SW: begin
		regwrited = 1'b0;
                memtoregd = 1'b0;
                memwrited = 1'b1;
		aluop     = 4'b0000;
                alusrcd   = 1'b1;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      
      RTYPE: begin
		regwrited = 1'b1;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0010;
                alusrcd   = 1'b0;
		regdstd   = 1'b1;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      BEQ: begin
		regwrited = 1'b0;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0001;
                alusrcd   = 1'b0;
		regdstd   = 1'b0;
		branchd   = 1'b1;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      BNE: begin
		regwrited = 1'b0;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0001;
                alusrcd   = 1'b0;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b1;
		jumpd     = 1'b0;
          end
      ADDI: begin
		regwrited = 1'b1;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0000;
                alusrcd   = 1'b1;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      ADDIU: begin
		regwrited = 1'b1;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0111;
                alusrcd   = 1'b1;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      ANDI: begin
		regwrited = 1'b1;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0100;
                alusrcd   = 1'b1;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      ORI: begin
		regwrited = 1'b1;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0011;
                alusrcd   = 1'b1;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      XORI: begin
		regwrited = 1'b1;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0101;
                alusrcd   = 1'b1;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      SLTI: begin
		regwrited = 1'b1;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0110;
                alusrcd   = 1'b1;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      SLTIU: begin
		regwrited = 1'b1;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b1000;
                alusrcd   = 1'b1;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b0;
          end
      J: begin
		regwrited = 1'b0;
                memtoregd = 1'b0;
                memwrited = 1'b0;
		aluop     = 4'b0000;
                alusrcd   = 1'b0;
		regdstd   = 1'b0;
		branchd   = 1'b0;
		bned      = 1'b0;
		jumpd     = 1'b1;
          end
      default: begin
		regwrited = 1'bx;
                memtoregd = 1'bx;
                memwrited = 1'bx;
		aluop     = 4'bxxxx;
                alusrcd   = 1'bx;
		regdstd   = 1'bx;
		branchd   = 1'bx;
		bned      = 1'bx;
		jumpd     = 1'bx;
          end
      /*LW:       controls <= 12'b110000010000;
      SW:       controls <= 12'b001000010000;
      RTYPE:    controls <= 12'b100001001000;
      BEQ:      controls <= 12'b000000100100;
      BNE:      controls <= 12'b000000100010;
      ADDI:     controls <= 12'b100000010000;
      ADDIU:    controls <= 12'b100011110000;
      ANDI:     controls <= 12'b100010010000;
      ORI:      controls <= 12'b100001110000;
      XORI:     controls <= 12'b100010110000;
      SLTI:     controls <= 12'b100011010000;
      SLTIU:    controls <= 12'b100100010000;
      J:        controls <= 12'b000000000001;
      default:  controls <= 12'bxxxxxxxxxxxx;*/
    endcase
  end

endmodule
