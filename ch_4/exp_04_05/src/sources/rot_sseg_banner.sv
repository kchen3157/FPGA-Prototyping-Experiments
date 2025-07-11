
module rotating_sseg_banner
    #(
        parameter PER_10_NS = 20000000 // Period in 10s of nanoseconds
    )
    (
        input   logic i_clk, i_rst,
        input   logic i_en, i_dir, // 1 = right, 0 = left
        input   logic [7:0] i_data_n [9:0],
        output  logic [7:0] o_map_n [3:0]
    );

    // generate slower clk
    logic [$clog2(PER_10_NS)-1:0] r_slo_clk_count;
    logic w_slo_clk;
    always @(posedge i_clk)
    begin
        r_slo_clk_count <= r_slo_clk_count + 1;
    end
    assign w_slo_clk = (r_slo_clk_count == PER_10_NS - 1) ? 1'b1 : 1'b0;

    // state register
    logic [3:0] r_window_state;
    logic [3:0] w_window_state_next;
    always_ff @(posedge w_slo_clk)
    begin
        if (i_rst)
        begin
            r_window_state <= 4'h6; // start at the most significant digits
        end
        else
        begin
            r_window_state <= w_window_state_next;
        end
    end

    // next state logic
    always_comb
    begin
        if (i_en && i_dir)
        begin
            w_window_state_next = (r_window_state == 4'h9) ? 4'h0 : (r_window_state + 1);
        end
        else if (i_en)
        begin
            w_window_state_next = (r_window_state == 4'h0) ? 4'h9 : (r_window_state - 1);
        end
        else
        begin
            w_window_state_next = r_window_state;
        end
    end

    // output logic
    always_comb
    begin
        case (r_window_state)
            4'h0: o_map_n = i_data_n[3:0];
            4'h1: o_map_n = i_data_n[4:1];
            4'h2: o_map_n = i_data_n[5:2];
            4'h3: o_map_n = i_data_n[6:3];
            4'h4: o_map_n = i_data_n[7:4];
            4'h5: o_map_n = i_data_n[8:5];
            4'h6: o_map_n = i_data_n[9:6];
            4'h7: o_map_n = {i_data_n[0:0], i_data_n[9:7]};
            4'h8: o_map_n = {i_data_n[1:0], i_data_n[9:8]};
            default: o_map_n = {i_data_n[2:0], i_data_n[9:9]};
        endcase
    end

endmodule