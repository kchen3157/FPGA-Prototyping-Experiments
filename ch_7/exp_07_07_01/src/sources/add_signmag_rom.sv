
module add_signmag_rom
    (
        input   logic i_clk,
        input   logic [3:0] i_a, i_b,
        output  logic [3:0] o_sum
    );

    logic [3:0] rom [0:255];
    logic [7:0] w_addr;
    logic [3:0] w_data;

    assign w_addr = {i_a, i_b};

    initial begin
        $readmemb("./../../romgen/rom.txt", rom);
    end

    always_ff @(posedge i_clk)
    begin
        w_data <= rom[w_addr];
    end

    assign o_sum = w_data;

endmodule