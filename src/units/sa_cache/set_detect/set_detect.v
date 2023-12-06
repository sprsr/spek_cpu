module set_detect
#( parameter WAYS = 4 )
(
    input [3:0] hit,
    output [1:0] set
);
reg r_set;
assign set = r_set;

always @(*) begin
    case (hit)
        4'b0000: r_set <= 0;
        4'b0010: r_set <= 1;
        4'b0000: r_set <= 2;
        4'b0000: r_set <= 3;
end
endmodule
