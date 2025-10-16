# 6.5.4 Fibonacci circuit with BCD I/O: design approach 2 
## Prompt
An alternative to the previous “subsystem approach” in Experiment 6.5.3 is to integrate the three subsystems into a single system and derive a customized FSMD for this particular application. The approach eliminates the overhead of the control FSM and provides opportunities to share registers among the three tasks. Design the circuit as follows:

1. Redesign the circuit of Experiment 6.5.3 using one FSMD. The design should eliminate all unnecessary circuits and states, such as the various done_tick signals and the done states, and exploit the opportunity to share and reuse the registers in different steps. 
2. Derive the ASMD chart. 
3. Derive the HDL code based on the ASMD chart. 
4. Derive a testbench and use simulation to verify operation of the code. 
5. Synthesize the circuit, program the FPGA, and verify its operation. 
6. Check the synthesis report and compare the number of LEs used in the two approaches. 
7. Calculate the number of clock cycles required to complete the operation in the two approaches.

## Derivation
The finished fibgen module combines the three submodules and fib_ctl of the previous experiment, while maintaining the same operability as fib_ctl.

Design approach 1 uses fewer LUTs (132 vs 139) than design approach 2, but uses a lot more registers (115 vs 88). Through simulation, design approach 1 takes 31.140 us to complete values 0->99, and 8.23 us to complete values 0->20. Design approach 2 takes 17.29 us and 7.81 us in comparison, so there is slight performance increase when computing regular values, and a very large increase when computing overflow values, due to the difference in handling the input n>20.
