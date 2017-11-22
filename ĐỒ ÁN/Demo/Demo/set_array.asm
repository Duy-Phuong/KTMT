.data
array: .space 10 #Khai bao mang array co 10 phan tu
num: .word 4 #So nguyen num = 4
.text
main:
	la $s0, array #$s0 = Dia chi cua mang array
	lw $s1, num #$s1 = num = 4

	move $a1, $s1 #$a1 = $s1
	jal set_array

	add $a0, $0, $s0
	jal print_array

	j exit

set_array:
	subi $sp, $sp, 8
	sw $ra, 4($sp)
	sw $a1, ($sp)
	addi $t0, $0, 0
	add $t1, $0, $s0
loop_set_array:
	lw $a0, ($sp)
	add $a1, $0, $t0
	jal compare
	sw $v0, ($t1)
	addi $t1, $t1, 4
	addi $t0, $t0, 1
	blt $t0, 10, loop_set_array
	j return_main
return_main:
	lw  $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra

compare:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	jal sub_func
	bltz $v0, zero
one: 
	addi $v0, $0, 1 
	j return_set_array
zero:
	addi $v0, $0, 0
return_set_array:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

sub_func:
	sub $v0, $a0, $a1
	jr $ra

print_array:
	addi $t0, $0, 0
	add $t1, $0, $a0
loop_print:
	addi $v0, $0, 1
	lw $a0, ($t1)
	syscall
	addi $v0, $0, 11
	addi $a0, $0, 10
	syscall
	addi $t1, $t1, 4
	addi $t0, $t0, 1
	blt $t0, 10, loop_print
	jr $ra
exit:
	addi $v0, $0, 10
	syscall
