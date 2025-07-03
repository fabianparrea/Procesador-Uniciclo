//Testbench for the MUX

module mux_tb #(parameter WIDTH=32) (

  input logic clk,
  input logic rst
  
);
  
  logic  [WIDTH-1:0] A;
  logic  [WIDTH-1:0] B;
  logic              sel;
  
  logic  [WIDTH-1:0] out;
  
  int error;
  int finish;
  
  mux_2_1 #(.WIDTH(WIDTH)) dut_mux(
    .A   (A),
    .B   (B),
    .sel (sel),
    .out (out)
  );
  
  //Initial values configuration
  initial begin
    A      = 0;
    B      = 0;
    sel    = 0;
    error  = 0;
    finish = 0;
  end
  
  //Task to simulate the mux. It runs two tasks: one for stimulus and another for self-checking
  task mux_sim();
    
    fork
      stimulus();
      selfcheck();
    join

  endtask
  
  //Stimulus Task
  task stimulus();
    // Dump waves
    /*$dumpfile("dump.vcd");
    $dumpvars(0);*/

    #10
    A   = 0;
    B   = 1;
    sel = 0;

    #50
    A   = 0;
    B   = 1;
    sel = 1;

    #100
    A   = 0;
    B   = 0;
    sel = 0;
    
    finish = 1;

  endtask
  
  //Self-check Task
  task selfcheck();
    
    forever begin //It verifies the output every 5 time units
	  @(negedge clk);
      if      ((sel == 0) && (out != A)) error = 1;
      else if ((sel == 1) && (out != B)) error = 1;

      if(error == 1) $display("[MUX TB] MUX has a bug!!!");
    end
    
  endtask
  
endmodule