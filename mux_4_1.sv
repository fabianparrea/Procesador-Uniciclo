//Mux 4x1: Inputs and outputs are parametrized 

module mux_4_1 #(parameter WIDTH=32) (

  input logic  [WIDTH-1:0] A,
  input logic  [WIDTH-1:0] B,
  input logic  [WIDTH-1:0] C,
  input logic  [WIDTH-1:0] D,
  input logic  [1:0]       sel,
  
  output logic [WIDTH-1:0] out

);
  
  always_comb begin
    case(sel)
      'h0: out = A;
      'h1: out = B;
      'h2: out = C;
      'h3: out = D;
    endcase
  end
  
endmodule