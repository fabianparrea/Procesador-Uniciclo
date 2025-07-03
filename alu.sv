//Register File: Register File for RV32I

module alu #(parameter WIDTH=32) (
	
  input logic  [WIDTH-1:0] data_in_1,
  input logic  [WIDTH-1:0] data_in_2,
  input logic  [2:0]       func3,
  input logic  [6:0]       func7,
  input logic  [6:0]       opcode,
  
  output logic [WIDTH-1:0] data_out,
  //output logic           carry,
  output logic             zero,
  output logic             comparison

);
  
  parameter ALI_OP    = 7'b0010011;
  parameter AL_OP     = 7'b0110011;
  parameter MEM_WR_OP = 7'b0100011;
  parameter MEM_RD_OP = 7'b0000011;
  parameter BR_OP     = 7'b1100011;
  parameter JALR      = 7'b1100111;
  parameter LUI       = 7'b0110111;
  parameter AUIPC     = 7'b0010111;
  
  
  always_comb begin
    case(opcode)
      ALI_OP: begin
        case(func3)
          3'b000: data_out = signed'(data_in_1) + signed'(data_in_2); //addi
          3'b001: data_out = data_in_1 << data_in_2; //slli
          3'b010: data_out = (signed'(data_in_1) < signed'(data_in_2)) ? 1 : 0; //slti
          3'b011: data_out = (unsigned'(data_in_1) < unsigned'(data_in_2)) ? 1 : 0; //sltiu
          3'b100: data_out = data_in_1 ^ data_in_2; //xori
          3'b101: begin
            if(func7 == 7'b0000000) data_out = data_in_1 >> data_in_2; //srli
            if(func7 == 7'b0100000) data_out = signed'(data_in_1) >>> data_in_2; //srai
          end
          3'b110: data_out = data_in_1 | data_in_2; //ori
          3'b111: data_out = data_in_1 & data_in_2; //andi
        endcase
        comparison = 0;
      end
      AL_OP: begin
        case(func3)
          3'b000: begin
            if(func7 == 7'b0000000) data_out = signed'(data_in_1) + signed'(data_in_2); //add
            if(func7 == 7'b0100000) data_out = signed'(data_in_1) - signed'(data_in_2); //sub
          end
          3'b001: data_out = data_in_1 << data_in_2; //sll
          3'b010: data_out = (signed'(data_in_1) < signed'(data_in_2)) ? 1 : 0; //slt
          3'b011: data_out = (unsigned'(data_in_1) < unsigned'(data_in_2)) ? 1 : 0; //sltu
          3'b100: data_out = data_in_1 ^ data_in_2; //xor
          3'b101: begin
            if(func7 == 7'b0000000) data_out = data_in_1 >> data_in_2; //srl
            if(func7 == 7'b0100000) data_out = signed'(data_in_1) >>> data_in_2; //sra
          end
          3'b110: data_out = data_in_1 | data_in_2; //or
          3'b111: data_out = data_in_1 & data_in_2; //and
        endcase
        comparison = 0;
      end
      MEM_WR_OP: begin
        data_out = signed'(data_in_1) + signed'(data_in_2); //addr for sb, sh, sw
        comparison = 0;
      end
      MEM_RD_OP: begin
        data_out = signed'(data_in_1) + signed'(data_in_2); //addr for lb, lh, lw, lbu, lhu
        comparison = 0;
      end
      BR_OP: begin
        case(func3)
          3'b000: comparison = (signed'(data_in_1) == signed'(data_in_2)) ? 1 : 0; //beq
          3'b001: comparison = (signed'(data_in_1) == signed'(data_in_2)) ? 0 : 1; //bne
          3'b100: comparison = (signed'(data_in_1) <  signed'(data_in_2)) ? 1 : 0; //blt
          3'b101: comparison = (signed'(data_in_1) >= signed'(data_in_2)) ? 1 : 0; //bge
          3'b110: comparison = (unsigned'(data_in_1) <  unsigned'(data_in_2)) ? 1 : 0; //bltu
          3'b111: comparison = (unsigned'(data_in_1) >= unsigned'(data_in_2)) ? 1 : 0; //bgeu
        endcase
      end
      JALR: begin
        //jal instruction doesn't need the ALU
        data_out = signed'(data_in_1) + signed'(data_in_2); //jalr
        comparison = 0;
      end
      LUI: begin
        data_out = data_in_2; //lui
        comparison = 0;
      end
      AUIPC: begin
        data_out = signed'(data_in_1) + signed'(data_in_2); //auipc
        comparison = 0;
      end
      default: data_out = 0;
    endcase
  end
  
  assign zero = (data_out == 0) ? 1 : 0; //zero logic
  
endmodule