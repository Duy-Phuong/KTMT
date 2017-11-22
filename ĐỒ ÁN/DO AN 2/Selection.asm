
		.data
xuatmang:		.asciiz "sau khi sap xep : \n"
daucach:		.asciiz " "
fout:   .asciiz "output1.txt"      # filename for output
buffer:         .space 13


fin: .asciiz "input1.txt"      # filename for input
buffer1: .space 10000		#chuoi chua du lieu doc vao
chuoi: .space 10			#chuoi chua tung so doc vao
		.text
		.globl	main
main: 

li $a3, -1		#$a3 la so de phan biet duoc so doc vo la n hay phan tu a[i] cua mang
# Open file for reading

li   $v0, 13       # goi lenh system call de mo file
la   $a0, fin      # ten file
li   $a1, 0        # flag de doc
syscall            # mo file 
move $s6, $v0      # luu file descriptor 

# doc du lieu tu file

li   $v0, 14       # goi system call de doc du lieu tu file
move $a0, $s6      # file descriptor 
la   $a1, buffer1   # dia chi cua buffer1 load vao de doc
li   $a2,  10000  # so luong ki tu toi da doc duoc
syscall            # goi system call de doc file

li      $t5, 0	# chieu dai chuoi khoi tao = 0
strLen1:                 #tinh chieu dai chuoi
lb      $t0, buffer1($t5)   #load tung ki tu tai vi tri t5 trong chuoi buffer1 ra  
add     $t5, $t5, 1	#tang t5 len 1
bne     $t0, $zero, strLen1 #neu chua doc den cuoi chuoi thi quay lai strLen1

li $t6, -1	#$t6 = -1
li $t7, -1
li $t8, 0
#tach chuoi do vao mang
strtok:
beq $t6, $t5, exit	#neu het chuoi thi nhay toi exit0
addi     $t6, $t6, 1     #tang $t6 len 1
la      $t0, buffer1($t6) #lay dia chi tai $t6 cua buffer1 vao $t0
lb      $a0, ($t0)	 #load tung ki tu tai vi tri t5 trong chuoi buffer1 ra 

blt $a0, 48, continue	#neu gap ki tu < '0' thi nhay toi continue
bgt $a0, 57, continue	#neu gap ki tu > '9' thi nhay toi continue

addi $t8, $t8, 1	#so ki tu neu doc duoc vao chuoi se tang len 1
addi $t7, $t7, 1	#$t7 la vi tri ki tu trong chuoi se tang len 1
sb $a0, chuoi($t7)	#luu ki tu doc duoc tu buffer1 vao chuoi tai vi tri $t7
j strtok		#nhay ve Loop1


exit:
j close_file	

continue:
beq $t8, $0, strtok	#neu k doc dk ki tu khac so
li $t7, -1		#khoi tao lai vi tri doc ki tu tu chuoi $t7 = -1
la $a0, chuoi		#load dia chi chuoi vao a0
move $a1, $t8		#luu do dai chuoi doc duoc vao $a1 de truyen vao ham atoi
jal atoi 		#nhay toi ham doi chuoi thanh so
			#ket qua tra ve nam trong v0

addi $a3, $a3, 1	# doc duoc so dau thi tang $a3 len
bne $a3, $0, jump	
			#neu a3 = 0 tuc la doc duoc n -> tao stack chua n phan tu
			# neu a3 != 0, tuc la doc duoc gia tri phan tu a[i] -> luu vao stack da tao
# neu $a3 = 0
move $s2, $v0		#luu n vao $s2
sll	$s0, $v0, 2	# $s0=n*4
sub	$sp, $sp, $s0	# Tao stack de chua n phan tu
move	$s1, $zero	# i=0 la vi tri phan tu cua mang
j next
#neu $a3 != 0			# cap phat cho no chua mang
jump:
bge	$s1, $s2, exit_get	# if i>=n nhay toi exit_get
sll	$t0, $s1, 2		# $t0=i*4
add	$t1, $t0, $sp		# $t1=$sp+i*4		
sw	$v0, 0($t1)		# luu so trong $v0 vao tai vi tri $t1 trong stack
		
addi	$s1, $s1, 1		# i=i+1

next:
li $t8, 0		#khoi tao lai $t8 = 0 la do dai cua chuoi doc duoc
j strtok		

# dong file 
close_file: 

li   $v0, 16       # system call de dong file
move $a0, $s6      # file descriptor
syscall            # dong file

exit_get:	

move	$a0, $sp		# luu dia chi cua mang vao $a0 de truyen vao ham
move	$a1, $s2		# $a1 = n de truyen vao ham
jal	selection_sort		# selection_sort(a,n)
				#sau khi goi ham mang da duoc sap xep 
la	$a0, xuatmang		# in ra xuatmang
li	$v0, 4
syscall

 # mo file de viet 
  li   $v0, 13       # system call de mo file
  la   $a0, fout     # ten output file
  li   $a1, 1        # mo file de viet(flags 0: read, 1: write)
  syscall            # mo file (file descriptor tra ve trong $v0)
  move $s6, $v0      # luu file descriptor 
		move	$s1, $zero		# i=0
for_print:	bge	$s1, $s2, exit_print	# if i>=n nhay toi exit_print
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $sp, $t0		# $t1 = dia chi cua a[i]
		lw	$a0, 0($t1)		#load phan tu tai vi tri $t1 trong stack vao $a0
		#doi so thanh chuoi de xuat ra file
		jal  itoa
		move $a3, $v0 			# a3 la chuoi vua chuyen doi


 # viet len file da duoc mo
