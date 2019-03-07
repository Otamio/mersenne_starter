  # shift_left.asm
  # void shift_left(Bigint *a) {
  # 	// Copy stuff
  # 	for (int i=0; i<a->n-1; ++i)
  # 		a->digits[i] = a->digits[i+1];
  # 	// Set highest digit to 0
  # 	a->digits[a->n-1] = 0;
  # 	// Set to new smaller size
  # 	--a->n;
  # 	// Trim any leading zeros
  # 	compress(a);
  # }
  .data
test_e:  .asciiz "Shift Left Test"
newline: .asciiz "\n"
  .text
function_b:
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
  move $s0, $a0               # $s0 is the starting address of b
# loop init
  lw $s7, 0($s0)
  addi $s7, $s7, -1           # $s7 = c (b.n-1)
  addi $s6, $s0, -4           # $s6 = &b.digits[]
  blt $s7, $0, exit_b         # branch if c<0
loop_b:
  move $t0, $s7               # $t0 = c
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4c
  sub $t0, $0, $t0            # $t0 = -4c (correct addressing)
  add $t0, $s6, $t0           # $t0 = &b.digits[c]
  lw $a0, 0($t0)              # load b.digits[c]
  li $v0, 1                   # load print sys call
  syscall                     # print element
  addi $s7, $s7, -1           # $s7 = $s7 - 1
  blt $s7, $0, exit_b         # branch if c<0
  j loop_b
exit_b:
  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall
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


function_c:
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
# loop init
  lw $s7, 0($s0)
  addi $s7, $s7, -1           # $s7 = i (a->n-1)
  addi $s6, $s0, -4           # $s6 = &(a->digits[])
  ble $s7, $0, exit_c         # branch if i<=0
loop_c:
  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  sub $t0, $0, $t0            # $t0 = -4i (correct addressing)
  add $t0, $s6, $t0           # $t0 = &a->digits[i]
  lw $t1, 0($t0)              # load a->digits[i] into $t1
  bne $t1, $0, exit_c         # branch if (a->digits[i] != 0)

  addi $s7, $s7, -1           # --i;
  ble $s7, $0, exit_c         # branch if i<=0
  j loop_c
exit_c:
  addi $s5, $s7, 1            # new size should be i+1
  sw $s5, 0($s0)              # update the new value to the memory address
return_c:
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


# shift_left
function_e:
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
# loop init
  li $s7, 0                   # $s7 = i (0)
  lw $t9, 0($s0)
  addi $t9, $t9, -1           # $t9 = a->n - 1
  addi $s6, $s0, -4           # $s6 = &(a->digits[]), starting address of array
  bge $s7, $t9, exit_e        # branch if i >= a->n-1
loop_e:
  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  sub $t0, $0, $t0            # $t0 = -4i (correct addressing)
  add $t0, $s6, $t0           # $t0 = &a.digits[i]
  lw $t1, -4($t0)             # load a->digits[i+1] into $t1
  sw $t1, 0($t0)              # a->digits[i] = a->digits[i+1]

  addi $s7, $s7, 1            # ++i;
  bge $s7, $t9, exit_e        # branch if i >= a->n-1
  j loop_e

exit_e:
  move $t0, $t9               # $t0 = a->n - 1
  sll $t0, $t0, 2             # $t0 * 4
  sub $t0, $0, $t0            # $t0 = -$t0
  add $t0, $s6, $t0           # $t0 = &a->digits[a->n-1]
  sw $0, 0($t0)               # a->digits[a->n-1] = 0；
  lw $s5, 0($s0)              # $s5 = a->n;
  addi $s5, $s5, -1           # $s5 += 1;
  sw $s5, 0($s0)              # a->n = $s5 (a->n -= 1);
# compress
  move $a0, $s0               # fill arguments
  jal function_c              # call compress

return_e:
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
  la $a0, test_e
  li $v0, 4
	syscall

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# create Bigint (351 words in size)
  addi $sp, $sp, -1404        # 1 size, and 3 digits
  li $t0, 1400
  add $t0, $t0, $sp           # $t0 is the iterator
loop_create:
  blt $t0, $sp, exit_create   # if $t0>$sp, then exit loop
  sw $0, 0($t0)               # initialize to 0
  addi $t0, $t0, -4           # iterate the the next element
  j loop_create

exit_create:
  li $t1, 4
  sw $t1, 1400($sp)           # Bigint size is 4

  li $t1, 0
  sw $t1, 1396($sp)           # last digit is 0

  li $t1, 0
  sw $t1, 1392($sp)           # third digit is 0

  li $t1, 0
  sw $t1, 1388($sp)           # second digit is 0

  li $t1, 7
  sw $t1, 1384($sp)           # first digit is 7

# call shift_left
  addi $s0, $sp, 1400         # $s0 is the starting pointer

  move $a0, $s0               # call first time
  jal function_e

  move $a0, $s0               # call second time
  jal function_e

# call print_big
  move $a0, $s0
  jal function_b

# reclaim stack memory
  addi $sp, $sp, 1404

# exit
  li $v0, 10                  # load exit syscall code
  syscall                     # exit
