# 6.5.4 Fibonacci circuit with BCD I/O: design approach 2 
An alternative to the previous “subsystem approach” in Experiment 6.5.3 is to integrate the three subsystems into a single system and derive a customized FSMD for this particular application. The approach eliminates the overhead of the control FSM and provides opportunities to share registers among the three tasks. Design the circuit as follows:

1. Redesign the circuit of Experiment 6.5.3 using one FSMD. The design should eliminate all unnecessary circuits and states, such as the various done_tick signals and the done states, and exploit the opportunity to share and reuse the registers in different steps. 
2. Derive the ASMD chart. 
3. Derive the HDL code based on the ASMD chart. 
4. Derive a testbench and use simulation to verify operation of the code. 
5. Synthesize the circuit, program the FPGA, and verify its operation. 
6. Check the synthesis report and compare the number of LEs used in the two approaches. 
7. Calculate the number of clock cycles required to complete the operation in the two approaches.