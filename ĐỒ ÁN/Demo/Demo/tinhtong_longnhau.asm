# De Bai: main -> Tong(a, LayDoi(b))

.data #Khai bao bien
a: .word 5
b: .word 3
tb1: .asciiz "Tong la: "
.text
main:
 #Truyen doi so cho ham Tong
 lw $a0, a
 lw $a1, b
 jal Tong #$ra = 11
 #Lay gia tri tra ve tu ham Tong
 add $s2, $0, $v0
 
 #Xuat tb1
 addi $v0, $0, 4
 la $a0, tb1
 syscall
 #Xuat tong
 addi $v0, $0, 1
 add $a0, $0, $s2
 syscall
 j Exit
 
Tong:
 #Khai bao kich thuoc stack
 subi $sp, $sp, 8
 #Cat giau dia chi tra ve ham main vao stack
 sw $ra, 4($sp) # $s3=11
 sw $a0, 0($sp)
 
 #Truyen doi so cho ham LayDoi
 add $a0, $0, $a1
 jal LayDoi #$ra = 28
 #Lay gia tri tra ve tu ham LayDoi
 add $s1, $0, $v0
 lw $s0, 0($sp)
 add $v0, $s0, $s1
 
 #Tra ve ham main
 lw $ra, 4($sp)
 jr $ra #Tro ve ham main
 #Thu hoi bo nho stack
 addi $sp, $sp, 8
 
LayDoi:
 sub $v0, $0, $a0
 jr $ra
 
Exit:
 addi $v0, $0, 10
 syscall
