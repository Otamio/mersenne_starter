  # compress.asm
  # void compress(Bigint *a) {
  #   for (int i = a->n - 1; i > 0; --i) {
  #     if (a->digits[i] == 0)
  #       a->n -= 1;
  #     else
  #       return;
  # 	}
  # }
  .data
test_c:  .asciiz "Compress Tests"
newline: .asciiz "\n"
  .text
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
  addi $s6, $s0, 4            # $s6 = &(a->digits[])
  ble $s7, $0, exit_c         # branch if i<=0
loop_c:
  move $t0, $s7
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  add $t0, $s6, $t0           # $t0 = &a.digits[i]
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

# test driver
main:
# print test notification
  la $a0, test_c
  li $v0, 4
	syscall

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# create Bigint
  addi $sp, $sp, -20          # 4 size, and 4 digits
  li $t1, 0                   # first digit is 0
  sw $t1, 16($sp)
  li $t1, 0                   # second digit is 0
  sw $t1, 12($sp)
  li $t1, 0                   # third digit is 0
  sw $t1, 8($sp)
  li $t1, 3
  sw $t1, 4($sp)              # last digit is 3
  li $t1, 4
  sw $t1, 0($sp)              # Bigint size is 4


# call compress
  move $a0, $sp
  jal function_c

  lw $a0, 0($sp)              # get new size
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# reclaim stack memory
  addi $sp, $sp, 20

# exit
  li $v0, 10                  # load exit syscall code
  syscall                     # exit
