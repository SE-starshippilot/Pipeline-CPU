module PC_REG(CLOCK, RESET, raw_addr, InstRAM_addr);
input CLOCK, RESET;
input [31:0] raw_addr;
output reg [31:0] InstRAM_addr;

task reset;
    begin
        InstRAM_addr <= 32'b0;
    end
endtask

initial reset;

always @ (posedge RESET) reset;

always @ (posedge CLOCK) begin
    InstRAM_addr <= raw_addr;
end
endmodule