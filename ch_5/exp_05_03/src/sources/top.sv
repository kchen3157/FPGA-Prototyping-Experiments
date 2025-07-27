module top
    (
        input   logic clk, cpu_resetn,
        input   logic [1:0] sw,
        output  logic [1:0] led
    );

    parking_lot_occupancy_counter u_parking_lot_occupancy_counter
        (.i_clk(clk), .i_rst(~cpu_resetn), .i_a(sw[0]), .i_b(sw[1]),
         .o_car_enter(led[0]), .o_car_exit(led[1]));


endmodule
