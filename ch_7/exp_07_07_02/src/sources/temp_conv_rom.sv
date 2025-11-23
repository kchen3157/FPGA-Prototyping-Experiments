
module temp_conv_rom
    (
        input   logic i_clk,
        input   logic [7:0] i_input,
        input   logic i_format,
        output  logic [7:0] o_output
    );

    logic [7:0] rom [0:2**9-1];
    logic [8:0] w_addr;
    logic [7:0] w_data;

    assign w_addr = {i_format, i_input};

    initial begin
        $readmemb("./../../rom/rom.txt", rom);
    end

    always_ff @(posedge i_clk)
    begin
        w_data <= rom[w_addr];
    end

    assign o_output = w_data;

endmodule