module top
    (
        input   logic [7:0] sw,
        input   logic [3:0] btn,
        input   logic btndir,
        output  logic [7:0] led
    );

    barrel_shifter u_barrel_shifter
        (.a(sw), .amt(btn), .lr(btndir), .y(led));


endmodule
