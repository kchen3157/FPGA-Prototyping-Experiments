module encoder_dual_priority
    (
        input   logic [11:0] req,
        output  logic [3:0] y1,
        output  logic [3:0] y2,
        output  logic v1,
        output  logic v2
    );

    always_comb
    begin
        
        v1 = 1'b0;
        v2 = 1'b0;
        y1 = 4'h0;
        y2 = 4'h0;
        for (int i = 0; i < 12; i = i + 1)
        begin
            if (req[i] & !v1)
            begin
                y1 = i;
                v1 = 1'b1;
            end
            else if (req[i] & !v2)
            begin
                y2 = i;
                v2 = 1'b1;
            end
        end
    end

endmodule
