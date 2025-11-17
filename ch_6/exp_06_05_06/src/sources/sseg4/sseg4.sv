`timescale 1 ns/10 ps


module sseg4
    (
        input   logic i_clk, i_rst,
        input   logic [$clog2(9999)-1:0] i_bin,
        input   logic i_greeting,               // When asserted, display "HI"

        output  logic [7:0] o_sseg_n,
        output  logic [3:0] o_ldsel,
        output  logic o_idle                    // For siulation usage
    );


    typedef enum {e_idle, e_change} t_state;
    t_state r_state, w_state_next;

    logic [13:0] r_bin, w_bin_next;
    logic r_greeting, w_greeting_next;

    logic [3:0] r_bcd3, r_bcd2, r_bcd1, r_bcd0;
    logic [3:0] w_bcd3_next, w_bcd2_next, w_bcd1_next, w_bcd0_next;


    logic w_bintobcd_start;
    logic w_bintobcd_ready, w_bintobcd_done;
    logic [3:0] w_bcd3, w_bcd2, w_bcd1, w_bcd0;
    bintobcd u_bintobcd
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_bintobcd_start),
        .i_bin(r_bin),
        .o_ready(w_bintobcd_ready), .o_done(w_bintobcd_done),
        .o_bcd3(w_bcd3), .o_bcd2(w_bcd2), .o_bcd1(w_bcd1), .o_bcd0(w_bcd0)
    );

    logic [7:0] w_sseg_0_n, w_sseg_1_n, w_sseg_2_n, w_sseg_3_n;
    hextosseg u_hextosseg_0
    (
        .i_hex(r_bcd0), .i_dp(1'b0), .o_sseg_n(w_sseg_0_n)
    );

    hextosseg u_hextosseg_1
    (
        .i_hex(r_bcd1), .i_dp(1'b0), .o_sseg_n(w_sseg_1_n)
    );

    hextosseg u_hextosseg_2
    (
        .i_hex(r_bcd2), .i_dp(1'b0), .o_sseg_n(w_sseg_2_n)
    );

    hextosseg u_hextosseg_3
    (
        .i_hex(r_bcd3), .i_dp(1'b0), .o_sseg_n(w_sseg_3_n)
    );

    logic [7:0] w_in_0, w_in_1, w_in_2, w_in_3;
    assign w_in_0 = (i_greeting) ? 8'b11111001 : w_sseg_0_n; // HI: 'I'
    assign w_in_1 = (i_greeting) ? 8'b10001001 : w_sseg_1_n; // HI: 'H'
    assign w_in_2 = (i_greeting) ? 8'b00000000 : w_sseg_2_n;
    assign w_in_3 = (i_greeting) ? 8'b00000000 : w_sseg_3_n;


    ledmux u_ledmux
    (
        .i_clk(i_clk), .i_reset(i_rst),
        .i_in_n({w_in_3, w_in_2, w_in_1, w_in_0}), // ACTIVE LO
        .o_ldsel(o_ldsel), // ACTIVE HI
        .o_sseg_n(o_sseg_n)  // ACTIVE LO
    );

    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_state <= e_idle;
            r_bin <= '0;
            r_greeting <= 1'b0;
            r_bcd3 <= '0;
            r_bcd2 <= '0;
            r_bcd1 <= '0;
            r_bcd0 <= '0;
        end
        else
        begin
            r_state <= w_state_next;
            r_bin <= w_bin_next;
            r_greeting <= w_greeting_next;
            r_bcd3 <= w_bcd3_next;
            r_bcd2 <= w_bcd2_next;
            r_bcd1 <= w_bcd1_next;
            r_bcd0 <= w_bcd0_next;
        end
    end

    always_comb
    begin : next_state_logic
        // defaults
        w_state_next = r_state;
        w_bin_next = r_bin;
        w_greeting_next = r_greeting;
        w_bcd0_next = r_bcd0;
        w_bcd1_next = r_bcd1;
        w_bcd2_next = r_bcd2;
        w_bcd3_next = r_bcd3;
        o_idle = 1'b0;

        w_bintobcd_start = 1'b0;

        case (r_state)
            e_idle:
            begin
                o_idle = 1'b1;
                if (w_bintobcd_ready)
                begin
                    w_bin_next = i_bin;
                    w_greeting_next = i_greeting;
                    w_bintobcd_start = 1'b1;
                    w_state_next = e_change;
                end
            end
            e_change:
            begin
                if (w_bintobcd_done)
                begin
                    w_bcd0_next = w_bcd0;
                    w_bcd1_next = w_bcd1;
                    w_bcd2_next = w_bcd2;
                    w_bcd3_next = w_bcd3;
                    w_state_next = e_idle;
                end          
            end
        endcase
    end

endmodule