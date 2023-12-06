module control( 
    input        clk,
    input        rst,
    input [31:0] inst,
    input        brEq,
    input        brLT,
    output       pcSel,
    output [3:0] ImmSel,
    output       RegWEn,
    output       BrUn,
    output       BSel,
    output       ASel,
    output [3:0] ALUSel,
    output       sign,
    output       MemRW,
    output [1:0] WBSel
);

wire [31:0] w_instr_de;
wire [31:0] w_instr_exe;
wire [31:0] w_instr_acc;

decode_ctl inst_decode_ctl(
    .clk(clk),
    .rst(rst),
    .instruction(inst),
    .immSel(ImmSel),
    .instr_de(w_instr_de)
);

execute_ctl inst_execute_ctl(
    .clk(clk),
    .rst(rst),
    .BrEq(BrEq),
    .BrLT(brLT),
    .instruction(w_instr_de),
    .a_sel(ASel),
    .b_sel(BSel),
    .pc_sel(pcSel),
    .sign(sign),
    .BrUn(BrUn),
    .alu_sel(ALUSel),
    .instr_exe(w_instr_exe)
);

access_ctl inst_access_ctl(
    .clk(clk),
    .rst(rst),
    .instruction(w_instr_exe),
    .instr_acc(w_instr_acc),
    .MemRW(MemRW)
);

wb_ctl inst_wb_ctl(
    .clk(clk),
    .rst(rst),
    .instruction(w_instr_acc),
    .wb_sel(WBSel)
);

//Leaving this buffer module for more logic
/*
instr_ctl inst_instr_ctl(
    .instruction(inst), 
    .BrEq(brEq),
    .BrLT(brLT),
    .a_sel(ASel),
    .b_sel(BSel),
    .alu_sel(ALUSel),
    .sign(sign),
    .mem_wr(MemRW),
    .RegWEn(RegWEn),
    .immSel(ImmSel),
    .BrUn(BrUn),
    .pc_sel(pcSel),
    .wb_sel(WBSel)
);
*/

endmodule
