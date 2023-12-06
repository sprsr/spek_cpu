module rv32(
    input clk,
    input rst
);


wire        w_regWEn;
wire        w_pc_sel;
wire [1:0]  w_a_sel;
wire        w_b_sel;
wire        w_sign;
wire        w_brEq;
wire        w_brLT;
wire        w_brUn;
wire        w_mem_rw;
wire  [3:0] w_alu_sel;
wire  [3:0] w_imm_sel;
wire  [1:0] w_wb_sel;
wire [31:0] w_pc_4;
wire [31:0] w_pc_4_acc;
wire [31:0] w_pc_4_wb;
wire [31:0] w_pc;
wire [31:0] w_pc_de;
wire [31:0] w_pc_exe;
wire [31:0] w_immediate;
wire [31:0] w_wr_back;
wire [31:0] w_data_a_mgr;
wire [31:0] w_reg_data_A;
wire [31:0] w_reg_data_A_exe;
wire [31:0] w_data_a;
wire [31:0] w_reg_data_B;
wire [31:0] w_data_b_mgr;
wire [31:0] w_reg_data_B_exe;
wire [31:0] w_data_b;
wire [31:0] w_reg_data_B_acc;
wire [31:0] w_alu_in_A;
wire [31:0] w_alu_in_B;
wire [31:0] w_alu_out;
wire [31:0] w_alu_out_acc;
wire [31:0] w_alu_out_wb;
wire [31:0] w_dmem_out;
wire [31:0] w_dmem_out_wb;
wire        w_alu_zero_flag;
wire        w_hazard_a;
wire        w_hazard_b;
wire        w_stall;
wire        w_br_success;
wire [3:0]  w_br_expect;
wire [31:0] w_debug [31:0];

wire [31:0] w_instr_fetch;
wire [31:0] w_instr_de;
wire [31:0] w_instr_exe;
wire [31:0] w_instr_acc;
wire [31:0] w_instr_wb;


PC inst_pc(
    .clk(clk),
    .rst(rst),
    .stall(w_stall),
    .sel_pc(w_pc_sel),
    .in_pc(w_pc_4),
    .in_alu(w_alu_out_acc),
    .pc_nxt(w_pc_4),
    .pc(w_pc),
    .instr_fetch(w_instr_fetch)
);

decode_ctl inst_decode_ctl(
    .clk(clk),
    .rst(rst),
    .stall(w_stall),
    .pc(w_pc),
    .instruction(w_instr_fetch),
    .pc_de(w_pc_de),
    .instr_de(w_instr_de)
);

execute_ctl inst_execute_ctl(
    .clk(clk),
    .rst(rst),
    .stall(w_stall),
    .data_a(w_reg_data_A),
    .data_b(w_reg_data_B),
    .pc_de(w_pc_de),
    .instruction(w_instr_de),
    .a_sel(w_a_sel),
    .b_sel(w_b_sel),
    .immSel(w_imm_sel),
    .br_expect(w_br_expect),
    .sign(w_sign),
    .alu_sel(w_alu_sel),
    .data_a_exe(w_reg_data_A_exe),
    .data_b_exe(w_reg_data_B_exe),
    .pc_exe(w_pc_exe),
    .instr_exe(w_instr_exe)
);

access_ctl inst_access_ctl(
    .clk(clk),
    .rst(rst),
    .pc_exe(w_pc_exe),
    .alu_out(w_alu_out),
    .data_b_exe(w_reg_data_B_exe),
    .instruction(w_instr_exe),
    .pc_4_acc(w_pc_4_acc),
    .alu_out_acc(w_alu_out_acc),
    .data_b_acc(w_reg_data_B_acc),
    .instr_acc(w_instr_acc),
    .MemRW(w_mem_rw)
);

wb_ctl inst_wb_ctl(
    .clk(clk),
    .rst(rst),
    .pc_4_acc(w_pc_4_acc),
    .alu_out_acc(w_alu_out_acc),
    .dmem_out(w_dmem_out),
    .instruction(w_instr_acc),
    .wb_sel(w_wb_sel),
    .regWEn(w_regWEn),
    .pc_4_wb(w_pc_4_wb),
    .alu_out_wb(w_alu_out_wb),
    .dmem_out_wb(w_dmem_out_wb),
    .instr_wb(w_instr_wb)
);

instr_mgr inst_instr_mgr(
    .clk(clk),
    .rst(rst),
    .instr_fetch(w_instr_fetch),
    .instr_de(w_instr_de),
    .instr_exe(w_instr_exe),
    .alu_out_exe(w_alu_out),
    .pc_exe(w_pc_exe),
    .instr_acc(w_instr_acc),
    .alu_out_acc(w_alu_out_acc),
    .dmem_out_acc(w_dmem_out),
    .instr_wb(w_instr_wb),
    .data_d_wb(w_wr_back),
    .pc_4_acc(w_pc_4_acc),
    .br_success(w_br_success),
    .stall(w_stall),
    .hazard_a(w_hazard_a),
    .hazard_b(w_hazard_b),
    .pc_sel(w_pc_sel),
    .data_a_mgr(w_data_a_mgr),
    .data_b_mgr(w_data_b_mgr)
);



immGen inst_immGen(
    .immSel(w_imm_sel),
    .instr(w_instr_exe[31:7]),
    .immediate(w_immediate)
);

register inst_register(
    .clk(clk),
    .rst(rst),
    .regWEn(w_regWEn),
    .dataD(w_wr_back),
    .addrD(w_instr_wb[11:7]),
    .addrA(w_instr_de[19:15]),
    .addrB(w_instr_de[24:20]),
    .dataA(w_reg_data_A),
    .dataB(w_reg_data_B),
    .debug(w_debug)
);

branch_comp inst_branch_comp(
    .i_dataA(w_data_a),
    .i_dataB(w_data_b),
    .br_expect(w_br_expect),
    .br_success(w_br_success)
);


mux2x1 inst_hazard_mux_A(
    .a(w_data_a_mgr),
    .b(w_reg_data_A_exe),
    .sel(w_hazard_a),
    .y(w_data_a)
);

mux2x1 inst_hazard_mux_B(
    .a(w_data_b_mgr),
    .b(w_reg_data_B_exe),
    .sel(w_hazard_b),
    .y(w_data_b)
);

mux2x1 inst_mux3x1_A(
    .a(w_pc_exe),
    .b(w_data_a),
    .sel(w_a_sel[0]),
    .y(w_alu_in_A)
);

mux2x1 inst_mux2x1_B(
    .a(w_immediate),
    .b(w_data_b),
    .sel(w_b_sel),
    .y(w_alu_in_B)
);

alu inst_alu(
    .i_1(w_alu_in_A),
    .i_2(w_alu_in_B),
    .aluSel(w_alu_sel),
    .sign(w_sign),
    .result(w_alu_out),
    .zero_flag(w_alu_zero_flag)
);

dmem inst_dmem(
    .clk(clk),
    .rst(rst),
    .i_addr(w_alu_out_acc),
    .dataW(w_reg_data_B_acc),
    .memRW(w_mem_rw),
    .o_data(w_dmem_out)
);

mux3x1 inst_mux3x1_wb(
    .a(w_pc_4_wb),
    .b(w_alu_out_wb),
    .c(w_dmem_out_wb),
    .sel(w_wb_sel),
    .y(w_wr_back)
);

debug_port inst_debug(
    .registers(w_debug),
    .reg0(w_debug[0]),
    .reg1(w_debug[1]),
    .reg2(w_debug[2]),
    .reg3(w_debug[3]),
    .reg4(w_debug[4]),
    .reg5(w_debug[5]),
    .reg6(w_debug[6]),
    .reg7(w_debug[7]),
    .reg8(w_debug[8]),
    .reg9(w_debug[9]),
    .reg10(w_debug[10]),
    .reg11(w_debug[11]),
    .reg12(w_debug[12]),
    .reg13(w_debug[13]),
    .reg14(w_debug[14]),
    .reg15(w_debug[15]),
    .reg16(w_debug[16]),
    .reg17(w_debug[17]),
    .reg18(w_debug[18]),
    .reg19(w_debug[19]),
    .reg20(w_debug[20]),
    .reg21(w_debug[21]),
    .reg22(w_debug[22]),
    .reg23(w_debug[23]),
    .reg24(w_debug[24]),
    .reg25(w_debug[25]),
    .reg26(w_debug[26]),
    .reg27(w_debug[27]),
    .reg28(w_debug[28]),
    .reg29(w_debug[29]),
    .reg30(w_debug[30]),
    .reg31(w_debug[31])
);
endmodule
