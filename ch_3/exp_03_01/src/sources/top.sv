module top
    (
        input logic [7:0] sw,
        input logic [2:0] btn,
        input logic btnlr,
        output logic [7:0] led
    );

    barrel_shifter_multi u_barrel_shifter_multi
        (.a(sw), .amt(btn), .lr(btnlr), .y(led));


endmodule
