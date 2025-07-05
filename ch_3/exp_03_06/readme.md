# 3.12.6 Floating-point and signed integer conversion circuit 

# Prompt
A number may need to be converted to different formats in a large system. Assume that we use the 13-bit format in Section 3.10.4 for the floating-point representation and the 8-bit signed data type for the integer representation. An integer-to-floating-point conversion circuit converts an 8-bit integer input to a normalized, 13-bit floating-point output. A floating-point-to-integer conversion circuit reverses the operation. Since the range of a floating-point number is much larger, conversion may lead to the underflow condition (i.e., the magnitude of the converted number is smaller than ”00000001”) or the overflow condition (i.e., the magnitude of the converted number is larger than ”01111111”).

1. Design an integer-to-floating-point conversion circuit and derive the code. 
2. Derive a testbench and use simulation to verify operation of the code. 
3. Design a testing circuit and derive the code. 
4. Synthesize the circuit, program the FPGA, and verify its operation. 
5. Design a floating-point-to-integer conversion circuit. In addition to the 8-bit integer output, the design should include two status signals, uf and of, for the underflow and overflow conditions. Derive the code and repeat steps 2 to 4.