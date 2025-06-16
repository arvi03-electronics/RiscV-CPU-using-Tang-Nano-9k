module reg_file (
    input             clk,
    input             we,
    input  [4:0]      rs1, rs2, rd,
    input  [31:0]     wd,
    output [31:0]     rd1, rd2
);
    reg [31:0] regs [0:31];

    always @(posedge clk) begin
        if (we && rd != 5'd0)
            regs[rd] <= wd;
    end

    assign rd1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];
endmodule
