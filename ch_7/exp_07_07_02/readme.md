# 7.7.2 ROM-Based Temperature Conversion

This is a conversion circuit using a lookup table in ROM. The input/output are 8-bit unsigned integers with a range of $0\degree{C}$ to $100\degree{C}$, $32\degree{F}$ to $212\degree{F}$. A format signal indicates whether the input is in Celsius or Fahrenheit, and the circuit converts it to the opposite scale.

The generator for the ROM content is located in the rom folder. It is a 2^9-by-8 ROM, with the address MSB notating the if it is $C\rightarrow{F}$ (1) or $F\rightarrow{C}$ (0).

For this top implementation, the switches are connected to the input temperature, and the output converted temperature is displayed on the seven segment display. The circuit will allow you to input illegal values outside 0-100C and 32-212F, the output in that case is undefined. The center button controls the format signal, with depression equating to $C\rightarrow{F}$ and $F\rightarrow{C}$ otherwise.