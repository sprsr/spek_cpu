.global tmp0
tmp0:	
        ori 	x3, x3, 2
        ori 	x3, x3, 4
        # Testing conditional branckes
        xor 	x2, x2, x2
        addi    x3, x2, 8
        addi    x4, x2, 8
        # Test conditionals with rboth registers = 0x8
        beq     x3, x4, tmp1
        ori     x2, x2, 1
tmp1:	
        bne     x3, x4, tmp2        
        ori     x2, x2, 2
tmp2:	
        blt     x3, x4, tmp3        
        ori     x2, x2, 4
tmp3:	
        bge     x3, x4, tmp4        
        ori     x2, x2, 8
tmp4:	
        bltu 	x3, x4, tmp5        
        ori     x2, x2, 10
tmp5:	
        bgeu 	x3, x4, tmp6        
        ori     x2, x2, 20
tmp6:
        xor 	x2, x2, x2
