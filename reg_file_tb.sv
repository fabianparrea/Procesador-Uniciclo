//Testbench for the Register File

module reg_file_tb #(parameter WIDTH=32, parameter DEPTH=5) (

  input logic clk,
  input logic rst
  
);
  
  logic [WIDTH-1:0] write_data;
  logic [DEPTH-1:0] write_register; //addr
  logic             wr;
  logic [DEPTH-1:0] read_register_1; //addr
  logic [DEPTH-1:0] read_register_2; //addr
  logic             rd;
  
  logic [WIDTH-1:0] read_data_1;
  logic [WIDTH-1:0] read_data_2;
  
  int error;
  int finish;
  
  logic [WIDTH-1:0] reg_file_checker [DEPTH];
  
  reg_file #(.WIDTH(WIDTH),.DEPTH(DEPTH)) dut_reg_file(
    .clk      		 (clk),
    .rst      		 (rst),
    .write_data      (write_data),
    .write_register  (write_register),
    .wr       		 (wr),
    .read_register_1 (read_register_1),
    .read_register_2 (read_register_2),
    .rd       		 (rd),
    .read_data_1  	 (read_data_1),
    .read_data_2	 (read_data_2)
  );
  
  //Initial values configuration
  initial begin
    write_data  	= 0;
    write_register 	= 0;
    wr              = 0;
    read_register_1 = 0;
    read_register_2 = 0;
    rd       		= 0;
    error    		= 0;
    finish   		= 0;
    
    reg_file_checker[0] = 0; //register zero
  end
  
  //Task to simulate the mux. It runs two tasks: one for stimulus and another for self-checking
  task reg_file_sim();
    
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
    
    for(int i=0; i<32;i++) begin
      @(posedge clk);
      write_data      = write_data + 4;
      write_register  = i;
      wr              = 1;
      rd			  = 0;
      read_register_1 = i;
      read_register_2 = i;
    end
    
    for(int i=0; i<32;i=i+2) begin
      @(posedge clk);
      write_data      = write_data + 4;
      write_register  = i;
      wr              = 0;
      rd			  = 1;
      read_register_1 = i;
      read_register_2 = i+1;
    end
    
    for(int i=0; i<32;i=i+2) begin
      @(posedge clk);
      write_data      = write_data + 4;
      write_register  = i;
      wr              = 0;
      rd			  = 1;
      read_register_1 = i+1;
      read_register_2 = i;
    end
    
    finish = 1;

  endtask
  
  //Self-check Task
  task selfcheck();
    
    forever begin //It verifies the output every clk cycle
      @(posedge clk);
      if (rst) begin
        for(int i=1; i<32;i++) begin
          reg_file_checker[i] = 0;
        end
      end
      else begin
        if ((wr) && (write_register != 0)) reg_file_checker[write_register] = write_data;
        if (rd) begin
          @(negedge clk); //check if the read data is the same as the checker
          if (read_data_1 != reg_file_checker[read_register_1]) error = 1;
          if (read_data_2 != reg_file_checker[read_register_2]) error = 1;
        end
      end

      if(error == 1) $display("[REG_FILE TB] Reg_File has a bug!!!");
    end
    
  endtask
  
endmodule