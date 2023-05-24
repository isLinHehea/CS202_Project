.data
	str:	.asciiz "Wecome to MIPS world:)"

.text
main:
	li $v0,4
	la $a0,str
	syscall
	
	li $v0,10
	syscall