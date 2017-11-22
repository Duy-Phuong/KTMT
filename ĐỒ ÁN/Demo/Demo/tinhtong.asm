.data #Khai bao bien
tb1: .asciiz "Nhap so nguyen a: "
tb2: .asciiz "Nhap so nguyen b: "
tb3: .asciiz "Tong la: "
sum: .word 0
.text
main:
 #In chuoi
 addi $v0, $0, 4 #$v0 = $0 + 4 = 4
 la $a0, tb1
 syscall
 #Nhap so nguyen a
 addi $v0, $0, 5 #$v0 = 5
 syscall
 #Nhap xong la cat giau lien
 add $s0, $0, $v0 #$a0 = $v0
 #Xuat thong bao 2
 addi $v0, $0, 4
 la $a0, tb2
 syscall
 #Nhap so nguyen b
 addi $v0, $0, 5
 syscall
 add $s1, $0, $v0 #$a0 = $v0
 #Truyen tham so cho ham
 add $a0, $0, $s0
 add $a1, $0, $s1
 #Goi ham
 jal Tong
 sw $v0, sum #Luu gia tri tra ve
 
 #Xuat thong bao 3
 addi $v0, $0, 4
 la $a0, tb3
 syscall
 #Xuat tong $s2
 addi $v0, $0, 1
 lw $a0, sum
 syscall
 
 #Ket thuc
 addi $v0, $zero, 10
 syscall
 
 Tong:
  add $v0, $a0, $a1
  jr $ra 
 
