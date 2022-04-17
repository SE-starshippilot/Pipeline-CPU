module Mux2_1_32BIT(In_A, In_B, SEL, Out);
    input[31:0] In_A, In_B;
    input SEL;
    output [31:0] Out;

    assign Out = (SEL == 0)? In_A: In_B;
endmodule

module Mux2_1_5BIT(In_A, In_B, SEL, Out);
    input[4:0] In_A, In_B;
    input SEL;
    output [4:0] Out;

    assign Out = (SEL == 0)? In_A: In_B;
endmodule