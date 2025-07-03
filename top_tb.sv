`timescale 1ns/1ps

module top_tb();

  parameter WIDTH = 32;
  parameter INST_MEM_DEPTH = 8;
  parameter REG_FILE_DEPTH = 5;
  parameter INST_SIZE = 32;

  logic clk;
  logic rst;

  // Instancia del procesador top
  top #(
    .WIDTH(WIDTH),
    .INST_MEM_DEPTH(INST_MEM_DEPTH),
    .REG_FILE_DEPTH(REG_FILE_DEPTH),
    .INST_SIZE(INST_SIZE)
  ) uut (
    .clk(clk),
    .rst(rst)
  );

  // Reloj: ciclo de 10ns
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset y simulación
  initial begin
    $display("Iniciando simulacion...");

    rst = 1;
    repeat (5) @(posedge clk); // mantener reset 5 ciclos
    rst = 0;

    // Simular varios ciclos para que el procesador avance
    repeat (100) @(posedge clk);

    $display("Simulación terminada.");
    $stop;
  end

  // Monitorear PC e instrucción en cada ciclo
  always @(posedge clk) begin
    if (!rst) begin
      $display("PC=0x%08h Instr=0x%08h", uut.pc_out, uut.instruction);
    end
  end

endmodule
