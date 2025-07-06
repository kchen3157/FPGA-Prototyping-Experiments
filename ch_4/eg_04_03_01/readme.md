# Design Example 4.3.1 Shift register

## Free-running shift register

This shifts its content to the left or right by one for each clock cycle.

The current example is a right shift. As it is by itself, it doesn't quite do anything useful.

## Universal shift register

This register loads and shifts data every clk cycle according to a ctrl register, where:
- ctrl = 3'b001 Shifts Left
- ctrl = 3'b010 Shifts Right
- ctrl = 3'b100 Loads
- Otherwise, it does nothing.

In the example top, I have routed d (input data) to the switches and q (output data) to the LEDs. Btnc is connected to ctrl[2], btnl is connected to ctrl[0], and btnr is connected to ctrl[1], such that they represent load, lshift, and rshift intuitively.

The clock is connected to btnu at the moment, so the user must press that to advance the clock and load/shift. The cpu_resetn button is used to reset the register to 0.