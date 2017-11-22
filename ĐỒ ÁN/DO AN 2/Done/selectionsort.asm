.data
	fin: 	 .asciiz "input.txt"      # filename for input
	buffer1: .space 128		#chuoi chua du lieu doc vao
	chuoi: 	 .space 5		#chuoi chua tung so doc vao

	str3:   .asciiz "sau khi sap xep : \n"
	str5:	.asciiz " "
	fout:   .asciiz "output.txt"      # filename for output
	buffer: .space 4

.text
main: 
	li $a3, -1  # co cho biet so doc vao la n hay a[i]

# Open file for reading

	li   $v0, 13       # mo file
	la   $a0, fin      # dia chi file
	li   $a1, 0        # mo file de doc
	#li   $a2, 0       # mode is ignored
syscall            	   # open a file 
	move $s6, $v0      # l?u con tr? t?i file vào $s0

# reading from file just opened

	li   $v0, 14       # systemcall 14 de doc file
	move $a0, $s6      # luu con tro den file doc tu $s6 vao $a0
	la   $a1, buffer1  # string nhan du lieu doc tu file vao
	li   $a2,  10000   # so luong ky tu doc vao
syscall            	   # read from file

	li      $t5, 0	 # khoi tao chieu dai chuoi = 0**
strLen1:                 #vong lap tinh chieu dai chuoi doc vao
	lb      $t0, buffer1($t5)   #doc 1 byte tai vi tri t5 cua buffer vao t0
	add     $t5, $t5, 1 	#tang chieu dai chuoi len 1
	bne     $t0, $zero, strLen1 #khi chua doc den file thi tiep tuc thuc hien vong lap

	addi $s1,$t5,0 #luu chieu dai chuoi vao $s1
	li $t6, -1
	li $t7, -1
	li $t8, 0
Loop1:
	beq 	$t6, $s1, exit0		#neu het chuoi
	addi    $t6, $t6, 1     	#tang vi tri doc len 1
	la      $t0, buffer1($t6) 	#doc 1 ky tu tu buffer vao $t0
	lb      $a0, ($t0) 		#

	blt $a0, 48, exit10  # neu khong doc duoc ky tu chu so
	bgt $a0, 57, exit10

	addi $t8, $t8, 1 #  do dai so doc duoc
	#lb   $a0, ($t0) 
	addi $t7, $t7, 1 #
	sb $a0, chuoi($t7) 
j Loop1


exit0:
j dongfile
####
exit10:
beq $t8, $0, Loop1#neu k doc dk ki tu khac so
li $t7, -1
la $a0, chuoi
move $a1, $t8
jal atoi
atoi:
 # to set up the stack frame for $ra
move $t0, $a0
li $v0, 0
move $t4, $a1#so ki tu doc duoc
li $t3, 0
next1:
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
addi $t0, $t0, 1
addi $t3, $t3, 1
j next1
endloop:

jr $ra
# print the return value from ATOI
addi $a3, $a3, 1
bne $a3, $0, jump


		move $s2, $v0

		sll 	$s0, $v0, 2		# $s0=n*4
		sub	$sp, $sp, $s0		# Tao stack
		move	$s1, $zero		# i=0
		j next
						# cap phat cho no chua mang
jump:
		bge	$s1, $s2, exit_get	# if i>=n go to exit_for_get
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $t0, $sp		# $t1=$sp+i*4		#
		sw	$v0, ($t1)		# The element is stored
						# at the address $t1
		
		addi	$s1, $s1, 1		# i=i+1

next:
li $t8, 0
j Loop1



dongfile:
# Close the file 

li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall            # close file

##____________________

exit_get:	move	$a0, $sp		# $a0=base address af the array
		move	$a1, $s2		# $a1=size of the array
		jal	isort			# isort(a,n)
						# In this moment the array has been 
						# sorted and is in the stack frame 
		la	$a0, str3		# Print of str3
		li	$v0, 4
		syscall

  ###############################################################
  # Open (for writing) a file that does not exist
  li   $v0, 13       # system call for open file
  la   $a0, fout     # output file name
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s6, $v0      # save the file descriptor 
		move	$s1, $zero		# i=0
for_print:	bge	$s1, $s2, exit_print	# if i>=n go to exit_print
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $sp, $t0		# $t1=address of a[i]
		lw	$a0, 0($t1)		#
#move $a0, $a1
jal  itoa
move $a3, $v0# a3 la str

  ###############################################################
  # Write to file just opened
#jal length
#move $t2, $v0

  li   $v0, 15       # system call for write to file
  move $a0, $s6      # file descriptor 
 #### la   $a1, buffer   # address of buffer from which to write
  move $a1, $a3#########**************
 # li   $a2, 2     # hardcoded buffer length === =doc dk max tam thoi la 2 so

