# Design Example 4.3.2 Binary Counters

## Free-running binary counter

This is a simple binary counter running on a reduced clock rate of around 1.5 Hz. The counter can be reset to 0 with cpu_resetn and it will set max_tick if the counter is at the maximum possible value for q.

On the example top, max_tick is not connected.

Can be synthesized with the build_fr.sh script.

## Universal binary counter

This adds on to the simple binary counter by adding the loading, synchronous clear/reset, min_tick, direction, and enable functionality.

The controls in the example top are the same as the free-running counter, with added controls as follows:
- btnc: synchronous clear/reset
- btnu: load value on sw[7:0] into register
- btnd: count down (default count up)

Note max_tick/min_tick are not connected, and en is always set to 1'b1 in the example top.

## Mod-m counter

This is a variation of the free running binary counter, except it counts for a specific parameter M inside a ceiling log2(M) sized register, then after it reaches (M - 1), it goes back to 0. max_tick is set when the counter reaches (M - 1).
