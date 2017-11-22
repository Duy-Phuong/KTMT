.data
msg1: .asciiz "Nhap vao so thu nhat: "
msg2: .asciiz "Nhap vao so thu hai: "
msg3: .asciiz "Tong la: "
msg4: .asciiz "Hieu la: "
msg5: .asciiz "Tich la: "
msg6: .asciiz "Thuong la: "
msg7: .asciiz "\nNhap vao chuc nang muon su dung (1 -> 7): "
msg8: .asciiz "So ban nhap khong dung "
msg9: .asciiz "\nSo du la: "
msg10: .asciiz "a > b "
msg11: .asciiz "a < b "
msg12: .asciiz "a = b "
msg13: .asciiz "Nhap vao so n "
msg14: .asciiz "  "
msg15: .asciiz "--------Menu--------- \n1. Tinh tong\n2. Tinh hieu\n3. Tinh tich\n4. Tinh thuong\n5. So sanh a va b\n6. Xuat day so (1..n)\n7. Thoat\n--------------------- " 
	.text
main:
	#Nhap vao so thu nhat
	addi $v0, $zero, 4 
	la $a0, msg1
	syscall
	#Thuc hien nhap
	addi $v0, $zero, 5
	syscall
	move $t0, $v0	#move $v0 -> $t0


	#Nhap vao so thu hai
	addi $v0, $zero, 4
	la $a0, msg2
	syscall
	#Thuc hien nhap
	addi $v0, $zero, 5
	syscall
	move $t1, $v0	#move $v0 -> $t1
#-------------------------------------#
	#Xuat menu
	addi $v0, $zero, 4 
	la $a0, msg15
	syscall
	

#-------------------------------------#
nhap:	
	#Gan bien so thu tu chuc nang
	addi $t2, $zero, 1
	addi $t3, $zero, 2
	addi $t4, $zero, 3
	addi $t5, $zero, 4
	addi $t6, $zero, 5
	addi $t7, $zero, 6
	addi $t8, $zero, 7
	#Nhap vao chuc nang muon dung ( 1 -> 6)
	addi $v0, $zero, 4 
	la $a0, msg7
	syscall
	#Thuc hien nhap
	addi $v0, $zero, 5
	syscall
	move $t9, $v0	#move $v0 -> $t9

	#Lenh if xet cac chuc nang
	beq $t9,$t2,tong
	beq $t9,$t3,hieu
	beq $t9,$t4,nhan
	beq $t9,$t5,chia
	beq $t9,$t6,sosanh
	beq $t9,$t7,dayso

	#Neu so  nhap vao la 7 thi thoat chuong trinh
	beq $t9,$t8,Exit
	#Neu so nhap vao khac 1->7 thi quay lai
	addi $v0, $zero, 4
	la $a0, msg8
	syscall
	j nhap
	
#-------------------------------------#
	#Tinh tong
tong:
	addi $v0, $zero, 4
	la $a0, msg3
	syscall

	add $t2, $t0, $t1
	addi $v0, $zero, 1
	move $a0, $t2
	syscall
	j nhap
#-------------------------------------#
	#Tinh hieu
hieu:
	addi $v0, $zero, 4
	la $a0, msg4
	syscall

	
	sub $t2, $t0, $t1
	addi $v0, $zero, 1
	move $a0, $t2
	syscall
	j nhap
#-------------------------------------#
nhan:
	#Thuc hien phep nhan
	mult $t0,$t1
	mfhi $t2
	mflo $t3

	#Xuat msg5
	addi $v0, $zero, 4
	la $a0,msg5
	syscall
	
	#Xuat ket qua
	addi $v0, $zero, 1
	move $a0, $t3
	syscall
	j nhap

#-------------------------------------#
chia:
	#Thuc hien phep chia
	div $t0,$t1
	mfhi $t2
	mflo $t3

	#Xuat msg6
	addi $v0,  $zero, 4
	la $a0,msg6
	syscall
	
	#Xuat ket qua
	addi $v0, $zero, 1
	move $a0, $t3
	syscall

	#Xuat msg9
	addi $v0,  $zero, 4
	la $a0,msg9
	syscall
	
	#Xuat ket qua
	addi $v0, $zero, 1
	move $a0, $t2
	syscall
	j nhap

#-------------------------------------#
	#So sanh 2 so
sosanh:
	# t2  = t0 - t1
	sub $t2,$t0,$t1
	#sosanh
	bgtz $t2,ketqua1
	bltz $t2,ketqua2
	beq $t2,$zero,ketqua3

	ketqua1:
	#Xuat msg10
	addi $v0, $zero, 4
	la $a0,msg10
	syscall
	j nhap

	ketqua2:
	#Xuat msg11
	addi $v0, $zero, 4
	la $a0,msg11
	syscall
	j nhap

	ketqua3:
	#Xuat msg12
	addi $v0, $zero, 4
	la $a0,msg12
	syscall
	j nhap

#-------------------------------------#
dayso:	
	#Nhap vao so n
	addi $v0, $zero, 4 
	la $a0, msg13
	syscall

	#Thuc hien nhap
	addi $v0, $zero, 5
	syscall
	move $t0, $v0	
	#move $v0 -> $t0

	#Kiem tra n <= 0 thi thoat
	blez $t0,nhap

	
	addi $t1,$zero,1

	Loop:
	addi $v0, $zero, 1
	move $a0,$t1
	syscall
	addi $v0, $zero, 4 
	la $a0, msg14
	syscall
	addi $t1,$t1,1

	# t2 = t1 - t0 ( i - n )
	sub $t2,$t1,$t0
	blez $t2,Loop
	bgtz $t2,nhap

#-------------------------------------#

Exit:
	addi $v0,$zero,10
	syscall
	
