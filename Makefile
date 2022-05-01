BIN_NAME=cpu_test/machine_code
RAM_NAME=cpu_test/DATA_RAM
autorun:
	@for var in 1 2 3 4 5 6 7 8;do\
		echo "Executing Testcase $$var";\
		BIN=$(addsuffix $$var.txt, $(BIN_NAME));\
		RAM=$(addsuffix $$var.txt, $(RAM_NAME));\
		make BIN=$$BIN RAM=$$RAM run --no-print-directory;\
		echo "*******************************";\
	done


run:compiled 
	@make load;
	@make compiled -s;
	@vvp compiled;
	@echo "Showing RAM after execution:";
	@echo "********************************";
	@cat LogRAM.txt;
	@echo "********************************";
	@echo "Showing difference with correct:";
	@diff LogRAM.txt $(RAM);

compiled: test_CPU.v ALU_SRC.v ALU.v CPU.v EX_MEM_REG.v Forward_Unit.v Hazard_Detect.v ID_EX_REG.v IF_ID_REG.v InstructionRAM.v Jump_CTRL.v Main_CTRL.v MEM_WB_REG.v Mux.v PC_REG.v Register_File.v
	@iverilog -o compiled test_CPU.v -Wselect-range;

load:
	@cp $(BIN) "instructions.bin"

clean:
	@rm *.out

