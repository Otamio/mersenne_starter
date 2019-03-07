  # compare_big.asm
  # int compare_big(Bigint a, Bigint b) {
  # 	if (a.n < b.n)
  # 		return -1;
  # 	if (a.n > b.n)
  # 		return 1;
  # 	for (int i = a.n-1; i>=0; --i) {
  # 		if (a.digits[i] > b.digits[i])
  # 			return 1;
  # 		else if (a.digits[i] < b.digits[i])
  # 			return -1;
  # 	}
  # 	return 0;
  # }
  .data
test_f:  .asciiz "Comparison Tests"
newline: .asciiz "\n"
  .text
function_f:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)
# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b
# compare the size of a and b
  lw $s7, 0($s0)              # $s7 = a->n
  lw $s6, 0($s1)              # $s6 = b->n
  blt $s7, $s6, exit_f1       # if a->n < b->n, return -1
  bgt $s7, $s6, exit_f2       # if a->n > b->n, return 1
# loop init
  addi $s2, $s0, -4           # $s2 = &a->digits[]
  addi $s3, $s1, -4           # $s3 = &b->digits[]
  addi $s4, $s7, -1           # $s4 = i (a.n-1)
  blt $s4, $0, exit_f3        # branch if i<0

loop_f:
  move $t0, $s4               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4i
  sub $t0, $0, $t0            # $t0 = -4i
  add $t1, $s2, $t0           # $t1 = &a->digits[i]
  lw $t3, 0($t1)              # $t3 = a->digits[i]
  add $t2, $s3, $t0           # $t2 = &b->digits[i]
  lw $t4, 0($t2)              # $t4 = b->digits[i]
  blt $t3, $t4, exit_f1       # branch if a->digits[i] < b->digits[i]
  bgt $t3, $t4, exit_f2       # branch if a->digits[i] > b->digits[i]

  addi $s4, $s4, -1           # --i;
  blt $s4, $0, exit_f3        # branch if i<0
  j loop_f

exit_f1:
  li $v0, -1                  # return -1
  j return_f

exit_f2:
  li $v0, 1                   # return 1
  j return_f

exit_f3:
  li $v0, 0                   # return 0

return_f:
# recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack
# return
  jr $ra

# test driver
main:
# print test notification
  la $a0, test_f
  li $v0, 4
	syscall

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall


# create Bigint 42 (351 words in size)
  addi $sp, $sp, -1404        # 1 size, and 3 digits
  li $t0, 1400
  add $t0, $t0, $sp           # $t0 is the iterator

loop_create_f1:
  blt $t0, $sp, exit_create_f1  # if $t0>$sp, then exit loop
  sw $0, 0($t0)                 # initialize to 0
  addi $t0, $t0, -4             # iterate the the next element
  j loop_create_f1

exit_create_f1:
  li $t1, 2
  sw $t1, 1400($sp)           # Bigint size is 2

  li $t1, 2
  sw $t1, 1396($sp)           # last digit is 2

  li $t1, 4
  sw $t1, 1392($sp)           # first digit is 2

  addi $s0, $sp, 1400         # save address of 42 in $s1


# create Bigint 30 (351 words in size)
  addi $sp, $sp, -1404        # 1 size, and 3 digits
  li $t0, 1400
  add $t0, $t0, $sp           # $t0 is the iterator

loop_create_f2:
  blt $t0, $sp, exit_create_f2  # if $t0>$sp, then exit loop
  sw $0, 0($t0)                 # initialize to 0
  addi $t0, $t0, -4             # iterate the the next element
  j loop_create_f2

exit_create_f2:
  li $t1, 2
  sw $t1, 1400($sp)           # Bigint size is 2

  li $t1, 0
  sw $t1, 1396($sp)           # last digit is 0

  li $t1, 3
  sw $t1, 1392($sp)           # first digit is 3

  addi $s1, $sp, 1400         # save address of 30 is $s1


# call compare_big
# first case
  move $a0, $s0
  move $a1, $s1
  jal function_f

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# second case
  move $a0, $s1
  move $a1, $s0
  jal function_f

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# third case
  move $a0, $s0
  move $a1, $s0
  jal function_f

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall


# reclaim stack memory
  addi $sp, $sp, 1404
  addi $sp, $sp, 1404

# exit
  li $v0, 10                  # load exit syscall code
  syscall                     # exit
