module Main_CTRL (opcode,
                  func,
                  RegWriteEN,
                  Mem2RegSEL,
                  MemWriteEN,
                  Beq,
                  Bne,
                  ALUCtrl,
                  ALUSrc,
                  RegDst);
    input [5:0] opcode, func;
    output reg RegWriteEN, Mem2RegSEL, MemWriteEN, Beq, Bne, ALUCtrl, ALUSrc, RegDst;
    
    //R type instruction, parameter indicates func
    parameter SLL  = 6'd0;
    parameter SRL  = 6'd2;
    parameter SRA  = 6'd3;
    parameter SLLV = 6'd4;
    parameter SRLV = 6'd6;
    parameter SRAV = 6'd7;
    parameter JR   = 6'd8;
    parameter ADD  = 6'd32;
    parameter ADDU = 6'd33;
    parameter SUB  = 6'd34;
    parameter SUBU = 6'd35;
    parameter AND  = 6'd36;
    parameter OR   = 6'd37;
    parameter XOR  = 6'd38;
    parameter NOR  = 6'd39;
    parameter SLT  = 6'd42;
    //I-type instruction, parameter indicates opcode
    parameter BEQ   = 6'd3;
    parameter BNE   = 6'd4;
    parameter ADDI  = 6'd8;
    parameter ADDIU = 6'd9;
    parameter ANDI  = 6'd12;
    parameter ORI   = 6'd13;
    parameter XORI  = 6'd14;
    parameter LW    = 6'd35;
    parameter SW    = 6'd43;
    //J-type instruction, parameter indicates opcode
    parameter J   = 6'd2;
    parameter JAL = 6'd3;
    //Misc
    parameter STOP  = 6'd63;    //opcode  = 111111, stop
    parameter RTYPE = 6'd0;     //opcode = 000000, R-type
    
    always @(opcode, func) begin
        case(opcode)
            RTYPE:
            begin
                case(func)
                    SLL:
                    begin
                        //change ALUCtrl with ALUSrc
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 7;
                        ALUSrc     <= 4;
                        RegDst     <= 1;
                    end
                    SRL:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 8;
                        ALUSrc     <= 4;
                        RegDst     <= 1;
                    end
                    SRA:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 9;
                        ALUSrc     <= 4;
                        RegDst     <= 1;
                    end
                    SLLV:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 7;
                        ALUSrc     <= 3;
                        RegDst     <= 1;
                    end
                    SRLV:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 8;
                        ALUSrc     <= 3;
                        RegDst     <= 1;
                    end
                    SRAV:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 9;
                        ALUSrc     <= 3;
                        RegDst     <= 1;
                    end
                    JR:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;//brahcn?
                        Bne        <= 0;//brahcn?
                        ALUCtrl    <= 0;
                        ALUSrc     <= 0;//x
                        RegDst     <= 1;
                    end
                    ADD:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 0;
                        ALUSrc     <= 0;
                        RegDst     <= 1;
                    end
                    ADDU:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 0;
                        ALUSrc     <= 0;
                        RegDst     <= 1;
                    end
                    SUB:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 1;
                        ALUSrc     <= 0;
                        RegDst     <= 1;
                    end
                    SUBU:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 1;
                        ALUSrc     <= 0;
                        RegDst     <= 1;
                    end
                    AND:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 2;
                        ALUSrc     <= 0;
                        RegDst     <= 1;
                    end
                    OR:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 3;
                        ALUSrc     <= 0;
                        RegDst     <= 1;
                    end
                    XOR:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 4;
                        ALUSrc     <= 0;
                        RegDst     <= 1;
                    end
                    NOR:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 5;
                        ALUSrc     <= 0;
                        RegDst     <= 1;
                    end
                    SLT:
                    begin
                        RegWriteEN <= 1;
                        Mem2RegSEL <= 0;
                        MemWriteEN <= 0;
                        Beq        <= 0;
                        Bne        <= 0;
                        ALUCtrl    <= 6;
                        ALUSrc     <= 0;
                        RegDst     <= 1;
                    end
                endcase
            end
            BEQ:
            begin
                RegWriteEN <= 0;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 1;
                Bne        <= 1;
                ALUCtrl    <= 1;
                ALUSrc     <= 0;
                RegDst     <= 0;//x
            end
            BNE:
            begin
                RegWriteEN <= 0;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 1;
                Bne        <= 1;
                ALUCtrl    <= 1;
                ALUSrc     <= 0;
                RegDst     <= 0;//x
            end
            ADDI:
            begin
                RegWriteEN <= 1;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 0;
                Bne        <= 0;
                ALUCtrl    <= 0;
                ALUSrc     <= 0;
                RegDst     <= 0;
            end
            ADDIU:
            begin
                RegWriteEN <= 1;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 0;
                Bne        <= 0;
                ALUCtrl    <= 0;
                ALUSrc     <= 0;
                RegDst     <= 0;
            end
            ANDI:
            begin
                RegWriteEN <= 1;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 0;
                Bne        <= 0;
                ALUCtrl    <= 0;
                ALUSrc     <= 0;
                RegDst     <= 0;
            end
            ORI:
            begin
                RegWriteEN <= 1;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 0;
                Bne        <= 0;
                ALUCtrl    <= 0;
                ALUSrc     <= 0;
                RegDst     <= 0;
            end
            XORI:
            begin
                RegWriteEN <= 0;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 0;
                Bne        <= 0;
                ALUCtrl    <= 0;
                ALUSrc     <= 0;
                RegDst     <= 0;
            end
            LW:
            begin
                RegWriteEN <= 0;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 0;
                Bne        <= 0;
                ALUCtrl    <= 0;
                ALUSrc     <= 0;
                RegDst     <= 0;
            end
            SW:
            begin
                RegWriteEN <= 0;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 0;
                Bne        <= 0;
                ALUCtrl    <= 0;
                ALUSrc     <= 0;
                RegDst     <= 0;
            end
            J:
            begin
                RegWriteEN <= 0;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 0;
                Bne        <= 0;
                ALUCtrl    <= 0;
                ALUSrc     <= 0;
                RegDst     <= 0;
            end
            JAL:
            begin
                RegWriteEN <= 0;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 0;
                Bne        <= 0;
                ALUCtrl    <= 0;
                ALUSrc     <= 0;
                RegDst     <= 0;
            end
            STOP:
            begin
                RegWriteEN <= 0;
                Mem2RegSEL <= 0;
                MemWriteEN <= 0;
                Beq        <= 0;
                Bne        <= 0;
                ALUCtrl    <= 0;
                ALUSrc     <= 0;
                RegDst     <= 0;
            end
        endcase
    end
    
    
    
    
endmodule //Main_CTRL
