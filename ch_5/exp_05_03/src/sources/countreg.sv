
module countreg
    (
        input   logic i_clk, i_rst,
        input   logic i_inc, i_dec,
        output  logic [15:0] o_count
    );

    // register instantiation
    logic [15:0] r_count, w_count_next;
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
            r_count <= 16'h0000;
        else
            r_count <= w_count_next;
    end

    // counter logic
    always_comb
    begin
        w_count_next = r_count;

        if (i_inc & ~i_dec)
            w_count_next = r_count + 1;
        else if (~i_inc & i_dec)
            w_count_next = r_count - 1;
    end

    assign o_count = r_count;

endmodule