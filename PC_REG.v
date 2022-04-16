module PC_REG(CLOCK, RESET, pc_in, pc_out);
input CLOCK, RESET;
input [31:0] pc_in;
output reg [31:0] pc_out;

always @ (posedge CLOCK) begin
    if (RESET != 1'b0) pc_out <= pc_in;
end
endmodule