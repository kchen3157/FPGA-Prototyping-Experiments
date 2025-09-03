module top
    (
        input   logic clk,
        input   logic cpu_resetn,
        input   logic sw,
        output  logic [3:0] ja
    );

    assign ja[0] = sw;

    debouncer_fsmd_exp u_debouncer_fsmd_exp
        (.i_clk(clk), .i_rst(~cpu_resetn), .i_sw(sw),
         .o_sw_debounced(ja[1]), .o_rising(ja[2]));

    assign ja[3] = 1'b0;

endmodule
