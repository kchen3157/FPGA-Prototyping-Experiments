`timescale 1 ns/10 ps

module dualedge_detector_tb;

    localparam CLK_PERIOD_NS = 20;

    logic i_clk, i_rst;
    logic i_lvl;
    logic o_edge;

    // dualedge_detector_moore uut_dualedge_detector_moore
    //     (.*);

    dualedge_detector_mealy uut_dualedge_detector_mealy
        (.*);

    // clockgen
    always
    begin
        i_clk = 1'b1;
        #(CLK_PERIOD_NS/2);
        i_clk = 1'b0;
        #(CLK_PERIOD_NS/2);
    end

    // reset
    initial
    begin
        i_rst = 1'b1;
        #(CLK_PERIOD_NS/2);
        i_rst = 1'b0;
    end

    // start test
    initial
    begin
        // initial condition
        i_lvl = 1'b0;

        @(negedge i_clk);
        i_lvl = 1'b1;
        #(CLK_PERIOD_NS);
        i_lvl = 1'b0;
        #(1);
        i_lvl = 1'b1;
        @(negedge i_clk);
        i_lvl = 1'b0;
        for (int i = 0; i < 20; i = i + 1)
        begin
            #($urandom_range(10,150));
            i_lvl = 1'b1;
            #($urandom_range(10,150));
            i_lvl = 1'b0;
        end

        $stop;
    end

endmodule
