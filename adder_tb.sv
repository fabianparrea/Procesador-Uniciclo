//Testbench for the Adder

module adder_tb #(parameter WIDTH=32) (

  input logic clk,
  input logic rst
  
);
  
  logic  [WIDTH-1:0] A;
  logic  [WIDTH-1:0] B;
  
  logic  [WIDTH-1:0] out;
  
  int error;
  int finish;
  
  adder #(.WIDTH(WIDTH)) dut_adder(
    .A   (A),
    .B   (B),
    .out (out)
  );
  
  //Initial values configuration
  initial begin
    A   = 0;
    B   = 0;
    error  = 0;
    finish = 0;
  end
  
  //Task to simulate the adder. It runs two tasks: one for stimulus and another for self-checking
  task adder_sim();
    
    fork
      stimulus();
      selfcheck();
    join

  endtask
  
  //Stimulus Task
  task stimulus();
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(0);
    
    for(int i=0; i<100;i++) begin
      #100
      A   = A + 1;//$urandom_range(0,10);
      B   = B + 4;//std::randomize(B);
    end
    
    #100
    A   = 0;
    B   = 0;
    
    finish = 1;
  endtask
  
  //Self-check Task
  task selfcheck();
    
    int sum;
    
    forever begin //It verifies the output every 5 time units
      @(negedge clk);
      sum = A + B;
      if (sum != out) error = 1;
      if (error == 1) $display("[ADDER TB] ADDER has a bug!!!");
    end
    
  endtask
  
endmodule