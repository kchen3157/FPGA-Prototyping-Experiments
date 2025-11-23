# FPGA Prototyping Experiments

This repository is my work while following along Pong P. Chu's book "FPGA Prototyping by SystemVerilog Examples." All exersises, up until the latest chapter I have worked on, have been worked on and verified in some manner, with the vast majority being complete to all of the textbook's specifications.

The board used in this repository is the Digilent Nexys Video.

## Peripherals

### 4 Digit Seven-Segment Display V1
*This display is used from chapter 2 to chapter 6, and in one example from chapter 7 (eg_07_03). Everything numerically after eg_07_03 uses V2 of the 4 Digit SSeg.*

The display used in this project is the CL5641BH, which is a common-anode, 4-Digit 7-segment display that is being driven at 3.3V. It is connected to the board via a custom FPGA mezzanine board. The connection is as follows, with the rightmost digit numbered as 0:

| LED Pin | FMC Pin
| ------- | -------
| A | LA09_N
| B | LA03_P
| C | LA09_P
| D | LA08_N
| E | CLK0_M2C_N
| F | LA12_P
| G | LA08_P
| DP | LA05_N
| DIG0 | CLK1_M2C_N
| DIG1 | LA04_P
| DIG2 | LA02_N
| DIG3 | LA02_P



### 4 Digit Seven-Segment Display V2
*This display is used starting from exp_07_07_01 in chapter 7.*

The display used in this project is the CL5641BH, which is a common-anode, 4-Digit 7-segment display that is being driven at 3.3V. It is connected to the board via an AMD/Xilinx HW-FMC-105-DEBUG mezzanine card, which provides FMC LPC breakout support. The connection is as follows, with the rightmost digit numbered as 0:

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

When the HW-FMC-105-DEBUG card is used, this routing becomes a simple common-sense pin to pin mapping directly from the LED pins to the leftmost pins on the J1 connector.