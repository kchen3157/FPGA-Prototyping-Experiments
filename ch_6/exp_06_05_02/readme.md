# 6.5.2 BCD-to-binary conversion circuit
## Prompt
A BCD-to-binary conversion converts a BCD number to the equivalent binary representation. Assume that the input is an 8-bit signal in BCD format (i.e., two BCD digits) and the output is a 7-bit signal in binary representation. Follow the procedure in Section 6.3.3 to design a BCD-to-binary conversion circuit:
- Derive the conversion algorithm and ASMD chart. 
- Derive the HDL code based on the ASMD chart. 
- Derive a testbench and use simulation to verify operation of the code. 
- Synthesize the circuit, program the FPGA, and verify its operation.

## Derivation
The conversion algorithm is known as the reverse double dabble, which repeats the following operations until all the input BCD data has been considered:
- Right shift the BCD register into the output binary register.
- If a digit group on the BCD register is greater than 7, then subtract 3 from that group.

