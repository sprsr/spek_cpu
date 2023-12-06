module instr_mgr(
    input        clk,
    input        rst,
    input [31:0] instr_fetch,
    input [31:0] instr_de,
    input [31:0] instr_exe,
    input [31:0] alu_out_exe,
    input [31:0] pc_exe,
    input [31:0] instr_acc,
    input [31:0] alu_out_acc,
    input [31:0] dmem_out_acc,
    input [31:0] instr_wb,
    input [31:0] data_d_wb,
    input [31:0] pc_4_acc,
    input        br_success,
    output       stall,
    output       hazard_a,
    output       hazard_b,
    output       pc_sel,
    output[31:0] data_a_mgr,
    output[31:0] data_b_mgr
);
reg       r_false_path;
reg       r_stall;
reg       r_pc_sel;
reg       r_hazard_a;
reg       r_hazard_b;
reg [5:0] r_conflict_map;
reg [2:0] r_wb_acc;
reg [2:0] r_wb_exe;
reg [2:0] r_wb_wb;
reg [31:0] r_data_mgr;
reg [31:0] r_data_a_mgr;
reg [31:0] r_data_b_mgr;

assign pc_sel = r_pc_sel;
assign stall = r_stall;
assign hazard_a = r_hazard_a;
assign hazard_b = r_hazard_b;
assign data_a_mgr = r_data_a_mgr;
assign data_b_mgr = r_data_b_mgr;

//Function checking if the instruction is a write back instruction
function [2:0] write_back_check;
    input [31:0] instruction;
    case (instruction[6:0])
        // LUI Instruction: 
        7'b0110111: begin
            write_back_check  = 2'b01;
        end
        // AUIPC Instruction: 
        7'b0010111: begin
            write_back_check  = 2'b01;
        end
        // JALR Instruction:
        7'b1100111: begin
            write_back_check  = 2'b10;
        end
        7'b1100011: begin
            write_back_check  = 2'bx;
        end
        7'b0000011: begin
            write_back_check  = 2'b0;
        end
        7'b0100011: begin
            write_back_check  = 2'b0;
        end
        7'b0010011: begin
            write_back_check  = 2'b1;
        end
        7'b0110011: begin
            write_back_check  = 2'b1;
        end
        default: begin
            write_back_check  = 2'b11;
        end
    endcase
endfunction

always @(posedge clk or posedge rst) begin
    if (rst) begin
        r_conflict_map = 6'b0;
        r_stall = 1'b0;
        r_hazard_a = 1'b0;
        r_hazard_b = 1'b0;
        r_wb_acc   = 4'h0;
        r_wb_exe   = 4'h0;
        r_data_mgr = 32'hx;
        r_data_a_mgr = 32'hx;
        r_data_b_mgr = 32'hx;
    end else begin
        r_conflict_map = 6'h0;
        r_pc_sel = 1'b0;
        r_stall = 1'b0;
        r_hazard_a = 1'b0;
        r_hazard_b = 1'b0;
        if (instr_wb[11:7] == instr_de[19:15]) begin
            r_conflict_map[5] = 1'b1;
        end if (instr_wb[11:7] == instr_de[24:20]) begin
            r_conflict_map[4] = 1'b1;
        end 
        if (instr_acc[11:7] == instr_de[19:15]) begin
            r_conflict_map[3] = 1'b1;
        end if (instr_acc[11:7] == instr_de[24:20]) begin
            r_conflict_map[2] = 1'b1;
        end 
        if (instr_exe[11:7] == instr_de[19:15]) begin
            r_conflict_map[1] = 1'b1;
        end if(instr_exe[11:7] == instr_de[24:20]) begin
            r_conflict_map[0] = 1'b1;
        end
        if (r_conflict_map[1] || r_conflict_map[0]) begin
            r_wb_exe = write_back_check(instr_exe);
            case (r_wb_exe)
                3'b00: begin
                    r_stall = 1'b1;
                    r_data_mgr = 32'hx;
                end
                3'b01: begin
                    r_data_mgr = alu_out_exe;
                end
                3'b10: begin
                    r_data_mgr = pc_exe + 1'b1;
                end
                default: begin
                    r_data_mgr = 32'hx;
                end
            endcase
            if (r_conflict_map[1] && r_wb_exe != 3'b11) begin
                r_data_a_mgr = r_data_mgr;
                r_hazard_a = 1'b1;
            end else if (r_conflict_map[0] && r_wb_exe != 3'b11) begin
                r_data_b_mgr = r_data_mgr;
                r_hazard_b = 1'b1;
            end
        end 
        if (r_conflict_map[3] || r_conflict_map[2]) begin
            r_wb_acc = write_back_check(instr_acc);
            case (r_wb_acc)
                3'b00: begin
                    r_data_mgr = dmem_out_acc;
                end
                3'b01: begin
                    r_data_mgr = alu_out_acc;
                end
                3'b10: begin
                    r_data_mgr = pc_4_acc;
                end
                default: begin
                    r_data_mgr = 32'hx;
                end
            endcase
            if (r_conflict_map[3] && !r_conflict_map[1] &&  r_wb_acc != 3'b11) begin
                r_data_a_mgr = r_data_mgr;
                r_hazard_a = 1'b1;
            end else if (r_conflict_map[2] && !r_conflict_map[0] &&  r_wb_acc != 3'b11) begin
                r_data_b_mgr = r_data_mgr;
                r_hazard_b = 1'b1;
            end
        end
        if (r_conflict_map[5] || r_conflict_map[4]) begin
            r_wb_wb = write_back_check(instr_wb);
            if (r_conflict_map[5] && !r_conflict_map[3] && !r_conflict_map[1] &&  r_wb_wb != 3'b11) begin
                r_data_a_mgr = data_d_wb;
                r_hazard_a = 1'b1;
            end else if (r_conflict_map[4] && !r_conflict_map[2] && !r_conflict_map[0] &&  r_wb_wb != 3'b11) begin
                r_data_b_mgr = data_d_wb;
                r_hazard_b = 1'b1;
            end
        end
        /*
        case (instr_fetch[6:0])
            // JAL Instruction:
            7'b1101111: begin
            end
            // JALR Instruction:
            7'b1101111: begin
            end
        */
       case (instr_exe[6:0])
            // JAL Instruction:
            7'b1101111: begin
                r_pc_sel <= 1'b1;
                r_stall <= 1'b1;
            end
            // JALR Instruction:
            7'b1101111: begin
                r_pc_sel <= 1'b1;
                r_stall <= 1'b1;
            end
            7'b1100011: begin
                if (br_success)
                    r_pc_sel <= 1'b1;
                    r_stall <= 1'b1;
            end
            default: r_pc_sel <= 1'b0;
        endcase
    end
end



endmodule
