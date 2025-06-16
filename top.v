module top (
    input clk_27m,     // 27 MHz clock input from board
    input rst_n,       // active-low reset button
    output uart_tx     // UART TX output to USB-to-Serial
);

    wire clk;
    wire rst;

    // --- Clock Divider (Optional) ---
    // If you want to slow down the 27 MHz clock, insert a divider here.
    // Otherwise just assign directly:
    assign clk = clk_27m;

    // --- Reset ---
    assign rst = ~rst_n;  // convert active-low to active-high

    // --- Instantiate CPU ---
    cpu u_cpu (
        .clk(clk),
        .rst(rst),
        .uart_tx(uart_tx)
    );

endmodule
