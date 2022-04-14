module ALU_CTRL(opcode,
                func,
                ctrl);
    input[5:0] opcode, func;
    output reg[3:0] ctrl;
    
    always @(opcode, func) begin
        casez (opcode)
            6'b000000:  casez (func)
                            6'b10000?: ctrl = 0;
                            6'b10001?: ctrl = 1;
                            6'b100100: ctrl = 2;
                            6'b100101: ctrl = 3;
                            6'b100110: ctrl = 4;
                            6'b100111: ctrl = 5;
                            6'b101010: ctrl = 6;
                            6'b101011: ctrl = 7;
                            6'b000?00: ctrl = 8;
                            6'b000?10: ctrl = 9;
                            6'b000?11: ctrl = 10;
                            default: ctrl   = -1;
                        endcase
            6'b10?011: ctrl = 0;
            6'b00100?: ctrl = 0;
            6'b00010?: ctrl = 1;
            6'b001100: ctrl = 2;
            6'b001110: ctrl = 4;
            6'b001010: ctrl = 6;
            6'b001011: ctrl = 7;
            default: ctrl   = -1;
        endcase
    end
    
endmodule
