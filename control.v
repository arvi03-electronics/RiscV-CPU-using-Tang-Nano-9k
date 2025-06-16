module control (
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] alu_op,
    output reg       alu_src,
    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       mem_to_reg,
    output reg       branch,
    output reg       jump
);
    always @(*) begin
        // Default values
        alu_op      = 4'b0000;
        alu_src     = 0;
        reg_write   = 0;
        mem_read    = 0;
        mem_write   = 0;
        mem_to_reg  = 0;
        branch      = 0;
        jump        = 0;

        case (opcode)
            7'b0110011: begin // R-type
                alu_src    = 0;
                reg_write  = 1;
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_op = 4'b0000; // ADD
                    {7'b0100000, 3'b000}: alu_op = 4'b0001; // SUB
                    {7'b0000000, 3'b111}: alu_op = 4'b0010; // AND
                    {7'b0000000, 3'b110}: alu_op = 4'b0011; // OR
                    {7'b0000000, 3'b100}: alu_op = 4'b0100; // XOR
                    {7'b0000000, 3'b010}: alu_op = 4'b0101; // SLT
                    {7'b0000000, 3'b001}: alu_op = 4'b0110; // SLL
                    {7'b0000000, 3'b101}: alu_op = 4'b0111; // SRL
                    {7'b0100000, 3'b101}: alu_op = 4'b1000; // SRA
                endcase
            end
            7'b0010011: begin // I-type ALU (e.g., addi)
                alu_src    = 1;
                reg_write  = 1;
                case (funct3)
                    3'b000: alu_op = 4'b0000; // ADDI
                    3'b111: alu_op = 4'b0010; // ANDI
                    3'b110: alu_op = 4'b0011; // ORI
                endcase
            end
            7'b0000011: begin // lw
                alu_src    = 1;
                reg_write  = 1;
                mem_read   = 1;
                mem_to_reg = 1;
                alu_op     = 4'b0000; // ADD
            end
            7'b0100011: begin // sw
                alu_src    = 1;
                mem_write  = 1;
                alu_op     = 4'b0000; // ADD
            end
            7'b1100011: begin // beq
                branch     = 1;
                alu_op     = 4'b0001; // SUB (for beq comparison)
            end
            7'b1101111: begin // jal
                jump       = 1;
                reg_write  = 1;
            end
            7'b1100111: begin // jalr
                jump       = 1;
                reg_write  = 1;
                alu_src    = 1;
            end
        endcase
    end
endmodule
