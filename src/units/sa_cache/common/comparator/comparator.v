module Comparator
#(
    parameter TAG_WIDTH = 18 
)
(
    input [TAG_WIDTH - 1: 0] i_a,
    input [TAG_WIDTH - 1: 0] i_b,
    output                     o_y
);
assign o_y = (i_a == i_b);
endmodule

