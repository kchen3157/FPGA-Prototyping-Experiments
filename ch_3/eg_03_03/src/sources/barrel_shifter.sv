module barrel_shifter_case
    (
        input logic [7:0] a,
        input logic [2:0] amt,
        output logic [7:0] y
    );

    always_comb
    begin
        case (amt)
            3'b000: y = a;
            3'b001: y = {a[0:0], a[7:1]};
            3'b010: y = {a[1:0], a[7:2]};
            3'b011: y = {a[2:0], a[7:3]};
            3'b100: y = {a[3:0], a[7:4]};
            3'b101: y = {a[4:0], a[7:5]};
            3'b110: y = {a[5:0], a[7:6]};
            default: y = {a[6:0], a[7:7]};
        endcase
    end

endmodule


module barrel_shifter_stage
    (
        input logic [7:0] a,
        input logic [2:0] amt,
        output logic [7:0] y
    );

    logic [7:0] t0, t1;

    assign t0 = (amt[0]) ? {a[0:0], a[7:1]} : a;
    assign t1 = (amt[1]) ? {t0[1:0], t0[7:2]} : t0;
    assign y = (amt[2]) ? {t1[3:0], t1[7:4]} : t1;

endmodule






module top_preview
    (
        input logic [7:0] a_case, a_stage,
        input logic [2:0] amt_case, amt_stage,
        output logic [7:0] y_case,
        output logic [7:0] y_stage
    );

    barrel_shifter_case u_barrel_shifter_case
        (.a(a_case), .amt(amt_case), .y(y_case));

    barrel_shifter_stage u_barrel_shifter_stage
        (.a(a_stage), .amt(amt_stage), .y(y_stage));

endmodule
