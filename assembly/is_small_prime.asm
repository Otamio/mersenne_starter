  # is_small_prime.asm
  # code segment
  # int is_small_prime(int p) {
  # 	for (int i=2; i<p-1; ++i)
  # 		if (p%i == 0)
  # 			return 0;
  # 	return 1;
  # }
  .text
main:
# save state
  addi $sp, $sp, -36 # 8 elements are pushed onto the stack
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
  li $a0, 127
  move $s0, $a0           # $s0 = p
# loop initialization
  li $s7, 2               # $s7 = i (2)
  addi $t0, $s0, -1       # $t0 = p-1
  slt $t9, $s7, $t0       # $t9 = $s7(i) < $t0(p-1)
  beq $t9, $0, exit_a2    # branch exit_a2 if $t9 is false
loop_a1:
  div $s0, $s7
  mfhi $t1                # $t1 = p%i
  beq $t1, $0, exit_a1    # branch exit_a1 if $t1 is 0
  addi $s7, $s7, 1        # ++i
  slt $t9, $s7, $t0       # $t9 = $s7(i) < $t0(p-1)
  beq $t9, $0, exit_a2    # branch exit_a2 if $t9 is false
  j loop_a1
exit_a1:
# return 0
  li $v0, 0               # return 0;
  j return_a
exit_a2:
  li $v0, 1               # return 1;
return_a:
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
  addi $sp, $sp, 36 # 8 elements are popped from the stack
# return
# (special) testing
  move $a0, $v0
  li $v0, 1               # load print syscall code
  syscall                 # print result
  li $v0, 10              # load exit syscall code
  syscall                 # exit