#######-----------------------#######
 li   $v0, 15       # system call de viet vao file
 move $a0, $s6      # file descriptor 
 move $a1, $a3	    # dia chi cua chuoi sau khi duoc chuyen tu so
 move $a2, $v1	    # chieu dai chuoi viet vao file duoc tinh trong ham itoa roi luu vao $v1
 syscall            # viet ra file
#xuat dau cach ra
  li   $v0, 15       # system call for write to file
  move $a0, $s6      # file descriptor 
  la $a1, daucach    #load dia chi dau cach vao $a1
  li   $a2, 1        # so ki tu cua daucach
  syscall            # viet ra file
#######-----------------------#######
#xuat ra man hinh de kiem tra
move $a0, $a3	    #chuoi sau khi doi gan vao $a0
li   $v0, 4         # in ra man hinh
syscall
#in ra dau cach
la	$a0, daucach
li	$v0, 4
syscall
addi	$s1, $s1, 1		# i=i+1
j	for_print	#tiep tuc xuat
exit_print:	
add	$sp, $sp, $s0		# tra lai sau khi xin cap phat tu stack
 # dong file 
li   $v0, 16       # system call de dong file
move $a0, $s6      # file descriptor 
syscall            # close file
li	$v0, 10			# EXIT
syscall			

#itoa de doi so thanh chuoi

itoa:
li $v1, 0		##chieu dai cua chuoi sau khi doi
  la      $t0, buffer   # load buffer
  sb      $0, ($t0)     # null-terminated str
  li      $t1, '0'  
  sb      $t1, ($t0)     # khoi tao chuoi = '0'
  li      $t3, 10        # $t3 = 10
  move 	  $t8, $a0	 # gan $t8 la so truyen vao
loop:
 div     $t8, $t3       # a /= 10
 addi $v1, $v1, 1
  mflo    $t8		#thuong
  mfhi    $t4            #so du
  add     $t4, $t4, $t1  # chuyen sang ki tu tuong ung trong ascii bang cach + 48
  sb      $t4, ($t0)     # luu ki tu vua moi chuyen duoc vao chuoi
  sub     $t0, $t0, 1     #  $t0 -= 1
  bne     $t8, $0, loop  # neu $t8 !=0 --> loop
  addi    $t0, $t0, 1    # tang $t0 += 1
iend:
  move    $v0, $t0       # return dia chi cua chuoi vao $t0.
  jr      $ra            


# selection_sort
selection_sort:		
		addi	$sp, $sp, -20		# luu gia tri vao stack
		sw	$ra, 0($sp)		#luu dia chi tra ve cua ham
		sw	$s0, 4($sp)		
		sw	$s1, 8($sp)
		sw	$s2, 12($sp)
		sw	$s3, 16($sp)

		move 	$s0, $a0		# $s0 la dia chi cua mang
		move	$s1, $zero		# i=0

		subi	$s2, $a1, 1		# lenght -1
isort_for:	bge 	$s1, $s2, isort_exit	# if i >= length-1 -> ket thuc
		
		move	$a0, $s0		# dia chi cua mang
		move	$a1, $s1		# i
		move	$a2, $s2		# length - 1
		
		jal	mini
		move	$s3, $v0		# return dia chi cua mini
		
		move	$a0, $s0		# dia chi cua mang
		move	$a1, $s1		# i
		move	$a2, $s3		# mini
		
		jal	swap

		addi	$s1, $s1, 1		# i += 1
		j	isort_for		
		
isort_exit:	lw	$ra, 0($sp)		# restore gia tri tu stack
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)
		lw	$s2, 12($sp)
		lw	$s3, 16($sp)
		addi	$sp, $sp, 20		# restore stack pointer
		jr	$ra			# return


mini:		move	$t0, $a0		# dia chi cua mang
		move	$t1, $a1		# mini = first = i
		move	$t2, $a2		# last
		
		sll	$t3, $t1, 2		# first * 4
		add	$t3, $t3, $t0		# index = dia chi cua mang + first * 4		
		lw	$t4, 0($t3)		# min = v[first]
		
		addi	$t5, $t1, 1		# j = i+1 vi tri  cua j
mini_for:	bgt	$t5, $t2, mini_end	# min_end

		sll	$t6, $t5, 2		# i * 4
		add	$t6, $t6, $t0		# index = dia chi cua mang + i * 4		
		lw	$t7, 0($t6)		# v[index]

		bge	$t7, $t4, mini_if_exit	#if when v[i] >= min
		
		move	$t1, $t5		# mini = i
		move	$t4, $t7		# min = v[i]

mini_if_exit:	addi	$t5, $t5, 1		# j += 1
		j	mini_for

mini_end:	move 	$v0, $t1		# return mini
		jr	$ra


# swap
swap:		sll	$t1, $a1, 2		# i * 4
		add	$t1, $a0, $t1		# v + i * 4
		
		sll	$t2, $a2, 2		# j * 4
		add	$t2, $a0, $t2		# v + j * 4

		lw	$t0, 0($t1)		# v[i]
		lw	$t3, 0($t2)		# v[j]

		sw	$t3, 0($t1)		# v[i] = v[j]
		sw	$t0, 0($t2)		# v[j] = $t0

		jr	$ra
#ham chuyen chuoi thanh so
atoi:
move $t0, $a0
li $v0, 0
move $t4, $a1#so ki tu doc duoc
li $t3, 0
next1:
beq $t4, $t3, endloop
lb $t1, ($t0)
# kiem tra neu gia tri hop le
blt $t1, 48, endloop
bgt $t1, 57, endloop
#  $v0 = v0*10 + $t1 - 48
li $t2, 10
mul $v0, $v0, $t2
add $v0, $v0, $t1
subi $v0, $v0, 48
# tang dia chi cua con tro den ki tu tiep theo
add $t0, $t0, 1
addi $t3, $t3, 1
b next1
endloop:

jr $ra
