# 3.12.3 Dual-priority encoder

## Prompt

A dual-priority encoder returns the codes of the highest or second-highest priority requests. The input is a 12-bit req signal and the outputs are first and second, which are the 4-bit binary codes of the highest and second-highest priority requests, respectively.

1. Design the circuit and derive the code. 
2. Derive a testbench and use simulation to verify operation of the code. 
3. Design a testing circuit that displays the two output codes on the seven-segment LED display of the prototyping board, and derive the code. 
4. Synthesize the circuit, program the FPGA, and verify its operation.

## Top

On the board, the module acts as a 8:3 dual-priority encoder, due to limitations in user I/O. the 8 switches are sent to the 8 LSB req signal, with the remaining 4 bits staying zero. 

The board leds display from right to left:
- 3 LSB y1 (highest priority request)
- 3 LSB y2 (second-highest priority request)
- v1 (set if there is at least one request)
- v2 (set if there are at least two requests)