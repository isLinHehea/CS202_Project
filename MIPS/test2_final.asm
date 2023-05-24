.data 0x0000
	buf: .word 0x0000
.text  0x0000
main:
	lui   $1,0xFFFF			
	ori   $1,$1,0xF000 # 0xFFFF_F000 prepared for I/O in $1
	ori	$sp,$sp,0xFFFF
	addi $30,$0,0x80 # judge case
	addi $26,$0,0x40 # judge input A
	addi $27,$0,0x20 # judge input B

forever:
	lw $t1, 0XC70($1) # input the testcase id
	and $v0,$t1,$30 # if the 8th bit is 1, the case number is read.
	beq $v0,$30,select
	sw $t1, 0XC60($1)
	j forever


select:
	addi $s0,$0,0 # clear $s0
	addi $s1,$0,1 # clear $s1
	addi $s2,$0,2 # clear $s2
	addi $s3,$0,3 # clear $s3
	addi $s4,$0,4 # clear $s4
	addi $s5,$0,5 # clear $s5
	addi $s6,$0,6 # clear $s6
	addi $s7,$0,7 # clear $s7

	#select the case
	sll $t1,$t1,29 # clear the rest bits
	srl $t1,$t1,29 # get the last 3 bits 
	beq $t1, $s0,case0
	beq $t1, $s1,case1
	beq $t1, $s2,case2
	beq $t1, $s3,case3
	beq $t1, $s4,case4
	beq $t1, $s5,case5
	beq $t1, $s6,case6
	beq $t1, $s7,case7
	j forever

loadword1:
	lw $t2, 0XC70($1) #a
	and $t4,$t2,$26 # if the 7th bit is 1, the number is read.
	beq $t4,$26,back1 # whether I finish reading
	j loadword1
	
loadword2:
	lw $t3, 0XC70($1) #b
	and $t4,$t3,$27 # if the 6th bit is 1, the number is read.
	beq $t4,$27,back2
	j loadword2
	
back1:
	srl $t2,$t2,8 # the switch is in high 8 bits, so shift right 8 bits
	jr $ra

back2:
	srl $t3,$t3,8
	jr $ra

#input a  signed number a, and out put the sum of 1 to a, if a is negative, give a blinking prompt
case0:
 jal loadword1 # a in $t2
 and $v0,$t2,$30 # sign bit
#  srl $v0,$t2,7
 add $t6,$0,$0 # cnt for on
 add $t8,$0,$0 # cnt for off
 #addi $t7,$t7,30000 # delay constant
 # lui $t7,0x000F
 lui $t7,0x3F

 bne $v0 ,$0 ,on # a<0
 add $t4,$0,$0 # cnt for calculate
 add $t5,$0,$0 # sum


sum0: 
 beq $t4,$t2,print0 # sum = 1+2+...+a print sum
 addi $t4,$t4,1
 add $t5,$t5,$t4
 j sum0

print0:
 sw $t5, 0XC60($1) # print sum
 j forever

on: 
 beq $t6,$t7,off
 sw $t2, 0XC60($1)
 addi $t6,$t6,1
 # addi $t6,$t6,-1
 # addi $t6,$t6,1
 j on

off:
 # do nothing, just delay
 beq $t8,$t7,forever
 sw $0, 0XC60($1) ###
 addi $t8,$t8,1
 # addi $t6,$t6,1
 # addi $t6,$t6,-1
 j off
 # sw $t2, 0XC62($31) # what is 62 ?
 # j forever

#input an unsigned number a, recursively calculate the sum of 1 to a,display the times the stack was pushed and popped
case1:
	jal loadword1
	add $a0,$t2,$0 #put a in $a0 !!!!!
	add $t3,$0,$0 #pushed times
	add $t4,$0,$0 #popped times
	jal sum1
	add $t5,$t3,$t4 # the sum of pushed and popped times
	sw $t5, 0XC60($1) 
	j forever
	
sum1:
	 addi $sp, $sp, -8
 	 sw $ra, 4($sp)
	 sw $a0, 0($sp)
	 addi $t3,$t3,1#push
	 slti $t0, $a0, 1 #compare $a0 and 1 if $ao >= 1 continue
	 beq $t0, $zero, L2
	 addi $v0, $zero, 0
	 addi $sp, $sp, 8
	 addi $t3,$t3,-1
	 jr $ra
L2:
	 addi $a0, $a0, -1
	 jal sum1
	 
	 lw $a0, 0($sp)
	 lw $ra, 4($sp)
 	 addi $sp, $sp, 8
 	 addi $t4,$t4,1#pop
	 add $v0, $a0, $v0
	 
 	 jr $ra


display:
	# 2 secs
	lui $t5,0xaa
	add $t6,$0,$0 #cnt
loop2:
	beq  $t5, $t6, jra
	sw $a0,0XC60($1) # modify here !!!!!!!!!!!!!!!!!!!!!
	addi $t6,$t6,1
	j loop2
	
jra:   
	jr  $ra
 	 	
