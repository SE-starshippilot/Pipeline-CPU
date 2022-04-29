module PC_REG(CLOCK, RESET, STALL, PC_In, PC_Out);
input CLOCK, RESET, STALL;
input [31:0] PC_In;
output reg [31:0] PC_Out;

task reset;
    begin
        PC_Out <= 32'b0;
    end
endtask

initial reset;

// always @ (posedge RESET) reset;

always @ (posedge CLOCK) begin
    #2
    if (STALL !== 1 ) begin
        #3 PC_Out <= PC_In;
    end
end
endmodule