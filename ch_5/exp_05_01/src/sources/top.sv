module top
    (
        input   logic clk, cpu_resetn,
        input   logic sw,
        output  logic ja0, ja1, ja2
    );

    // generate slower (default 10ms) tick
    logic w_slow_tick;
    logic [3:0] r_tick_counter, w_tick_counter_next;
    always_ff @(posedge clk)
    begin
        r_tick_counter <= w_tick_counter_next;
    end
    assign w_tick_counter_next = r_tick_counter + 1;
    assign w_slow_tick = (r_tick_counter == 0) ? 1'b1 : 1'b0;
    assign ja0 = w_slow_tick;

    // dualedge_detector_moore u_dualedge_detector_moore
    //     (.i_clk(w_slow_tick), .i_rst(~cpu_resetn), .i_lvl(sw),
    //      .o_edge(ja1));

    dualedge_detector_mealy u_dualedge_detector_mealy
        (.i_clk(w_slow_tick), .i_rst(~cpu_resetn), .i_lvl(sw),
         .o_edge(ja1));

    assign ja2 = sw;


endmodule
