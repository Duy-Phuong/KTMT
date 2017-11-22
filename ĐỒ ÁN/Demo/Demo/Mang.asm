.data
n: .word 0
a: .space 100
tb1: .asciiz "Nhap n: "
tb2: .asciiz "a["
tb3: .asciiz "]: "
tb4: .asciiz "Mang vua nhap la: "
khoangtrang: .asciiz "  "
.text
main:
#Xuat tb1
li $v0,4
la $a0, tb1
syscall
#Nhap gia tri 
li $v0,5
syscall
#Luu vao n
sw $v0, n

#Khoi tao gia tri vong lap
lw $t0, n 
li $t1, 0 # i = 0
la $t2, a	
Lap1:
beq $t0, $t1,KTLap1
#Xuat tb2
li $v0,4
la $a0, tb2
syscall

#Xuat chi so i
li $v0,1
move $a0,$t1
syscall
#Xuat tb3
li $v0,4
la $a0, tb3
syscall
#Nhap gia tri 
li $v0,5
syscall

#Luu vao a[i]
sw $v0, ($t2)
addi $t2, $t2,4
addi $t1,$t1,1
j Lap1
KTLap1: 
#Xuat tb4
li $v0,4
la $a0, tb4
syscall
#Khoi tao gia tri vong lap xuat
lw $t0, n 
li $t1, 0 # i = 0
la $t2, a	
Lap2:
beq $t0,$t1,Exit
#Xuat a[i]
li $v0,1
lw $a0,($t2)
syscall
#Xuat khoang trang
li $v0,4
la $a0, khoangtrang
syscall
addi $t2, $t2,4
addi $t1,$t1,1
j Lap2
Exit:
li $v0,10
syscall
