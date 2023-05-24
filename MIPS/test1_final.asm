.data 0x0000
	buf: .word 0x0000
.text  0x0000
main:
	lui   $1,0xFFFF			
	ori   $1,$1,0xF000 # 0xFFFF_F000 prepared for I/O in $1
	addi $30,$0,0x80 # judge case
	addi $26,$0,0x40 # judge input A
	addi $27,$0,0x20 # judge input B

forever:
	lw $t1, 0XC70($1) # input the testcase id
	and $v0,$t1,$30 # if the 8th bit is 1, the case number is read.
	beq $v0,$30,select
	sw $t1, 0XC50($1)
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

# enter a number, judge if a power of 2 , if yes, light on
case0: 
	jal loadword1 # load the number in $t2
	beq $t2,$0,printNo # if a is 0, is not a power of 2
	addi $t3,$t2,-1 # a-1
	and $t4,$t2,$t3 # a&(a-1)
	beq $t4,$0,printYes # if a&(a-1) is 0, is a power of 2
	j printNo
		
printNo:
	sll $v0,$t2,8 # the format is {a,tag} , can be change
	# the last bit is 0
	sw $v0,  0XC60($1)
	j forever
printYes:
	sll $v0,$t2,8
	ori $v0,$v0,1 # the last bit is 1
	sw $v0,  0XC60($1)
	j forever
	
	
#enter a number, judge if  odd , if yes, light on	
case1:
	jal loadword1 # load the number in $t2
	andi $v0,$t2,1 # get the last bit
	bne $v0,$0, printYes # last bit is 1, is odd
	j printNo

#enter two number a and b, and display it
# 两个开关不能同时拨上去，必须先拨一个，再拨下去，再拨另一个
case7:
	
	jal loadword1 # a in $t2
	jal loadword2 # b in $t3
	sll $v0,$t2,8
	or $v0, $v0,$t3 # display in the format of {a,b}
	sw $v0,  0XC60($1)
	j forever

#first run case7 and then calculate the bitwise or
case2:
	# jal loadword1 # a in $t2
	# jal loadword2 # b in $t3
	# sll $t4,$t2,8
	# add $t4, $t4,$t3 #display in the format of {a,b}
	# sw $t4,  0XC60($31)

	# first run case7
	# a is in $t2, b is in $t3
	or $v0,$t2,$t3 
	sw $v0,  0XC60($1)
	j forever
	
#first run case7 and then calculate the bitwise nor			
case3:
	# jal loadword1
	# jal loadword2
	# sll $t4,$t2,8
	# add $t4, $t4,$t3#display in the format of {a,b}
	# sw $t4,  0XC60($31)
	nor $v0,$t2,$t3
	sw $v0,  0XC60($1)
	j forever

#first run case7 and then calculate the bitwise xor			
case4:
	# jal loadword1
	# jal loadword2
	# sll $t4,$t2,8
	# add $t4, $t4,$t3#display in the format of {a,b}
	# sw $t4,  0XC60($31)
	xor $v0,$t2,$t3
	sw $v0,  0XC60($1)
	j forever
	
	
#first run case7 and then calculate the SLT in a, b	
case5:
	# jal loadword1
	# jal loadword2
	# sll $t4,$t2,8
	# add $t4, $t4,$t3#display in the format of {a,b}
	# sw $t4,  0XC60($31)
	# may need some sign extension!!!!!!!!!!!!
	# andi $t5,$t2,0x0080 # get the sign 
	# andi $t6,$t3,0x0080 
	sll $t2,$t2,24 # shift left 8 bits
	sll $t3,$t3,24
	sra $t2,$t2,24 # shift right 24 bits
	sra $t3,$t3,24 # get the sign extension

	slt $v0,$t2,$t3 # slt a,b
	sw $v0,  0XC60($1)
	j forever

# 	jal extend1
# 	jal extend2
# 	##########
# 	slt $t4,$t2,$t3 # slt a,b
# 	sw $t4,  0XC60($31)
# 	j forever

# extend1: # for a
# 	beq $t5,$0,breakExtend1 # 0, no need to extend
# 	ori $t2,$t2,0xFFFFFF00 # 1 extend to 32 bits
# breakExtend1:
# 	jr $ra

# extend2: # for b
# 	beq $t6,0,breakExtend2 # 0, no need to extend
# 	ori $t3,$t3,0xFFFFFF00 # 1 extend to 32 bits	
# breakExtend2:
# 	jr $ra

#first run case7 and then calculate the SLTU  in a, b	
case6:
	# jal loadword1
	# jal loadword2
	# sll $t4,$t2,8
	# add $t4, $t4,$t3#display in the format of {a,b}
	# sw $t4,  0XC60($31)
	sltu $v0,$t2,$t3 # if sltu works!!!!!!!!!!!!!!
	sw $v0,  0XC60($1)
	j forever

