# Experiment 5.5.3 Parking Lot Occupancy Counter

Consider a parking lot with a single entry and exit gate. Two pairs of photo sensors are used to monitor the activity of cars, as shown in Figure 5.11. When an object is between the photo transmitter and the photo receiver, the light is blocked and the corresponding output is asserted to 1. By monitoring the events of two sensors, we can determine whether a car is entering or exiting or whether a pedestrian is passing through. For example, the following sequence indicates that a car enters the lot:
- Initially, both sensors are unblocked (i.e., the a and b signals are 00). 
- Sensor a is blocked (i.e., the a and b signals are 10). 
- Both sensors are blocked (i.e., the a and b signals are 11). 
- Sensor a is unblocked (i.e., the a and b signals are 01). 
- Both sensors becomes unblocked (i.e., the a and b signals are 00).  

Design a parking lot occupancy counter as follows:
1. Design an FSM with two input signals, a and b, and two output signals, car_enter and car_exit. The car_enter and car_exit signals assert one clock cycle when a car enters and one clock cycle when a car exits the lot, respectively.
2. Derive the HDL code for the FSM. 
3. Design a counter with two control signals, inc and dec, which increment and decrement the counter when asserted. Derive the HDL code. 
4. Combine the counter and the FSM and seven-segment LED decoding circuits. Use two debounced pushbuttons to mimic operation of the two sensor outputs. Verify operation of the occupancy counter.