# Design Example 3.10.2

## Sign-magnitude adder

A sign-magnitude adder performs an addition operation in the sign-magnitude format. The operation can be summarized as follows:
- If the two operands have the same sign, simply add the magnitudes and keep the sign.
- If the two operands have different signs, subtract the smaller magnitude operand from the larger one and keep the sign of the larger magnitude operand.

We separate this process into two stages. The first sorts the operands into max and min, and the second actually performs the add operation.

The adder is 4-bit (1 sign, 3 mag) by default. My implementation saves a LUT by removing the unnecessary logic for max/min sign decision.