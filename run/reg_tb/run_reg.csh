# Compile Project
iverilog -g2012 -o reg -c ../link/reg/reg_file_list.txt
vvp reg 
gtkwave reg_tb.vcd &
