# Design Example 5.3.2 Debouncing Circuit

This circuit debounces btnc and displays the number of rising edges both in the raw button signal (right LEDs) and the debounced signal (left LEDs). Some signals are exposed for testing to the pmod ports:
- lvl -> ja0
- lvl_db -> ja1
- debounce_state -> {ja4, ja3, ja2}
- slow_tick -> jb0