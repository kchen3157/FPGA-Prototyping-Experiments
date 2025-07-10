// Max duty cycle would be 15/16, lowest would be 0/16 (off)
module pwm_gen
    (
        input   logic i_clk, i_rst,
        input   logic [3:0] i_w,
        output  logic o_q,
        output  logic [3:0] o_test_duty_count
    );

    logic r_state; // 0->low, 1->high
    logic [3:0] r_duty_count;
    logic w_state_next;
    logic [3:0] w_duty_count_next;
    assign o_test_duty_count = r_duty_count;
    always_ff @(posedge i_clk)
    begin
        if (i_rst)
        begin
            r_state <= 1'b0;
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
        if (!r_state && (r_duty_count == (4'hF - i_w)) && r_duty_count != 4'hF)
        begin
            w_state_next = ~r_state;
        end
        if (r_state && (r_duty_count == 4'hF))
        begin
            w_state_next = ~r_state;
        end
    end

    assign o_q = r_state;

endmodule
