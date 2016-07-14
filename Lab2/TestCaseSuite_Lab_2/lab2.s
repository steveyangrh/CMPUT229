#---------------------------------------------------------------
# Assignment:           2
# Due Date:             January 30, 2015
# Name:                 Ronghao(Steve) Yang
# Unix ID:              ryang  1434313
# Lecture Section:      B1
# Instructor:           Jeeva
# Lab Section:          Monday 1400 - 1700
#---------------------------------------------------------------

#---------------------------------------------------------------
#The main function takes a input and output its converted endianess number
#Register Usage:
#---------------------------------------------------------------

.data  #indicate data 
    bgez1: 	       .asciiz "bgez "
	bgezal1:       .asciiz "bgezal "
	bltz1:	       .asciiz "bltz "
	bltzal1:       .asciiz "bltzal "
	beq1:	       .asciiz "beq "
	bne1:	       .asciiz "bne "
	blez1:	       .asciiz "blez "
	bgtz1:	       .asciiz "bgtz "
	dex1:	       .asciiz " 0x"
	doa1:	       .asciiz " $"
	dot1:	       .asciiz ", "
	
   
	

	.text  #enable the input/output data



disassembleBranch:
	lw $t0,0($a0)		#load the instruction into register $t0
	srl $t1,$t0,29		#shift t0 29 bits to the right
	bne $t1,$zero,exit	#if t1 is not 0 jumps to exit
	srl $t1,$t0,28		#shift t0 28 bits to the right
	li $t2,0x1		#assign 1 to the register $t2
	beq $t1,$zero,L1	#if the forth dight is 0,jumps to L1
	beq $t1,$t2,L2		#if the forth digit is 1,jumps to L2
	


#L1 checks if the instruction is a branch intruction when the first four digits are 0000
L1:
	srl $t1,$t0,26			#shift t0 26 bits to the right
	bne $t1,$t2,exit		#see if the first 6 bits are 000001,if not,jumps to exit
	li $t3,0xFC1F0000		#create $t3 as a musk
	and $t4,$t0,$t3			#use and operator to get the exact bits in the instruction
	li $t2,0x04010000	 	#check if it's bgez
	beq $t4,$t2,L11			#if it's bgez,jumps to L11
	li $t2,0x04110000		#check if it's bgezal
	beq $t4,$t2,L12 		#if it's bgezal,jumps to L12
	li $t2,0x04000000		#check if it's bltz
	beq $t4,$t2,L13			#if it's bltz,jumps to L13
	li $t2,0x04100000		#check if it's bltzal
	beq $t4,$t2,L14			#if it's bltzal,jumps to L14
	j exit				#if the instruction is none of the above,jumps to exit



#bgez instruction
L11:
	la $a0,bgez1
	li $v0,4
	syscall				#print bgez
	j L15

#bgezal instruction
L12:
	la $a0,bgezal1			#print bgezal
	li $v0,4
	syscall
	j L15

#bltz instruction
L13:
	la $a0,bltz1			#print bltz
	li $v0,4
	syscall
	j L15


#bltzal instruction
L14:
	la $a0,bltzal1			#print bltzal
	li $v0,4
	syscall
	

L15:	
	la $a0,doa1
	li $v0,4
	syscall                         #print bgez $
	
	li $t1,0x03E00000
	and $t1,$t1,$t0
	srl $t1,$t1,21
	add $a0,$t1,$zero
	li $v0,1
	syscall                         #print bgez $reister
	
	li $t1,0x0000FFFF
	and $t1,$t1,$t0
	sll $t1,$t1,2
	addi $t2,$t0,4
	add $t1,$t1,$t2                 #now t1 contains the final address
	la $a0,dot1
	li $v0,4
	syscall                         #print bgez $register,
	
	la $a0,dex1
	li $v0,4
	syscall                         #print bgez $register, 0x
	
	addi $t3,$zero,0x9              #assign A to the register t3
		
	li $s2,0xF0000000
	and $t2,$t1,$s2
	srl $t2,$t2,28                  #t2 has the first four bits of the address
	
	sub $t4,$t3,$t2
	bgez $t4,L111                   #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L112
L111:
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L112:	
	li $s2,0x0F000000
	and $t2,$t1,$s2
	srl $t2,$t2,24                  #t2 has the second four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1121                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L113
	
L1121:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L113:	
	li $s2,0x00F00000
	and $t2,$t1,$s2
	srl $t2,$t2,20                  #t2 has the third four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1131                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L114

L1131:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L114:
	li $s2,0x000F0000
	and $t2,$t1,$s2
	srl $t2,$t2,16                  #t2 has the forth four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1141                   #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L115
