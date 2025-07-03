module top
    (
        input   logic [7:0] sw,
        output  logic [7:0] led
    );

    logic [11:0] req_i;
    logic [3:0] y1_i, y2_i;
    logic v1_i, v2_i;

    encoder_dual_priority u_encoder_dual_priority
        (.req(req_i), .y1(y1_i), .y2(y2_i), .v1(v1_i), .v2(v2_i));

    assign req_i = {4'h0, sw};
    assign led = {v2_i, v1_i, y2_i[2:0], y1_i[2:0]};


endmodule
