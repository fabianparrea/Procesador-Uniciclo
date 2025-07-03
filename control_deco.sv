//Control Decoder: Control Decoder for RV32I
 //Le entra la instrucción y genera las señales de control para el microprocesador
module control_deco #(parameter WIDTH=32, parameter INST_SIZE = 32) (
	
  input logic  [WIDTH-1:0] instr,
  input logic              comparison,
  
  output logic [1:0]	   if_mux_sel,
  output logic 			   ex_mux_sel,
  output logic [1:0]	   wb_mux_sel,
  output logic             reg_file_rd,
  output logic             reg_file_wr,
  output logic			   mem_read,
  output logic			   mem_write,
  output logic             one_byte,
  output logic			   two_bytes,
  output logic			   four_bytes
);
  
  parameter ALI_OP    = 7'b0010011;
  parameter AL_OP     = 7'b0110011;
  parameter MEM_WR_OP = 7'b0100011;
  parameter MEM_RD_OP = 7'b0000011;
  parameter BR_OP     = 7'b1100011;
  parameter JALR      = 7'b1100111;
  parameter JAL       = 7'b1101111;
  parameter LUI       = 7'b0110111;
  parameter AUIPC     = 7'b0010111;
  
  logic [6:0] opcode;
  logic [6:0] func3;
  
  assign opcode = instr[6:0];
  assign func3  = instr[14:12];
  
  always_comb begin
    case(opcode)
      ALI_OP: begin
        		if_mux_sel = 0;
        		ex_mux_sel = 1;
        		wb_mux_sel = 0;
        		reg_file_rd = 1;
        		reg_file_wr = 1;
        		mem_read    = 0;
        		mem_write   = 0;
                one_byte    = 0;
                two_bytes   = 0;
                four_bytes  = 0;
      		  end
      AL_OP: begin
        		if_mux_sel = 0;
        		ex_mux_sel = 0;
        		wb_mux_sel = 0;
        		reg_file_rd = 1;
        		reg_file_wr = 1;
        		mem_read    = 0;
        		mem_write   = 0;
        		one_byte    = 0;
                two_bytes   = 0;
                four_bytes  = 0;
      		 end
      MEM_WR_OP: begin
                	if_mux_sel = 0;
        			ex_mux_sel = 1;
        			wb_mux_sel = 0;
        			reg_file_rd = 1;
        			reg_file_wr = 0;
        			mem_read    = 0;
        			mem_write   = 1;
        			if (func3 == 000) begin
                      one_byte     = 1;
                      two_bytes    = 0;
                      four_bytes   = 0;
          			end
        			else if (func3 == 001) begin
                      one_byte     = 0;
                      two_bytes    = 1;
                      four_bytes   = 0;
          			end
                    else begin
                      one_byte     = 0;
                      two_bytes    = 0;
                      four_bytes   = 1;
          			end
      		     end
      MEM_RD_OP: begin
                	if_mux_sel = 0;
        			ex_mux_sel = 1;
        			wb_mux_sel = 1;
        			reg_file_rd = 1;
        			reg_file_wr = 1;
        			mem_read    = 1;
        			mem_write   = 0;
        			if ((func3 == 000) || (func3 == 100)) begin
                      one_byte     = 1;
                      two_bytes    = 0;
                      four_bytes   = 0;
          			end
        			else if ((func3 == 001) || (func3 == 101)) begin
                      one_byte     = 0;
                      two_bytes    = 1;
                      four_bytes   = 0;
          			end
                    else begin
                      one_byte     = 0;
                      two_bytes    = 0;
                      four_bytes   = 1;
          			end
      		     end
      BR_OP:  begin
        		if_mux_sel = (comparison == 1) ? 1 : 0;
        		ex_mux_sel = 0;
        		wb_mux_sel = 0;
        		reg_file_rd = 1;
        		reg_file_wr = 0;
        		mem_read    = 0;
        		mem_write   = 0;
        		one_byte    = 0;
                two_bytes   = 0;
                four_bytes  = 0;
      		  end
      JALR: begin
        		if_mux_sel = 2;
        		ex_mux_sel = 1;
        		wb_mux_sel = 2;
        		reg_file_rd = 1;
        		reg_file_wr = 1;
        		mem_read    = 0;
        		mem_write   = 0;
        		one_byte    = 0;
                two_bytes   = 0;
                four_bytes  = 0;
      		end
      JAL: begin
        		if_mux_sel = 1;
        		ex_mux_sel = 1;
        		wb_mux_sel = 2;
        		reg_file_rd = 1;
        		reg_file_wr = 1;
        		mem_read    = 0;
        		mem_write   = 0;
        		one_byte    = 0;
                two_bytes   = 0;
                four_bytes  = 0;
      		end
      LUI: begin
        		if_mux_sel = 0;
        		ex_mux_sel = 1;
        		wb_mux_sel = 2;
        		reg_file_rd = 1;
        		reg_file_wr = 1;
        		mem_read    = 0;
        		mem_write   = 0;
        		one_byte    = 0;
                two_bytes   = 0;
                four_bytes  = 0;
      		end
      AUIPC: begin
        		if_mux_sel = 0;
        		ex_mux_sel = 1;
        		wb_mux_sel = 3;
        		reg_file_rd = 1;
        		reg_file_wr = 1;
        		mem_read    = 0;
        		mem_write   = 0;
        		one_byte    = 0;
                two_bytes   = 0;
                four_bytes  = 0;
      		end
      default: begin
        		if_mux_sel = 0;
                ex_mux_sel = 0;
        		wb_mux_sel = 0;
        		reg_file_rd = 0;
        		reg_file_wr = 0;
        		mem_read    = 0;
        		mem_write   = 0;
        		one_byte    = 0;
                two_bytes   = 0;
                four_bytes  = 0;
      		   end
    endcase
  end
  
endmodule