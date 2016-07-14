#---------------------------------------------------------------
# Assignment:           1
# Due Date:             January 24, 2015
# Name:                 Ronghao(Steve) Yang
# Unix ID:              ryang  1434313
# Lecture Section:      B1
# Instructor:           Jeeva
# Lab Section:          Monday 1400 - 1700
#---------------------------------------------------------------

#---------------------------------------------------------------
#The main function takes a input and output its converted endianess number
#Register Usage:
#	$v0:System usage
#	$t0:holds the original integer bytes order	
#   $t1-t4:save the operated numbers
#	$a0:stores the value of the output
#---------------------------------------------------------------

	.data  #indicate that 
	.text  #enable the input/output data

#the main fuction	
main:
	
#load number 5 to the register v0 and read an integer
	li $v0,5	#load number 5 to the register v0
	syscall		#input the data and store the data to v0
	move $t0,$v0	#copy data from v0 to t0


	
#switch the first byte and the last byte, and set the middle two bytes to 0 
	sll $t1,$t0,24	#shift the number left for 24 bytes,set the right most significant byte to the left
	srl $t2,$t0,24	#shift the number right for 24 bytes,set the left significant byte to the right
	or $t1,$t1,$t2	#combine the two switches together,the most left and most right bytes are switched,the middle two bytes are 0 
	

	
#switch the middle two bytes	
	li $t3,0x0000FF00	#create a mask for the right middle byte
	and $t3,$t3,$t0		#load the right middle byte out and store it to t3
	li $t4,0x00FF0000	#create a mask for the left middle byte
	and $t4,$t4,$t0		#load the left middle byte out and store it to t4
	srl $t4,$t4,8		#shift t4 1 byte to the right
	sll $t3,$t3,8		#shift t3 1 byte to the left
	or $t3,$t3,$t4		#use or operator to combine them together, the two most significant bytes are 0

#finish the conversion
	or $t1,$t1,$t3		#use or operator to finish the conversion, t1 now stores the converted numberr


#print out the result
	li $v0,1		#load 1 to v0, tell the system to print an integer
	move $a0,$t1		#move t1 to a0, which is the register of the output
	syscall			#print out the result
	j exit

exit:	