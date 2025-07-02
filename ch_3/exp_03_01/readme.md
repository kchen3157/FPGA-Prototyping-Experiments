# 3.12.1 Multi-function barrel shifter

## Prompt
Consider an 8-bit shifting circuit that can perform a rotating-right or a rotating-left operation. An additional 1-bit control signal, lr, specifies the desired direction.

1. Design the circuit using one rotate-right circuit, one rotate-left circuit, and one 2-to-1 multiplexer to select the desired result. Derive the code. 
2. Derive a testbench and use simulation to verify operation of the code. 
3. Synthesize the circuit, program the FPGA, and verify its operation. 
4. This circuit can also be implemented by one rotate-right shifter with pre-and post-reversing circuits. The reversing circuit either passes the original input or reverses the input bitwise (e.g., if an 8-bit input is a7a6a5a4a3a2a1a0, the reversed result becomes a0a1a2a3a5a5a6a7). Repeat steps 2 and 3. 
5. Check the report files and compare the number of logic cells and propagation delays of the two designs. 
   - barrel_shifter_multi_rev (impl)
     - Usage: 24 LUTs
     - Max Setup Delay: 15.247 ns
     - Max Hold Delay: 4.774 ns
   - barrel_shifter_multi (impl)
     - Usage: 24 LUTs
     - Max Setup Delay: 15.247 ns
     - Max Hold Delay: 4.774 ns
6. Expand the code for a 16-bit circuit and synthesize the code. Repeat steps 1 to 5.
   - barrel_shifter_rev_16
     - 48 LUTs
   - barrel_shifter_16
     - Usage: 56 LUTs
     - Max Setup Delay: 10.391 ns
     - Max Hold Delay: 2.512 ns
7. Expand the code for a 32-bit circuit and synthesize the code. Repeat steps 1 to 5.
   - barrel_shifter_rev_32
     - 96 LUTs
   - barrel_shifter_32
     - Usage: 160 LUTs
     - Max Setup Delay: 14.814 ns
     - Max Hold Delay: 2.587 ns