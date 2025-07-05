module top
    (
        input   logic [7:0] sw,
        input   logic btnc,
        output  logic [7:0] led
    );

    logic [12:0] y;

    int_to_float u_int_to_float
        (.a(sw), .y(y));

    assign led = (btnc) ? {3'b0, y[12:8]} : y[7:0];

endmodule
