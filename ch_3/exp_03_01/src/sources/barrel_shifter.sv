`timescale 1 ns/10 ps

module barrel_shifter_multi
    (
        input logic [7:0] a,
        input logic [2:0] amt,
        input logic lr,
        output logic [7:0] y
    );

    logic [7:0] r0, r1, l0, l1, lr2;

    assign r0 = (amt[0]) ? {a[0:0], a[7:1]} : a;
    assign r1 = (amt[1]) ? {r0[1:0], r0[7:2]} : r0;

    assign l0 = (amt[0]) ? {a[6:0], a[7:7]} : a;
    assign l1 = (amt[1]) ? {l0[5:0], l0[7:6]} : l0;

    assign lr2 = (lr) ? r1 : l1;

    assign y = (amt[2]) ? {lr2[3:0], lr2[7:4]} : lr2;

endmodule

module barrel_shifter_multi_rev
    (
        input logic [7:0] a,
        input logic [2:0] amt,
        input logic lr,
        output logic [7:0] y
    );

    logic [7:0] t0, t1, t2, tr;

    assign tr = (lr) ? a : {a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]};

    assign t0 = (amt[0]) ? {tr[0:0], tr[7:1]} : tr;
    assign t1 = (amt[1]) ? {t0[1:0], t0[7:2]} : t0;
    assign t2 = (amt[2]) ? {t1[3:0], t1[7:4]} : t1;

    assign y = (lr) ? t2 : {t2[0], t2[1], t2[2], t2[3], t2[4], t2[5], t2[6], t2[7]};

endmodule

