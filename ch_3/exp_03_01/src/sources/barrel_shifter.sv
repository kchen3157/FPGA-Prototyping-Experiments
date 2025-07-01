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

