module scr1_tb_log_cmd(
    input logic clk,
    input logic [1:0] imem_resp,
    input logic [31:0] imem_rdata
);

logic detected_xor, detected_xor_d1, detected_xor_d2;
logic [31:0] saved_rs1, saved_rs2;

wire [31:0] rs1_data;
wire [31:0] rs2_data;

assign rs1_data = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_mprf.mprf2exu_rs1_data_o;
assign rs2_data = scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_mprf.mprf2exu_rs2_data_o;

// Такт 1: детекция
always_ff @(posedge clk) begin
    detected_xor <= (imem_rdata[6:0] == 7'b0110011) &&
                    (imem_rdata[14:12] == 3'b100) &&
                    (imem_rdata[31:25] == 7'b0000000);
end

// Такт 2: задержка
always_ff @(posedge clk) begin
    detected_xor_d1 <= detected_xor;
end

// Такт 2: запоминаем данные (rs2 уже валиден!)
always_ff @(posedge clk) begin
    if (detected_xor_d1) begin
        saved_rs1 <= rs1_data;
        saved_rs2 <= rs2_data;
        detected_xor_d2 <= 1;
    end else begin
        detected_xor_d2 <= 0;
    end
end

// Такт 3: вывод
always_ff @(posedge clk) begin
    if (detected_xor_d2) begin
        $display("DETECTED: xor instruction");
        $display("  rs1_data = 0x%0h", saved_rs1);
        $display("  rs2_data = 0x%0h", saved_rs2);
        $display("  result   = 0x%0h", saved_rs1 ^ saved_rs2);
    end
end

endmodule
