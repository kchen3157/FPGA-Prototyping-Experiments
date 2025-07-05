module free_run_shift_reg
    #(parameter N = 8)
    (
        input   logic clk, reset,
        input   logic s_in,
        output  logic s_out
    );

    logic [N-1:0] r_reg;
    logic [N-1:0] r_next;

    always_ff @(posedge clk, posedge reset)
    begin
        if (reset)
            r_reg <= 0;
        else
            r_reg <= r_next;
    end

    assign r_next = {s_in, r_reg[N-1:1]};

    assign s_out = r_reg[0];
endmodule

module univ_shift_reg
    #(parameter N=8)
    (
        input   logic clk, resetn,
        input   logic [2:0] ctrl,
        input   logic [N-1:0] d,
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
        case (ctrl)
            3'b001: r_next = {r_reg[N-2:0], d[0]};
            3'b010: r_next = {d[N-1], r_reg[N-1:1]};
            3'b100: r_next = d;
            default: r_next = r_reg;
        endcase
    end

    assign q = r_reg;

endmodule
