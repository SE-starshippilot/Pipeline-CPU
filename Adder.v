module ADDER_32BIT(In_A, In_B, Out);
input [31:0] In_A, In_B;
output [31:0] Out;

assign Out = In_A + In_B;

endmodule
