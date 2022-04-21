module Register_File (CLOCK,       //clock signal
                     RESET,       //reset signal
                     RegRead1,    //address of register to be read, 1
                     RegRead2,    //address of register to be read, 2
                     RegWrite,    //address of register to be written
                     DataWrite,   //data to be written in the register file
                     WriteEnable, //write enable
                     ReadOut1,    //data output from register 1
                     ReadOut2);   //data output from register 2
    input[4:0] RegRead1, RegRead2, RegWrite;
    input[31:0] DataWrite;
    input WriteEnable, CLOCK, RESET;
    output reg [31:0]  ReadOut1, ReadOut2;
    
    reg [31:0] RegFile[31:0];     //the register file
    
    task reset;
        begin
            RegFile[0]  <= 32'b0;
            RegFile[1]  <= 32'b0;
            RegFile[2]  <= 32'b0;
            RegFile[3]  <= 32'b0;
            RegFile[4]  <= 32'b0;
            RegFile[5]  <= 32'b0;
            RegFile[6]  <= 32'b0;
            RegFile[7]  <= 32'b0;
            RegFile[8]  <= 32'b0;
            RegFile[9]  <= 32'b0;
            RegFile[10] <= 32'b0;
            RegFile[11] <= 32'b0;
            RegFile[12] <= 32'b0;
            RegFile[13] <= 32'b0;
            RegFile[14] <= 32'b0;
            RegFile[15] <= 32'b0;
            RegFile[16] <= 32'b0;
            RegFile[17] <= 32'b0;
            RegFile[18] <= 32'b0;
            RegFile[19] <= 32'b0;
            RegFile[20] <= 32'b0;
            RegFile[21] <= 32'b0;
            RegFile[22] <= 32'b0;
            RegFile[23] <= 32'b0;
            RegFile[24] <= 32'b0;
            RegFile[25] <= 32'b0;
            RegFile[26] <= 32'b0;
            RegFile[27] <= 32'b0;
            RegFile[28] <= 32'b0;
            RegFile[29] <= 32'b0;
            RegFile[30] <= 32'b0;
            RegFile[31] <= 32'b0;
        end
    endtask
    
    initial reset;
    
    always @(posedge RESET) reset;
    
    always @(posedge CLOCK) begin
        if (WriteEnable == 1) begin
            RegFile[RegWrite] <= DataWrite;
        end
        #2
        ReadOut1 <= RegFile[RegRead1];
        ReadOut2 <= RegFile[RegRead2];
    end
endmodule
