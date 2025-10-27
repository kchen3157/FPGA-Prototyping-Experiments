# 6.5.5 Auto-scaled low-frequency counter 
## Prompt
The operation of the low-frequency counter in Section 6.3.5 is very restricted. The frequency range of the input signal is limited between 1 and 10 Hz. It loses accuracy when the frequency is beyond this range. Recall that the accuracy of this frequency counter depends on the accuracy of the period counter of Section 6.3.5, which counts in terms of millisecond ticks. We can modify the t counter to generate a microsecond tick (i.e., counting from 0 to 49) and increase the accuracy 1000-fold. This allows the range of the frequency counter to increase to 9999 Hz and still maintain at least four-digit accuracy.

Using a microsecond tick introduces more than four accuracy digits for low-frequency input, and the number must be shifted and truncated to be displayed on the seven-segment LED. An auto-scaled low-frequency counter performs the adjustment automatically, displays the four most significant digits, and places a decimal point in the proper place. For example, according to their range, the frequency measurements will be shown as ”1.234”, ”12.34”, ”123.4”, or ”1234.”.

The auto-scaled low-frequency counter needs an additional BCD adjustment circuit. It first checks whether the most significant BCD digit (i.e., the four MSBs) of a BCD sequence is zero. If this is the case, the circuit shifts the BCD sequence to the left by four positions and increments the decimal point counter. The operation is repeated until the most significant BCD digit is not ”0000”.

The complete auto-scaled low-frequency counter can be implemented as follows:
1. Modify the period counter to use the microsecond tick. 
2. Extend the size of the binary-to-BCD conversion circuit. 
3. Derive the ASMD chart for the BCD adjustment circuit and the HDL code. 
4. Modify the control FSM to include the BCD adjustment in the last step. 
5. Design a simple decoding circuit that uses the decimal point counter’s output to activate the desired decimal point of the seven-segment LED display. 
6. Derive a testbench and use simulation to verify operation of the code. 
7. Synthesize the circuit, program the FPGA, and verify its operation.