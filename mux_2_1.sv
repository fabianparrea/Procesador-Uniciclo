//Mux 2x1: Inputs and outputs are parametrized 

module mux_2_1 #(parameter WIDTH=32) (

  input logic  [WIDTH-1:0] A,
  input logic  [WIDTH-1:0] B,
  input logic              sel,
  
  output logic [WIDTH-1:0] out

);
  
  /*esto de abajo es equivalente a 
  if(sel) out = A;
  else    out = B;
  */
  always_comb out = (!sel) ? A : B; //out = al primer argumento (A) si la condición antes del signo de pregunta es verdadera, si no out = al segundo argumento (B) 
  
endmodule