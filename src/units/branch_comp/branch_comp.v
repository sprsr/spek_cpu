module branch_comp(
    input [31:0] i_dataA,
    input [31:0] i_dataB,
    input [3:0]  br_expect,
    output       br_success 
);

reg r_br_success;

assign br_success = r_br_success;

always @(*) begin

            case (br_expect)
                3'b001: r_br_success <= (i_dataA == i_dataB);
                3'b010: r_br_success <= !(i_dataA == i_dataB);
                3'b011: r_br_success <= ($signed(i_dataA) < $signed(i_dataB));
                3'b100: r_br_success <= !($signed(i_dataA) < $signed(i_dataB));
                3'b101: r_br_success <= ($unsigned(i_dataA) < $unsigned(i_dataB));
                3'b110: r_br_success <= !($unsigned(i_dataA) < $unsigned(i_dataB));
                default: r_br_success <= 1'b0;
            endcase

end
endmodule
