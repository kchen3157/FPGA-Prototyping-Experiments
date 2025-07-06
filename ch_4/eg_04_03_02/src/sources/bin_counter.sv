module free_run_bin_counter
    #(parameter N = 8)
    (
        input   logic clk,
        input   logic resetn,
        output  logic max_tick,
        output  logic [N-1:0] q
    );

    logic [N-1:0] r_reg;
    logic [N-1:0] r_next;

    always_ff @(posedge clk, negedge resetn)
    begin
        if (~resetn)
            r_reg = 0;
        else
            r_reg = r_next;
    end

    assign r_next = r_reg + 1;

    assign q = r_reg;
    assign max_tick = (r_reg == 2 ** N - 1) ? 1'b1 : 1'b0;

endmodule

module univ_bin_counter
    #(parameter N = 8)
    (
        input   logic clk, resetn,
        input   logic syn_clr, load, en, up,
        input   logic [N-1:0] d,
        output  logic max_tick, min_tick,
        output  logic [N-1:0] q
    );

    logic [N-1:0] r_reg, r_next;

    always_ff @(posedge clk, negedge resetn)
    begin
        if (~resetn)
            r_reg <= 0;
        else
            r_reg <= r_next;
    end

    always_comb
    begin
        if (syn_clr)
            r_next = 0;
        else if (load)
            r_next = d;
        else if (en & up)
            r_next = r_reg + 1;
        else if (en & ~up)
            r_next = r_reg - 1;
        else
            r_next = r_reg;
    end

    assign q = r_reg;
    assign max_tick = (q == 2 ** N - 1) ? 1'b1 : 1'b0;
    assign min_tick = (q == 0) ? 1'b1 : 1'b0;

endmodule

module mod_m_counter
    #(parameter M = 10)
    (
        input   logic clk, resetn,
        output  logic max_tick,
        output  logic [$clog2(M)-1:0] q
    );

    localparam N = $clog2(M);

    logic [N-1:0] r_reg;
    logic [N-1:0] r_next;

    always_ff @(posedge clk, negedge resetn)
    begin
        if (~resetn)
            r_reg = 0;
        else
            r_reg = r_next;
    end

    assign r_next = (r_reg == (M - 1)) ? 0 : (r_reg + 1);

    assign q = r_reg;
    assign max_tick = (r_reg == (M - 1)) ? 1'b1 : 1'b0;
    

endmodule
