module ALU_SRC(Src_SEL,
               RegData1,
               RegData2,
               Shamt,
               Imm,
               Op1,
               Op2);
    input [31:0] RegData2, RegData1;
    input [4:0] Shamt, Src_SEL;
    input [15:0] Imm;
    output reg [31:0] Op1, Op2;
    
    always @(RegData1, RegData2, Shamt, Imm, Src_SEL) begin
        case(Src_SEL)
            0: begin                                        //for other R-type instruction
                Op1 <= RegData1;
                Op2 <= RegData2;
            end
            1: begin                                        //for andi, xori, ori
                Op1 <= RegData1;
                Op2 <= {{16{1'b0}}, Imm};                   //zero-extend Immediate to 32-bit
            end
            2: begin                                        //for other types of I-type instruction
                Op1 <= RegData1;
                Op2 <= {{16{Imm[15]}}, Imm};                //sign-extend Immediate to 32-bit
            end
            3: begin                                        //for sllv, srlv, srav
                Op1 <= RegData2;
                Op2 <= {{27{1'b0}}, RegData1[4:0]};         //lower 5 bits of register A
            end
            4: begin                                        //for sll, srl, sra
                Op1 <= RegData2;
                Op2 <= {{27{1'b0}}, Shamt};                 //zero-extended shift amount to 32-bit
            end
            default: begin
                Op1 <= {32{1'b1}};
                Op2 <= {32{1'b1}};
            end
        endcase
    end
endmodule
