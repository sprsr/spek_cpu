module mux3x1(
    input [31:0]      a,
    input [31:0]      b,
    input [31:0]      c,
    input [1:0]       sel,
    output reg [31:0] y
);

    always @(*) begin
        case(sel)
            2'h2 : y = a;
            2'h1 : y = b;
            2'h0 : y = c;
        endcase    
    end
endmodule
