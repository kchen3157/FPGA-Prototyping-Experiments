# 7.7.2 ROM-Based Temperature Conversion

This is a conversion circuit using a lookup table in ROM. The input/output are 8-bit unsigned integers with a range of $0\degree{C}$ to $100\degree{C}$, $32\degree{F}$ to $212\degree{F}$. A format signal indicates whether the input is in Celsius or Fahrenheit, and the circuit converts it to the opposite scale.

The generator for the ROM content is located in the romgen folder. It is a 2^9-by-8 ROM, with the address MSB notating the if it is $C\rightarrow{F}$ (1) or $F\rightarrow{C}$ (0).