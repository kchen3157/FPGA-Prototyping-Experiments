# Design Example 3.10.3

## Barrel Shifter

This barrel shifter shifts the input a right by amt. Though Verilog has built-in shift functions, they cannot be synthesized automatically sometimes. The operation is implemented two ways:
- Hard-coded case
- Stage

The case method arranges the input by a hard-coded case for every possible amt value. The stage method splits the logic into amt bitwise stages, where each stage shifts the amount by its value.