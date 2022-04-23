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
            $fdisplay(Signal_FHANDLER, "IF-Branch_SEL:\tPCBranched:%-32d\tPC+4           :%-32d\tBranch Addr :%-10d\tPCSrc_D       :%-10d", cpu.PCBranched, cpu.PCPlus4_F, cpu.PCBranchAddr_D, cpu.PCSrc_D);
            $fdisplay(Signal_FHANDLER, "IF-Jump_CTRL :\tJSEL      :%-32d\tOpcode_F       :%-32b\tFunc_F      :%-10b", cpu.JSEL, cpu.Opcode_F, cpu.Func_F);
            $fdisplay(Signal_FHANDLER, "IF-Jump_SEL  :\tPCJumped  :%-32d\tPCBranched     :%-32d\tPCJumpAddr  :%-10d\tJSEL          :%-10d", cpu.PCJumped, cpu.PCBranched, cpu.PCJumpAddr, cpu.JSEL);
            $fdisplay(Signal_FHANDLER, "IF-PC_REG    :\tPC_out    :%-32d\tPC_in          :%-32d", cpu.PC_F, cpu.PCJumped);
            $fdisplay(Signal_FHANDLER, "IF-Inst_RAM  :\tIndex     :%-32d\tFetched Inst   :%-32b\n", cpu.PC_F >> 2, cpu.Inst_F);
            // $fdisplay(Signal_FHANDLER, "ID-Decoded   :\tRegAddr1_D:%-32d\tRegAddr2_D     :%-32d\tRt_D        :%-10d\tRd_D          :%-10d\tShamt_D :%-5d\tImm_D    :%-32d\tOpcode_D   :%-32b\tFunc_D   :%-5b", cpu.RegAddr1_D, cpu.RegAddr2_D, cpu.Rt_D, cpu.Rd_D, cpu.Shamt_D, cpu.Imm_D, cpu.Opcode_D, cpu.Func_D);
            $fdisplay(Signal_FHANDLER, "ID-Reg_File  :\tRegAddr1_D:%-32d\tRegAddr2_D     :%-32d\tRegAddr3_W  :%-10d\tRegWrite      :%-10d\tWrtEN     :%-10d\tRegRead1 :%-10d\tRegRead2   :%-10d", cpu.RegAddr1_D, cpu.RegAddr2_D, cpu.RegAddr3_W, cpu.RegWriteData_W, cpu.RegWriteData_W, cpu.RegReadData1_D, cpu.RegReadData2_D);
            $fdisplay(Signal_FHANDLER, "ID-Branch    :\tBranch?   :%-32b\tBranchAddr     :%-32b", cpu.PCSrc_D,cpu.PCBranchAddr_D);
            $fdisplay(Signal_FHANDLER, "ID-Main_CTRL :\tOpcode_D  :%-32b\tFunc_D         :%-32b\tRegWrtEN_D  :%-10d\tMem2RegSEL_D  :%-10d\tMemWrtEN  :%-10d\tBeq_D    :%-10d\tBne_D      :%-10d\tALUCtrl_D:%-5d\tALUSrc_D:%-5d\tRegDstSEL_D:%-5d\n", cpu.Opcode_D, cpu.Func_D, cpu.RegWriteEN_D, cpu.Mem2RegSEL_D, cpu.MemWriteEN_D, cpu.Beq_D, cpu.Bne_D, cpu.ALUCtrl_D, cpu.ALUSrc_D, cpu.RegDstSEL_D);
            $fdisplay(Signal_FHANDLER, "EX-RegDstSEL :\tRegAddr3_E:%-32d\tRtAddr_E       :%-32d\tRdAddr_E    :%-10d\tRegDstSEL_E   :%-10d", cpu.RegAddr3_E, cpu.Rt_E, cpu.Rd_E, cpu.RegDstSEL_E);
            $fdisplay(Signal_FHANDLER, "EX-ALUSrc    :\tOp1       :%-32d\tOp2            :%-32d\tALUSrc_E    :%-10b\tRegRead1_E    :%-10d\tRegRead2_E:%-10d\tShamt_E  :%-10d\tImm_E      :%-10d", cpu.Op1, cpu.Op2, cpu.ALUSrc_E, cpu.RegReadData1_E, cpu.RegReadData2_E, cpu.Shamt_E, $signed(cpu.Imm_E));
            $fdisplay(Signal_FHANDLER, "EX-ALU       :\tALUOut_E  :%-32d\tFlag_E         :%-32d\tALUCtrl_E   :%-10d\tOp1           :%-10d\tOp2       :%-10d\n", $signed(cpu.ALUOut_E),  cpu.ZeroFlag_E, cpu.ALUCtrl_E, $signed(cpu.Op1), $signed(cpu.Op2));
            $fdisplay(Signal_FHANDLER, "MEM-Main Mem :\tMemWrtEN_M:%-32d\tIndex          :%-32d\tMemWrtData_M:%-10d\tMemReadData_M :%-10d\n",cpu.MemWriteEN_M, (cpu.ALUOut_M)>>2,  cpu.MemWriteData_M,  cpu.MemReadData_M);
            $fdisplay(Signal_FHANDLER, "WB-DataSEL   :\tRegWrtDt_W:%-32d\tALUOut_W       :%-32d\tMemRedData_W:%-10d\tMem2RegSEL_W  :%-10d", $signed(cpu.RegWriteData_W), cpu.ALUOut_W, cpu.MemReadData_W, cpu.Mem2RegSEL_W);
            $fdisplay(Signal_FHANDLER, "WB-DataAddr  :\tRegAddr3_W:%-32d", cpu.RegAddr3_W);
            $fdisplay(Signal_FHANDLER, "___________________________________________________________________________________________________");
            // $fdisplay(Signal_FHANDLER, "IF-PC_REG    :\tPCJumped  :%-32b\tPC_F           :%-32b", cpu.PCJumped, cpu.PC_F);
            // $fdisplay(Signal_FHANDLER, "IF-ID_REG    :\tInst_F    :%-32b\tPCPlus4_F      :%-32b\tInst_D      :%-10d\tPCPlus4_D     :%32b", cpu.Inst_F,cpu. PCPlus4_F, cpu.Inst_D, cpu.PCPlus4_D);
            // $fdisplay(Signal_FHANDLER, "ID-EX_REG    :\tRegWrtEN_D:%-32b\tMem2RegSEL_D   :%-32b\tMemWriteEN_D:%-10d\tBeq_D         :%32b\tBne_D    :%-5d\nALUCtrl_D:%-32d\tALUSrc_D   :%-32d\tRegDstSEL_D, RegReadData1_D, RegReadData2_D, Rt_D, Rd_D, Shamt_D, Imm_D, PCPlus4_D,
            //             RegWriteEN_E, Mem2RegSEL_E, MemWriteEN_E, Beq_E, Bne_E, ALUCtrl_E, ALUSrc_E, RegDstSEL_E, RegReadData1_E, RegReadData2_E, Rt_E, Rd_E, Shamt_E, Imm_E, PCPlus4_E");
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
        $monitor("[CC %4d] Branch signal:%-2b", ClockCycleCount, cpu.PCSrc_D);
        // $display("|  CC  |R1A | R2A |       Read 1      |       Read 2      |");
        // $monitor("| %4d | %-2d |  %-2d |  %-10d       |  %-10d       |",  ClockCycleCount,  cpu.register_file.RegRead1, cpu.register_file.RegRead2, cpu.register_file.ReadOut1, cpu.register_file.ReadOut2);
        // $display("| time |  CC  | CLK | RST | EN  | R1A | R2A | WTA |       Read 1      |       Read 2      |       Write       |");
        // $monitor("| %4t | %4d |  %1b  |  %1b  |  %1b  |  %-2d |  %-2d |  %-2d |  %-10d       |  %-10d       |  %-10d       |", $time, ClockCycleCount, cpu.register_file.CLOCK, cpu.register_file.RESET, cpu.register_file.WriteEnable, cpu.register_file.RegRead1, cpu.register_file.RegRead2, cpu.register_file.RegWrite, cpu.register_file.ReadOut1, cpu.register_file.ReadOut2, cpu.register_file.DataWrite);
        // $display("|  CC  | EN  |    Addr    |              Dt_In             |              Dt_                 |");
        // $monitor("| %4d |  %1b  | %10d |%32b|%32b|",  ClockCycleCount, cpu.mainmemory.WRITE_EN, cpu.mainmemory.FETCH_ADDRESS, cpu.mainmemory.WRITE_DATA, cpu.mainmemory.DATA);
        // $monitor("| %4d | %5d|%32b|%32b|", ClockCycleCount, cpu.mainmemory.FETCH_ADDRESS, cpu.mainmemory.DATA_RAM[13], cpu.mainmemory.DATA);
        // $monitor("| %4d | Addr:%-10d | Data:%-10d | 28:%-10d", ClockCycleCount, cpu.mainmemory.FETCH_ADDRESS, cpu.mainmemory.WRITE_DATA, cpu.register_file.RegFile[28]);
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