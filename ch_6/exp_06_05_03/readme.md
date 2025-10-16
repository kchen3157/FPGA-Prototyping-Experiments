# 6.5.3 Fibonacci circuit with BCD I/O: design approach 1 
## Prompt
To make the Fibonacci circuit more user friendly, we can modify the circuit to use the BCD format for the input and output. Assume that the input is an 8-bit signal in BCD format (i.e., two BCD digits) and the output is displayed as four BCD digits on the seven-segment LED display. Furthermore, the LED will display ”9999” if the resulting Fibonacci number is larger than 9999 (i.e., overflow). The operation can be done in three steps: convert input to the binary format, compute the Fibonacci number, and convert the result back to the BCD format.
The first design approach is to follow the procedure in Section 6.3.5. Begin by constructing three smaller subsystems, which are the BCD-to-binary conversion circuit, Fibonacci circuit, and binary-to-BCD conversion circuit, and then use a master FSM to control the overall operation. Design the circuit as follows:

- Implement the BCD-to-binary conversion circuit in Experiment 6.5.2. 
- Modify the Fibonacci number circuit in Section 6.3.1 to include an output signal to indicate the overflow condition. 
- Derive the top-level block diagram and the master control FSM state diagram.
- Derive the HDL code. 
- Derive a testbench and use simulation to verify operation of the code. 
- Synthesize the circuit, program the FPGA, and verify its operation.

## Derivation
The finished project routes the input (nth Fibonacci number to generate) to the 8 switches on the Nexys Video, and the center button is wired to start the calculation. Display output is via the 4 Digit SSeg display interface common to this repository, using connectors on FMC.

Testbenches have been created for 