handlePacket:
        addi $sp,$sp,-24
        sw $a0,0($sp)
        sw $ra,4($sp)
        sw $s1,8($sp)
        sw $s2,12($sp)
        sw $s3,16($sp)
        sw $s4,20($sp)          #save the registers

        add $t0,$a0,$zero       #set t0 to the base address of the header
        lb $t1,0($t0)           #t1 stores the first byte of the packet
        srl $t1,$t1,4           #t1 now stores the IP version
        li $t2,4                #t2 now stores 4
        bne $t1,$t2,F1          #if t1 is not 4,which means it's not IPv4,go to F1


        lb $t1,0($t0)           #t1 stores the first byte of the header
        sll $t1,$t1,28
        srl $t1,$t1,28          #*t1 now stores the length of the packet header

        lb $t2,8($t0)           #t2 stores TTL
        blez $t2,F2             #if t2<=0,jumps to L2


        lhu $t3,10($t0)         #*t3 stores the original unflipped checksum


        li $t4,0
        sh $t4,10($t0)          #now the packet checksum becomes 0


        add $t5,$zero,$zero     #set $t5 to be the accumulator
        add $t6,$zero,$zero     #let $t0 be the loop counter

        #the loop that calculate checksum
CS:

        lhu $s1,0($t0)
        srl $s2,$s1,8
        sll $s1,$s1,24
        srl $s1,$s1,16
        or $s1,$s1,$s2          #flip the byte order of the first half word

        lhu $s3,2($t0)
        srl $s4,$s3,8
        sll $s3,$s3,24
        srl $s3,$s3,16
        or $s3,$s3,$s4          #flip the byte order of the second half word

        add $t5,$t5,$s1
        srl $t7,$t5,16
        sll $t5,$t5,16
        srl $t5,$t5,16
        add $t5,$t5,$t7         #add the first halfword to the checksum

        add $t5,$t5,$s3
        srl $t7,$t5,16
        sll $t5,$t5,16
        srl $t5,$t5,16
        add $t5,$t5,$t7         #add the second halfword to the checksum

        addi $t0,$t0,4          #increment t0 by 4
        addi $t6,$t6,1          #increment the loop counter by 1

        bne $t6,$t1,CS          #if t6<t1, go back to CS to calculate the checksum

        not $t5,$t5             #the logical complement of the checksum
        sll $t5,$t5,16
        srl $t5,$t5,16          #get the complement of the checksum

        sll $t6,$t5,24
        srl $t6,$t6,16
        srl $t5,$t5,8
        or $t5,$t5,$t6          #now t5 stores the calculated checksum in bigendian

        bne $t5,$t3,F3          #if the checksum fails,go to L3

        add $t0,$a0,$zero       #set t0 to the base address of the header
        lb $t2,8($t0)           #t2 stores TTL
        addi $t2,$t2,-1         #decrement TTL by one
        sb $t2,8($t0)           #store the new TTL back

        add $t5,$zero,$zero     #set $t5 to be the accumulator
        add $t6,$zero,$zero     #let $t0 be the loop counter

CS2:
        lhu $s1,0($t0)
        srl $s2,$s1,8
        sll $s1,$s1,24
        srl $s1,$s1,16
        or $s1,$s1,$s2          #flip the byte order of the first half word

        lhu $s3,2($t0)
        srl $s4,$s3,8
        sll $s3,$s3,24
        srl $s3,$s3,16
        or $s3,$s3,$s4          #flip the byte order of the second half word

        add $t5,$t5,$s1
        srl $t7,$t5,16
        sll $t5,$t5,16
        srl $t5,$t5,16
        add $t5,$t5,$t7         #add the first halfword to the checksum

        add $t5,$t5,$s3
        srl $t7,$t5,16
        sll $t5,$t5,16
        srl $t5,$t5,16
        add $t5,$t5,$t7         #add the second halfword to the checksum

        addi $t0,$t0,4          #increment t0 by 4
        addi $t6,$t6,1          #increment the loop counter by 1

        bne $t6,$t1,CS2         #if t6<t1, go back to CS to calculate the checksum

        not $t5,$t5             #the logical complement of the checksum
        sll $t5,$t5,16
        srl $t5,$t5,16          #get the complement of the checksum

        sll $t6,$t5,24
        srl $t6,$t6,16
        srl $t5,$t5,8
        or $t5,$t5,$t6          #now t5 stores the calculated checksum in bigendian

        add $t0,$a0,$zero       #set t0 to the base address of the header
        sh $t5,10($t0)          #store the new checksum back

        li $v0,1                #set $v0 to 1
        add $v1,$a0,$zero       #store a0 into v1

        j exit                  #go to exit


#IP version fails
F1:
        add $v0,$zero,$zero     #set $v0 to 0,which means it should be dropped
        addi $v1,$zero,2        #set $v1 to 2 which means invalid IPv4 format
        j exit                  #jump to exit


#TTL fails
F2:
        add $v0,$zero,$zero     #set $v0 to 0,which means it should be dropped
        addi $v1,$zero,1        #set $v1 to 1 which means TTL zeroed
        j exit                  #jump to exit


#checksum fail
F3:
        add $v0,$zero,$zero     #set $v0 to 0,which means it should be dropped
        addi $v1,$zero,0        #set $v1 to 0 which means checksum fails
        j exit                  #jump to exit


exit:
        lw $a0,0($sp)
        lw $ra,4($sp)
        lw $s1,8($sp)
        lw $s2,12($sp)
        lw $s3,16($sp)
        lw $s4,20($sp)
        addi $sp,$sp,24         #restore the registers

        jr $ra                  #jump back to the return address


