.data

.text
lw $t1, 0XC70($31) # input the testcase id

#select the case

beq $t1,0,case0
beq $t1,1,case1
beq $t1,2,case2
beq $t1,3,case3
beq $t1,4,case4
beq $t1,5,case5
beq $t1,6,case6
beq $t1,7,case7
j Exit


# enter a number, judge if a power of 2 , if yes, light on
case0: 
	lw $t2, 0XC70($31) #load the eight bit data from io
	li $t3, 0
	li $t5, 0
loop0:	#judge if power of 2, is only one bit is 1, other is 0 , it is a power of 2
	beq $t5, 8, judge0
	lb $t4 , ($t2)
	addi $t2, $t2, 1
	addi $t5, $t5, 1
	beq $t4 , 1 ,case0Cnt
	j loop0
	
	case0Cnt:
	addi $t3,$t3,1
	j loop0

judge0:
	beq $t3 ,1 , printYes # is cnt  is 1, is a power of 2 
		
printNo:
	sll $t3,$t2,1# the format is {a,tag} , can be change
	sw $t3,  0XC60($31)
	j Exit
printYes:
	sll $t3,$t2,1
	addi $t2,$t2,0
	sw $t3,  0XC60($31)
	j Exit
	
	
##enter a number, judge if  odd , if yes, light on	
case1:
	lw $t2, 0XC70($31)
	rem $t3,$t3,2
	beq $t3,1, printYes
	j printNo

#enter two number a and b, and display it
case7:
	lw $t2, 0XC70($31)#a
	lw $t3, 0XC70($31)#b
	sll $t4,$t2,8
	add $t4, $t4,$t3#display in the format of {a,b}
	sw $t4,  0XC60($31)
	j Exit

#firsr run case7 and then calculate the bitwise or
case2:
	lw $t2, 0XC70($31)#a
	lw $t3, 0XC70($31)#b
	sll $t4,$t2,8
	add $t4, $t4,$t3#display in the format of {a,b}
	sw $t4,  0XC60($31)
	or $t4,$t2,$t3
	sw $t4,  0XC60($31)
	j Exit
	
#firsr run case7 and then calculate the bitwise nor			
case3:
	lw $t2, 0XC70($31)#a
	lw $t3, 0XC70($31)#b
	sll $t4,$t2,8
	add $t4, $t4,$t3#display in the format of {a,b}
	sw $t4,  0XC60($31)
	nor $t4,$t2,$t3
	sw $t4,  0XC60($31)
	j Exit

#firsr run case7 and then calculate the bitwise xor			
case4:
	lw $t2, 0XC70($31)#a
	lw $t3, 0XC70($31)#b
	sll $t4,$t2,8
	add $t4, $t4,$t3#display in the format of {a,b}
	sw $t4,  0XC60($31)
	xor $t4,$t2,$t3
	sw $t4,  0XC60($31)
	j Exit
	
	
#firsr run case7 and then calculate the SLT in a, b	
case5:
	lw $t2, 0XC70($31)#a
	lw $t3, 0XC70($31)#b
	sll $t4,$t2,8
	add $t4, $t4,$t3#display in the format of {a,b}
	sw $t4,  0XC60($31)
	slt $t4,$t2,$t3
	sw $t4,  0XC60($31)
	j Exit
	
	#firsr run case7 and then calculate the SLTU  in a, b	
case6:
	lw $t2, 0XC70($31)#a
	lw $t3, 0XC70($31)#b
	sll $t4,$t2,8
	add $t4, $t4,$t3#display in the format of {a,b}
	sw $t4,  0XC60($31)
	sltu $t4,$t2,$t3
	sw $t4,  0XC60($31)
	j Exit
	
	
Exit:
