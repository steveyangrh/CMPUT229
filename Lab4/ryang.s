#----------------------------------------------------------------
#The main function takes a input and output its converted endianess number
#Register Usage:
#         $t0:to make sure to print 2 0's
#         $t1:to count how many 0's are printed
#         $t2:load the data display control register to see if it's ready
#         $t3:to check if needs to increment the third number of the timer
#         $t4:to check if need to incrmet the second number of the timer
#         $t5:make sure the backspace is entered 5 times
#         $t6:to cound how mant times the backspace is entered
#         $s0:to modify the coprocessor 0 registers
#         $s1:to modify the increments of the timer
#         $s2:to check what key is pressed
#         $k0-k1:kernel	registers
#-----------------------------------------------------------------
.data
T1:	     .byte   48
T2:	     .byte   48
T3:	     .byte   48
T4:	     .byte   48
.text
.globl  __start                 #global start


__start:
	li      $t0,2
	li      $t1,0          #used to count how many 0 is printed
	li      $t3,58
	li      $t4,54         #t3 and t4 are used to check when to increment the time
	li      $t5,5
	li      $t6,0
	
	li      $s0,100
	mtc0    $s0,$11         #let the clock increment per second

	li      $s0,0x2
	sw      $s0,0xffff0000  #enable the keyboard interrupt
	
	li      $s0,0x8801
	mtc0    $s0,$12         #enable the timer and keyboard interrupt by modifying the status register
		
P0:	
	lw   $t2,0xffff0008
	and  $t2,0x1
	beq  $t2,$zero,P0       #check if it is ready to print a data
	li   $t2,48
	sb   $t2,0xffff000c     #print 0 out
	addi $t1,$t1,1
	bne  $t1,$t0,P0         #check how many 0 is printed
	li   $t1,0              #reset the counter to 0

P1:
	lw   $t2,0xffff0008
	and  $t2,0x1
	beq  $t2,$zero,P1       #check if it is ready to print a data
	li   $t2,0x3a
	sb   $t2,0xffff000c     #print : out

P2:
	lw   $t2,0xffff0008
	and  $t2,0x1
	beq  $t2,$zero,P2       #check if it is ready to print a data
	li   $t2,48
	sb   $t2,0xffff000c     #print 0 out
	addi $t1,$t1,1
	bne  $t1,$t0,P2         #check how many 0 is printed
	li   $t1,0              #reset the counter to 0

	mtc0 $zero, $9

#p3 used as a infinite loop
P3:
	nop
	j P3

.ktext 0x80000180               #the exception handler address

	.set noat
	move $k1,$at            #save the at register
	.set at
	
	sw   $a0,save0
	sw   $s1,save1
	sw   $s2,save2
	
	mfc0 $k0,$13
	srl  $k0,$k0,2
	andi $k0,$k0,0x1f
	bne  $k0,$zero,FINISH   #if the excption code is not 0, go to finish
	mfc0 $k0,$13            #get the the cause register
	andi $k0,$k0,0x2000
	srl  $k0,$k0,15
	bne  $k0,$zero,TIMER    #if it's a timer exception go to TIMER
	mfc0 $k0,$13
	andi $k0,$k0,0x800
	srl  $k0,$k0,11
	bne  $k0,$zero,KEYBOARD #if it's a keyboard exception go to KEYBOARD

#used to handle timer exception
TIMER:
	lb   $s1,T1
	addi $s1,$s1,1
	beq  $s1,$t3,TIMER1
	sb   $s1,T1
	j PULL1
TIMER1:
	li   $s1,48
	sb   $s1,T1
	lb   $s1,T2
	addi $s1,$s1,1
	beq  $s1,$t4,TIMER2
	sb   $s1,T2
	j PULL1

TIMER2:
	li   $s1,48
	sb   $s1,T2
	lb   $s1,T3
	addi $s1,$s1,1
	beq  $s1,$t3,TIMER3
	sb   $s1,T3
	j    PULL1
TIMER3:
	li   $s1,48
	sb   $s1,T3
	lb   $s1,T4
	addi $s1,$s1,1
	sb   $s1,T4
	j PULL1

KEYBOARD:
	lw   $s1,0xffff0004             #get the data from keyboard data register
	andi $s1,$s1,0xff
	li   $s2,0x71
	beq  $s1,$s2,Q                  #check if q is pressed
	li   $s2,0x72
	beq  $s1,$s2,R                  #check if r is pressed
	j FINISH

#q is pressed
Q:
	li   $v0,10
	syscall
#r is pressed
R:
	li   $s1,48
	sb   $s1,T1
	sb   $s1,T2
	sb   $s1,T3
	sb   $s1,T4
	j    PULL1

#used to print out the time
PULL1:
	lw   $s1,0xffff0008
	and  $s1,0x1
	beq  $s1,$zero,PULL1
	li   $s1,0x8
	sb   $s1,0xffff000c
	addi $t6,$t6,1
	bne  $t6,$t5,PULL1
	li   $t6,0              #used to print 5 backspaces
PULL2:	
	lw   $s1,0xffff0008
	and  $s1,0x1
	beq  $s1,$zero,PULL2
	lb   $s1,T4
	sb   $s1,0xffff000c     #used to print the first number of the time
PULL3:	
	lw   $s1,0xffff0008
	and  $s1,0x1
	beq  $s1,$zero,PULL3
	lb   $s1,T3
	sb   $s1,0xffff000c     #used to print the second number of the time
	
PULL4:	
	lw   $s1,0xffff0008
	and  $s1,0x1
	beq  $s1,$zero,PULL4
	li   $s1,0x3a
	sb   $s1,0xffff000c     #print : out
	
PULL5:
	lw   $s1,0xffff0008
	and  $s1,0x1
	beq  $s1,$zero,PULL5
	lb   $s1,T2
	sb   $s1,0xffff000c     #used to print the third number of the time
	
PULL6:	
	lw   $s1,0xffff0008
	and  $s1,0x1
	beq  $s1,$zero,PULL6
	lb   $s1,T1
	sb   $s1,0xffff000c     #used to print the last number of the time
	
	mtc0 $zero, $9          #reset the timer to 0
FINISH:

	lw    $a0,save0
	lw    $s1,save1
	lw    $s2,save2         #restore the registers
	
	mtc0  $zero,$13         #clear the cause register
	
	mfc0  $t0,$12
	ori   $t0,$t0,0x8801
	mtc0  $t0,$12           #reset the status register
	
	lw    $t0,0xffff0000
	ori   $t0,$t0,0x2
	sw    $t0,0xffff0000    #reenable the keyboard exception
	.set noa	t
	move   $at,$k1          #restore at register
	.set at
	
	eret                    #return back to the main code

.kdata
save0:	  .word 0
save1:	  .word 0
save2:	  .word 0
	
	
	
	
	
	
	