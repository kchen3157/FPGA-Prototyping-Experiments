`timescale 1 ns/10 ps

module encoder_dual_priority_tb;

    logic [11:0] req_i;
    logic [3:0] y1_o;
    logic [3:0] y2_o;
    logic v1_o, v2_o;


    encoder_dual_priority encoder_dual_priority_uut
        (.req(req_i), .y1(y1_o), .y2(y2_o), .v1(v1_o), .v2(v2_o));

    initial
    begin
        for (int i = 0; i < 2**12; i = i + 1)
        begin
            req_i = i;
            # 10;
        end

        $stop;
    end

endmodule
