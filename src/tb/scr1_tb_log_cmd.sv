module scr1_tb_log_cmd(
    input logic clk,
    input logic [1:0] imem_resp,
    input logic [31:0] imem_rdata
);

always_ff @(posedge clk) begin
    if ((imem_rdata[6:0] == 7'b0110011) &&
        (imem_rdata[14:12] == 3'b100) &&
        (imem_rdata[31:25] == 7'b0000000)) begin
        $display("DETECTED: xor instruction at time %0t", $time);
    end
end

endmodule
