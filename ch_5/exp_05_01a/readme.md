# Experiment 5.5.1 Dual-Edge Detector

## Prompt
A dual-edge detector is similar to a rising-edge detector except that the output is asserted for one clock cycle when the input changes from 0 to 1 (i.e., rising edge) and 1 to 0 (i.e., falling edge).
1. Design the circuit based on the Moore machine and draw the state diagram and ASM chart. 
2. Derive the HDL code based on the state diagram of the ASM chart. 
3. Derive a testbench and use simulation to verify operation of the code.
4. Replace the rising detectors in Section 5.3.3 with dual-edge detectors and verify their operations. 
    - Implemented in exp_05_01a.
5. Repeat steps 1 to 4 for a Mealy machine–based design.


## Implementation
This 
A slow clock of around 6.25 MHz is used in this implementation. The top routes the detector input to the first switch, and outputs the slow clock, raw switch, and edge detect to pmod ja0, ja1, and ja2 respectively.