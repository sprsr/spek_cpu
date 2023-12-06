# rv32_processor <br>
A 5 stage pipeline that handles RV32I instructions.  <br>
Current Status: 5 stage pipeline is implemented.<br> 
Testbench is in progress. The following instructions have been loosely verified to work: <br>
Repition of ADDI Instruction. <br>
Datapath Pipeline <br>
![Alt text](https://github.com/sprsr/rv32_processor/blob/main/diagrams/block_diagrams/Datapath%20Pipeline.png)
ADDI Waveform <br>
![Alt text](https://github.com/sprsr/rv32_processor/blob/fa0ad4a512a3f50206afd149f270ab276eb7d999/diagrams/waveform/rv32_addi_instruction_testbench.png) <br>
<br>
Right Now IMEM is a 4Kb Instruction Cache.  No method of fetching from main memory or dynamic cache transfer <br>
To be added later <br> <br> <br>

Risc V RV32I Instruction Format <br>
Instruction Variants  <br>
Type R, I, S, B, U, J <br>
(Image from RV32I Specification Section 2.3: https://riscv.org/wp-content/uploads/2019/06/riscv-spec.pdf) <br>
![alt text](https://github.com/sprsr/rv32_processor/blob/main/diagrams/standard/rv32i_formats.png) <br>
Immediate Construction Format <br>
Important to the Immediate Generator located in immGen/immGen.v <br>
![alt text](https://github.com/sprsr/rv32_processor/blob/main/diagrams/standard/rv32i_immediate_formats.png)
<br> <br> <br>
Control Unit <br>
pc_sel Signal <br> 
![alt text](https://github.com/sprsr/rv32_processor/blob/main/diagrams/block_diagrams/pc_sel.png)
![alt text](https://github.com/sprsr/rv32_processor/blob/main/diagrams/block_diagrams/pc_sel2.png)

Current Status <br>
11/6/23 : Currently adding instructions into control unit <br>
Control Signals <br>
BrEq	  :  1<br>
BrLT	  :  2<br>
a_sel	  ... <br>
b_sel		... <br>
alu_sel	... <br>
mem_wr	... <br>
RegWEn	... <br>
immSel	... <br>
BrUn	  :  9<br>
pc_sel	:  A<br>
wb_sel  :  B<br><br>
Ctl   1 2 3 4 5 6 7 8 9 A B<br>
LUI	  x	x	0	1	9	0	1	4	x	0	1<br>
AUIPC	x	x	1	1	2	0	1	4	x	0	1<br>
JAL	  x	x	1	1	2	0	1	5	x	1	2<br>
JALR	x	x	0	1	2	0	1	1	x	1	2<br>
BEQ	  0	x	0	0	2	0	0	3	x	0	x<br>
BEQ	  1	x	0	0	2	0	0	3	x	1	x<br>
BNE	  1	x	0	0	2	0	0	3	x	0	x<br>
BNE	  0	x	0	0	2	0	0	3	x	1	x<br>
BLT	  x	0	0	0	2	0	0	3	0	0	x<br>
BLT	  x	1	0	0	2	0	0	3	0	1	x<br>
BGE	  x	0	0	0	2	0	0	3	0	1	x<br>
BGE	  x	1	0	0	2	0	0	3	0	0	x<br>
BLT	  x	0	0	0	2	0	0	3	1	0	x<br>
BLT	  x	1	0	0	2	0	0	3	1	1	x<br>
BGE	  x	0	0	0	2	0	0	3	1	1	x<br>
BGE	  x	1	0	0	2	0	0	3	1	0	x<br>
LB	  x	x	0	1	2	0	1	1	0	0	0<br>
LH	  x	x	0	1	2	0	1	1	0	0	0<br>
LW	  x	x	0	1	2	0	1	1	0	0	0<br>
LBU	  x	x	0	1	2	0	1	1	0	0	0<br>
LHU	  x	x	0	1	2	0	1	1	0	0	0<br>
SB	  x	x	0	1	2	1	0	2	0	0	0<br>
SH	  x	x	0	1	2	1	0	2	0	0	0<br>
SW	  x	x	0	1	2	1	0	2	0	0	0<br>
ADDI	x	x	0	1	2	0	1	1	0	0	1<br>
STLI	x	x	0	1	8	0	1	1	0	0	1<br>


FPGA Tests:
Assembly Programs:
https://marz.utk.edu/my-courses/cosc230/book/example-risc-v-assembly-programs/
Assembler:
https://www.riscvassembler.org/
