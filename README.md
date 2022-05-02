# CSC 3050 Assignment 4 Report

Tianhao SHI, May 1^st^ 2022

****

## Running Environment



### Prerequisites

​	iverilog and vvp

### Execution

​	This project is written in **Verilog** and tested on **Linux** environment. The file structure should be

```
+--Report.pdf
+--cpu_test							#where the original testcases are stored
|	+--DATA_RAM1.txt
|	+--...
|	+--DATA_RAM8.txt
|	+--machine_code1.txt
|	+--...
|	+--machine_code8.txt
|	+--mips1.asm
|	+--...
|	+--mips8.asm
+--instructions.bin					#where the machine code for execution is stored
+--CPU.v							#top-level module of CPU
+--test_CPU.v						#testbench for CPU
+--LogRAM.txt						#log file to record the RAM data AFTER execution
+--LogRegister.txt					#log register file data FOR THE WHOLE PROCESS
+--LogSignal.txt					#log all signals FOR THE WHOLE PROCESS
+--compled							#compiled testbench
+--...								#other components of CPU
```

​	The Makefile contains a `autorun` feature, which will compile, execute and show the total clock cycle used, simulation result and its difference with correct answer.

```
$cd 120090472
$make autorun
```

​	You can also test your own testcase using the `run` feature

```
$make run BIN=path/to/machine/code RAM=path/to/correct/RAM/state
```

​	Or if you just want to compile

```
$cd 120090472
$make load BIN=path/to/machine/code/file	#optional, you can also paste directly to the .bin file
$make compiled								#this will generate 3 log files mentioned above
```

## Bigger picture

​	The core idea of pipeline is to make full use of every component of the CPU.  Different components belong to one of five stages and each instruction is passed from one stage to the next. During one clock cycle, each stage receive data from previous stage (stored in the stage register in between), manipulate data (combinational circuit), and place the result in the stage register for the next stage to access.

### IF: Instruction fetch

- Acquire the 32-bit instruction to execute. 
  - The instruction is stored in the instruction memory.
  - The instruction can be fetched:
    -  sequentially (PC+4),
    - branched to (PC+offset)
    - jumped to based on instruction (PC[31:28] + Instruction[26:0]<<2) 
    - jumped based on register data (JR instruction)
- Increment PC by 4

### ID: Instruction decode

- Acquire the **Opcode** and **Func**, which determines all the control signals for main control, jump control signals
- Read 2x32-bit data from register file
- Calculate the branch address and jump address
- Acquire data fields (immediate number, shift amount, address of RS, RT, RD)

### EX: Execution

- Determine the destination register address

- Determine operands for execution, which can be either

  - Two registers' data (Most R-type)
  - Register + zero-extended immediate number (andi, xori, ori)
  - Register + sign-extended immediate number (Most I-type)
  - Register + zero-extended lower 5 bits of another register (sllv, srlv, srav)
  - Register + zero-extended shift amount (sll, srl, sra)

- Determine operation and execute the operation. All instructions that requires execution uses one of the following operation:

  - arithmetic: add	substitute	

  - logic: and	or	xor	nor	

  - compare: set on less than	

  - shift: shift left logic	shift right logic	shift right arithmetic

### MEM: Memory access

- Access the main memory
  - Read data at give address(calculated from ALU)
  - Write data if necessary

### WB: Write back

- Determine the write back data, which can be either:
  - ALU result (Most instructions)
  - MEM read (SW)
  - PC (JAL) 

## Data Flow Chart

<img src="flowchart.svg" alt="a4" style="zoom:200%;" />

## Implementation Details

### Stopping Simulation

​	According to the pipeline, the last valid instruction will write back when the *32'hffff_ffff* instruction is at MEM stage. During the execution of *32'hffff_ffff*, I manually set the ALU output to be 32'hx. Therefore, if ALU output at MEM stage is **x** (set) and ALU output at EX stage is also **x** (because no instruction), the simulation is completed.

​	If, unfortunately, my program enters a dead-loop (unlikely), it will exit upon clock cycle 1000. This is an arbitrary number and can be modified by changing the parameter *FORCE_STOP* at `test_CPU.v`

### Dealing with hazards:

#### Forwarding

​	Forwarding is used to deal with **data hazard**, where succeeding instructions try to read from a register whose value haven't been updated yet.

​	The latest value can be acquired from either EX stage or MEM stage.

​	Forwarding is not only used for arithmetic operations, but also branch operations.

##### Forwarding logic

​	For branch forwarding (Fwd1_D, Fwd2_D):

​		If (instruction@EX will update register *and* the register being updated is not zero)

​			If(register updated @EX==register RS@ID)

​				-> forward the ==result from ALU to Fwd1_D==

​			If(register updated @EX==register RT@ID)

​				-> forward the ==result from ALU to Fwd2_D==

​	If(instruction@MEM will update register *and* the register being updated is not zero)

​		If(register updated @MEM==register RS@ID)

​				-> forward the ==data read from RAM to Fwd1_D==

​		If(register updated @MEM==register RT@ID)

​				-> forward the ==data read from RAM to Fwd2_D==

Otherwise, use data read from register file.

****

For data forwarding:

​	If(instruction@MEM will update register *and* register being updated is not zero)

​		If(register updated @MEM==register RS@EX)

​				->forward the ==data read from ALU to Fwd1_E==

​		If(register updated @MEM==register RT@EX)

​				->forward the ==data read from ALU to Fwd2_E==

If(instruction@WB will update register *and* register being updated is not zero)

​	If(Register updated @WB==register RS@EX)

​				->forward the ==write back data to Fwd1_E==

​	If(Register updated @WV==register RT@EX)

​								->forward the ==write back data to Fwd2_E==

### Stalling

​	Forwarding cannot solve data hazard if subsequent instruction tries to read an register updated by RAM data. To deal with this hazard, the pipeline need to be stalled for one cycle. That is, PC register and IF/ID register is not updated in the stalling cycle and the control signals for ID/EX signal is flushed. After stalling for one cycle, the hazard can be soled using forwarding technique mentioned above.

##### Stalling logic

If(Instruction@EX tries to read data from RAM *and* the destination register is either RS@ID or RT@ID) 

​	*or*(Instruction@ID requires branching *and* instruction@MEM tries to read data from RAM *and* the destination register is either RS@ID or RT@ID)

Then stall

### Branching

​	The branching can be determined at ID stage. The logic is

​	If (instruction@ID is BEQ and two address forwarded is same) *or* (Instruction@ID is BNE and two address forwarded is different)

Then branch

### Read/Write Register file at the same time

​	By adding a delay, I let the register file write data back first, before reading from it.

## Other techniques

​	Uncomment the DisplayCriticalInfo at line 123 and line 22~37 of `test_CPU.v` to view some critical information during execution.

​	Uncomment the LogRAM at 126 of `test_CPU.v` to view the RAM state during whole execution process

​		For better readability, uncomment line 88, 90, 91 of `test_CPU.v`



