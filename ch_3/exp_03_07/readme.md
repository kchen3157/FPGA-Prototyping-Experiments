# 3.12.7 Enhanced floating-point adder

## Prompt
The floating-point adder in Section 3.10.4 discards the lower bits when they are shifted out (it is known as round to zero). A more accurate method is to round to the nearest even, as defined in the IEEE Standard for Binary Floating-Point Arithmetic (IEEE Std 754). Three extra bits, known as the guard, round, and sticky bits, are required to implement this method. If you have previously learned floating-point arithmetic, modify the floating-point adder in Section 3.10.4 to accommodate the round-to-the-nearest-even method.