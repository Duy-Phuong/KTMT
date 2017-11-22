.data 
str1: .asciiz "Nhap so Int: "
str2: .asciiz "So nay lon hon 0"
str3: .asciiz "So nay bang 0"
str4: .asciiz "So nay be hon 0"
.globl main
.text 
main:
li $v0,4
la $a0,str1
syscall 
li $v0,5
syscall 
move $s0,$v0

beq $s0,$0,bang
bgtz $s0,lon
bltz $s0,be

lon:
li $v0,4
la $a0,str2
syscall
j exit

bang:
li $v0,4
la $a0,str3
syscall
j exit

be:
li $v0,4
la $a0,str4
syscall

exit:
li $v0,10
syscall