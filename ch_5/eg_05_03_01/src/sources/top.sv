module top
    (
        input   logic clk, cpu_resetn,
        input   logic sw,
        output  logic ja0
    );

    // edge_detect_gate u_edge_detect_gate
    //     (.i_clk(clk), .i_rst(~cpu_resetn), .i_level(sw),
    //      .o_tick(ja0));
    
    // edge_detect_moore u_edge_detect_moore
    //     (.i_clk(clk), .i_rst(~cpu_resetn), .i_level(sw),
    //      .o_tick(ja0));

    edge_detect_mealy u_edge_detect_mealy
        (.i_clk(clk), .i_rst(~cpu_resetn), .i_level(sw),
         .o_tick(ja0));

endmodule
