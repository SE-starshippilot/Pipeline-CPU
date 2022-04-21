module Mux2_1 #(parameter WIDTH = 32)(In_A, In_B, SEL, Out);
    input[WIDTH - 1:0] In_A, In_B;
    input SEL;
    output reg[WIDTH - 1:0] Out;
    always @(*) begin
        Out <= (SEL == 1'b0)? In_A: In_B;
    end
endmodule

module Mux3_1 #(parameter WIDTH = 32)(In_A, In_B, In_C, SEL, Out);
    input[WIDTH - 1:0] In_A, In_B, In_C;
    input[1:0] SEL;
    output reg[WIDTH - 1:0] Out;

    always @(*) begin
        case(SEL)
            0:       Out <= In_A;
            1:       Out <= In_B;
            2:       Out <= In_C;
            default: Out <= -1;
        endcase
    end
endmodule