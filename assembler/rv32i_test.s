# Clear x1 x2
xor x1, x1, x1
xor	x2, x2, x2
# Set x1 to 1
addi	x1, x1, 1 
# do some adds
add 	x2, x1, x1
add 	x2, x2, x1
add 	x2, x1, x2
# test lui
lui     x2, 0xFFFFF
# Testing shift immediates
srai 	x2,x2,2
srli 	x2,x2,4
slli 	x2,x2,2

# auipc
AUIPC   x2, 0x12345
#load to x7
lui     x7, 0x10000

# Test stores
sb      x2, 0(x7)
sb      x2, 1(x7)
sb      x2, 2(x7)
sb      x2, 3(x7)

# load ass word
lw	x3, 0(x7)
# store half word x2
sh      x2, 0(x7)
sh      x2, 2(x7)
# load ass word
lw	x3, 0(x7)
# new test val
lui     x2, 0x89ABD
addi    x2, x2, 0xFFFFFDEF
# store in ram
sw      x2, 0(x7)
# load back as word
lw      x3, 0(x7)
# test half word load
lh      x2, 0(x7)
lh      x2, 2(x7)
# test load byte
lb      x2, 0(x7)
lb      x2, 1(x7)
lb      x2, 2(x7)
lb      x2, 3(x7)
# test unsigned half load
lhu     x2, 0(x7)
lhu     x2, 2(x7)
# test unsigned byte load
lbu     x2, 0(x7)
lbu     x2, 1(x7)
lbu     x2, 2(x7)
lbu     x2, 3(x7)

#setup
lui	x2, 0x66666
addi	x2, x2, 0x666

lui	x3, 0xCCCCD
addi	x3, x3, 0xFFFFFCCC

# reg to reg

add	x4, x2, x3
add	x4, x3, x2
sub	x4, x2, x3
sub	x4, x3, x2
sll	x4, x2, x3
sll	x4, x3, x2
slt	x4, x2, x3
slt	x4, x3, x2
sltu	x4, x2, x3
sltu	x4, x3, x2
xor	x4, x2, x3
xor	x4, x3, x2
srl	x4, x2, x3
srl	x4, x3, x2
sra	x4, x2, x3
sra	x4, x3, x2
or	x4, x2, x3
or	x4, x3, x2
and	x4, x2, x3
and	x4, x3, x2


# reg reg immeidiate
addi	x4, x3, 0x666
slti	x4, x3, 0x666
sltiu	x4, x3, 0x666
xori 	x4, x3, 0x666
ori 	x4, x3, 0x666
andi 	x4, x3, 0x666
slli 	x4, x3, 6
srli 	x4, x3, 6
srai 	x4, x3, 6

#relative jmp
andi 	x3, x0, 0
jal     x4, x100 

#x100
ori 	x3, x3, 2
ori 	x3, x3, 4
# prep conditional branches
xor 	x2, x2, x2
addi    x3, x2, 0x8
addi    x4, x2, 0x8

# Test conditionals with rboth registers = 0x8
beq     x3, x4, 0x150 
ori     x2, x2, 1
#0x150
bne     x3, x4, 0x200        
ori     x2, x2, 2
#0x200
blt     x3, x4, 0x250        
ori     x2, x2, 4
#0x250
bge     x3, x4, 0x300
ori     x2, x2, 8
#0x300
bltu 	x3, x4, 0x350        
ori     x2, x2, 0x10
#0x350
bgeu 	x3, x4, 0x400        
ori     x2, x2, 0x20
#0x400



