module MUX2_1(In_A, In_B, SEL, Out);
    input[31:0] In_A, In_B;
    input SEL;
    output [31:0] Out;

    assign Out = (SEL == 0)? In_A: In_B;
endmodule