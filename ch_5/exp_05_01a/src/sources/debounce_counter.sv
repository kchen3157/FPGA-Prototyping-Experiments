
module debounce_counter
    (
        input   logic i_clk, i_rst, i_clr,
        input   logic i_lvl,
        output  logic [7:0] o_lvl_count,
        output  logic [7:0] o_lvl_db_count,
        output  logic o_lvl_db,
        output  logic [3:0] o_debounce_state,
        output  logic o_slow_tick
    );

    logic w_lvl_db;

    debouncer u_debouncer
        (.i_clk(i_clk), .i_rst(i_rst), .i_sw(i_lvl), .o_sw_debounced(w_lvl_db),
         .o_debounce_state(o_debounce_state), .o_slow_tick(o_slow_tick));

    // edge detectors
    logic w_lvl_edge, w_lvl_db_edge;
    dualedge_detector_moore u_dualedge_detector_mealy_lvl
        (.i_clk(i_clk), .i_rst(i_rst), .i_lvl(i_lvl), .o_edge(w_lvl_edge));
    dualedge_detector_moore u_dualedge_detector_mealy_db
        (.i_clk(i_clk), .i_rst(i_rst), .i_lvl(w_lvl_db), .o_edge(w_lvl_edge1));


    // counter
    logic [7:0] r_lvl_count, r_lvl_db_count;
    logic [7:0] w_lvl_count_next, w_lvl_db_count_next;
    always_ff @(posedge i_clk)
    begin
        r_lvl_count <= w_lvl_count_next;
        r_lvl_db_count <= w_lvl_db_count_next;
    end
    assign w_lvl_count_next = (i_clr) ? 0 :
                              (w_lvl_edge) ? r_lvl_count + 1 :
                              r_lvl_count;
    assign w_lvl_db_count_next = (i_clr) ? 0 :
                                 (w_lvl_db_edge) ? r_lvl_db_count + 1 :
                                 r_lvl_db_count;

    // output
    assign o_lvl_count = r_lvl_count;
    assign o_lvl_db_count = r_lvl_db_count;
    assign o_lvl_db = w_lvl_db;


endmodule
