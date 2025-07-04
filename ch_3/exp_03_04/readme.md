# 2.12.4 BCD incrementor

The binary-coded-decimal (BCD) format uses 4 bits to represent 10 decimal digits. For example, 259<sub>10</sub> is represented as ”0010 0101 1001” in BCD format. A BCD incrementor adds 1 to a number in BCD format. For example, after incrementing, ”0010 0101 1001” (i.e., 259<sub>10</sub>) becomes ”0010 0110 0000” (i.e., 260<sub>10</sub>).
1. Design a three-digit 12-bit incrementor and derive the code. 
2. Derive a testbench and use simulation to verify operation of the code. 
3. Design a testing circuit that displays three digits on the seven-segment LED display and derive the code. 
4. Synthesize the circuit, program the FPGA, and verify its operation.