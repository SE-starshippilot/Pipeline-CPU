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
    output reg RegWriteEN, MemWriteEN, Beq, Bne;
    output reg [1:0] Mem2RegSEL, RegDst;
    output reg [4:0] ALUCtrl, ALUSrc;
    
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
    parameter BEQ   = 6'd4;
    parameter BNE   = 6'd5;
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
        RegWriteEN <= 1;        //Most instructions write back to a register
        Mem2RegSEL <= 0;        //Most instructions use data fro ALU
        MemWriteEN <= 0;        //Most instructions do not write to RAM
        Beq        <= 0;
        Bne        <= 0;
        case(opcode)
            RTYPE:
            begin
                RegDst <= 1'b1;    //R-type always write back to Rd.
                case(func)
                    SLL:
                    begin
                        ALUCtrl    <= 7;
                        ALUSrc     <= 4;
                    end
                    SRL:
                    begin
                        ALUCtrl    <= 8;
                        ALUSrc     <= 4;
                    end
                    SRA:
                    begin
                        ALUCtrl    <= 9;
                        ALUSrc     <= 4;
                    end
                    SLLV:
                    begin
                        ALUCtrl    <= 7;
                        ALUSrc     <= 3;
                    end
                    SRLV:
                    begin
                        ALUCtrl    <= 8;
                        ALUSrc     <= 3;
                    end
                    SRAV:
                    begin
                        ALUCtrl    <= 9;
                        ALUSrc     <= 3;
                    end
                    JR:
                    begin
                        RegWriteEN   <= 0;
                    end
                    ADD:
                    begin
                        ALUCtrl    <= 0;
                        ALUSrc     <= 0;
                    end
                    ADDU:
                    begin
                        ALUCtrl    <= 0;
                        ALUSrc     <= 0;
                    end
                    SUB:
                    begin
                        ALUCtrl    <= 1;
                        ALUSrc     <= 0;
                    end
                    SUBU:
                    begin
                        ALUCtrl    <= 1;
                        ALUSrc     <= 0;
                    end
                    AND:
                    begin
                        ALUCtrl    <= 2;
                        ALUSrc     <= 0;
                    end
                    OR:
                    begin
                        ALUCtrl    <= 3;
                        ALUSrc     <= 0;
                    end
                    XOR:
                    begin
                        ALUCtrl    <= 4;
                        ALUSrc     <= 0;
                    end
                    NOR:
                    begin
                        ALUCtrl    <= 5;
                        ALUSrc     <= 0;
                    end
                    SLT:
                    begin
                        ALUCtrl    <= 6;
                        ALUSrc     <= 0;
                    end
                endcase
            end
            BEQ:
            begin
                RegWriteEN <= 0;
                Beq        <= 1;
                ALUCtrl    <= 1;
                ALUSrc     <= 0;
            end
            BNE:
            begin
                RegWriteEN <= 0;
                Bne        <= 1;
                ALUCtrl    <= 1;
                ALUSrc     <= 0;
            end
            ADDI:
            begin
                ALUCtrl    <= 0;
                ALUSrc     <= 2; 
                RegDst     <= 0;
            end
            ADDIU:
            begin
                ALUCtrl    <= 0;
                ALUSrc     <= 2;
                RegDst     <= 0;
            end
            ANDI:
            begin
                ALUCtrl    <= 2;
                ALUSrc     <= 1;
                RegDst     <= 0;
            end
            ORI:
            begin
                ALUCtrl    <= 3;
                ALUSrc     <= 1;
                RegDst     <= 0;
            end
            XORI:
            begin
                ALUCtrl    <= 4;
                ALUSrc     <= 1;
                RegDst     <= 0;
            end
            LW:
            begin
                RegDst     <= 0;
                Mem2RegSEL <= 1;
                ALUCtrl    <= 0;
                ALUSrc     <= 2;
            end
            SW:
            begin
                RegWriteEN <= 0;
                MemWriteEN <= 1;
                ALUCtrl    <= 0;
                ALUSrc     <= 2;
            end
            J:                      //not sure if correct
            begin
                RegWriteEN <= 0;
            end
            JAL:                    //not sure if correct
            begin
                RegWriteEN <= 1;
                RegDst     <= 2;
                Mem2RegSEL <= 2;
            end
            default:                   //do we even need this?
            begin
                ALUCtrl    <= 1;
                ALUSrc     <= 1;
            end
        endcase
    end
    
    
    
    
endmodule //Main_CTRL
