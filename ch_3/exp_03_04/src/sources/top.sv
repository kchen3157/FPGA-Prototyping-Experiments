module top
    (
        input   logic [7:0] sw,
        output  logic [7:0] led
    );

    bcd_inc u_bcd_inc
        (.x(sw), .y(led));


endmodule
