// Code your design here

`define  UNICYCLE
//`define  MULTICYCLE

`include "mux_2_1.sv"
`include "mux_4_1.sv"
`include "adder.sv"
`include "register.sv"
`include "reg_file.sv"
`include "alu.sv"
`include "data_mem.sv"
`include "inst_mem.sv"
`include "imm_gen.sv"
`include "control_deco.sv"

module top #(parameter WIDTH=32,
             parameter INST_MEM_DEPTH=8,
             parameter REG_FILE_DEPTH=5,
             parameter INST_SIZE=32) (
  input logic			   clk,
  input logic              rst
);
  
  
  wire [WIDTH-1:0] mux_pc;
  wire [WIDTH-1:0] pc_out;
  wire [WIDTH-1:0] pc_4;
  wire [WIDTH-1:0] instruction;
  wire [WIDTH-1:0] rs1_data;
  wire [WIDTH-1:0] rs2_data;
  wire [WIDTH-1:0] immediate;
  wire [WIDTH-1:0] alu_mux;
  wire [WIDTH-1:0] wb_mux_out;
  wire [WIDTH-1:0] pc_imm;
  wire [1:0]       if_mux_sel;
  wire             ex_mux_sel;
  wire [1:0]       wb_mux_sel;
  wire [WIDTH-1:0] alu_out;
  wire [WIDTH-1:0] mem_data_out;
  wire			   comparison;
  wire			   reg_file_rd;
  wire			   reg_file_wr;
  wire			   mem_write;
  wire			   mem_read;
  wire one_byte, two_bytes, four_bytes;

  
  //DATA PATH
  //Instruction Fetch Stage
  //IF MUX
  mux_4_1 #(.WIDTH(WIDTH)) if_mux(
    .A   (pc_4),
    .B   (pc_imm),
    .C   (alu_out),
    .D   (),
    .sel (if_mux_sel),
    .out (mux_pc)
  );
  
  //Program Counter Register
  register #(.WIDTH(WIDTH)) pc_register(
    .clk      (clk),
    .rst      (rst),
    .data_in  (mux_pc),
    .wr       (1'b1),
    .data_out (pc_out)
  );
  
  //PC + 4 Adder
  adder #(.WIDTH(WIDTH)) pc_4_adder(
    .A   (32'd4),
    .B   (pc_out),
    .out (pc_4)
  );
  
  //Instruction Memory
  inst_mem #(.WIDTH(WIDTH),.DEPTH(INST_MEM_DEPTH)) inst_mem (
  `ifdef MULTICYCLE
    .clk      (clk),
  `endif
    .rst      (rst),
    .data_in  (32'b0),
    .addr     (pc_out),
    .wr       (1'b0),
    .rd       (1'b1),
    .data_out (instruction) //this is the instruction
  );
  
  //Instruction Decode Stage
  //Register File
  reg_file #(.WIDTH(WIDTH),.DEPTH(REG_FILE_DEPTH)) reg_file(
    .clk      		 (clk),
    .rst      		 (rst),
    .write_data      (wb_mux_out),
    .write_register  (instruction[11:7]),
    .wr       		 (reg_file_wr), //decode logic needed 
    .read_register_1 (instruction[19:15]),
    .read_register_2 (instruction[24:20]),
    .rd       		 (reg_file_rd), //decode logic needed 
    .read_data_1     (rs1_data),
    .read_data_2     (rs2_data)
  );
  
  //Immediate Generator
  imm_gen #(.WIDTH(WIDTH)) imm_gen(
    .instr    (instruction),
    .data_out (immediate)
  );
  
  //Instruction Decoder for control signals.
  //This is the ControlPath
  //Pending
  
  //Execution Stage
  //Arithmetic-Logic Unit
  alu #(.WIDTH(WIDTH)) alu(
    .data_in_1  (rs1_data),
    .data_in_2  (alu_mux),
    .func3      (instruction[14:12]), 
    .func7      (instruction[31:25]),
    .opcode     (instruction[6:0]),
    .data_out   (alu_out), 
    .zero       (), //this two are control signals 
    .comparison (comparison)
  );
  
  //EX MUX
  mux_2_1 #(.WIDTH(WIDTH)) ex_mux(
    .A   (rs2_data),
    .B   (immediate),
    .sel (ex_mux_sel),
    .out (alu_mux)
  );
  
  //PC + Imm Adder
  adder #(.WIDTH(WIDTH)) pc_imm_adder(
    .A   (pc_out),
    .B   (immediate),
    .out (pc_imm)
  );
  
  //Memory Stage
  //Data Memory
  data_mem #(.WIDTH(WIDTH),.DEPTH(INST_MEM_DEPTH)) data_mem (
    .clk        (clk),
    .rst        (rst),
    .data_in    (rs2_data),
    .addr       (alu_out),
    .wr         (mem_write),
    .rd         (mem_read),
    .one_byte   (one_byte),
    .two_bytes  (two_bytes),
    .four_bytes (four_bytes),
    .data_out   (mem_data_out) //this is the instruction
  );
  
  //Write Back Stage
  //WB MUX
  mux_4_1 #(.WIDTH(WIDTH)) wb_mux(
    .A   (alu_out),
    .B   (mem_data_out),
    .C   (pc_4),
    .D   (pc_imm),
    .sel (wb_mux_sel),
    .out (wb_mux_out)
  );
  
  //CONTROL PATH
  control_deco #(.INST_SIZE(INST_SIZE)) control_deco (
    .instr       (instruction),
    .comparison  (comparison),
    .if_mux_sel  (if_mux_sel),
    .ex_mux_sel  (ex_mux_sel),
    .wb_mux_sel  (wb_mux_sel),
    .reg_file_rd (reg_file_rd),
    .reg_file_wr (reg_file_wr),
    .mem_read    (mem_read),
    .mem_write   (mem_write),
    .one_byte    (one_byte),
    .two_bytes   (two_bytes),
    .four_bytes  (four_bytes)
  );
  
endmodule