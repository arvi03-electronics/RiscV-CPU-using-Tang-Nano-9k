# RiscV-CPU-using-Tang-Nano-9k
This project implements a minimal RISC-V RV32I CPU core on the Tang Nano 9K FPGA using Verilog and Gowin IDE. It features basic instruction execution (ALU operations, load/store), and outputs register values (especially x10/a0) via UART, viewable in serial terminals like PuTTY.

-----------------------------------------------------------------------------------------------------------------------------------------------
1) Download the files provided here as a zip file.
2) create a folder named rtl and add the following files to it:
     a) alu.v
     b) top.v
     c) control.v
     d) cpu.v
     e) imm_gen.v
     f) reg_file.v
     g) uart_debug.v
     h) instr_mem.v
3) In a separate folder add the program.hex file.
