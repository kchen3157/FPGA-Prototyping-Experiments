
module pwm_gen
    (
        input   logic i_clk, i_rst,
        input   logic [3:0] i_w,
        output  logic o_q
    );

    logic r_state; // 0->low, 1->high
    logic [3:0] r_duty_count;
    logic w_state_next;
    logic [3:0] w_duty_count_next;
    always_ff @(posedge i_clk)
    begin
        if (i_rst)
        begin
            r_state <= 1'b1;
            r_duty_count <= 1'b0;
        end
        else
        begin
            r_state <= w_state_next;
            r_duty_count <= w_duty_count_next;
        end
    end

    always_comb
    begin
        w_duty_count_next = r_duty_count + 1; // will automatically roll over if 16
        w_state_next = r_state;
        if (r_state && (r_duty_count > i_w))
        begin
            w_state_next = ~r_state;
        end
        if (!r_state && (r_duty_count == 4'hF))
        begin
            w_duty_count_next = 4'h0;
            w_state_next = ~r_state;
        end
    end

    assign o_q = r_state;

endmodule
