# Experiment 5.5.2 Early Detection Debouncing Circuit

# Prompt
The early detection debouncing scheme is discussed in Section 5.3.2. The output timing diagram is shown at the bottom of Figure 5.8. When the input changes from 0 to 1, the FSM responds immediately. The FSM then ignores the input for about 20 ms to avoid glitches. After this amount of time, the FSM starts to check the input for the falling edge. Follow the design procedure in Section 5.3.2 to design the alternative circuit.
1. Derive the state diagram and ASM chart for the circuit. 
2. Derive the HDL code. 
3. Derive the HDL code based on the state diagram and ASM chart. 
4. Derive a testbench and use simulation to verify operation of the code. 
5. Replace the debouncing circuit in Section 5.3.3 with the alternative design and verify its operation.


# Implementation
My implementation reuses the debouncing edge counter circuit from experiment 5.5.1. There are only two testpoints, the debounced button and the raw button, connected to ja0 and ja1 respectively.