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
            $display("PC            |%-10d", cpu.raw_PC>>2);
            $display("Instruction_F |%-32b", cpu.Inst_F);
            $display("- - - - - - - - - - - - - - - - - - - - - - - - - - ");
            $display("Opcode        |%-6b", cpu.Inst_D[31:26]);
            $display("func          |%-6b", cpu.Inst_D[5:0]);
            $display("- - - - - - - - - - - - - - - - - - - - - - - - - - ");
            $display("Writeback reg |%-2d", cpu.RegAddr3_E);
            $display("Operands      |%-10d, %-10d", cpu.Op1, cpu.Op2);
            $display("Operation     |%-2d", cpu.ALUCtrl_E);
            $display("ALU output    |%-10d, flag=%1b", cpu.ALUOut_E, cpu.ZeroFlag_E);
            $display("- - - - - - - - - - - - - - - - - - - - - - - - - - ");
            $display("MEM output    |%-32b", cpu.MemReadData_M);
            $display("- - - - - - - - - - - - - - - - - - - - - - - - - - ");
            $display("WB data       |%-32d", cpu.RegWriteData_W);
            $display("WB addr       |%-2d", cpu.RegAddr3_W);
            $display("*****************************************************");
        end
    endtask
    task LogRegister;
        begin
            $fdisplay(Register_FHANDLER, "[CC %3d]", ClockCycleCount);
            for(reg_idx = 0; reg_idx < 32; reg_idx = reg_idx + 1) $fdisplay(Register_FHANDLER, "|Reg %-2d |%-10d", reg_idx, cpu.register_file.RegFile[reg_idx]);
            $fdisplay(Register_FHANDLER, "__________________");
        end
    endtask
    task LogSignal;
        begin
            $fdisplay(Signal_FHANDLER, "[CC %3d]\n", ClockCycleCount);
            $fdisplay(Signal_FHANDLER, "IF :\tCurrent PC:%-10d\tInstruction_F:%-32b", cpu.raw_PC>>2, cpu.Inst_F);
            $fdisplay(Signal_FHANDLER, "ID :\tPC+4_D    :%-10d\tInstruction_D:%-32b\tReg1 addr   :%-10d\tReg2 addr     :%-2d\tReg3 addr:%-2d\tRS_D addr :%-2d\tRT_D addr     :%-10d\tImm:%-10d\t", cpu.PCPlus4_D, cpu.Inst_D, cpu.Inst_D[25:21], cpu.Inst_D[20:16], cpu.RegAddr3_W, cpu.Inst_D[20:16], cpu.Inst_D[15:11], cpu.Inst_D[15:0]);
            $fdisplay(Signal_FHANDLER, "    \tRegWrite_D:%-10d\tMem2Reg_D    :%-32d\tMemWrite_D  :%-10d\tBEQ_D         :%-2d\tShamt     :%-2d\tImm_D    :%-5d\tBranchAddr_D  :%-10d", cpu.RegReadData1_D, cpu.RegReadData2_D,  cpu.Inst_D[20:16], cpu.Inst_D[20:16], cpu.Inst_D[20:16], cpu.Inst_D[15:0], cpu.PCPlus4_D>>2);
            $fdisplay(Signal_FHANDLER, "EX :\tRegWrite_E:%-10b\tMem2RegSEL_E :%-32b\tMemWriteEN_E:%-10b\tBeq_E         :%-2b\tBne_E     :%-2b",cpu.RegWriteEN_E, cpu.Mem2RegSEL_E, cpu.MemWriteEN_E, cpu.Beq_E, cpu.Bne_E);
            $fdisplay(Signal_FHANDLER, "    \tZeroFlag_E:%-10b\tBranchAddr_E :%-32d\tALUOut_E    :%-10d\tWriteMemData_E:%-2d\tRegAddr3_E:%-2d\tImm_E    :%-5d\tRegReadData2_E:%-10d", cpu.ZeroFlag_E, cpu.BranchAddr_E>>2, cpu.ALUOut_E, cpu.RegReadData2_E, cpu.RegAddr3_E, cpu.Imm_E, cpu.RegReadData2_E);
            $fdisplay(Signal_FHANDLER, "MEM:\tMemWrite_M:%-10b\tMem2RegSEL_M :%-32b", cpu.MemWriteEN_M, cpu.Mem2RegSEL_M);
            $fdisplay(Signal_FHANDLER, "    \tALU  Out_M:%-10d\tMemWtData_M  :%-32b\tMemRdData_M :%-10b\tRegAddr3_M    :%-10d", cpu.ALUOut_M, cpu.MemWriteData_M,cpu.MemReadData_M, cpu.RegAddr3_M);
            $fdisplay(Signal_FHANDLER, "WB :\tRegWrite_W:%-10d\tMemReadData_W:%-32b\tALUOut_W    :%-10d\tRegWBSEL      :%-2d\tRegWBAddr:%-5d\tRegWBData   :%-10d", cpu.RegWriteEN_W,  cpu.MemReadData_W, cpu.ALUOut_W, cpu.Mem2RegSEL_W, cpu.RegAddr3_W, cpu.RegWriteData_W);
            $fdisplay(Signal_FHANDLER, "___________________________________________________________________________________________________");
        end
    endtask
    task LogRAM;
        begin
            $fdisplay(RAM_FHANDLER, "[CC %3d]", ClockCycleCount);
            for(ram_idx = 0; ram_idx < 512; ram_idx = ram_idx + 1) $fdisplay(RAM_FHANDLER, "RAM %-3d |%-32b", ram_idx, cpu.mainmemory.DATA_RAM[ram_idx]);
            $fdisplay(RAM_FHANDLER, "__________________");
        end
    endtask

    initial begin
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
            if (^(cpu.BranchAddr_M) !== 1'bx && ^(cpu.BranchAddr_E) === 1'bx) begin
                DisplayCriticalInfo;
                LogSignal;
                LogRegister;
                LogRAM;
                $finish;
            end
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