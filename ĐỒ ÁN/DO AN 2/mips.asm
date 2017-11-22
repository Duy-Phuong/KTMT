.data
	cach: .asciiz " "
	NULL: .asciiz "\n"
	mangso: .word 1000
	nhapso: .asciiz "nhap so phan tu cua mang: "
	xuatmang: .asciiz "cac phan tu cua mang la: "
buffer:         .space 32
.text
	la $a0,nhapso
	li $v0,4 #print string
	syscall
	li $v0,5 #read int into  v0
	syscall
	#add $a0,$v0,$zero
	move $s1,$v0
	move $s0,$v0
	#li $v0,1 #print int
		#move $a0,$s0#gan a0 = s0
	#syscall

	la $t0,mangso #lay dc cua mang bo vao t0
nhap:
	beq $s1,$0, ndo #neu mang 0 co pt thi nhay toi ndo
	
	li $v0,5 #read int into  v0
	syscall
	sw $v0,($t0)
	
	addi $s1,$s1,-1
	addi $t0,$t0,4
	j nhap
	

ndo:
	la $a0,xuatmang
	li $v0,4 #print string
	syscall
	#j selection_sort
	j exit


exit:
	la $t0,mangso #lay dc cua mang bo vao t0
	add $s1,$s0,$0
	j print


print:

	beq $s1,$0, ndo1 #neu mang 0 co pt thi nhay toi ndo

	lw $a1,($t0)
#move $a0, $a1
#jal  itoa


      move $a0, $a1
     # li   $v0, 4         # print_string    
     # syscall
	li $v0,1
	syscall	

syscall
	addi $t0,$t0,4
	
	addi $s1,$s1,-1
	la $a0,cach
	li $v0,4 #print string
	syscall

	j print
ndo1:

	li $v0,10
	syscall






#itoa


itoa:
  la      $t0, buffer   # load buf
  add     $t0, $t0, 30   # seek the end
  sb      $0, 1($t0)     # null-terminated str
  li      $t1, '0'  
  sb      $t1, ($t0)     # init. with ascii 0
  li      $t3, 10        # preload 10
move 	$t8, $a0
  beq     $t8, $0, iend  # end if 0
loop:
  div     $t8, $t3       # a /= 10
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


