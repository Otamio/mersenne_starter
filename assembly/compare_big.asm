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
.align 2
bigint1:  .space  1404
.align 2
bigint2:  .space  1404

  .text
compare_big:
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
  blt $s7, $s6, CB_exit1      # if a->n < b->n, return -1
  bgt $s7, $s6, CB_exit2      # if a->n > b->n, return 1

# loop init
  addi $s2, $s0, 4            # $s2 = &a->digits[]
  addi $s3, $s1, 4            # $s3 = &b->digits[]
  addi $s4, $s7, -1           # $s4 = i (a.n-1)
  blt $s4, $0, CB_exit3       # branch if i<0

CB_loop:
  move $t0, $s4               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4i
  add $t1, $s2, $t0           # $t1 = &a->digits[i]
  lw $t3, 0($t1)              # $t3 = a->digits[i]
  add $t2, $s3, $t0           # $t2 = &b->digits[i]
  lw $t4, 0($t2)              # $t4 = b->digits[i]
  blt $t3, $t4, CB_exit1      # branch if a->digits[i] < b->digits[i]
  bgt $t3, $t4, CB_exit2      # branch if a->digits[i] > b->digits[i]

  addi $s4, $s4, -1           # --i;
  blt $s4, $0, CB_exit3       # branch if i<0
  j CB_loop

CB_exit1:
  li $v0, -1                  # return -1
  j CB_return

CB_exit2:
  li $v0, 1                   # return 1
  j CB_return

CB_exit3:
  li $v0, 0                   # return 0

CB_return:
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


# This function clears the memory of an uninitialized big int
# store bigint
init_bigint:
  move $t0, $a0                # t0 is the address of the first element (n)
  addi $t1, $t0, 1400          # t1 is the (word) address of the last element

init_loop:
  bgt $t0, $t1, init_exit      # if $t0 > $t1, branch to exit
  sw $0, 0($t0)                # arr[$t0] = 0
  addi $t0, $t0, 4             # $t0 += 4 (go to next element)
  j init_loop

init_exit:
# return (no return value)
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
  
# init bigint1
  la $a0, bigint1            # $a0 is the starting address of bigint1
  jal init_bigint            # initialize bigint 1

# load bigint1
  li $t1, 2
  sw $t1, 0($a0)            # Bigint size is 2

  li $t1, 4
  sw $t1, 8($a0)            # first digit is 4
  li $t1, 2
  sw $t1, 4($a0)            # second digit is 2

# init bigint 2
  la $a0, bigint2           # $a0 is the starting address of bigint2
  jal init_bigint           # initialize bigint2

# load bigint 2
  li $t1, 2
  sw $t1, 0($a0)            # Bigint size is 2

  li $t1, 3
  sw $t1, 8($a0)            # first digit is 3
  li $t1, 0
  sw $t1, 4($a0)            # second digit is 0

# call compare_big
# first case
  la $a0, bigint1
  la $a1, bigint2
  jal compare_big

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# second case
  la $a0, bigint2
  la $a1, bigint1
  jal compare_big

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# third case
  la $a0, bigint1
  la $a1, bigint1
  jal compare_big

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# exit (from main)
  li $v0, 10                 # load exit syscall code
  syscall                    # exit
