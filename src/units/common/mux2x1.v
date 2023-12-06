module mux2x1(
    input [31:0]      a,
    input [31:0]      b,
    input             sel,
    output reg [31:0] y
);

    always @(*) begin
        case(sel)
            1'b1 : y = a;
            1'b0 : y = b;
        endcase    
    end
endmodule
