//Register File: Register File for RV32I

module reg_file #(parameter WIDTH=32, parameter DEPTH=5) (
	
  input logic  	   	      clk,
  input logic             rst,
  input logic [WIDTH-1:0] write_data,
  input logic [DEPTH-1:0] write_register, //addr
  input logic             wr,
  input logic [DEPTH-1:0] read_register_1, //addr
  input logic [DEPTH-1:0] read_register_2, //addr
  input logic             rd,
  
  output logic [WIDTH-1:0] read_data_1,
  output logic [WIDTH-1:0] read_data_2

);
  
  logic [WIDTH-1:0] registers [2**DEPTH];
  logic [WIDTH-1:0] reg_zero;
  
  assign reg_zero = 0;
  
  always_ff @(negedge clk or posedge rst) begin
    if (rst) begin
      for(int i=1; i < 2**DEPTH;i++) begin
        $display("Here!!!!!");
        registers[i] <= 0;
      end
    end
    else if ((wr) && (write_register != 0)) registers[write_register] <= write_data;
  end
  
  always_comb begin
    if (rd) begin
        if   (read_register_1 == 0) read_data_1 = reg_zero;
        else                        read_data_1 = registers[read_register_1];
        if   (read_register_2 == 0) read_data_2 = reg_zero;
        else                        read_data_2 = registers[read_register_2];
    end
    else begin
      read_data_1 = 'hz;
      read_data_2 = 'hz;
    end
  end
  
endmodule