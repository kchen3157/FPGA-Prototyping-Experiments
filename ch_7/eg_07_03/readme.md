# 7.3 FIFO Buffer Implementation

This is an implementation of a FWFT FIFO Buffer. At the top, the left and right buttons control write and read signals respectively, the switch array is used to input the data to write into the buffer, and the sseg display is used as before to output the data in the read port.

To synchronize the buttons, they have been put through an edge detector to output a pulse at rising edge.