.data 0x0000				      		
	buf: .word 0x0000
.text 0x0000
main:
		
	addi $2, $2, 0xFFFFF000
	#lui   $3,0xFFFF			
        #ori   $2,$3,0xF000
		
start:

	
	# addi $1, $1, 1
	lw $1, 0xC70($2)
	sw $1, 0xC60($2)
	
	j start