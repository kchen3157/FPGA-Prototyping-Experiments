# Design Example 4.5.2 Stopwatch

## Cascading description for stopwatch
This implementation uses three mod-10 counters representing 0.1, 1, and 10 seconds respectively. Note that they all use the same clock in order to keep good synchronous design practice.


## Nested if-statement description for stopwatch
This implementation nests the logic in if statements, which each check if the digit has reached 9. This is the default implementation in the example top.