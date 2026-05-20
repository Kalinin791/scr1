module scr1_tb_log_cmd(
    input logic clk,
    input logic [1:0] imem_resp,
    input logic [31:0] imem_rdata
);

wire [31:0] rs1_data;
wire [31:0] rs2_data;

assign rs1_data = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.mprf2exu_rs1_data;
assign rs2_data = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.mprf2exu_rs2_data;

always_ff @(posedge clk) begin
    if ((imem_rdata[6:0] == 7'b0110011) &&
        (imem_rdata[14:12] == 3'b100) &&
        (imem_rdata[31:25] == 7'b0000000)) begin
        $display("DETECTED: xor instruction");
        $display("  rs1_data = 0x%0h", rs1_data);
        $display("  rs2_data = 0x%0h", rs2_data);
        $display("  result   = 0x%0h", rs1_data ^ rs2_data);
    end
end

endmodule
