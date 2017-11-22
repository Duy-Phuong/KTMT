
.data  
fin: .asciiz "input.txt"      # filename for input
buffer: .space 128
chuoi: .space 5
empty: .asciiz "0"
str5:		.asciiz " "
.text



################################################ fileRead:

# Open file for reading

li   $v0, 13       # system call for open file
la   $a0, fin      # input file name
li   $a1, 0        # flag for reading
li   $a2, 0        # mode is ignored
syscall            # open a file 
move $s6, $v0      # save the file descriptor 

# reading from file just opened

li   $v0, 14       # system call for reading from file
move $a0, $s6      # file descriptor 
la   $a1, buffer   # address of buffer from which to read
li   $a2,  10000  # hardcoded buffer length
syscall            # read from file

li      $t5, 0# chieu dai chuoi**
strLen:                 #getting length of string
lb      $t0, buffer($t5)   #loading value
add     $t5, $t5, 1
bne     $t0, $zero, strLen

li $t6, -1
li $t7, -1
li $t8, 0
Loop:
beq $t6, $t5, exit
addi     $t6, $t6, 1     #this statement is now before the 'load address'
la      $t0, buffer($t6)   #loading value



lb      $a0, ($t0)#print character
#li      $v0, 11        
#syscall

blt $a0, 48, exit1
bgt $a0, 57, exit1

addi $t8, $t8, 1
lb      $a0, ($t0)#lay a0 la dia chi cua chuoi
addi $t7, $t7, 1
sb $a0, chuoi($t7)
j Loop
exit:
li      $v0, 10              #program done: terminating
syscall
####
exit1:
beq $t8, $0, Loop#neu k doc dkki tu khac so
li $t7, -1
la $a0, chuoi
move $a1, $t8
jal atoi
# print the return value from ATOI
move $a0, $v0
li $v0, 1
syscall
la	$a0, str5
li	$v0, 4
syscall
#in ra so " " 1 2 3 4
li $t8, 0
j Loop



# Close the file 

li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall            # close file


atoi: # to set up the stack frame for $ra
move $t0, $a0
li $v0, 0
move $t4, $a1#so ki tu doc duoc
li $t3, 0
next:
beq $t4, $t3, endloop
lb $t1, ($t0)
# check if the current char is a valid digit
blt $t1, 48, endloop
bgt $t1, 57, endloop
# to update result $v0 = v0*10 + $t1 - 48
li $t2, 10
mul $v0, $v0, $t2
add $v0, $v0, $t1
subi $v0, $v0, 48
# to advance the address to point to the next char
add $t0, $t0, 1
addi $t3, $t3, 1
b next
endloop:

jr $ra
