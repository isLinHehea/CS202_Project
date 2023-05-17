#0xFFFF_FFFC70 : input from 16 switch
#0xFFFF_FFFC60 : output to 16 LED
#0xFFFF_FFFC62 : output to 16 LED and blink


.data

.text
forever:
	lw $t1, 0XC70($31) # input the testcase id
	andi $t2,$t1,0x00000080
	beq $t2,1,select
	j forever

#select the case
select:

beq $t1,0,case0
beq $t1,1,case1
beq $t1,2,case2
beq $t1,3,case3
beq $t1,4,case4
beq $t1,5,case5
beq $t1,6,case6
beq $t1,7,case7
j forever

loadword1:
	lw $t2, 0XC70($31) #a
	andi $t3,$2,0x00000040
	beq $t3,1,back
	j loadword1
	
loadword2:
	lw $t3, 0XC70($31) #b
	andi $t4,$3,0x00000020
	beq $t4,1,back
	j loadword2
	
back:
	jr $ra


#inout a  signed number a, and out put the sum of 1 to a, if a is negative, give a blinking prompt
case0:
	jal loadword1
	srl $t3,$t2,7
	beq $t3 ,1 ,blink
	li $t4,0
	li $t5,0
loop0:	
	beq $t4,$t2,print0
	addi $t4,$t4,1
	add $t5,$t5,$t4
	j loop0
	

blink:
	sw $t2, 0XC62($31)#blink
	j forever

print0:
	sw $t5, 0XC60($31)
	j forever

#input an unsigned number a, recursively calculate the sum of 1 to a,display the times the stack was pushed and popped
case1:
	jal loadword1
	li $t3,0 #pushed times
	li $t4,0 #popped times
	jal sum
	add $t5,$t3,$t4
	sw $t5, 0XC60($31) 
	j forever
	
	
	
sum:
	 addi $sp, $sp, -8
 	 sw $ra, 4($sp)
	 sw $a0, 0($sp)
	 slti $t0, $a0, 1
	 beq $t0, $zero, L1
	 addi $v0, $zero, 0#n<1 return 0
	 addi $sp, $sp, 8
	 jr $ra
L1:
	 addi $a0, $a0, -1
	 addi $t3,$t3,1 #push
	 jal sum
	 addi $t4,$t4,1#pop
	 lw $a0, 0($sp)
	 lw $ra, 4($sp)
 	 addi $sp, $sp, 8
	 add $v0, $a0, $v0
 	 jr $ra

 	 	
#input an unsigned number a, recursively calculate the sum of 1 to a,display every  pushed arguments 2-3s	 	 	 	 	
case2:
	jal loadword1
	#li $t3,0 #pushed times
	#li $t4,0 #popped times
	jal sum1
	j forever
	

sum1:
	 addi $sp, $sp, -8
 	 sw $ra, 4($sp)
	 sw $a0, 0($sp)
	  sw $a0,0XC60($31)#ouput the pushed element
	 jal display # 2- 3 s
	 slti $t0, $a0, 1
	 beq $t0, $zero, L2
	 addi $v0, $zero, 0#n<1 return 0
	 addi $sp, $sp, 8
	 jr $ra
L2:
	 addi $a0, $a0, -1
	 #addi $t3,$t3,1 #push
	 jal sum1
	# addi $t4,$t4,1#pop
	 lw $a0, 0($sp)
	 lw $ra, 4($sp)
 	 addi $sp, $sp, 8
	 add $v0, $a0, $v0
 	 jr $ra

display:
	li $t5, 5000000
	li $t6, 0
loop2:
	beq  $t5, $t6, jra
	addi $t6,$t6,1
	j loop2
	
jra:   jr  $ra
	
#input an unsigned number a, recursively calculate the sum of 1 to a,display every  popped arguments 2-3s	 	 	 	 	
case3:
	jal loadword1
	#li $t3,0 #pushed times
	#li $t4,0 #popped times
	jal sum2
	j forever

		

sum2:
	 addi $sp, $sp, -8
 	 sw $ra, 4($sp)
	 sw $a0, 0($sp)
	 slti $t0, $a0, 1
	 beq $t0, $zero, L3
	 addi $v0, $zero, 0#n<1 return 0
	 addi $sp, $sp, 8
	 jr $ra
L3:
	 addi $a0, $a0, -1
	 #addi $t3,$t3,1 #push
	 jal sum2
	# addi $t4,$t4,1#pop
	 lw $a0, 0($sp)
	  sw $a0,0XC60($31)#ouput the popped element
	 jal display # 2- 3 s
	 lw $ra, 4($sp)
 	 addi $sp, $sp, 8
	 add $v0, $a0, $v0
 	 jr $ra



#input a and b, then calculate a + b and judge overflow
case4:
	jal loadword1
	jal loadword2
	add $t4, $t2,$t3
	srl $t5,$t2,7#the sign of a
	srl $t6,$t3,7#the sign of b
	srl $t7,$t4,7#the sign of c
	beq $t5,$t6,judge4
	j noOverflow
	
	
judge4:
	beq $t5,$t7,noOverflow
	
Overflow:
	sll $t5,$t4,1
	addi $t5,$t5,1
	sw $t5,0XC60($31)#output in the format{sum, OverfolwBit}
	j forever
	
noOverflow:
	sll $t5,$t4,1
	sw $t5,0XC60($31)
	j Exit
	
#input a and b, then calculate a - b and judge overflow
case5:
	jal loadword1
	jal loadword2
	sub $t4, $t2,$t3
	srl $t5,$t2,7#the sign of a
	srl $t6,$t3,7#the sign of b
	srl $t7,$t4,7#the sign of c
	bne $t5,$t6,judge5
	j noOverflow
	
	
judge5:
	beq $t5,$t7,noOverflow #if the sign of a is samewith b
	j Overflow 

	
#input two number a and b, calculate a*b and output the answer	
case6:
	jal loadword1
	jal loadword2
	mul $t4, $t2,$t3
	sw $t4,0XC60($31)
	j forever
	
#input two number a and b, calculate a / b and display the quotient and remainder alternately(5s)
case7:
	jal loadword1
	jal loadword2
	div $t4, $t2,$t3 #quotient
	rem $t5, $t2,$t3 #remainder
	li $t6 , 0
loop7:	#alternately display 3 times
	beq $t6,3,Exit
	addi $t6,$t6,1
	sw $t4,0XC60($31)
	jal display5s
	sw $t5,0XC60($31)
	jal display5s
	j loop7
	
	
display5s:
	li $t7,115000000
	beq $t7,$zero,jra
	subi $t7,$t7,1
	j display5s

Exit:
