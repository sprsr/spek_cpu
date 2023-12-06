module access_ctl(
    input clk,
    input rst,
    input [31:0] pc_exe,
    input [31:0] alu_out,
    input [31:0] data_b_exe,
    input [31:0] instruction,
    output [31:0] pc_4_acc,
    output [31:0] alu_out_acc,
    output [31:0] data_b_acc,
    output [31:0] instr_acc,
    output MemRW
);

reg        r_mem_wr;
reg [31:0] r_pc_4_acc;
reg [31:0] r_alu_out_acc;
reg [31:0] r_data_b_acc;
reg [31:0] r_instr_acc;

assign instr_acc = r_instr_acc;
assign MemRW = r_mem_wr;
assign pc_4_acc = r_pc_4_acc;
assign alu_out_acc = r_alu_out_acc;
assign data_b_acc = r_data_b_acc;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        r_pc_4_acc <= 32'b1;
        r_mem_wr   <= 1'b0;
        r_instr_acc <= 32'hxxxxxxxx;
    end else begin
        case (instruction[6:0])
            7'b0100011: begin
                case (instruction[14:12])
                    // SB Instruction
                    3'b000: begin
                        r_mem_wr  <= 1'b1;
                    end
                    // SH Instruction
                    3'b001: begin
                        r_mem_wr  <= 1'b1;
                    end
                    // SW Instruction
                    3'b010: begin
                        r_mem_wr  <= 1'b1;
                    end
                endcase
            end
            default: begin
                r_mem_wr <= 1'b0;
            end
        endcase
        r_pc_4_acc    <= pc_exe + 'b1;
        r_alu_out_acc <= alu_out;
        r_data_b_acc  <= data_b_exe;
        r_instr_acc   <= instruction;
    end
end
endmodule


