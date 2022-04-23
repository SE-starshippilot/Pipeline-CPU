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
            $fdisplay(Signal_FHANDLER, "IF-Branch_SEL:\tPCBranched:%-32d\tPC+4           :%-32d\tBranch Addr :%-32d\tPCSrc_D       :%-10d", cpu.PCBranched, cpu.PCPlus4_F, cpu.PCBranchAddr_D, cpu.PCSrc_D);
            $fdisplay(Signal_FHANDLER, "IF-Jump_CTRL :\tJSEL      :%-32d\tOpcode_F       :%-32b\tFunc_F      :%-32b", cpu.JSEL, cpu.Opcode_F, cpu.Func_F);
            $fdisplay(Signal_FHANDLER, "IF-Jump_SEL  :\tPCJumped  :%-32d\tPCBranched     :%-32d\tPCJumpAddr  :%-32d\tJSEL          :%-10d", cpu.PCJumped, cpu.PCBranched, cpu.PCJumpAddr, cpu.JSEL);
            $fdisplay(Signal_FHANDLER, "IF-PC_REG    :\tPC_out    :%-32d\tPC_in          :%-32d", cpu.PC_F, cpu.PCJumped);
            $fdisplay(Signal_FHANDLER, "IF-Inst_RAM  :\tIndex     :%-32d\tFetched Inst   :%-32b\n", cpu.PC_F >> 2, cpu.Inst_F);
            // $fdisplay(Signal_FHANDLER, "ID-Decoded   :\tRegAddr1_D:%-32d\tRegAddr2_D     :%-32d\tRt_D        :%-10d\tRd_D          :%-10d\tShamt_D :%-5d\tImm_D    :%-32d\tOpcode_D   :%-32b\tFunc_D   :%-5b", cpu.RegAddr1_D, cpu.RegAddr2_D, cpu.Rt_D, cpu.Rd_D, cpu.Shamt_D, cpu.Imm_D, cpu.Opcode_D, cpu.Func_D);
            $fdisplay(Signal_FHANDLER, "ID-Reg_File  :\tRegAddr1_D:%-32d\tRegAddr2_D     :%-32d\tRegAddr3_W  :%-32d\tRegWrite      :%-10d\tWrtEN     :%-10d\tRegRead1 :%-10d\tRegRead2   :%-10d", cpu.RegAddr1_D, cpu.RegAddr2_D, cpu.RegAddr3_W, cpu.RegWriteData_W, cpu.RegWriteData_W, cpu.RegReadData1_D, cpu.RegReadData2_D);
            $fdisplay(Signal_FHANDLER, "ID-Branch    :\tBranch?   :%-32b\tBranchAddr     :%-32d\tReg1Data    :%-32d\tREg2Data      :%-10d", cpu.PCSrc_D,cpu.PCBranchAddr_D, cpu.RegReadData1_D, cpu.RegReadData2_D);
            $fdisplay(Signal_FHANDLER, "ID-Main_CTRL :\tOpcode_D  :%-32b\tFunc_D         :%-32b\tRegWrtEN_D  :%-32d\tMem2RegSEL_D  :%-10d\tMemWrtEN  :%-10d\tBeq_D    :%-10d\tBne_D      :%-10d\tALUCtrl_D:%-5d\tALUSrc_D:%-5d\tRegDstSEL_D:%-5d\n", cpu.Opcode_D, cpu.Func_D, cpu.RegWriteEN_D, cpu.Mem2RegSEL_D, cpu.MemWriteEN_D, cpu.Beq_D, cpu.Bne_D, cpu.ALUCtrl_D, cpu.ALUSrc_D, cpu.RegDstSEL_D);
            $fdisplay(Signal_FHANDLER, "EX-RegDstSEL :\tRegAddr3_E:%-32d\tRtAddr_E       :%-32d\tRdAddr_E    :%-32d\tRegDstSEL_E   :%-10d", cpu.RegAddr3_E, cpu.Rt_E, cpu.Rd_E, cpu.RegDstSEL_E);
            $fdisplay(Signal_FHANDLER, "EX-Forward1  :\tForwarded1:%-32d\tfrom reg       :%-32d\tfrom MEM    :%-32d\tFrom WB       :%-10d\tSEL       :%-10d", $signed(cpu.Reg1DataForward), $signed(cpu.RegReadData1_E), $signed(cpu.ALUOut_M), $signed(cpu.RegWriteData_W), cpu.ForwardReg1SEL);
            $fdisplay(Signal_FHANDLER, "EX-Forward2  :\tForwarded2:%-32d\tfrom reg       :%-32d\tfrom MEM    :%-32d\tFrom WB       :%-10d\tSEL       :%-10d", $signed(cpu.Reg2DataForward), $signed(cpu.RegReadData2_E), $signed(cpu.ALUOut_M), $signed(cpu.RegWriteData_W), cpu.ForwardReg2SEL);
            $fdisplay(Signal_FHANDLER, "EX-FWD Unit  :\tRS Address:%-32d\tRT Address     :%-32d\tWB Address  :%-32d\tRegWrtEN_M    :%-10d\tRegWEN_M  :%-10d\tRegWEN_W :%-10d\tFwd1SEL    :%-10d\tFwd2SEL  :%-5d",cpu.Rs_E, cpu.Rt_E, cpu.RegAddr3_M, cpu.RegAddr3_W, cpu.RegWriteEN_M, cpu.RegWriteEN_W, cpu.ForwardReg1SEL, cpu.ForwardReg2SEL);
            $fdisplay(Signal_FHANDLER, "EX-ALUSrc    :\tOp1       :%-32d\tOp2            :%-32d\tALUSrc_E    :%-32d\tRegRead1_E    :%-10d\tRegRead2_E:%-10d\tShamt_E  :%-10d\tImm_E      :%-10d", cpu.Op1, cpu.Op2, cpu.ALUSrc_E, $signed(cpu.Reg1DataForward), $signed(cpu.Reg2DataForward), cpu.Shamt_E, $signed(cpu.Imm_E));
            $fdisplay(Signal_FHANDLER, "EX-ALU       :\tALUOut_E  :%-32d\tFlag_E         :%-32d\tALUCtrl_E   :%-32d\tOp1           :%-10d\tOp2       :%-10d\n", $signed(cpu.ALUOut_E),  cpu.ZeroFlag_E, cpu.ALUCtrl_E, $signed(cpu.Op1), $signed(cpu.Op2));
            $fdisplay(Signal_FHANDLER, "MEM-Main Mem :\tMemWrtEN_M:%-32d\tIndex          :%-32d\tMemWrtData_M:%-32d\tMemReadData_M :%-10d",cpu.MemWriteEN_M, (cpu.ALUOut_M)>>2,  cpu.MemWriteData_M,  cpu.MemReadData_M);
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
        // $monitor("[CC %4d] Branch signal:%-2b", ClockCycleCount, cpu.PCSrc_D);
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
                DisplayCriticalInfo;
                LogSignal;
                LogRegister;
                LogRAM;
                $finish;
            end
            if (ClockCycleCount > 200) $finish;
        end
        $fclose(Signal_FHANDLER);
        $fclose(Register_FHANDLER);
        $fclose(RAM_FHANDLER);
    end

    always @(posedge CLOCK) begin
        DisplayCriticalInfo;
        LogSignal;
        LogRegister;
        // LogRAM;
        ClockCycleCount = ClockCycleCount + 1;
    end
endmodule