//Instruction Memory File: Instruction Memory

module inst_mem #(parameter WIDTH=32, parameter DEPTH=16) (
 
`ifdef MULTICYCLE
  input logic  	    	   clk,
`endif
  input logic              rst,
  input logic  [WIDTH-1:0] data_in,
  input logic  [DEPTH-1:0] addr,
  input logic              wr,
  input logic              rd,
  
  output logic [WIDTH-1:0] data_out

);
  
  logic [7:0] memory [2**DEPTH];
  
  initial $readmemh("program.mem", memory);
  
`ifdef MULTICYCLE 
  always_ff @(posedge clk) if (wr) memory[addr] <= data_in;
`endif
  
  assign data_out = rd ? {memory[addr+3],memory[addr+2],memory[addr+1],memory[addr]} : 'hz;
  
endmodule