L1141:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L115:	
	li $s2,0x0000F0000
	and $t2,$t1,$s2
	srl $t2,$t2,12                  #t2 has the fifth four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1151                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L116
L1151:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L116:
	li $s2,0x00000F00
	and $t2,$t1,$s2
	srl $t2,$t2,8                   #2 has the sixth four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1161                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L117
L1161:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L117:	
	li $s2,0x000000F0
	and $t2,$t1,$s2
	srl $t2,$t2,4                   #t2 has the seventh four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1171                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L118
L1171:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L118:	
	li $s2,0x0000000F
	and $t2,$t1,$s2          #t2 now has the last four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1181                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j exit

L1181:
	addi $a0,$t2,48
	li $v0,4
	syscall
	j exit

		
#L2 checks if the instruction is a branch intruction when the first four digits are 0001
L2:
	li $t3,0xFC000000		#create $t3 as a must 
	and $t4,$t0,$t3			#use and operator to get the exact first 6 bits
	li $t2,0x10000000
	beq $t4,$t2,L21			#if it's beq, go to L21
	li $t2,0x14000000
	beq $t4,$t2,L21			#if it's bne, go to L21
	li $t3,0xFC1F0000		#create t3 as a musk
	and $t4,$t0,$t3 		#use and operator to get the exact bits
	li $t2,0x18000000
	beq $t4,$t2,L23			#if it's blez, go to L23
	li $t2,0x1C000000
	beq $t4,$t2,L24			#if it's bgtz, go to L24
	j exit


#beq instruction
L21:
	la $a0,beq1
	li $v0,4
	syscall
	j L25


#bne instruction
L22:
	la $a0,bne1
	li $v0,4
	syscall
	j L25

#blez instruction
L23:
	la $a0,blez1
	li $v0,4
	syscall
	j L25

#bgtz instruction
L24:
	la $a0,bgtz1
	li $v0,4
	syscall

L25:
	
	la $a0,doa1
	li $v0,4
	syscall                         #print instruction $

	li $t1,0x03E00000
	and $t1,$t1,$t0
	srl $t1,$t1,21
	add $a0,$t1,$zero
	li $v0,1
	syscall                         #print instruction $reister

	la $a0,dot1
	li $v0,4
	syscall                         #print instruction $register,

	la $a0,doa1
	li $v0,4
	syscall                         #print instruction $register, $

	li $t1,0x001F0000
	and $t1,$t1,$t0
	srl $t1,$t1,16
	add $a0,$t1,$zero
	li $v0,1
	syscall				#print out instruction $register, $register

	la $a0,dot1
	li $v0,4
	syscall				#print out instruction $register, $register,

	
	li $t1,0x0000FFFF
	and $t1,$t1,$t0
	sll $t1,$t1,2
	addi $t2,$t0,4
	add $t1,$t1,$t2                 #now t1 contains the final address


	addi $t3,$zero,0x9              #assign A to the register t3

	li $s2,0xF0000000
	and $t2,$t1,$s2
	srl $t2,$t2,28                  #t2 has the first four bits of the address
	
	sub $t4,$t3,$t2
	bgez $t4,L121                   #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L122
L121:
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L122:	
	li $s2,0x0F000000
	and $t2,$t1,$s2
	srl $t2,$t2,24                  #t2 has the second four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1221                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L123
	
L1221:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L123:	
	li $s2,0x00F00000
	and $t2,$t1,$s2
	srl $t2,$t2,20                  #t2 has the third four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1231                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L124

L1231:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L124:
	li $s2,0x000F0000
	and $t2,$t1,$s2
	srl $t2,$t2,16                  #t2 has the forth four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1241                   #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L125
L1241:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L125:	
	li $s2,0x0000F000
	and $t2,$t1,$s2
	srl $t2,$t2,12                  #t2 has the fifth four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1251                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L126
L1251:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L126:
	li $s2,0x00000F00
	and $t2,$t1,$s2
	srl $t2,$t2,8                   #2 has the sixth four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1261                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L127
L1261:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L127:	
	li $s2,0x000000F0
	and $t2,$t1,$s2
	srl $t2,$t2,4                   #t2 has the seventh four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1271                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j L128
L1271:	
	addi $a0,$t2,48
	li $v0,4
	syscall
	
L128:	
	li $s2,0x0000000F
	and $t2,$t1,$s2		        #t2 now has the last four bits of the address
	sub $t4,$t3,$t2
	bgez $t4,L1281                  #if the 4 bits is a number, jumps to L111
	addi $a0,$t2,55
	li $v0,4
	syscall
	j exit

L1281:
	addi $a0,$t2,48
	li $v0,4
	syscall
	j exit
	
#exit the program and jumps to the return address
exit:
	jr $ra
