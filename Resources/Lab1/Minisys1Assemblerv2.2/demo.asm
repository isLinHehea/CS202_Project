.data 0x0000
	buf: .word 0x0000
.text  0x0000
main:
    lui   $1,0xFFFF			
	ori   $1,$1,0xF000 # 0xFFFF_F000 prepared for I/O in $1

start:
    jal loadword
    jal display
	jal off
    j start 

loadword:
	lui $t5,0xaa
	add $t6,$0,$0 #cnt
loop3:
	beq  $t5, $t6, jra
	lw $2,0xC70($1) # modify here !!!!!!!!!!!!!!!!!!!!!
	addi $t6,$t6,1
	j loop3


display:
	# 2 secs
	lui $t5,0x3f
	add $t6,$0,$0 #cnt
loop2:
	beq  $t5, $t6, jra
	sw $2,0xC50($1) # modify here !!!!!!!!!!!!!!!!!!!!!
	addi $t6,$t6,1
	j loop2

off:
	# 2 secs
	lui $t5,0x3f
	add $t6,$0,$0 #cnt
loop4:
	beq  $t5, $t6, jra
	sw $0,0xC50($1) # modify here !!!!!!!!!!!!!!!!!!!!!
	addi $t6,$t6,1
	j loop4
	
jra:   
	jr  $ra
