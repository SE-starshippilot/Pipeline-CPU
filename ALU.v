`include "ALU_CTRL.v"
`include "ALU_SRC.v"

module ALU(instruction,
           reg_A,
           reg_B,
           result,
           flags);
    
    input [31:0] instruction;
    input signed [31:0] reg_A, reg_B;
    output reg[31:0] result;
    output reg [2:0] flags;
    
    wire [3:0] ALU_op;         // operation for the ALU to perform
    reg [5:0] opcode, func;    //opcode and function from instruction
    reg [15:0] imm;
    reg[4:0] shamt;
    wire signed [31:0] selected_A, selected_B;
    reg zero_flag, neg_flag, overflow_flag;

    ALU_CTRL alu_ctrl(opcode, func, ALU_op);
    ALU_SRC alu_src(reg_A, reg_B, shamt, imm, opcode, func, selected_A, selected_B);

    always @(reg_A, reg_B, instruction) begin
        opcode            <= instruction[31:26];
        func              <= instruction[5:0];
        imm               <= instruction[15:0];
        shamt             <= instruction[10:6];
    end
    
    
    always @(ALU_op, selected_A, selected_B) begin
        zero_flag     <= 1'b0;
        neg_flag      <= 1'b0;
        overflow_flag <= 1'b0;
        #5
        $display("sel_A:%d, sel_B:%d", selected_A, selected_B);
        $display("ctrl:%d", ALU_op);
        case (ALU_op)
            0: result       = selected_A + selected_B;
            1: result       = selected_A - selected_B;
            2: result       = selected_A & selected_B;
            3: result       = selected_A | selected_B;
            4: result       = selected_A ^ selected_B;
            5: result       = ~(selected_A | selected_B);
            6: result       = selected_A < selected_B;
            7: result       = $unsigned(selected_A) < $unsigned(selected_B);
            8: result       = selected_A << selected_B;
            9: result       = selected_A >> selected_B;
            10:result       = selected_A >>> selected_B;
            default: result = 32'bx;
        endcase
        casez(opcode)
            6'b00010?:  zero_flag     = result == 0;  //beq, bne
            6'b00101?:  neg_flag      = result;  //slti, sltiu
            6'b001000:  overflow_flag = (selected_A[31]&selected_B[31]&(!result[31])) + ((!selected_A[31])&(!selected_B[31])&result[31]);  //addi
            6'b000000:  casez(func)
                            6'b100000: overflow_flag = (selected_A[31]&selected_B[31]&(!result[31])) + ((!selected_A[31])&(!selected_B[31])&result[31]);    //add
                            6'b100010: overflow_flag = (selected_A[31]&(!selected_B[31])&(!result[31])) + ((!selected_A[31])&selected_B[31]&result[31]);    //sub
                            6'b10101?: neg_flag      = result;   //slt, sltu
                        endcase
        endcase
        flags = {zero_flag, neg_flag, overflow_flag};
    end
    
endmodule
