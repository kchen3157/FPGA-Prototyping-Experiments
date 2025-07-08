# Design Example 4.5.1 LED time-multiplexing circuit

This design example uses a mux-implemented time-sharing scheme to display symbols on a 4-digit wide seven segment display.

The specific display used for this implementation is the common-anode model 5461BH, with an FMC connection running LVCMOS18 standard, and according to the following pinouts below (Display -> FMC):
- E -> CLK0_M2C_N (MSPI[5])
- D -> LA_8N (MSPI[4])
- DP -> LA_5N (MSPI[8])
- C -> LA_9P (MSPI[3])
- G -> LA_8P (MSPI[7])
- LED4 -> CLK1_M2C_N (I2S[4])
- B -> LA_3P (MSPI[2])
- LED3 -> LA_4P (I2S[3])
- LED2 -> LA_2N (I2S[2])
- F -> LA_12P (MSPI[6])
- A -> LA_9N (MSPI[1])
- LED1 -> LA_2P (I2S[1])

Two different behaving modules can be used within the top, led_switch and led_switch_set.

led_switch allows one to input a value using the 8 switches on the Nexys, which will be displayed accordingly in hex form on the two rightmost sseg digits. The remaining two leftmost sseg digits will display the sum of the first and second sseg digits.

led_switch_set uses enable registers to allow the user to set a specific value for each digit. The rightmost 4 switches control the 4-bit value to be set onto the digit(s), and the leftmost 4 switches control which digit the 4-bit value is to be set.