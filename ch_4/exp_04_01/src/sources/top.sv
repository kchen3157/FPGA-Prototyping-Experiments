module top
    (
        input   logic clk,
        input   logic cpu_resetn,
        input   logic [7:0] sw,
        output  logic ja0
    );

    square_wave_gen u_square_wave_gen
        (.i_clk(clk), .i_rst(~cpu_resetn), .i_m(sw[3:0]),
         .i_n(sw[7:4]), .o_q(ja0));


endmodule
