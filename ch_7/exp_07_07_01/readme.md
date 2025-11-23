# 7.7.1 ROM-Based Sign-Magnitude Adder

The adder is 4-bit input signals (8-bit not implemented), that can be inputted via the switches on the board. Sign magnitude means the most significant bit is 1 when negative and 0 otherwise. The sum is displayed on the display.

## Display Information
The display used in this project is the CL5641BH, which is a common-anode, 4-Digit 7-segment display that is being driven at 3.3V. The connection is as follows, with the rightmost digit numbered as 0:

| LED Pin | FMC Pin |
| ------- | ------- |
| A | LA10_N
| B | LA12_N
| C | LA01_N_CC
| D | LA00_N_CC
| E | LA00_P_CC
| F | LA11_P
| G | LA02_P
| DP | LA01_P_CC
| DIG0 | LA02_N
| DIG1 | LA12_P
| DIG2 | LA11_N
| DIG3 | LA10_P

If you use the Xilinx/AMD HW-FMC-105-DEBUG mezzanine card, this routing becomes a simple common-sense pin to pin mapping directly from the LED pins to the leftmost pins on the J1 connector.