#input an unsigned number a, recursively calculate the sum of 1 to a,display every pushed arguments 2-3s	 	 	 	 	
case2:
	jal loadword1
	add $a0,$t2,$0 #put a in $a0 !!!!!
	#li $t3,0 #pushed times
	#li $t4,0 #popped times
	 #############
 	 jal display
 	 #############
	jal sum2
	j forever

sum2:
		
	 addi $sp, $sp, -8
 	 sw $ra, 4($sp)
	 sw $a0, 0($sp)
	 addi $t3,$t3,1 #push

	 slti $t0, $a0, 1 #compare $a0 and 1 if $ao >= 1 continue
	 beq $t0, $zero, L3
	 addi $v0, $zero, 0
	 addi $sp, $sp, 8
	 addi $t3,$t3,-1 #push
	 jr $ra
L3:
	 addi $a0, $a0, -1
	 #############
 	 jal display
 	 #############
	 jal sum2
	 lw $a0, 0($sp)
	 #jal display
	 lw $ra, 4($sp)
 	 addi $sp, $sp, 8
 	 #addi $t4,$t4,1#pop
	 add $v0, $a0, $v0
	 
 	 jr $ra


	
#input an unsigned number a, recursively calculate the sum of 1 to a,display every  popped arguments 2-3s	 	 	 	 	
case3:
	jal loadword1
	add $a0,$t2,$0 #put a in $a0 !!!!!
	#li $t3,0 #pushed times
	#li $t4,0 #popped times
	jal sum3
	j forever
	
sum3:
	 addi $sp, $sp, -8
 	 sw $ra, 4($sp)
	 sw $a0, 0($sp)
	 addi $t3,$t3,1 #push
	 slti $t0, $a0, 1 #compare $a0 and 1 if $ao >= 1 continue
	 beq $t0, $zero, L4
	 addi $v0, $zero, 0
	 addi $sp, $sp, 8
	 addi $t3,$t3,-1
	 jr $ra
L4:
	 addi $a0, $a0, -1
	 jal sum3	
	 lw $a0, 0($sp)
	 #############
 	 jal display
 	 #############
	 lw $ra, 4($sp)
 	 addi $sp, $sp, 8
 	 addi $t4,$t4,1 #pop
	 add $v0, $a0, $v0
 	 jr $ra



#input a and b, then calculate a + b and judge overflow
case4:
	jal loadword1
	jal loadword2
	and $t5, $t2,$30 #the sign of a
	and $t6, $t3,$30 #the sign of b
	# srl $t5,$t2,7
	# srl $t6,$t3,7

	sll $t2,$t2,24
	sll $t3,$t3,24
	sra $t2,$t2,24
	sra $t3,$t3,24 # sign extension

startadd:
	add $t4, $t2,$t3 # t4 is the sum
	and $t7, $t4,$30 #the sign of c in t7
	# srl $t7,$t4,7  
	jal checkOverflow1 # !!!!!!!
	########
	sw $t4,0XC60($1) #output in the format{sum, OverfolwBit}
	j forever

checkOverflow1:
	beq $t5,$t6,judgeSign1 #if the sign of a is samewith b
	j noOverflow

judgeSign1:
	beq $t5,$t7,noOverflow # sum's sign unchanged
	# now it is overflow
	sll $t4,$t4,8 
	ori $t4,$t4,1 # modify here !!!!! LSB is 1 means overflow
	jr $ra
	
noOverflow:
	sll $t4,$t4,8 # display in the left 8 leds
	jr $ra
	

	
#input a and b, then calculate a - b and judge overflow
case5:
	jal loadword1
	jal loadword2
	and $t5, $t2,$30 #the sign of a
	and $t6, $t3,$30 #the sign of b
	# srl $t5,$t2,7
	# srl $t6,$t3,7

	sll $t2,$t2,24
	sll $t3,$t3,24
	sra $t2,$t2,24
	sra $t3,$t3,24 # sign extension
	

startsub:
	sub $t4, $t2,$t3 # t4 is the minus
	and $t7, $t4,$30
	# srl $t7,$t4,7  #the sign of c in t7
	jal checkOverflow2 # !!!!!!!
	########
	sw $t4,0XC60($1) #output in the format{sum, OverfolwBit}
	j forever

checkOverflow2:
	bne $t5,$t6,judgeSign2 #if the sign of a is different from b
	j noOverflow

judgeSign2:
	bne $t6,$t7,noOverflow 
	# now it is overflow # b's sign = result's sign
	sll $t4,$t4,8 # maybe sll 8 bits to display in the left 8 leds????!!!!!!!!!
	#addi $t5,$t5,1
	ori $t4,$t4,1 # modify here !!!!!!!!!!!!!!!!!!!!! 1 means overflow
	jr $ra
	