move $a2, $v1
  syscall            # write to file
#xuat dau cach ra
  li   $v0, 15       # system call for write to file
  move $a0, $s6      # file descriptor 
 # la   $a1, buffer   # address of buffer from which to write
  la $a1, str5#########**************
  li   $a2, 1     # hardcoded buffer length
  syscall            # write to file
  ###############################################################

move $a0, $a3
li   $v0, 4         # print_string    ra man hinh
syscall
		#li	$v0, 1			# print of the element a[i]
		#syscall				#

		la	$a0, str5
		li	$v0, 4
		syscall
		addi	$s1, $s1, 1		# i=i+1
		j	for_print
exit_print:	add	$sp, $sp, $s0		# elimination of the stack frame 
  # Close the file 
  li   $v0, 16       # system call for close file
  move $a0, $s6      # file descriptor to close
  syscall            # close file
##########################################################
		li	$v0, 10			# EXIT
		syscall			

#itoa

itoa:
li $v1, 0#length
  la      $t0, buffer   # load buf
  add     $t0, $t0, 3   # seek the end
  sb      $0, 1($t0)     # null-terminated str
  li      $t1, '0'  
  sb      $t1, ($t0)     # init. with ascii 0
  li      $t3, 10        # preload 10
move 	$t8, $a0
  beq     $t8, $0, iend  # end if 0
loop:
  div     $t8, $t3       # a /= 10
addi $v1, $v1, 1
  mflo    $t8
  mfhi    $t4            # get remainder
  add     $t4, $t4, $t1  # convert to ASCII digit
  sb      $t4, ($t0)     # store it
  sub     $t0, $t0, 1    # dec. buf ptr
  bne     $t8, $0, loop  # if not zero, loop
  addi    $t0, $t0, 1    # adjust buf ptr
iend:
  move    $v0, $t0       # return the addr.
  jr      $ra            # of the string


# selection_sort
isort:		addi	$sp, $sp, -20		# save values on stack
		sw	$ra, 0($sp)		#save adress to return
		sw	$s0, 4($sp)		
		sw	$s1, 8($sp)
		sw	$s2, 12($sp)
		sw	$s3, 16($sp)

		move 	$s0, $a0		# base address of the array
		move	$s1, $zero		# i=0

		subi	$s2, $a1, 1		# lenght -1
isort_for:	bge 	$s1, $s2, isort_exit	# if i >= length-1 -> exit loop
		
		move	$a0, $s0		# base address
		move	$a1, $s1		# i
		move	$a2, $s2		# length - 1
		
		jal	mini
		move	$s3, $v0		# return value of mini
		
		move	$a0, $s0		# array
		move	$a1, $s1		# i
		move	$a2, $s3		# mini
		
		jal	swap

		addi	$s1, $s1, 1		# i += 1
		j	isort_for		# go back to the beginning of the loop
		
isort_exit:	lw	$ra, 0($sp)		# restore values from stack
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)
		lw	$s2, 12($sp)
		lw	$s3, 16($sp)
		addi	$sp, $sp, 20		# restore stack pointer
		jr	$ra			# return


# index_minimum routine
mini:		move	$t0, $a0		# base of the array
		move	$t1, $a1		# mini = first = i
		move	$t2, $a2		# last
		
		sll	$t3, $t1, 2		# first * 4
		add	$t3, $t3, $t0		# index = base array + first * 4		
		lw	$t4, 0($t3)		# min = v[first]
		
		addi	$t5, $t1, 1		# j = i+1 vi tri  cua j
mini_for:	bgt	$t5, $t2, mini_end	# go to min_end

		sll	$t6, $t5, 2		# i * 4
		add	$t6, $t6, $t0		# index = base array + i * 4		
		lw	$t7, 0($t6)		# v[index]

		bge	$t7, $t4, mini_if_exit	# skip the if when v[i] >= min
		
		move	$t1, $t5		# mini = i
		move	$t4, $t7		# min = v[i]

mini_if_exit:	addi	$t5, $t5, 1		# j += 1
		j	mini_for

mini_end:	move 	$v0, $t1		# return mini
		jr	$ra


# swap routine
swap:		sll	$t1, $a1, 2		# i * 4
		add	$t1, $a0, $t1		# v + i * 4
		
		sll	$t2, $a2, 2		# j * 4
		add	$t2, $a0, $t2		# v + j * 4

		lw	$t0, 0($t1)		# v[i]
		lw	$t3, 0($t2)		# v[j]

		sw	$t3, 0($t1)		# v[i] = v[j]
		sw	$t0, 0($t2)		# v[j] = $t0

		jr	$ra


