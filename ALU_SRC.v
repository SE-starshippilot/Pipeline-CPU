module ALU_SRC(reg_A,
               reg_B,
               shamt,
               imm,
               opcode,
               func,
               out_A,
               out_B);
    input [31:0] reg_B, reg_A;
    input [4:0] shamt;
    input [15:0] imm;
    input [5:0] opcode, func;
    output reg [31:0] out_A, out_B;
    
    always @(reg_A, reg_B, shamt, imm, opcode, func) begin
        $display("reg_A:%d, reg_B:%d, shamt:%d, imm:%d, opcode:%d, func:%d", reg_A, reg_B, shamt, imm, opcode, func);
        if (opcode == 6'b000000) begin
            if (func == 6'b000100 || func == 6'b000110 || func == 6'b000111)begin        //sllv, srlv, srav
                out_A <= reg_B;
                out_B <= {{27{1'b0}}, reg_A[4:0]}; //lower 5 bits of register A
                $display("flag1");
            end else if (func == 6'b000000 || func == 6'b000010 || func == 6'b000011)begin   //sll, srl, sra
                out_A <= reg_B;
                out_B <= {{27{1'b0}}, shamt};  // zero-extended shift amount to 32-bit
                $display("flag2");
            end else begin    //other R-type instruction
                out_A <= reg_A;
                out_B <= reg_B;
                $display("flag3");
            end
        end else if (opcode == 6'b000100 || opcode == 6'b000101)begin                   //beq, bne
            out_A <= reg_A;
            out_B <= reg_B;
        end else if (opcode == 6'b001100 || opcode == 6'b001110)begin                     //andi, xori
            out_A <= reg_A;
            out_B <= {{16{1'b0}}, imm};    //zero-extend immediate to 32-bit
        end else begin
            out_A <= reg_A;
            out_B <= {{16{imm[15]}}, imm}; //sign-extend immediate to 32-bit
        end
    end
endmodule
