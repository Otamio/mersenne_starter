# sub_big.asm
# Bigint sub_big(Bigint a, Bigint b)
# {
#   Bigint c;
# 	c.n = a.n;
# 	for (int i = 0; i < c.n; ++i)
# 		c.digits[i] = 0;
#
# 	int carry = 0;
# 	for (int i = 0; i < b.n; ++i) {
# 		c.digits[i] = a.digits[i] - b.digits[i] + carry;
# 		if (c.digits[i] < 0) {
# 			carry = -1;
# 			c.digits[i] += 10;
# 		} else
# 			carry = 0;
# 	}
#
# 	if (a.n > b.n) {
# 		for (int i=b.n; i<a.n; ++i) {
# 			c.digits[i] = a.digits[i] + carry;
# 			if (c.digits[i]<0) {
# 				carry = -1;
# 				c.digits[i] += 10;
# 			} else
# 				carry = 0;
# 		}
# 	}
#
# 	compress(&c);
# 	return c;
# }
  .data
test_i:   .asciiz "Subtraction Tests"
newline:  .asciiz "\n"
.align 2
bigint1:  .space  1404
.align 2
bigint2:  .space  1404
.align 2
bigint3:  .space  1404

  .text
sub_big:
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
  move $s2, $a2               # $s2 is the starting address of c

# initialize c (by calling init_bigint)
# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call init_bigint
  move $a0, $s2
  jal init_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# c can have at most the number of digits in a
# c.n = a.n
  lw $t0, 0($s0)              # $t0 = a.n
  sw $t0, 0($s2)              # c.n = a.n

# initialization for c has been done in the previous step

# initialize carry
  li $s7, 0                   # $s7 is carry

# prepare for loop 1
  addi $s3, $s0, 4            # $s3 = &(a.digits[])
  addi $s4, $s1, 4            # $s4 = &(b.digits[])
  addi $s5, $s2, 4            # $s5 = &(c.digits[])
  lw $t9, 0($s1)              # $t9 = b.n
  li $s6, 0                   # $s7 = 0 (i)

SUB_loop1:
  bge $s6, $t9, SUB_loop1_end # branch if i>=b.n

  sll $t1, $s6, 2             # $t1 = 4i
  add $t2, $t1, $s0           # $t2 = &(a.digits[i])
  lw $t8, 0($t2)              # $t8 = a.digits[i]

  add $t2, $t1, $s1           # $t2 = &(b.digits[i])
  lw $t2, 0($t2)              # $t2 = b.digits[i]
  sub $t8, $t8, $t2           # $t8 = a.digits[i] - b.digits[i]

  add $t8, $t8, $s7           # $t8 = a.digits[i] - b.digits[i] + carry

  add $t2, $t1, $s2           # $t2 = &(c.digits[i])

  sw $t8, 0($t2)              # c.digits[i] = $t8

# if statement to check underflow
  bge $t8, $0, SUB_loop1_if   # branch if c.digits[i] >= 0 (optimized)
# if no
  li $s7, 0                   # carry = 0
  j SUB_loop1_if_end

SUB_loop1_if:
# if yes
  li $s7, -1                  # carry = -1
  addi $t8, $t8, 10           # $t8 += 10
  sw $t8, 0($t2)              # c.digits[i] += 10
  j SUB_loop1_if_end

SUB_loop1_if_end:
  addi $s6, $s6, 1            # ++i
  j SUB_loop1

SUB_loop1_end:
# check if a.n > b.n
  lw $t9, 0($s1)              # $t9 = b.n
  lw $t8, 0($s0)              # $t8 = a.n
  ble $t8, $t9, SUB_if_end    # branch if a.n <= b.n

  move $s6, $t9               # $s6 = b.n (i)

# loop through b.n through a.n-1
SUB_if_loop:
  bge $s6, $t8, SUB_if_end    # branch if i>= a.n

  sll $t1, $s6, 2             # $t1 = 4i
  add $t2, $t1, $s0           # $t2 = &(a.digits[i])
  lw $t7, 0($t2)              # $t7 = a.digits[i]

  addi $t7, $t7, $s7          # $t7 = a.digits[i] + carry

  add $t2, $t1, $s2           # $t2 = &(c.digits[i])
  sw $t7, 0($t2)              # c.digits[i] = a.digits[i] + carry

SUB_if_if:
  bge $t7, $0, SUB_if_if_t    # branch if $t7 >= 0
  li $s7, 0                   # carry = 0
  j SUB_if_if_end

SUB_if_if_t:
  li $s7, -1                  # carry = -1
  addi $t7, $t7, 10           # $t7 = $t7 + 10
  sw $t7, 0($t2)              # c.digits[i] += 10
  j SUB_if_if_end

SUB_if_if_end:
  addi $s6, $s6, 1            # i += 1
  j SUB_if_loop

SUB_if_end:
# call compress
  move $a0, $s2
  jal compress

SUB_return:
# generate return value
  move $v0, $s2

# restore state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36             # 8 elements are popped from the stack

# return
  jr $ra

compress:
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
  ble $s7, $0, CPS_exit       # branch if i<=0

CPS_loop:
  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  add $t0, $s6, $t0           # $t0 = &a.digits[i]
  lw $t1, 0($t0)              # load a->digits[i] into $t1
  bne $t1, $0, CPS_exit       # branch if (a->digits[i] != 0)

  addi $s7, $s7, -1           # --i;
  ble $s7, $0, CPS_exit       # branch if i<=0
  j CPS_loop

CPS_exit:
  addi $s5, $s7, 1            # new size should be i+1 (since i is the index)
  sw $s5, 0($s0)              # update the new value to the memory address

CPS_return:
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
  addi $sp, $sp, 36             # 8 elements are popped from the stack

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


print_big:
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
  addi $s6, $s0, 4            # $s6 = &b.digits[]
  blt $s7, $0, PG_exit        # branch if c<0

# loop
BG_loop:
  move $t0, $s7               # $t0 = c
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4c
  add $t0, $s6, $t0           # $t0 = &b.digits[c]
  lw $a0, 0($t0)              # load b.digits[c]
  li $v0, 1                   # load print sys call
  syscall                     # print element
  addi $s7, $s7, -1           # $s7 = $s7 - 1
  blt $s7, $0, PG_exit        # branch if c<0
  j BG_loop

# end of loop (print newline)
PG_exit:
  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

PG_return:
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
  la $a0, test_g
  li $v0, 4
	syscall

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# test case 1 (7 and 3)

# init bigint1
  la $a0, bigint1            # $a0 is the starting address of bigint1
  jal init_bigint            # initialize bigint 1

# load bigint1
  li $t1, 1
  sw $t1, 0($a0)            # Bigint size is 1

  li $t1, 7
  sw $t1, 4($a0)            # the digit is 7

# init bigint 2
  la $a0, bigint2           # $a0 is the starting address of bigint2
  jal init_bigint           # initialize bigint2

# load bigint2
  li $t1, 1
  sw $t1, 0($a0)            # Bigint size is 1

  li $t1, 3
  sw $t1, 4($a0)            # the digit is 3

# call sub_big
  la $a0, bigint1
  la $a1, bigint2
  la $a2, bigint3
  jal sub_big

# print output
  move $a0, $v0
  jal print_big

# exit (from main)
  li $v0, 10                 # load exit syscall code
  syscall                    # exit
