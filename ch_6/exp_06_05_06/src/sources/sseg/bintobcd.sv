// This takes a 32 bit binary encoded in Decimal Fixed Point Float, (NOT BCD) to 4 Digit 
// BCD (Binary-Coded Decimal) circuit that is designed for use in the output logic
// of the frequency counter.
//
// ! Input of more than 0d9_999_999 (0x98_967F) will result in undefined behavior.
//
//
// TESTED INPUT: 32 Bit Binary (0d0000000->0d9999999 in binary, corresponding to 1.000->9999.999)
// TESTED OUTPUT: 4 Digit BCD with Moving Decimal (0.000->9999.)

`timescale 1 ns/10 ps

module bintobcd
    (
        input   logic i_clk, i_rst,
        input   logic i_start,
        input   logic [31:0] i_bin,

        output  logic o_ready, o_done, o_overflow,
        output  logic [3:0] o_bcd3, o_bcd2, o_bcd1, o_bcd0,
        output  logic [3:0] o_dp
    );

    typedef enum logic [2:0] {e_ready, e_operation, e_window, e_done, e_overflow} t_state;
    t_state r_state, w_state_next;

    logic [31:0] r_bin, w_bin_next;
    logic [5:0] r_index, w_index_next;

    logic [3:0] r_bcd0, w_bcd0_next, w_bcd0_adj;
    logic [3:0] r_bcd1, w_bcd1_next, w_bcd1_adj;
    logic [3:0] r_bcd2, w_bcd2_next, w_bcd2_adj;
    logic [3:0] r_bcd3, w_bcd3_next, w_bcd3_adj;
    logic [3:0] r_bcd4, w_bcd4_next, w_bcd4_adj;
    logic [3:0] r_bcd5, w_bcd5_next, w_bcd5_adj;
    logic [3:0] r_bcd6, w_bcd6_next;
    logic [2:0] w_bcd6_adj;

    logic [3:0] r_dp, w_dp_next;

    

    always_comb begin : bcd_add
        w_bcd0_adj = (r_bcd0 > 4'h4) ? (r_bcd0 + 4'h3) : (r_bcd0);
        w_bcd1_adj = (r_bcd1 > 4'h4) ? (r_bcd1 + 4'h3) : (r_bcd1);
        w_bcd2_adj = (r_bcd2 > 4'h4) ? (r_bcd2 + 4'h3) : (r_bcd2);
        w_bcd3_adj = (r_bcd3 > 4'h4) ? (r_bcd3 + 4'h3) : (r_bcd3);
        w_bcd4_adj = (r_bcd4 > 4'h4) ? (r_bcd4 + 4'h3) : (r_bcd4);
        w_bcd5_adj = (r_bcd5 > 4'h4) ? (r_bcd5 + 4'h3) : (r_bcd5);
        w_bcd6_adj = (r_bcd6 > 4'h4) ? (r_bcd6 + 4'h3) : (r_bcd6);
    end

    always_ff @( posedge i_clk, posedge i_rst ) begin : register_inst
        if (i_rst)
        begin
            r_state <= e_ready;
            r_bin <= 0;
            r_bcd0 <= 0;
            r_bcd1 <= 0;
            r_bcd2 <= 0;
            r_bcd3 <= 0;
            r_bcd4 <= 0;
            r_bcd5 <= 0;
            r_bcd6 <= 0;
            r_dp <= 0;
            r_index <= 0;
        end
        else
        begin
            r_state <= w_state_next;
            r_bin <= w_bin_next;
            r_bcd0 <= w_bcd0_next;
            r_bcd1 <= w_bcd1_next;
            r_bcd2 <= w_bcd2_next;
            r_bcd3 <= w_bcd3_next;
            r_bcd4 <= w_bcd4_next;
            r_bcd5 <= w_bcd5_next;
            r_bcd6 <= w_bcd6_next;
            r_dp <= w_dp_next;
            r_index <= w_index_next;
        end
    end

    always_comb begin : next_state_logic
        // defaults
        w_state_next = r_state;
        w_bin_next = r_bin;
        w_bcd0_next = r_bcd0;
        w_bcd1_next = r_bcd1;
        w_bcd2_next = r_bcd2;
        w_bcd3_next = r_bcd3;
        w_bcd4_next = r_bcd4;
        w_bcd5_next = r_bcd5;
        w_bcd6_next = r_bcd6;
        w_dp_next = r_dp;
        w_index_next = r_index;

        o_ready = 1'b0;
        o_done = 1'b0;
        o_overflow = 1'b0;


        case (r_state)
            e_ready:
            begin
                o_ready = 1'b1;
                if (i_start)
                begin
                    w_bin_next = i_bin;
                    w_bcd0_next = 4'h0;
                    w_bcd1_next = 4'h0;
                    w_bcd2_next = 4'h0;
                    w_bcd3_next = 4'h0;
                    w_bcd4_next = 4'h0;
                    w_bcd5_next = 4'h0;
                    w_bcd6_next = 4'h0;
                    w_index_next = 6'h20; // 32 bits
                    w_state_next = e_operation;
                    if (i_bin > 32'd9_999_999)
                    begin
                        w_state_next = e_overflow;
                        w_bcd6_next = 4'h9;
                        w_bcd5_next = 4'h9;
                        w_bcd4_next = 4'h9;
                        w_bcd3_next = 4'h9;
                        w_dp_next = 4'b0001;
                    end
                end
            end
            e_operation:
            begin
                if (r_index == 0)
                begin
                    // default (no window shift) dp
                    w_dp_next = 4'b0001;

                    w_index_next = 6'h03; // three possible shifts in total
                    
                    w_state_next = e_window;
                end
                else 
                begin
                    w_bcd6_next = {w_bcd6_adj[2:0], w_bcd5_adj[3]};
                    w_bcd5_next = {w_bcd5_adj[2:0], w_bcd4_adj[3]};
                    w_bcd4_next = {w_bcd4_adj[2:0], w_bcd3_adj[3]};
                    w_bcd3_next = {w_bcd3_adj[2:0], w_bcd2_adj[3]};
                    w_bcd2_next = {w_bcd2_adj[2:0], w_bcd1_adj[3]};
                    w_bcd1_next = {w_bcd1_adj[2:0], w_bcd0_adj[3]};
                    w_bcd0_next = {w_bcd0_adj[2:0], r_bin[31]};
                    w_bin_next = (r_bin << 1);
                    w_index_next = r_index - 1;
                end
            end
            e_window:
            begin
                // bcd registers    6  5  4  3  <-  2  1  0
                //
                // window0          6  5  4  3  <-  2  1  0
                // window1          5  4  3  2  <-  1  0
                // window2          4  3  2  1  <-  0
                // window3          3  2  1  0  <-  
                //
                if (r_index == 0) // no more shifts left
                    w_state_next = e_done;
                else if (r_bcd6 == 0) // still leading 0, shift
                begin
                    w_bcd6_next = r_bcd5;
                    w_bcd5_next = r_bcd4;
                    w_bcd4_next = r_bcd3;
                    w_bcd3_next = r_bcd2;
                    w_bcd2_next = r_bcd1;
                    w_bcd1_next = r_bcd0;
                    w_bcd0_next = 0;
                    
                    w_dp_next = (r_dp << 1);

                    w_index_next = r_index - 1;
                end
                else // not leading 0 anymore, we're done
                begin
                    w_state_next = e_done;
                end
                
            end
            e_done:
            begin
                o_done = 1'b1;
                w_state_next = e_ready;
            end
            e_overflow:
            begin
                o_done = 1'b1;
                o_overflow = 1'b1;
                w_state_next = e_ready;
            end
            default:
            begin
                w_state_next = e_ready;
            end
        endcase
    end

    always_comb
    begin
        
    end

    assign o_bcd0 = r_bcd3;
    assign o_bcd1 = r_bcd4;
    assign o_bcd2 = r_bcd5;
    assign o_bcd3 = r_bcd6;
    assign o_dp = r_dp;


endmodule