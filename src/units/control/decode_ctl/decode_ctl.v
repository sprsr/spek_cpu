module decode_ctl(
    input        clk,
    input        rst,
    input        stall,
    input [31:0] pc,
    input [31:0] instruction,
    output  [3:0] immSel,
    output [31:0] pc_de,
    output [31:0] instr_de
);

reg [31:0]  r_pc_de;
reg [31:0]  r_instr_de;

assign pc_de = r_pc_de;
assign instr_de = r_instr_de;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        r_pc_de   <= 32'h0;
        r_instr_de <= 32'hxxxxxxxx;
    end else begin      
        r_pc_de    <= pc;
        if (stall)
            r_instr_de <= 32'b00000000000000000000000000010011;
        else
            r_instr_de <= instruction;
    end
end
endmodule
