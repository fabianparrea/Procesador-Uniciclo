//Testbench for the Register

module register_tb #(parameter WIDTH=32) (

  input logic clk,
  input logic rst
  
);
  
  logic  [WIDTH-1:0] data_in;
  logic              wr;
  
  logic  [WIDTH-1:0] data_out;
  
  int error;
  int finish;
  
  logic [WIDTH-1:0] register_checker;
  
  register #(.WIDTH(WIDTH)) dut_register(
    .clk      (clk),
    .rst      (rst),
    .data_in  (data_in),
    .wr       (wr),
    .data_out (data_out)
  );
  
  //Initial values configuration
  initial begin
    data_in  = 0;
    wr       = 0;
    error    = 0;
    finish   = 0;
  end
  
  //Task to simulate the mux. It runs two tasks: one for stimulus and another for self-checking
  task register_sim();
    
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
    
    @(negedge clk);
    data_in = 0;
    wr      = 1;
    
    for(int i=0; i<50;i++) begin
      @(negedge clk);
      data_in = data_in + 4;
      wr      = 1;
    end
    
    for(int i=0; i<5;i++) begin
      @(negedge clk);
      data_in = data_in + 4;
      wr      = 0;
    end
    
    finish = 1;

  endtask
  
  //Self-check Task
  task selfcheck();
    
    forever begin //It verifies the output every 5 time units
      @(posedge clk);
      if      (rst) register_checker = 0;
      else if (wr)  register_checker = data_in;
      else          register_checker = register_checker;
      
      @(negedge clk);
      if (data_out != register_checker) error = 1;

      if(error == 1) $display("[REGISTER TB] Register has a bug!!!");
    end
    
  endtask
  
endmodule