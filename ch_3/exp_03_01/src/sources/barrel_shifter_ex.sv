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

module barrel_shifter_rev_16
    (
        input logic [15:0] a,
        input logic [3:0] amt,
        input logic lr,
        output logic [15:0] y
    );

    logic [15:0] t0, t1, t2, t3, tr;

    assign tr = (lr) ? a : {a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], 
                            a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15]};

    assign t0 = (amt[0]) ? {tr[0:0], tr[15:1]} : tr;
    assign t1 = (amt[1]) ? {t0[1:0], t0[15:2]} : t0;
    assign t2 = (amt[2]) ? {t1[3:0], t1[15:4]} : t1;
    assign t3 = (amt[3]) ? {t2[7:0], t2[15:8]} : t2;

    assign y = (lr) ? t3 : {t3[0], t3[1], t3[2], t3[3], t3[4], t3[5], t3[6], t3[7],
                            t3[8], t3[9], t3[10], t3[11], t3[12], t3[13], t3[14], t3[15]};

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


module barrel_shifter_rev_32
    (
        input logic [31:0] a,
        input logic [4:0] amt,
        input logic lr,
        output logic [31:0] y
    );

    logic [31:0] t0, t1, t2, t3, t4, tr;

    assign tr = (lr) ? a : {a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], 
                            a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15],
                            a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23],
                            a[24], a[25], a[26], a[27], a[28], a[29], a[30], a[31]};

    assign t0 = (amt[0]) ? {tr[0:0], tr[31:1]} : tr;
    assign t1 = (amt[1]) ? {t0[1:0], t0[31:2]} : t0;
    assign t2 = (amt[2]) ? {t1[3:0], t1[31:4]} : t1;
    assign t3 = (amt[3]) ? {t2[7:0], t2[31:8]} : t2;
    assign t4 = (amt[4]) ? {t3[15:0], t3[31:16]} : t3;

    assign y = (lr) ? t3 : {t4[0], t4[1], t4[2], t4[3], t4[4], t4[5], t4[6], t4[7], 
                            t4[8], t4[9], t4[10], t4[11], t4[12], t4[13], t4[14], t4[15],
                            t4[16], t4[17], t4[18], t4[19], t4[20], t4[21], t4[22], t4[23],
                            t4[24], t4[25], t4[26], t4[27], t4[28], t4[29], t4[30], t4[31]};

endmodule

