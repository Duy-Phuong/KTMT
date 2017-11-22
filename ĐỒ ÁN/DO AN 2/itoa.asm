

.data
string: .ascii "12345"
buffer:         .space 32
.text
#nhap so vao----------------
#li $v0, 5
#syscall
#move $a0, $v0
#jal itoa
	#li   $a0, 123456      # a number
	li $v0,5 #read int into  v0
	syscall
	#add $a0,$v0,$zero
	move $a0,$v0
      jal  itoa
      move $a0, $v0
      li   $v0, 4         # print_string    
      syscall
exit: # exit
li $v0, 10
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