#input two number a and b, calculate a*b and output the answer	#######################
case6:
	jal loadword1 # a in $t2
	jal loadword2 # b in $t3
	and $t5, $t2,$30 #the sign of a
	and $t6, $t3,$30 #the sign of b
	# srl $t5,$t2,7
	# srl $t6,$t3,7
	xor $t7,$t5,$t6 #the sign of product
	#product is negative, t7 = 1,  positive: t7 =0

	# get absolute value of a and b
	jal absolute1
	jal absolute2
	j startMul

absolute1:
	beq $t5,$0,absback1 # a is positive
	xori $t2, $t2,0xFF # 1's complement, 8 bits
	addi $t2,$t2,1 # 2's complement
absback1:
	jr $ra

absolute2:
	beq $t6,$0,absback2 # b is positive
	xori $t3, $t3,0xFF # 1's complement, 8 bits
	addi $t3,$t3,1 # 2's complement
absback2:
	jr $ra


startMul:
	jal multiply

	# if $t7 != 0, product is negative, 2's complement
	bne $t7,$0,negative
	# if $t7 = 1, product is positive, do nothing
	sw $t4,0XC60($1)
	j forever

negative:
	xori $t4, $t4,0xFFFF # 1's complement, 16 bits
	addi $t4,$t4,1 # 2's complement
	sw $t4,0XC60($1) # pay attention to address !!!!!!!!!!!!!!
	j forever
	

multiply:
	# t2 is a, t3 is b
	add $s0,$0,$0 # cnt
	addi $s1,$0,8 # 8 times maybe fine
	add $t4,$0,$0 # product

loopMul:	
	addi $s0,$s0,1 # cnt++
	# the result in $t4
	# $t2 is 16-bit multiplicand, shift left
	# $t3 is 8-bit multiplier, shift right
	
	andi $s2, $t3, 1 #take the LSB of multiplier
	beq $s2, $0, next # if it is 0, do nothing
	add $t4,$t4,$t2 # it is 1, add multiplicand to product

next: 	
	
	sll $t2,$t2,1 # shift the multiplicand left
	srl $t3,$t3,1 #shift multiplier right
	beq $s0,$s1, exitmul # 8 loops !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	j loopMul

exitmul:
	jr $ra


#input two number a and b, calculate a / b and display the quotient and remainder alternately(5s)
case7:
	jal loadword1
	jal loadword2
	and $t5, $t2,$30 #the sign of a, also the sign of remainder
	and $t6, $t3,$30 #the sign of b
	# srl $t5,$t2,7 #the sign of a, 
	# srl $t6,$t3,7 #the sign of b
	add $s0, $0,$0 #quotient
	#The quotient is +, if the signs of divisor and dividend agrees, otherwise, quotient is -
	#The sign of the remainder matches that of the dividend!!!!!
	xor $s2,$t5,$t6
	#s2: the sign of quotient
	jal absolute1
	jal absolute2


startDiv:
##############
	add $s3,$0,$0 # cnt
	addi $s4,$0,9 # 9 loop times
	
	# assume are in $t2 (initially dividend) and $t3 (divisor)
	# $t2 is 16-bit divisor (place at left), shift right
	# $9 is 8-bit quotient, shift left
	sll $t3,$t3,8 #Initially divisor in left half!!

loopDiv:
	addi $s3,$s3,1 # cnt++
	sub $t2,$t2,$t3 # subtract divisor from remainder
	slt $v0, $t2, $0
	beq $v0,$0,next1 # not less than 0, next
	add $t2,$t2,$t3 #less than 0 ,add back
	sll $s0,$s0,1 # shift quotient left, set rightmost to 0
	j next2
	
next1: # is 1 
	# shift quotient left, set rightmost to 1
	sll $s0,$s0,1
	ori $s0,$s0,1
next2:
	srl $t3,$t3,1 # shift divisor right 1 bit
	beq $s3,$s4, end # is 9 loops?
	j loopDiv
end:
	# quotient in s0, remainder in t2
	# t5: the sign of remainder
	# s2: sign of quotient
	jal quoSign
	jal remSign
	# to be displayed!!!
	add $t8,$0,$0 # cnt for display
	add $t9,$0,$0 # delay constant
	lui $t9,0xff
	#ori $t9,$t9,0xd090 # t9: 250000

	jal quo
	j forever


	# each loop has 4 instructions, 4 * 250000 = 1000000 cycles ~ 5s
quo:
	# display quotient
	beq $t8,$t9,rem # 5s
	sw $s0,0XC60($1)
	addi $t8,$t8,1
	j quo

rem:
	# display remainder
	beq $t8,$0,jra # 5s
	sw $t2,0XC60($1)
	addi $t8,$t8,-1
	j rem


quoSign:
	# quotient in s0
	# s2: sign of quotient
	beq $s2,$0,exitQuoSign # positive
	# negative, 2's complement
	xori $s0,$s0, 0xFF 
	addi $s0,$s0,1 
exitQuoSign:
	jr $ra

remSign:
	#remainder in t2	
	# t5: the sign of remainder
	beq $t5,$0,exitRemSign # positive
	# negative, 2's complement
	xori $t2,$t2, 0xFF #
	addi $t2,$t2,1
exitRemSign:
	jr $ra
############

