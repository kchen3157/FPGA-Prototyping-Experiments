module gt_2_sop
    (
        input logic [1:0] a, b,
        output logic agtb
    );

    logic p0, p1, p2, p3, p4, p5;

    // test
    // summation
    assign agtb = p0 | p1 | p2 | p3 | p4 | p5;

    // product terms
    assign p0 = (~b[1] & ~b[0]) & (~a[1] &  a[0]); // 00 < 01
    assign p1 = (~b[1] & ~b[0]) & ( a[1] & ~a[0]); // 00 < 10
    assign p2 = (~b[1] & ~b[0]) & ( a[1] &  a[0]); // 00 < 11
    assign p3 = (~b[1] &  b[0]) & ( a[1] & ~a[0]); // 01 < 10
    assign p4 = (~b[1] &  b[0]) & ( a[1] &  a[0]); // 01 < 11
    assign p5 = ( b[1] & ~b[0]) & ( a[1] &  a[0]); // 10 < 11
    

endmodule


module gt_4_sop
    (
        input logic [3:0] a, b,
        output logic agtb
    );

    logic agtb_low, agtb_high, aeqb_high;

    gt_2_sop gt_2_sop_inst_low
        (.a(a[1:0]), .b(b[1:0]), .agtb(agtb_low));
    
    gt_2_sop gt_2_sop_inst_high
        (.a(a[3:2]), .b(b[3:2]), .agtb(agtb_high));

    eq_2_sop eq_2_sop_inst_high
        (.a(a[3:2]), .b(b[3:2]), .aeqb(aeqb_high));
    
    assign agtb = agtb_high | (agtb_low & aeqb_high);

endmodule