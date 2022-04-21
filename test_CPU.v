`timescale 100fs/100fs
`include "CPU.v"
module test_CPU();
    parameter PERIOD = 10;
    reg CLOCK, RESET;
    reg [2:0]cc;
    integer ClockCycleCount;
    CPU cpu(CLOCK, 1'b0);

    task Display;
        begin
            $display("[CC %3d]\n", ClockCycleCount);
            $display("IF:\tCurrent PC:%-4d\tInstruction_F:%b", cpu.raw_PC>>2, cpu.Inst_F);
            $display("ID:\tRegWrite_D:%-4b\tMem2RegSEL_D:%1b\tMemWriteEN_D:%0b\tBeq_D:%0b\tBne_D:%0b\tALUCtrl_D:%0d\tALUSrc_D:%0d\tRegDstSEL:%0b", cpu.RegWriteEN_D, cpu.Mem2RegSEL_D, cpu.MemWriteEN_D, cpu.Beq_D, cpu.Bne_D, cpu.ALUCtrl_D, cpu.ALUSrc_D, cpu.RegDstSEL_D);
            $display("   \tReg read 1:%-4d\tReg read 2:%0b  \tRt_Addr_D:%2d\tRd_Addr_D:%2d\tShamt:%2d\tImm_D:%5d\tPC_Branch:%0b", cpu.RegReadData1_D, cpu.RegReadData2_D,  cpu.Inst_D[20:16], cpu.Inst_D[20:16], cpu.Inst_D[20:16], cpu.Inst_D[15:0], cpu.PCPlus4_D);
            $display("EX:\tRegWrite_E:%-4b\tMem2RegSEL_E:%1b\tMemWriteEN_E:%0b\tBeq_E:%0b\tBne_E:%0b",cpu.RegWriteEN_E, cpu.Mem2RegSEL_E, cpu.MemWriteEN_E, cpu.Beq_E, cpu.Bne_E);
            $display("   \tZeroFlag_E:%0b \tALUOut_E:%-10d\tRegReadData2_E:%0b\tRegAddr3_E:%0b\tBranchAddr_E:%0b", cpu.ZeroFlag_E, cpu.ALUOut_E, cpu.RegReadData2_E, cpu.RegAddr3_E, cpu.BranchAddr_E);
            $display("___________________________________________________________________________________________________");
        end
    endtask

    initial begin
        // $monitor("[%3tns] CC %4d", $time, ClockCycleCount);
        ClockCycleCount <= 1;
        RESET <= 1'b1;
        CLOCK <= 1'b0;
        #5;
        RESET <= 1'b0;
        #5
        while (1'b1) begin
            CLOCK <= !(CLOCK);
            #(PERIOD/2);
            if (cpu.Inst_F == 32'hffff_ffff) begin
                Display;
                $finish;
            end
        end
    end

    always @(posedge CLOCK) begin
        Display;
        ClockCycleCount = ClockCycleCount + 1;
    end
// The following code is used to test one-off CPU pipeline
    // always @(posedge CLOCK) begin
        // if (cc==1) begin
            // $display("\n*********This is the Instruction Decode Stage***********\n");
            // $display("PC:%b", cpu.PC_F);
            // $display("Output of IF_ID_REG: Inst_D:%b, PCPlus4_D:%b", cpu.Inst_D, cpu.PCPlus4_D);
            // $display("Output of Main Control:  RegWrite_D:%b |   Mem2RegSEL_D:%b |   MemWriteEN_D:%b |    Beq_D:%b    |   Bne_D:%b    |   ALUCtrl_D:%d    |   ALUSrc_D:%d    |   RegDstSEL:%b", cpu.RegWriteEN_D, cpu.Mem2RegSEL_D, cpu.MemWriteEN_D, cpu.Beq_D, cpu.Bne_D, cpu.ALUCtrl_D, cpu.ALUSrc_D, cpu.RegDstSEL_D);
        // end

    //     if (cc==2) begin
    //         $display("\n*********This is the Execution          Stage***********\n");
    //         $display("Output of ID_EX_REG: RegWriteEN_E:%b  |  Mem2RegSEL_E:%b  |  MemWriteEN_E:%b  |  Beq_E:%b  |  Bne_E:%b  |  ALUCtrl_E:%d  |  ALUSrc_E:%d  |  RegDstSEL_E:%b  |  RegReadData1_E:%b  |  RegReadData2_E:%b  |  Rt_E:%b  |  Rd_E:%b  |  Shamt_E:%b  |  Imm_E:%b  |  PCPlus4_E:%b", cpu.RegWriteEN_E, cpu.Mem2RegSEL_E, cpu.MemWriteEN_E, cpu.Beq_E, cpu.Bne_E, cpu.ALUCtrl_E, cpu.ALUSrc_E, cpu.RegDstSEL_E, cpu.RegReadData1_E, cpu.RegReadData2_E, cpu.Rt_E, cpu.Rd_E, cpu.Shamt_E, cpu.Imm_E, cpu.PCPlus4_E);
    //         $display("Register Destination: %b", cpu.RegAddr3_E);
    //         $display("Operands for ALU:\tOp1:%d\t|Op2:%d", cpu.Op1, cpu.Op2);
    //         $display("Output of ALU:%d, with zero flag:%b", cpu.ALUOut_E, cpu.ZeroFlag_E);
    //         // $display("--------------------------");
    //     end
    //     if (cc==3) begin
    //         $display("\n*********This is the Memory Access     Stage***********\n");
    //         $display("Output of EX_MEM_REG: RegWriteEN_M:%b, Mem2RegSEL_M:%b, MemWriteEN_M:%b, Beq_M:%b, Bne_M:%b, ZeroFlag_M:%b, ALUOut_M:%d, MemWriteData_M:%b, RegAddr3_M:%d, PCBranch_M:%b", cpu.RegWriteEN_M, cpu.Mem2RegSEL_M, cpu.MemWriteEN_M, cpu.Beq_M, cpu.Bne_M, cpu.ZeroFlag_M, cpu.ALUOut_M, cpu.MemWriteData_M, cpu.RegAddr3_M, cpu.BranchAddr_M);
    //         $display("Should PC Branch:%b", cpu.PCSrc_M);
    //     end
    //     if (cc==4) begin
    //         $display("\n*********This is the Write  Back     Stage***********\n");
    //         $display("Output of MEM_WB_REG: RegWriteEN_W:%b, Mem2RegSEL_W:%b, ALUOut_W:%b, MemReadData_W:%b, RegAddr3_W:%d", cpu.RegWriteEN_W, cpu.Mem2RegSEL_W, cpu.ALUOut_W, cpu.MemReadData_W, cpu.RegAddr3_W);
    //         $display("What should be write back:%b", cpu.RegWriteData_W);
    //     end
    // end
endmodule