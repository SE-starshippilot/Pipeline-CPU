`timescale 100fs/100fs
`include "CPU.v"
module test_CPU();
    parameter PERIOD = 10;
    reg CLOCK, RESET;
    reg [2:0]cc;
    integer ClockCycleCount;
    CPU cpu(CLOCK, RESET);
    localparam Signal_FNAME = "LogSignal.txt";
    localparam Register_FNAME = "LogRegister.txt";
    localparam RAM_FNAME = "LogRAM.txt";
    integer Signal_FHANDLER = 0;
    integer Register_FHANDLER = 0;
    integer RAM_FHANDLER = 0;
    integer reg_idx = 0;
    integer ram_idx = 0;

    task DisplayCriticalInfo;
        begin
            $display("[CC %3d]\n", ClockCycleCount);
            $display("PC            |%-10d", cpu.PCJumped>>2);
            $display("Instruction_F |%-32b", cpu.Inst_F);
            $display("- - - - - - - - - - - - - - - - - - - - - - - - - - ");
            $display("Opcode        |%-6b", cpu.Inst_D[31:26]);
            $display("func          |%-6b", cpu.Inst_D[5:0]);
            $display("- - - - - - - - - - - - - - - - - - - - - - - - - - ");
            $display("Writeback reg |%-2d", cpu.RegAddr3_E);
            $display("Operands      |%-10d, %-10d", $signed(cpu.Op1), $signed(cpu.Op2));
            $display("Operation     |%-2d", cpu.ALUCtrl_E);
            $display("ALU output    |%-10d, flag=%1b", cpu.ALUOut_E, cpu.ZeroFlag_E);
            $display("- - - - - - - - - - - - - - - - - - - - - - - - - - ");
            $display("MEM output    |%-32b", cpu.MemReadData_M);
            $display("- - - - - - - - - - - - - - - - - - - - - - - - - - ");
            $display("WB data       |%-32d", $signed(cpu.RegWriteData_W));
            $display("WB addr       |%-2d", cpu.RegAddr3_W);
            $display("*****************************************************");
        end
    endtask
    task LogRegister;
        begin
            $fdisplay(Register_FHANDLER, "[CC %3d]", ClockCycleCount);
            for(reg_idx = 0; reg_idx < 32; reg_idx = reg_idx + 1) $fdisplay(Register_FHANDLER, "|Reg %-2d |%-10d", reg_idx, $signed(cpu.register_file.RegFile[reg_idx]));
            $fdisplay(Register_FHANDLER, "__________________");
        end
    endtask
    task LogSignal;
        begin
            $fdisplay(Signal_FHANDLER, "[CC %3d]\n", ClockCycleCount);

            $fdisplay(Signal_FHANDLER, "HZ-PC-ID_RST :\tReset     :%-32d\tPCSrc_D        :%-32d\tJSEL        :%-32d\tBitwise Or    :%-10d", cpu.PC_ID_RESET, cpu.PCSrc_D, cpu.JSEL, |cpu.JSEL);

            $fdisplay(Signal_FHANDLER, "IF-Branch_SEL:\tPCBranched:%-32d\tPC+4           :%-32d\tBranch Addr :%-32d\tPCSrc_D       :%-10d", cpu.PCBranched, cpu.PCPlus4_F, cpu.PCBranchAddr_D, cpu.PCSrc_D);
            $fdisplay(Signal_FHANDLER, "IF-Jump_CTRL :\tJSEL      :%-32d\tOpcode_F       :%-32b\tFunc_F      :%-32b", cpu.JSEL, cpu.Opcode_D, cpu.Func_D);
            $fdisplay(Signal_FHANDLER, "IF-Jump_SEL  :\tPCJumped  :%-32d\tPCBranched     :%-32d\tPCJumpAddr  :%-32d\tJumpRegAddr   :%-10d\tJSEL      :%-10d", cpu.PCJumped, cpu.PCBranched, cpu.PCJumpAddr_D, cpu.RegReadData1_D,cpu.JSEL);
            $fdisplay(Signal_FHANDLER, "IF-PC_REG    :\tPC_out    :%-32d\tPC_in          :%-32d\tStalled?    :%-32d\tReset?        :%-32d", cpu.PC_F, cpu.PCJumped, cpu.pc_register.STALL, cpu.pc_register.RESET);
            $fdisplay(Signal_FHANDLER, "IF-Inst_RAM  :\tIndex     :%-32d\tFetched Inst   :%-32b", cpu.PC_F >> 2, cpu.Inst_F);
            $fdisplay(Signal_FHANDLER, "IF-ID-REG    :\tReset?    :%-32d\tStalled?       :%-32d\tInstr_out   :%-32b\tPCPlus4_out   :%-32d\tInstr_in  :%-32b\tPCPlus4_in:%-32d\n", cpu.if_id_reg.RESET, cpu.Stall_F, cpu.if_id_reg.Instruction_Out, cpu.if_id_reg.PCPlus4_Out, cpu.if_id_reg.Instruction_In, cpu.if_id_reg.PCPlus4_In);

            $fdisplay(Signal_FHANDLER, "ID-Instruct  :\tInstruct  :%-32b", cpu.Inst_D);
            $fdisplay(Signal_FHANDLER, "ID-Decoded   :\tRegAddr1_D:%-32d\tRegAddr2_D     :%-32d\tRs_Addr     :%-32d\tRt_Addr       :%-10d\tRd_Addr   :%-10d\tShamt_D  :%-10d\tImm_D       :%-10d\tOpcode_D :%-5b\tFunc_D :%-5b", cpu.RegAddr1_D, cpu.RegAddr2_D, cpu.Rs_D, cpu.Rt_D, cpu.Rd_D, cpu.Shamt_D, cpu.Imm_D, cpu.Opcode_D, cpu.Func_D);
            $fdisplay(Signal_FHANDLER, "ID-Reg_File  :\tRegAddr1_D:%-32d\tRegAddr2_D     :%-32d\tRegAddr3_W  :%-32d\tRegWrite      :%-10d\tWrtEN     :%-10d\tRegRead1 :%-10d\tRegRead2   :%-10d", cpu.RegAddr1_D, cpu.RegAddr2_D, cpu.RegAddr3_W, cpu.RegWriteData_W, cpu.RegWriteData_W, cpu.RegReadData1_D, cpu.RegReadData2_D);
            $fdisplay(Signal_FHANDLER, "ID-Hazard    :\tStall PC  :%-32d\tStall IF_ID_REG:%-32d\tRSAddr_D    :%-32d\tRTAddr_D      :%-10d\tRTAddr_E  :%-10d\tStallSEL :%-10d", cpu.Stall_F, cpu.Stall_D, cpu.Rs_D, cpu.Rt_D, cpu.Rt_E, cpu.Mem2RegSEL_E);
            $fdisplay(Signal_FHANDLER, "ID-Branch    :\tBranch?   :%-32b\tBranchAddr     :%-32d\tReg1Data    :%-32d\tREg2Data      :%-10d", cpu.PCSrc_D,cpu.PCBranchAddr_D, cpu.RegReadData1_D, cpu.RegReadData2_D);
            $fdisplay(Signal_FHANDLER, "ID-JumpAddr  :\tOutput    :%-32d\tPCHeader       :%-32b\tExtended    :%-32d\t", cpu.PCJumpAddr_D, cpu.PCPlus4_D[31:28], cpu.Inst_D[25:0]<< 2);
            $fdisplay(Signal_FHANDLER, "ID-Main_CTRL :\tOpcode_D  :%-32b\tFunc_D         :%-32b\tRegWrtEN_D  :%-32d\tMem2RegSEL_D  :%-10d\tMemWrtEN  :%-10d\tBeq_D    :%-10d\tBne_D      :%-10d\tALUCtrl_D:%-5d\tALUSrc_D:%-5d\tRegDstSEL_D:%-5d\n", cpu.Opcode_D, cpu.Func_D, cpu.RegWriteEN_D, cpu.Mem2RegSEL_D, cpu.MemWriteEN_D, cpu.Beq_D, cpu.Bne_D, cpu.ALUCtrl_D, cpu.ALUSrc_D, cpu.RegDstSEL_D);
            // $fdisplay(Signal_FHANDLER, "ID-CTRLS     :\tRESET     :%-32b\tRegWriteEN     :%-32b\tMem2RegSEL  :%-32d\tMemWriteEN    :%-10d\tBeq       :%-10d\tBne      :%-10d\tALUCtrl    :%-10d\tALUSrc   :%-5d\tRegDst  :%-5d", cpu.Flush_E | cpu.PCSrc_D, cpu.RegWriteEN_D_Ctrl, cpu.Mem2RegSEL_D_Ctrl, cpu.MemWriteEN_D_Ctrl, cpu.Beq_D_Ctrl, cpu.Bne_D_Ctrl, cpu.ALUCtrl_D_Ctrl, cpu.ALUSrc_D_Ctrl, cpu.RegDstSEL_D_Ctrl);
            // $fdisplay(Signal_FHANDLER, "ID-CTRLS     :\tRESET     :%-32b\tRegWriteEN     :%-32b\tMem2RegSEL  :%-32d\tMemWriteEN    :%-10d\tBeq       :%-10d\tBne      :%-10d\tALUCtrl    :%-10d\tALUSrc   :%-5d\tRegDst  :%-5d\tRegWriteEN :%-5d", cpu.Flush_E | cpu.PCSrc_D, cpu.RegWriteEN_D, cpu.Mem2RegSEL_D, cpu.MemWriteEN_D, cpu.Beq_D, cpu.Bne_D, cpu.ALUCtrl_D, cpu.ALUSrc_D, cpu.RegDstSEL_D,cpu.RegWriteEN_D_Ctrl, cpu.Mem2RegSEL_D_Ctrl, cpu.MemWriteEN_D_Ctrl, cpu.Beq_D_Ctrl, cpu.Bne_D_Ctrl, cpu.ALUCtrl_D_Ctrl, cpu.ALUSrc_D_Ctrl, cpu.RegDstSEL_D_Ctrl);
            $fdisplay(Signal_FHANDLER, "ID-EX-REG    :\tflush?    :%-32b\n", cpu.id_ex_reg.RESET);
            
            $fdisplay(Signal_FHANDLER, "EX-RegDstSEL :\tRegAddr3_E:%-32d\tRtAddr_E       :%-32d\tRdAddr_E    :%-32d\tRegDstSEL_E   :%-10d", cpu.RegAddr3_E, cpu.Rt_E, cpu.Rd_E, cpu.RegDstSEL_E);
            $fdisplay(Signal_FHANDLER, "EX-Forward1  :\tForwarded1:%-32d\tfrom reg       :%-32d\tfrom MEM    :%-32d\tFrom WB       :%-10d\tSEL       :%-10d", $signed(cpu.Reg1DataForward), $signed(cpu.RegReadData1_E), $signed(cpu.ALUOut_M), $signed(cpu.RegWriteData_W), cpu.ForwardReg1SEL);
            $fdisplay(Signal_FHANDLER, "EX-Forward2  :\tForwarded2:%-32d\tfrom reg       :%-32d\tfrom MEM    :%-32d\tFrom WB       :%-10d\tSEL       :%-10d", $signed(cpu.Reg2DataForward), $signed(cpu.RegReadData2_E), $signed(cpu.ALUOut_M), $signed(cpu.RegWriteData_W), cpu.ForwardReg2SEL);
            $fdisplay(Signal_FHANDLER, "EX-FWD Unit  :\tRS Address:%-32d\tRT Address     :%-32d\tWB Address  :%-32d\tRegWrtEN_M    :%-10d\tRegWEN_M  :%-10d\tRegWEN_W :%-10d\tFwd1SEL    :%-10d\tFwd2SEL  :%-5d",cpu.Rs_E, cpu.Rt_E, cpu.RegAddr3_M, cpu.RegAddr3_W, cpu.RegWriteEN_M, cpu.RegWriteEN_W, cpu.ForwardReg1SEL, cpu.ForwardReg2SEL);
            $fdisplay(Signal_FHANDLER, "EX-ALUSrc    :\tOp1       :%-32d\tOp2            :%-32d\tALUSrc_E    :%-32d\tRegRead1_E    :%-10d\tRegRead2_E:%-10d\tShamt_E  :%-10d\tImm_E      :%-10d", cpu.Op1, cpu.Op2, cpu.ALUSrc_E, $signed(cpu.Reg1DataForward), $signed(cpu.Reg2DataForward), cpu.Shamt_E, $signed(cpu.Imm_E));
            $fdisplay(Signal_FHANDLER, "EX-ALU       :\tALUOut_E  :%-32d\tFlag_E         :%-32d\tALUCtrl_E   :%-32d\tOp1           :%-10d\tOp2       :%-10d\n", $signed(cpu.ALUOut_E),  cpu.ZeroFlag_E, cpu.ALUCtrl_E, $signed(cpu.Op1), $signed(cpu.Op2));
            $fdisplay(Signal_FHANDLER, "MEM-Main Mem :\tMemWrtEN_M:%-32d\tIndex          :%-32d\tMemWrtData_M:%-32d\tMemReadData_M :%-10d\n",cpu.MemWriteEN_M, (cpu.ALUOut_M)>>2,  cpu.MemWriteData_M,  cpu.MemReadData_M);
            $fdisplay(Signal_FHANDLER, "WB-DataSEL   :\tRegWrtDt_W:%-32d\tALUOut_W       :%-32d\tMemRedData_W:%-32d\tMem2RegSEL_W  :%-10d", $signed(cpu.RegWriteData_W), cpu.ALUOut_W, cpu.MemReadData_W, cpu.Mem2RegSEL_W);
            $fdisplay(Signal_FHANDLER, "WB-DataAddr  :\tRegAddr3_W:%-32d", cpu.RegAddr3_W);
            $fdisplay(Signal_FHANDLER, "___________________________________________________________________________________________________");
        end
    endtask
    task LogRAM;
        begin
            // $fdisplay(RAM_FHANDLER, "[CC %4d]", ClockCycleCount);
            for(ram_idx = 0; ram_idx < 512; ram_idx = ram_idx + 1) $fdisplay(RAM_FHANDLER, "%-32b", cpu.mainmemory.DATA_RAM[ram_idx]);
            // for(ram_idx = 0; ram_idx < 512; ram_idx = ram_idx + 1) $fdisplay(RAM_FHANDLER, "[RAM %5d]%-32d", ram_idx, $signed(cpu.mainmemory.DATA_RAM[ram_idx]));
            // $fdisplay(RAM_FHANDLER, "____________________________________________________________________");
        end
    endtask

    initial begin
        // $monitor("%t[CC%-4d] RESET:%1d, Mem2RegSEL:D:%10d, D-S:%10d, E:%10d, M:%10d, W:%10d", $time, ClockCycleCount, cpu.id_ctrl_mux.RESET,  cpu.Mem2RegSEL_D, cpu.Mem2RegSEL_D_Ctrl, cpu.Mem2RegSEL_E, cpu.Mem2RegSEL_M, cpu.Mem2RegSEL_W);
        // $monitor("[%-4t/CC%-4d]\tSEL:%-10d\tBeq_D:%-10d\tBne_D :%-10d\tRegReadData1_D:%-10d\tRegReadData2_D:%-10d", $time, ClockCycleCount, cpu.PCSrc_D, cpu.Beq_D, cpu.Bne_D, cpu.RegReadData1_D, cpu.RegReadData2_D);
        // $monitor("[%-4t/CC%-4d]\tSEL:%-10d\tBeq_D:%-10d\tBne_D :%-10d\tRegReadData1_D:%-10d\tRegReadData2_D:%-10d", $time, ClockCycleCount, cpu.PCSrc_D, cpu.Beq_D, cpu.Bne_D, cpu.RegReadData1_D, cpu.RegReadData2_D);
        // $monitor("[%-4t/CC%-4d]\t+4:%-10d\tBranch:%-10d\tSEL :%-10d\tOut:%-10d", $time, ClockCycleCount, cpu.PCPlus4_F, cpu.PCBranchAddr_D, cpu.PCSrc_D, cpu.PCBranched);
        // $monitor("[%-4t/CC%-4d]\tOut:%-32d\In:%-32d\tGeneration of PC+4:%-10d\tGeneration of Branch:%-32d", $time, ClockCycleCount, cpu.PC_F, cpu.PCJumped, cpu.PCPlus4_F, cpu.PCBranchAddr_D);
        $monitor("[%-4t/CC%-4d]\tOut:%-10d\tJumped:%-10d\tBranched:%-10d\t+4:%-10d\tBranchAddr:%-10d\tBranchSEL:%-10d\tJumpAddr:%-10d\tJumpRegAddr:%-10d\tJSEL:%-10d"
                        , $time, ClockCycleCount, cpu.PC_F, cpu.PCJumped, cpu.PCBranched, cpu.PCPlus4_F, cpu.PCBranchAddr_D, cpu.PCSrc_D, cpu.PCJumpAddr_D, cpu.RegReadData1_D,cpu.JSEL);
        Signal_FHANDLER = $fopen(Signal_FNAME, "w");
        Register_FHANDLER = $fopen(Register_FNAME, "w");
        RAM_FHANDLER = $fopen(RAM_FNAME, "w");
        ClockCycleCount <= 0;
        RESET <= 1'b1;
        CLOCK <= 1'b0;
        #5
        RESET = 1'b0;
        #5
        while (1'b1) begin
            CLOCK <= !(CLOCK);
            #(PERIOD/2);
            if (^(cpu.ALUOut_M) !== 1'bx && ^(cpu.ALUOut_E) === 1'bx) begin
                // DisplayCriticalInfo;
                LogSignal;
                LogRegister;
                LogRAM;
                $finish;
            end
            // if (ClockCycleCount > 200) $finish;
        end
        $fclose(Signal_FHANDLER);
        $fclose(Register_FHANDLER);
        $fclose(RAM_FHANDLER);
    end

    always @(posedge CLOCK) begin
        // DisplayCriticalInfo;
        LogSignal;
        LogRegister;
        // LogRAM;
        ClockCycleCount = ClockCycleCount + 1;
    end
endmodule