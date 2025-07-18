module top
    (
        input   logic clk, cpu_resetn,
        input   logic sw,
        output  logic ja0
    );

    // dualedge_detector_moore u_dualedge_detector_moore
    //     (.i_clk(clk), .i_rst(~cpu_resetn), .i_lvl(sw),
    //      .o_edge(ja0));
    
    dualedge_detector_mealy u_dualedge_detector_mealy
        (.i_clk(clk), .i_rst(~cpu_resetn), .i_lvl(sw),
         .o_edge(ja0));


endmodule
