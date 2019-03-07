  # print_big.asm
  # code segment (slight change based on pointer)
  # void print_big(Bigint b) {
  # 	for (int c = b.n-1; c>=0; --c)
  # 		printf("%d", b.digits[c]);
  # 	printf("\n");
  # }
  .data
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


# test driver
main:
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
  li $t1, 3
  sw $t1, 1400($sp)           # Bigint size is 3

  li $t1, 3
  sw $t1, 1396($sp)           # third digit is 3
  li $t1, 2
  sw $t1, 1392($sp)           # second digit is 2
  li $t1, 1
  sw $t1, 1388($sp)           # first digit is 1

# call print_big
  addi $s0, $sp, 1400
  move $a0, $s0
  jal function_b

# reclaim stack memory
  addi $sp, $sp, 1404

# exit
  li $v0, 10              # load exit syscall code
  syscall                 # exit
