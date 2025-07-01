# Design Example 3.10.4

## Simplified floating-point adder
This adder uses a simplified 13-bit floating point specification:
- 1-bit sign field s
- 4-bit exponent field e
- 8-bit significand field f

Where the decimal format of this number is (-1)^s * .f * 2^e, e and f are unsigned, and the representation is either normalized or zero.

Thus the largest nonzero magnitude is 0b0.111111111\*2^(0b1111) and the smallest 0b0.10000000\*2^(0b0000). Zero is written as 0b0.00000000\*2^(0b0000).

The computation is done in four steps:
1. *Sort*: Find which number's magnitude is larger and which number's magnitude is smaller.
2. *Align*: Align the numbers so they have the same exponent, i.e. adjust the exponent of the small number to match that of the big number, then adjust the smaller significand to conform.
3. *Add/Subtract*: Add or subtract the now aligned numbers.
4. *Normalize*: Adjust the result, which may be:
   - Getting rid of leading zeros
   - Converting to zero if the result is too small to be normalized
   - Getting rid of a carry-out bit