.data
string: .ascii "345"
.text
main: # call ATOI function, using $a0 to pass the address of the string
la $a0, string
jal atoi
# print the return value from ATOI
move $a0, $v0
li $v0, 1
syscall

exit: # exit
li $v0, 10
syscall



# ATOI function
# to conver the initial portion of the given string an integer
# $a0: taking the address of the given string
# $v0: to return the converted integer value
# $t0: the address of the current char
# $t1: the ASCII value of the current char
atoi: # to set up the stack frame for $ra
# move the input to the address of the current char
move $t0, $a0
# to initialize the result to 0
li $v0, 0
next: # fetch the current char
lb $t1, ($t0)
# check if the current char is a valid digit
blt $t1, 48, endloop
bgt $t1, 57, endloop
# to update result $v0 = v0*10 + $t1 - 48
li $t2, 10
mul $v0, $v0, $t2
add $v0, $v0, $t1
subi $v0, $v0, 48
# to advance the address to point to the next char
add $t0, $t0, 1
# continue for the next char
b next
endloop:
# to terminate the function
jr $ra
#----------------------------------------------
# data segment |
#----------------------------------------------

