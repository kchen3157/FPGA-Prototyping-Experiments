module top
    (
        input logic [2:0] btn,
        input logic [7:0] sw,
        output logic [7:0] led
    );

    barrel_shifter_stage u_barrel_shifter_stage
        (.a(sw), .amt(btn), .y(led));

endmodule
