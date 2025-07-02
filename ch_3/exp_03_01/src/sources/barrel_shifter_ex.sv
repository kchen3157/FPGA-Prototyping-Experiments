`timescale 1 ns/10 ps

module barrel_shifter_16
    (
        input logic [15:0] a,
        input logic [3:0] amt,
        input logic lr,
        output logic [15:0] y
    );

    logic [15:0] r0, r1, r2, l0, l1, l2, lr3;

    assign r0 = (amt[0]) ? {a[0:0], a[15:1]} : a;
    assign r1 = (amt[1]) ? {r0[1:0], r0[15:2]} : r0;
    assign r2 = (amt[2]) ? {r1[3:0], r1[15:4]} : r1;

    assign l0 = (amt[0]) ? {a[14:0], a[15:15]} : a;
    assign l1 = (amt[1]) ? {l0[13:0], l0[15:14]} : l0;
    assign l2 = (amt[2]) ? {l1[11:0], l1[15:12]} : l1;

    assign lr3 = (lr) ? r2 : l2;

    assign y = (amt[3]) ? {lr3[7:0], lr3[15:8]} : lr3;

endmodule

module barrel_shifter_32
    (
        input logic [31:0] a,
        input logic [4:0] amt,
        input logic lr,
        output logic [31:0] y
    );

    logic [31:0] r0, r1, r2, r3, l0, l1, l2, l3, lr4;

    assign r0 = (amt[0]) ? {a[0:0], a[31:1]} : a;
    assign r1 = (amt[1]) ? {r0[1:0], r0[31:2]} : r0;
    assign r2 = (amt[2]) ? {r1[3:0], r1[31:4]} : r1;
    assign r3 = (amt[3]) ? {r2[7:0], r2[31:8]} : r2;

    assign l0 = (amt[0]) ? {a[30:0], a[31:31]} : a;
    assign l1 = (amt[1]) ? {l0[29:0], l0[31:30]} : l0;
    assign l2 = (amt[2]) ? {l1[27:0], l1[31:28]} : l1;
    assign l3 = (amt[3]) ? {l2[23:0], l2[31:24]} : l2;

    assign lr4 = (lr) ? r3 : l3;

    assign y = (amt[4]) ? {lr4[15:0], lr4[31:16]} : lr4;

endmodule

