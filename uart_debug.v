module uart_debug (
    input        clk,
    input        send_enable,
    input [31:0] data,
    output       tx
);
    // UART config: 115200 baud @ 50MHz => clk_div = 434
    localparam CLK_DIV = 434;
    reg [8:0] bit_cnt;
    reg [9:0] tx_data;
    reg [15:0] clk_cnt = 0;
    reg sending = 0;
    reg tx_reg = 1;

    always @(posedge clk) begin
        if (!sending && send_enable) begin
            tx_data <= {1'b1, data[7:0], 1'b0};  // Start, 8-bit, Stop
            sending <= 1;
            bit_cnt <= 0;
            clk_cnt <= 0;
        end else if (sending) begin
            clk_cnt <= clk_cnt + 1;
            if (clk_cnt >= CLK_DIV) begin
                clk_cnt <= 0;
                tx_reg <= tx_data[bit_cnt];
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 9)
                    sending <= 0;
            end
        end
    end

    assign tx = tx_reg;
endmodule
