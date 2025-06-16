module cpu (
    input clk,
    input rst,
    output wire uart_tx  // <-- expose for top.v
);

    wire [31:0] instr;
    wire [6:0]  opcode;
    wire [4:0]  rd, rs1, rs2;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [31:0] imm;
    wire [31:0] pc, pc_next;
    wire [31:0] rd1, rd2;
    wire [31:0] alu_result;
    wire [3:0]  alu_op;
    wire [31:0] alu_b;
    wire        mem_to_reg, mem_read, mem_write, alu_src, reg_write;

    // ---- Program Counter ----
    reg [31:0] pc_reg;
    assign pc = pc_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_reg <= 0;
        else
            pc_reg <= pc_next;
    end

    assign pc_next = pc + 4;

    // ---- Instruction Memory ----
    instr_mem imem (
        .addr(pc),
        .instr(instr)
    );

    // ---- Instruction Decode ----
    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    imm_gen immgen (
        .instr(instr),
        .imm(imm)
    );

    // ---- Register File ----
    reg_file rf (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wb_data),           // <-- changed from alu_result
        .reg_write(reg_write),
        .rd1(rd1),
        .rd2(rd2)
    );

    // ---- Control ----
    control ctrl (
        .opcode(opcode),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_op(alu_op)
    );

    // ---- ALU Input Mux ----
    assign alu_b = alu_src ? imm : rd2;

    // ---- ALU ----
    alu alu1 (
        .a(rd1),
        .b(alu_b),
        .alu_op(alu_op),
        .result(alu_result)
    );

    // ---- Data Memory ----
    wire [31:0] mem_out;

    data_mem dmem (
        .clk(clk),
        .addr(alu_result),
        .write_data(rd2),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(mem_out)
    );

    // ---- Write-Back Mux ----
    wire [31:0] wb_data = mem_to_reg ? mem_out : alu_result;

    // ---- UART Debug (only prints when x10 is written) ----
    wire uart_trigger = reg_write && (rd == 5'd10); // x10 (a0)

    uart_debug uart_dbg (
        .clk(clk),
        .send_enable(uart_trigger),
        .data(wb_data),
        .tx(uart_tx)
    );

endmodule
