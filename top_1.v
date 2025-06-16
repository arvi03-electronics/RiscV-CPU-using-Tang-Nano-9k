module top (
    input clk,
    input rst,
    output uart_tx
);

    cpu cpu_core (
        .clk(clk),
        .rst(rst),
        .uart_tx(uart_tx)
    );

endmodule
