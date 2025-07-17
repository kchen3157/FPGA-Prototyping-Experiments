
module debounce_counter
    (
        input   logic i_clk, i_rst, i_clr,
        input   logic i_lvl,
        output  logic [7:0] o_lvl_count,
        output  logic [7:0] o_lvl_db_count,
        output  logic o_lvl_db
    );

    logic w_lvl_db;

    debouncer u_debouncer
        (.i_clk(i_clk), .i_rst(i_rst), .i_sw(i_lvl), .o_sw_debounced(w_lvl_db));

    // positive edge detector
    logic r_lvl, r_lvl_db;
    logic w_lvl_posedge, w_lvl_db_posedge;
    always_ff @(posedge i_clk)
    begin
        r_lvl <= i_lvl;
        r_lvl_db <= w_lvl_db;
    end
    assign w_lvl_posedge = ~r_lvl & i_lvl;
    assign w_lvl_db_posedge = ~r_lvl_db & w_lvl_db;

    // counter
    logic [7:0] r_lvl_count, r_lvl_db_count;
    logic [7:0] w_lvl_count_next, w_lvl_db_count_next;
    always_ff @(posedge i_clk)
    begin
        r_lvl_count <= w_lvl_count_next;
        r_lvl_db_count <= w_lvl_db_count_next;
    end
    assign w_lvl_count_next = (i_clr) ? 0 :
                              (w_lvl_posedge) ? r_lvl_count + 1 :
                              r_lvl_count;
    assign w_lvl_db_count_next = (i_clr) ? 0 :
                                 (w_lvl_db_posedge) ? r_lvl_db_count + 1 :
                                 r_lvl_db_count;

    // output
    assign o_lvl_count = r_lvl_count;
    assign o_lvl_db_count = r_lvl_db_count;
    assign o_lvl_db = w_lvl_db;


endmodule
