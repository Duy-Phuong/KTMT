#Nhap vao 1 so INT (luu tru trong pt 3 cua a)
.data
str1: .asciiz " Nhap: "
str2: .asciiz "Xuat: "
n: .word 0
a: .space 100 #Khoi tao mang a co 100 phan tu
.text
main:
la $s0, a
#In chuoi Nhap
addi $v0, $0, 4
la $a0, str1
syscall
#Nhap
addi $v0, $0, 5
syscall
#Luu vao n
addi $t0, $s0, 12
sw $v0, ($t0)
#In chuoi Xuat
addi $v0, $0, 4
la $a0, str2
syscall
#Xuat INT
addi $v0, $0, 1
lw $a0, n
syscall
#Thoat
addi $v0, $0, 10
syscall