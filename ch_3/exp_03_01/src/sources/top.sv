module top
    (
        input logic [7:0] a,
        input logic [2:0] amt,
        input logic lr,
        output logic [7:0] y
    );

    barrel_shifter_multi u_barrel_shifter_multi
        (.a(a), .amt(amt), .lr(lr), .y(y));


endmodule
