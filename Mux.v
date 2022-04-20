module Mux2_1 #(parameter WIDTH = 32)(In_A, In_B, SEL, Out);
    input[WIDTH - 1:0] In_A, In_B;
    input SEL;
    output [WIDTH - 1:0] Out;

    assign Out = (SEL == 0)? In_A: In_B;
endmodule