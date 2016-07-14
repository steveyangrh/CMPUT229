###############################
# Author: Taylor Lloyd
# Date: June 4, 2012
#
# NOTE: output file must be touched before use
#-------------------------------

###############################
#
# Bug fixing
#
# Author: Alejandro Ramirez (ramirezs@ualberta.ca)
# Date:   Fall 2013
# Description: 
#	1. The packet.out file was being created empty
#	since the file descriptor was never used to close
#	the file
###############################

.data
packetFile:
.asciiz "./packet.in"
outputFile:
.asciiz "./packet.out"
.align 2
packetData:
.space 200
packetNotGenerated:
.asciiz "Packet not Generated. Reason: "
badIPVersion:
.asciiz "Not IPv4\n"
badChecksum:
.asciiz "Bad Checksum\n"
ttlTimeout:
.asciiz "TTL Timeout\n"
invalidReason:
.asciiz "Invalid Reason Supplied\n"
packetSaved:
.asciiz "Packet saved.\n"

.text
main:
#Open the packet file
	la	$a0 packetFile #filename
	li	$a1 0x00 #flags
	li	$a2 0x0644 #file mode
	li	$v0 13 
	syscall #file_open
#Read into buffer
	move 	$a0 $v0
	la	$a1 packetData
	li	$a2 200
	li	$v0 14
	syscall #file_read
#Close the reading file
	li	$v0 16
	syscall

#Run the appended solution
	la	$a0 packetData
	jal	handlePacket
	bnez	$v0 savePacketToFile
printNoPacketMsg:
	la	$a0 packetNotGenerated
	li	$v0 4
	syscall
	beqz	$v1 printBadChecksum
	li	$t0 1
	beq	$v1 $t0 printTTLTimeout
	li	$t0 2
	beq	$v1 $t0 printBadIPVersion
	#No legitimate reason supplied
	la	$a0 invalidReason
	syscall
	j	packetTestingEnd
printBadChecksum:
	la	$a0 badChecksum
	syscall
	j	packetTestingEnd
printTTLTimeout:
	la	$a0 ttlTimeout
	syscall
	j	packetTestingEnd
printBadIPVersion:
	la	$a0 badIPVersion
	syscall
	j	packetTestingEnd

savePacketToFile:
#determine the total length of the generated packet
	#load the packet length
	lh	$t0 2($v1)
	#cut sign extension
	li	$t1 0xFFFF
	and	$t0 $t0 $t1
	#endianness swap
	srl	$t1 $t0 8
	sll	$t0 $t0 24
	srl	$t0 $t0 16
	or	$t0 $t0 $t1
	 
#print out the resulting packet to our output file
	#open file
	la	$a0 outputFile
	li	$a1 0x102
	li	$a2 0x0644
	li	$v0 13
	syscall
	#Show file open value
	##move	$s0 $v0
	##move	$a0 $s0
	##li	$v0 1
	##syscall
	#Setup our write
	move  	$t4 $v0  #Save the file descriptor
	
	move	$a0 $t4
	move	$a1 $v1
	move	$a2 $t0
	li	$v0 15
	syscall	
	#print the value of file_write
	##move	$a0 $v0
	##li	$v0 1
	##syscall
	#close the file
	move 	$a0 $t4
	li	$v0 16
	syscall
	#Print saved message
	li	$v0 4
	la	$a0 packetSaved
	syscall
#End execution
packetTestingEnd:
	li	$v0 10
	syscall

###################Student appended code begins here#####################

