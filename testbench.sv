// Code your testbench here
// or browse Examples

`include "mux_tb.sv"
`include "adder_tb.sv"
`include "register_tb.sv"
`include "reg_file_tb.sv"

module top_tb();
  
  parameter WIDTH = 32;
  parameter REG_DEPTH = 5;
  
  logic clk_global;
  logic rst_global;
  
  int error;
  int finish;
  
  top dut(
    .clk (clk_global),
    .rst (rst_global)
  );
  
  mux_tb #(.WIDTH(WIDTH)) mux_tb(
    .clk (clk_global),
    .rst (rst_global)
  );
  
  adder_tb #(.WIDTH(WIDTH)) adder_tb(
    .clk (clk_global),
    .rst (rst_global)
  );
  
  register_tb #(.WIDTH(WIDTH)) register_tb(
    .clk (clk_global),
    .rst (rst_global)
  );
  
  reg_file_tb #(.WIDTH(WIDTH),.DEPTH(REG_DEPTH)) reg_file_tb(
    .clk (clk_global),
    .rst (rst_global)
  );
  
  initial begin
    
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(6);
    
    clk_global = 0;
    rst_global = 0;
    
    error  = 0;
    finish = 0;
    
    $display("[MAIN TB] Initiating simulation");
    
    #20
    rst_global = 1;
    
    #20
    rst_global = 0;
    
    fork 
      mux_tb.mux_sim();
      adder_tb.adder_sim();
      register_tb.register_sim();
      reg_file_tb.reg_file_sim();
      end_sim_checker();
    join
    
  end
  
  always begin
    #10 clk_global = !clk_global; 
  end
  
  //Task that checks every 5 time units if all simulations have finished
  task end_sim_checker();
    
    forever begin
      @(posedge clk_global);
      finish =    mux_tb.finish
               && adder_tb.finish
               && register_tb.finish
      		   && reg_file_tb.finish; //When this is 1
      
      if (finish) begin //Simulation is about to finish
        #100
        $display("[MAIN TB] Finishing simulation");
        error =    mux_tb.error
                || adder_tb.error
                || register_tb.error
        		|| reg_file_tb.error; //But check for errors first
        
        if   (error) $display("[MAIN TB] Test Failed");
        else         $display("[MAIN TB] Test Pass");
   
        //Simulation ends. Make sure the simulation reaches 					this part, otherwise the simulator will run forever 					and crash.
        $finish;
      end
    end
    
  endtask
  
endmodule
