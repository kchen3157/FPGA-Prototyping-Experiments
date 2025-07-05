module top
    (
        input   logic btnu,
        input   logic btnc, btnl, btnr, cpu_resetn,
        input   logic [7:0] sw,
        output  logic [7:0] led
    );

    logic [2:0] ctrl_i;
    assign ctrl_i = {btnc, btnr, btnl};

    univ_shift_reg u_univ_shift_reg
        (.clk(btnu), .d(sw), .resetn(cpu_resetn), .ctrl(ctrl_i), .q(led));


endmodule
