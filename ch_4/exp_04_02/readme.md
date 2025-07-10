# Experiment 4.8.2 PWM and LED dimmer 

## Prompt
The duty cycle of a square wave is defined as the percentage of the on interval (i.e., logic ’1’) in a period. A PWM (pulse width modulation) circuit can generate an output with variable duty cycles. For a PWM with 4-bit resolution, a 4-bit control signal, w, specifies the duty cycle. The w signal is interpreted as an unsigned integer and the duty cycle is .

1. Design a PWM circuit with 4-bit resolution and verify its operation using a logic analyzer or oscilloscope.
2. Modify the LED time-multiplexing circuit to include the PWM circuit for the an signal. The PWM circuit specifies the percentage of time that the LED display is on. We can control the perceived brightness by changing the duty cycle. Verify the circuit’s operation by observing 1 bit of an on a logic analyzer or oscilloscope. 
3. Replace the LED time-multiplexing circuit of Listing 4.21 with the new design and use four slide switches to control the duty cycle. Verify operation of the circuit. It may be necessary to go to a dark area to see the effect of dimming.