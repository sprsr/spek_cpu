# Compile Project
iverilog -g2012 -o imem -c ../link/imem/imem_file_list.txt
vvp imem 
gtkwave imem_tb.vcd &
