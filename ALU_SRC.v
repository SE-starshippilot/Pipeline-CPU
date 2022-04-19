module ALU_SRC(src_ctrl,
               reg_A,
               reg_B,
               shamt,
               imm,
               out_A,
               out_B);
    input [31:0] reg_B, reg_A;
    input [4:0] shamt, src_ctrl;
    input [15:0] imm;
    input [5:0] opcode, func;
    output reg [31:0] out_A, out_B;
    
    always @(reg_A, reg_B, shamt, imm, src_ctrl) begin
        case(src_ctrl)
        0: begin                                        //for other R-type instruction
                out_A <= reg_A;
                out_B <= reg_B;
            end
        1: begin                                        //for andi, xori, ori
                out_A <= reg_A;
                out_B <= {{16{1'b0}}, imm};             //zero-extend immediate to 32-bit     
            end
        2: begin                                        //for other types of I-type instruction
                out_A <= reg_A;
                out_B <= {{16{imm[15]}}, imm};          //sign-extend immediate to 32-bit
            end
        3: begin                                        //for sllv, srlv, srav
                out_A <= reg_B;
                out_B <= {{27{1'b0}}, reg_A[4:0]};      //lower 5 bits of register A  
            end
        4: begin                                        //for sll, srl, sra
                out_A <= reg_B;
                out_B <= {{27{1'b0}}, shamt};           //zero-extended shift amount to 32-bit
            end
        endcase
    end
endmodule
