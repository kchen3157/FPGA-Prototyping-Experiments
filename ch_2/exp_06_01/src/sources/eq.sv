module eq_2_sop
    (
        input logic [1:0] a, b,
        output logic aeqb  
    );

    // summation
    assign agtb = p0 | p1 | p2 | p3;

    // product terms
    assign p0 = (~b[1] & ~b[0]) & (~a[1] & ~a[0]); // 00 == 00
    assign p1 = (~b[1] &  b[0]) & (~a[1] &  a[0]); // 01 == 01
    assign p2 = ( b[1] & ~b[0]) & ( a[1] & ~a[0]); // 10 == 10
    assign p3 = ( b[1] &  b[0]) & ( a[1] &  a[0]); // 11 == 11


endmodule