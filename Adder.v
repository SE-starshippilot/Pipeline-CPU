module ADDER#(parameter WIDTH=32)(In_A, In_B, Out);
input [WIDTH - 1:0] In_A, In_B;
output [WIDTH - 1:0] Out;

assign Out = In_A + In_B;

endmodule
