module top
    (
        input logic [3:0] sw,
        output logic [0:0] led
    );

    gt_4_sop gt_unit (.a(sw[3:2]), .b(sw[1:0]), .agtb(led[0]));


endmodule
